import 'dart:async';
import 'dart:ui';

import 'package:confetti/confetti.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:labyrinth/global/constants/colors.dart';
import 'package:labyrinth/global/constants/strings.dart';
import 'package:labyrinth/global/constants/values.dart';
import 'package:labyrinth/global/widgets/popup_alert.dart';
import 'package:labyrinth/services/beacon_service.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
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
  MobileScannerController controller = MobileScannerController(
    autoStart: true,
  );
  MobileScannerArguments? arguments;
  Barcode? barcode;
  BarcodeCapture? capture;
  late HomeProvider homeProvider;
  bool qrVisible = true, flash = false, isChecking = false;
  late ConfettiController _controllerCenter;
  
  DateTime displayTime = DateTime.now();
  Timer? countdown;
  
  @override
  void dispose() {
    controller.dispose();
    _controllerCenter.dispose();
    super.dispose();
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
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.start();
    });
  }
  
  format(Duration d) =>
      d.toString().split('.').first.padLeft(8, "0").replaceAll(":", " : ");

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
                    Align(
                      // top: SizeHelper(context).height * 0.02,
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  context: context,
                                  builder: (context) => BackdropFilter(
                                    child: DraggableScrollableSheet(
                                      expand: false,
                                      initialChildSize: 0.8,
                                      maxChildSize: 1,
                                      snap: true,
                                      snapSizes: const [0.8],
                                      builder: (context, scrollController) {
                                        return RuleSheet(
                                          scrollController: scrollController,
                                        );
                                      }
                                    ),
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
                            SizedBox(width: SizeHelper(context).width * 0.025),
                            CircularIconButton(
                              icon: Icons.refresh,
                              size: 28,
                              sleek: true,
                              onClick: () {
                                homeProvider.refreshHomeScreen();
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: SizeHelper(context).height * 0.25,
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
                        initialChildSize: 0.25,
                        minChildSize: 0.25,
                        maxChildSize: 0.8,
                        snap: true,
                        snapSizes: const [0.25, 0.8],
                        builder: (context, scrollController) => ClueDisplay(
                          scrollController: scrollController,
                        ),
                      ),
                    ),
                    
                    Visibility(
                      visible: qrVisible && _eventStarted,
                      maintainState: true,
                      child: Container(
                        color: Colors.black.withOpacity(0.8),
                        child: qrView(context),
                      ),
                    ),
                    
                    Positioned(
                      bottom: SizeHelper(context).width * 0.1,
                      left: SizeHelper(context).width * 0.1,
                      child: Visibility(
                        visible: qrVisible && _eventStarted,
                        maintainState: true,
                        child: CircularIconButton(
                          iconWidget: ValueListenableBuilder(
                            valueListenable: controller.torchState,
                            builder: (context, state, child) {
                              switch (state as TorchState) {
                                case TorchState.off:
                                  return const Icon(Icons.flash_off, color: kPrimary, size: 25,);
                                case TorchState.on:
                                  return const Icon(Icons.flash_on, color: kPrimary, size: 25,);
                              }
                            },
                          ),
                          onClick: () async {
                            controller.toggleTorch();
                          },
                        ),
                      ),
                    ),
                    
                    Positioned(
                      bottom: SizeHelper(context).width * 0.1,
                      right: SizeHelper(context).width * 0.1,
                      child: Visibility(
                        visible: qrVisible && _eventStarted,
                        maintainState: true,
                        child: CircularIconButton(
                          onClick: () async {
                            setState(
                              () {
                                // controller?.pauseCamera();
                                qrVisible = false;
                              },
                            );
                          },
                        ),
                      ),
                    ),
                    
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
        child: Stack(
          children: [
            MobileScanner(
              fit: BoxFit.contain,
              scanWindow: Rect.fromCenter(
                center: MediaQuery.of(context).size.center(Offset.zero),
                width: SizeHelper(context).width * 0.8,
                height: SizeHelper(context).width * 0.8,
              ),
              controller: controller,
              onScannerStarted: (arguments) {
                setState(() {
                  this.arguments = arguments;
                });
              },
              onDetect: (capture) {
                final List<Barcode> barcodes = capture.barcodes;
                capture = capture;
                barcode = barcodes[0];
                if (qrVisible) {
                  setState(
                    () {
                      // controller.pauseCamera();
                      qrVisible = false;
                    },
                  );
                  checkCode();
                }
              },
            ),
            CustomPaint(
              painter: ScannerOverlay(Rect.fromCenter(
                center: MediaQuery.of(context).size.center(Offset.zero),
                width: SizeHelper(context).width * 0.8,
                height: SizeHelper(context).width * 0.8,
              )),
            ),
            Container(
              alignment: Alignment.center,
              child: SizedBox(
                width: SizeHelper(context).width * 0.8,
                height: SizeHelper(context).width * 0.8,
                child: CustomPaint(
                  foregroundPainter: BorderPainter(),
                ),
              ),
            ),
          ],
        ),
      );

  Future<void> checkCode() async {
    String toCheck;
    try {
      final uri = Uri.parse(barcode?.rawValue ?? '');
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
                // controller?.pauseCamera();
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

class BorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double sh = size.height; // for convenient shortage
    double sw = size.width; // for convenient shortage
    double cornerSide = sh * 0.15; // desirable value for corners side

    Paint paint = Paint()
      ..color = kPrimary
      ..strokeWidth = 7
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    Path path = Path()
      ..moveTo(cornerSide, 0)
      ..lineTo(0, 0)
      ..lineTo(0, cornerSide)
      ..moveTo(0, sh - cornerSide)
      ..lineTo(0, sh)
      ..lineTo(cornerSide, sh)
      ..moveTo(sw - cornerSide, sh)
      ..lineTo(sw, sh)
      ..lineTo(sw, sh - cornerSide)
      ..moveTo(sw, cornerSide)
      ..lineTo(sw, 0)
      ..lineTo(sw - cornerSide, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(BorderPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(BorderPainter oldDelegate) => false;
}

class ScannerOverlay extends CustomPainter {
  ScannerOverlay(this.scanWindow);

  final Rect scanWindow;

  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPath = Path()..addRect(Rect.largest);
    final cutoutPath = Path()..addRect(scanWindow);

    final backgroundPaint = Paint()
      ..color = Colors.black.withOpacity(0.5)
      ..style = PaintingStyle.fill
      ..blendMode = BlendMode.dstOut;

    final backgroundWithCutout = Path.combine(
      PathOperation.difference,
      backgroundPath,
      cutoutPath,
    );
    canvas.drawPath(backgroundWithCutout, backgroundPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}