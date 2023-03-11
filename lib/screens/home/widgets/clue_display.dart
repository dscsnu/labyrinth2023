import 'package:flutter/material.dart';
import 'package:labyrinth/global/constants/values.dart';
import 'package:provider/provider.dart';

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
                    });
                  },
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(kRoundedCornerValue),
                        border: Border.all(
                          color: Colors.black,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.lightbulb_outline,
                          ),
                          Text(
                            "Hint (" +
                                homeProvider.hintsLeft.toString() +
                                ")",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 17.0,
                              fontWeight: FontWeight.bold,
                              height: 1.65,
                            ),
                          ),
                          SizedBox(
                            width: SizeHelper(context).width * 0.025,
                          ),
                          const Icon(
                            Icons.arrow_forward_sharp,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : const SizedBox(),
          (homeProvider.selectedClue.hint != "" &&
                  homeProvider.selectedClue.clueEasy ==
                      homeProvider.latestClue)
              ? Container(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(kRoundedCornerValue),
                  border: Border.all(
                    color: Colors.black,
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.lightbulb_outline,
                        ),
                        Text(
                          "Hint (" +
                              homeProvider.hintsLeft.toString() +
                              ")",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 17.0,
                            fontWeight: FontWeight.bold,
                            height: 1.65,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10,),
                    Text(
                        homeProvider.selectedClue.hint,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 17.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
              )
              : const SizedBox(),
        ],
      ),
    );
  }
}
