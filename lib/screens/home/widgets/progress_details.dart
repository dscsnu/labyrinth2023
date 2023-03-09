import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

import '../../../global/constants/colors.dart';
import '../../../global/constants/values.dart';
import '../../../global/size_helper.dart';
import '../../../providers/home_provider.dart';

class ProgressDetails extends StatefulWidget {
  const ProgressDetails({Key? key}) : super(key: key);

  @override
  State<ProgressDetails> createState() => _ProgressDetailsState();
}

class _ProgressDetailsState extends State<ProgressDetails> {
  DateTime displayTime = DateTime.now();
  Timer? countdown;

  @override
  void initState() {
    super.initState();
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

  @override
  void dispose() {
    super.dispose();
    countdown?.cancel();
  }

  format(Duration d) =>
      d.toString().split('.').first.padLeft(8, "0").replaceAll(":", " : ");

  @override
  Widget build(BuildContext context) {
    var homeProvider = Provider.of<HomeProvider>(context);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: kBorderGradient,
                borderRadius: BorderRadius.circular(kRoundedCornerValue),
              ),
              child: Container(
                margin: const EdgeInsets.all(2.6),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: kBackgroundColor,
                  borderRadius: BorderRadius.circular(kRoundedCornerValue),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.add_task,
                      color: kPrimaryOrange,
                      size: 20.0,
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                    GradientText(
                      '${homeProvider.cluesCollected.length} / 10 completed',
                      gradientDirection: GradientDirection.rtl,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0,
                      ),
                      colors: const [
                        Color(0xFFff0006),
                        Color(0xFFFF8A00),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: SizeHelper(context).width * 0.05),
            Container(
              decoration: BoxDecoration(
                gradient: kBorderGradient,
                borderRadius: BorderRadius.circular(kRoundedCornerValue),
              ),
              child: Container(
                margin: const EdgeInsets.all(2.6),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: kBackgroundColor,
                  borderRadius: BorderRadius.circular(kRoundedCornerValue),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.timer,
                      color: Colors.orange,
                      size: 20.0,
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                    GradientText(
                      (displayTime.compareTo(homeProvider.startTime) < 0)
                          ? " - " +
                              format(homeProvider.startTime
                                  .difference(displayTime))
                          : (displayTime.compareTo(homeProvider.endTime) < 0)
                              ? format(
                                  homeProvider.endTime.difference(displayTime))
                              : "00:00:00",
                      gradientDirection: GradientDirection.rtl,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0,
                      ),
                      colors: const [
                        Color(0xFFff0006),
                        Color(0xFFFF8A00),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
