import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:confetti/confetti.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:labyrinth/global/constants/colors.dart';
import 'package:labyrinth/global/constants/strings.dart';
import 'package:labyrinth/global/constants/values.dart';
import 'package:labyrinth/global/widgets/popup_alert.dart';
import 'package:labyrinth/services/beacon_service.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../global/size_helper.dart';
import '../../global/widgets/circular_icon_button.dart';
import '../../providers/connectivity_provider.dart';
import '../../providers/home_provider.dart';
import '../no_internet/no_internet_screen.dart';
import 'widgets/campus_map.dart';
import 'widgets/clue_display.dart';
import 'widgets/rule_sheet.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final qrKey = GlobalKey(debugLabel: "QR");
  QRViewController? controller;
  Barcode? barcode;
  late HomeProvider homeProvider;
  bool qrVisible = true, flash = false, isChecking = false;
  late ConfettiController _controllerCenter;
  
  DateTime displayTime = DateTime.now();
  Timer? countdown;
  
  @override
  void dispose() {
    controller?.dispose();
    _controllerCenter.dispose();
    super.dispose();
  }

  @override
  void reassemble() {
    super.reassemble();

    try {
      if (Platform.isAndroid) {
        controller?.pauseCamera();
      }
      controller?.resumeCamera();
    } on Exception catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    _controllerCenter =
        ConfettiController(duration: const Duration(seconds: 10));
    
    countdown = Timer.periodic(
      const Duration(
        seconds: 1,
      ),
      (timer) {
        setState(
          () {
            displayTime = DateTime.now();
          },
        );
      },
    );
  }
  
  format(Duration d) =>
      d.toString().split('.').first.padLeft(8, "0").replaceAll(":", " : ");

  @override
  Widget build(BuildContext context) {
    homeProvider = Provider.of<HomeProvider>(context);
    var connectivityProvider = Provider.of<ConnectivityProvider>(context);
    
    // TODO: CHANGE BACK
    // bool _eventStarted = DateTime.now().isAfter(homeProvider.startTime) &&
    //     (DateTime.now().isBefore(homeProvider.endTime));
    bool _eventStarted = true;

    _controllerCenter.play();

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: SafeArea(
        child: connectivityProvider.connectivityStatus !=
                ConnectivityResult.none
            ? Scaffold(
                body: Stack(
                  alignment: Alignment.center,
                  children: [
                    const CampusMap(),
                    Align(
                      // top: SizeHelper(context).height * 0.02,
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            // TODO: Ask Keshav for refresh button
                            // CircularIconButton(
                            //   icon: Icons.refresh,
                            //   size: 28,
                            //   onClick: () {
                            //     homeProvider.refreshHomeScreen();
                            //   },
                            // ),
                            // SizedBox(width: SizeHelper(context).width * 0.025),
                            GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  context: context,
                                  builder: (context) => BackdropFilter(
                                    child: const RuleSheet(),
                                    filter:
                                        ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                                  ),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                                decoration: BoxDecoration(
                                  color: kBackgroundColor,
                                  borderRadius: BorderRadius.circular(kRoundedCornerValue),
                                  border: Border.all(
                                    color: kPrimary.withOpacity(0.6),
                                    width: 1.0,
                                  ),
                                ),
                                child: Row(
                                  children: const [
                                    Icon(
                                      Icons.help,
                                      size: 28,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      "Rules",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 15,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: SizeHelper(context).height * 0.2,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  // HomeProvider().refreshHomeScreen();
                                  setState(
                                      () {
                                        qrVisible = true;
                                        _eventStarted = true;
                                      },
                                    );
                                  if (!_eventStarted) {
                                    showDialog(
                                      context: context,
                                      builder: (context) => PopupAlert(
                                        bodyText: 'The event is not in progress.',
                                        onConfirm: () => Navigator.pop(context),
                                        cancelOrNo: false,
                                        buttonText: 'Okay',
                                      ),
                                    );
                                  } else if (homeProvider.scansLeft == 0) {
                                    showDialog(
                                      context: context,
                                      builder: (context) => PopupAlert(
                                        bodyText:
                                            "You've exhausted all your scans.",
                                        onConfirm: () => Navigator.pop(context),
                                        cancelOrNo: false,
                                        buttonText: 'Okay',
                                      ),
                                    );
                                  } else {
                                    setState(
                                      () {
                                        qrVisible = true;
                                      },
                                    );
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                                  child: Text(
                                    "Scan QR (" + homeProvider.scansLeft.toString() + ")",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                                decoration: BoxDecoration(
                                  color: kBackgroundColor,
                                  borderRadius: BorderRadius.circular(kRoundedCornerValue),
                                  border: Border.all(
                                    color: kPrimary.withOpacity(0.6),
                                    width: 1.0,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.add_task,
                                      color: Colors.white,
                                      size: 20.0,
                                    ),
                                    const SizedBox(
                                      width: 6,
                                    ),
                                    Text(
                                      '${homeProvider.cluesCollected.length} / 10',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15.0,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 20),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                                decoration: BoxDecoration(
                                  color: kBackgroundColor,
                                  borderRadius: BorderRadius.circular(kRoundedCornerValue),
                                  border: Border.all(
                                    color: kPrimary.withOpacity(0.6),
                                    width: 1.0,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.timer,
                                      color: Colors.white,
                                      size: 20.0,
                                    ),
                                    const SizedBox(
                                      width: 6,
                                    ),
                                    Text(
                                      (displayTime.compareTo(homeProvider.startTime) < 0)
                                          ? " - " +
                                              format(homeProvider.startTime
                                                  .difference(displayTime))
                                          : (displayTime.compareTo(homeProvider.endTime) < 0)
                                              ? format(
                                                  homeProvider.endTime.difference(displayTime))
                                              : "00:00:00",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15.0,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),  
                    
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: DraggableScrollableSheet(
                        expand: false,
                        initialChildSize: 0.2,
                        minChildSize: 0.2,
                        maxChildSize: 0.8,
                        snap: true,
                        snapSizes: const [0.2, 0.8],
                        builder: (context, scrollController) => ClueDisplay(
                          scrollController: scrollController,
                        ),
                      ),
                    ),
                                      
                    qrVisible
                        ? _eventStarted
                            ? qrView(context)
                            : const SizedBox()
                        : const SizedBox(),
                    qrVisible
                        ? _eventStarted
                            ? Positioned(
                                bottom: SizeHelper(context).width * 0.1,
                                left: SizeHelper(context).width * 0.1,
                                child: CircularIconButton(
                                  icon: (flash)
                                      ? Icons.flash_on
                                      : Icons.flash_off,
                                  onClick: () async {
                                    controller?.toggleFlash();
                                    var temp =
                                        await controller?.getFlashStatus();
                                    setState(
                                      () {
                                        flash = temp!;
                                      },
                                    );
                                  },
                                ),
                              )
                            : const SizedBox()
                        : const SizedBox(),
                    qrVisible
                        ? _eventStarted
                            ? Positioned(
                                bottom: SizeHelper(context).width * 0.1,
                                right: SizeHelper(context).width * 0.1,
                                child: CircularIconButton(
                                  onClick: () async {
                                    setState(
                                      () {
                                        qrVisible = false;
                                      },
                                    );
                                  },
                                ),
                              )
                            : const SizedBox()
                        : qrVisible
                            ? Positioned(
                                bottom: SizeHelper(context).width * 0.1,
                                right: SizeHelper(context).width * 0.1,
                                child: CircularIconButton(
                                  onClick: () => setState(
                                    () {
                                      qrVisible = false;
                                    },
                                  ),
                                ),
                              )
                            : const SizedBox(),
                    (homeProvider.cluesCollected.length == 10)
                        ? Align(
                            alignment: Alignment.center,
                            child: ConfettiWidget(
                              confettiController: _controllerCenter,
                              blastDirectionality:
                                  BlastDirectionality.explosive,
                              colors: const [
                                Colors.green,
                                Colors.blue,
                                Colors.pink,
                                Colors.orange,
                                Colors.purple
                              ],
                            ),
                          )
                        : Container(),
                  ],
                ),
              )
            : const NoInternetScreen(),
      ),
    );
  }

  Widget qrView(BuildContext context) => Container(
        color: const Color(0x000223bf),
        child: QRView(
          key: qrKey,
          overlay: QrScannerOverlayShape(
            borderColor: kPrimary,
            borderRadius: kRoundedCornerValue,
            borderWidth: 10,
          ),
          onQRViewCreated: (QRViewController controller) {
            setState(
              () {
                this.controller = controller;
              },
            );
            controller.scannedDataStream.listen(
              (barcode) {
                this.barcode = barcode;
                if (qrVisible) {
                  setState(
                    () {
                      qrVisible = false;
                    },
                  );
                  checkCode();
                }
              },
            );
          },
        ),
      );

  Future<void> checkCode() async {
    String toCheck;
    try {
      final uri = Uri.parse(barcode?.code ?? '');
      toCheck = uri.queryParameters['__lr_key'] ?? '';
    } catch (e) {
      toCheck = '';
    }
    print(toCheck);
    var result = await BeaconService.scanIsValid(toCheck);
    showDialog(
      context: context,
      builder: (context) => PopupAlert(
        bodyText: 'Let\'s see if you got it right :)',
        onConfirm: () async {
          Navigator.pop(context);
          homeProvider.refreshHomeScreen();
          if (result) {
            showDialog(
              context: context,
              builder: (context) => PopupAlert(
                bodyText: 'Good job! You got this one',
                onConfirm: () async {
                  Navigator.pop(context);
                },
                buttonText: 'Proceed',
                cancelOrNo: false,
              ),
            );
            setState(
              () {
                qrVisible = false;
              },
            );
          } else {
            await launch(rickrollUrl);
          }
        },
        buttonText: 'Check',
        cancelOrNo: false,
      ),
    );
  }
}
