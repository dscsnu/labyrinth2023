import 'package:flutter/material.dart';
import '../../../global/widgets/popup_alert.dart';
import 'package:provider/provider.dart';

import '../../../global/constants/colors.dart';
import '../../../global/constants/values.dart';
import '../../../global/size_helper.dart';
import '../../../providers/home_provider.dart';
import '../../../services/beacon_service.dart';

class ClueDisplay extends StatefulWidget {
  const ClueDisplay({Key? key}) : super(key: key);

  @override
  State<ClueDisplay> createState() => _ClueDisplayState();
}

class _ClueDisplayState extends State<ClueDisplay> {
  bool showHint = false;

  @override
  Widget build(BuildContext context) {
    var homeProvider = Provider.of<HomeProvider>(context);

    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(kRoundedCornerValue),
        color: kPrimaryViolet.withOpacity(0.5),
        border: Border.all(
          color: kPrimaryOrange.withOpacity(0.6),
          width: 2.0,
        ),
      ),
      child: Container(
        width: SizeHelper(context).height * 0.37,
        padding: const EdgeInsets.only(bottom: 2.0),
        child: Column(
          children: [
            Text(
              homeProvider.clueToDisplay,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 17.0,
                fontWeight: FontWeight.bold,
                height: 1.65,
              ),
            ),
            (homeProvider.hintsLeft > 0)
                ? SizedBox(
                    height: SizeHelper(context).height * 0.04,
                  )
                : const SizedBox(),
            (homeProvider.selectedClue.hint == "" &&
                    homeProvider.hintsLeft > 0 &&
                    homeProvider.selectedClue.clueEasy ==
                        homeProvider.latestClue)
                ? GestureDetector(
                    onTap: () async {
                      await BeaconService.getHint().then((value) {
                        if (value == 'ok') {
                          homeProvider
                              .refreshHomeScreen(); // To update the hints left
                        } else {
                          showDialog(
                            context: context,
                            builder: (context) => PopupAlert(
                              bodyText: value,
                              onConfirm: () => Navigator.pop(context),
                              cancelOrNo: false,
                              buttonText: 'Okay',
                            ),
                          );
                        }
                        setState(
                          () {
                            showHint = !showHint;
                          },
                        );
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Stuck? Use a hint (" +
                              homeProvider.hintsLeft.toString() +
                              ")",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 17.0,
                            fontWeight: FontWeight.bold,
                            height: 1.65,
                            color: Colors.white.withOpacity(0.5),
                          ),
                        ),
                        SizedBox(
                          width: SizeHelper(context).width * 0.025,
                        ),
                        Icon(
                          Icons.lightbulb_outline,
                          color: Colors.white.withOpacity(0.5),
                        ),
                      ],
                    ),
                  )
                : const SizedBox(),
            (homeProvider.selectedClue.hint != "" &&
                    homeProvider.selectedClue.clueEasy ==
                        homeProvider.latestClue)
                ? GestureDetector(
                    onTap: () async {
                      setState(
                        () {
                          showHint = !showHint;
                        },
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "HINT",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 17.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                          child: ShaderMask(
                            blendMode: BlendMode.srcATop,
                            shaderCallback: (Rect bounds) {
                              return const LinearGradient(
                                colors: <Color>[
                                  kGradientColor1,
                                  kGradientColor2,
                                ],
                                tileMode: TileMode.repeated,
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ).createShader(bounds);
                            },
                            child: Icon(
                              (showHint)
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down,
                              size: 35.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : const SizedBox(),
            SizedBox(
              height: SizeHelper(context).height * 0.005,
            ),
            (homeProvider.selectedClue.hint != "" &&
                    showHint &&
                    homeProvider.selectedClue.clueEasy ==
                        homeProvider.latestClue)
                ? Text(
                    homeProvider.selectedClue.hint,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : const SizedBox(),
            (homeProvider.selectedClue.hint != "" &&
                    showHint &&
                    homeProvider.selectedClue.clueEasy ==
                        homeProvider.latestClue)
                ? SizedBox(
                    height: SizeHelper(context).height * 0.005,
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
