import 'dart:io';
import 'dart:ui';

import 'package:confetti/confetti.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../global/constants/colors.dart';
import '../../global/constants/strings.dart';
import '../../global/constants/values.dart';
import '../../global/size_helper.dart';
import '../../global/widgets/circular_icon_button.dart';
import '../../global/widgets/popup_alert.dart';
import '../../global/widgets/rounded_button.dart';
import '../../providers/connectivity_provider.dart';
import '../../providers/home_provider.dart';
import '../../services/beacon_service.dart';
import '../no_internet/no_internet_screen.dart';
import 'widgets/campus_map.dart';
import 'widgets/clue_display.dart';
import 'widgets/progress_details.dart';
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
  bool qrVisible = false, flash = false, isChecking = false;
  late ConfettiController _controllerCenter;

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
  }

  @override
  Widget build(BuildContext context) {
    homeProvider = Provider.of<HomeProvider>(context);
    var connectivityProvider = Provider.of<ConnectivityProvider>(context);
    bool _eventStarted = DateTime.now().isAfter(homeProvider.startTime) &&
        (DateTime.now().isBefore(homeProvider.endTime));

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
                    const Align(
                      alignment: Alignment.topCenter,
                      child: ProgressDetails(),
                    ),
                    Positioned(
                      child: Row(
                        children: [
                          CircularIconButton(
                            icon: Icons.refresh,
                            size: 28,
                            onClick: () {
                              homeProvider.refreshHomeScreen();
                            },
                          ),
                          SizedBox(width: SizeHelper(context).width * 0.025),
                          RoundedButton(
                            text: "SCAN QR (" +
                                homeProvider.scansLeft.toString() +
                                ")",
                            child: Image.asset('assets/images/scan_logo.png'),
                            onClick: () {
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
                          ),
                          SizedBox(width: SizeHelper(context).width * 0.025),
                          CircularIconButton(
                            icon: Icons.help,
                            size: 28,
                            onClick: () {
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
                          ),
                        ],
                      ),
                      bottom: SizeHelper(context).height * 0.05,
                    ),
                    Positioned(
                      child: const ClueDisplay(),
                      top: SizeHelper(context).height * 0.09,
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
            borderColor: kPrimaryOrange,
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
