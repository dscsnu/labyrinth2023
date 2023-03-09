import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../global/constants/colors.dart';
import '../../../global/size_helper.dart';
import '../../../global/widgets/popup_alert.dart';
import '../../../providers/home_provider.dart';
import '../../../services/beacon_service.dart';

class ClueDisplay extends StatefulWidget {
  final ScrollController scrollController;
  
  const ClueDisplay({
    Key? key,
    required this.scrollController,
  }) : super(key: key);

  @override
  State<ClueDisplay> createState() => _ClueDisplayState();
}

class _ClueDisplayState extends State<ClueDisplay> {
  bool showHint = false;

  @override
  Widget build(BuildContext context) {
    var homeProvider = Provider.of<HomeProvider>(context);

    return Container(
      width: SizeHelper(context).width,
      padding: const EdgeInsets.all(15.0),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(35),
          topRight: Radius.circular(35),
        ),
        color: Colors.white,
      ),
      child: ListView(
        controller: widget.scrollController,
        shrinkWrap: true,
        children: [
          Center(
            child: Container(
              height: 4,
              width: SizeHelper(context).width * 0.3,
              decoration: const BoxDecoration(
                color: Color(0xFF121314),
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 40,
          ),
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
                                kPrimary,
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
    );
  }
}
