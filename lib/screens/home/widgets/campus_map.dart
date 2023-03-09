import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../global/constants/values.dart';
import '../../../global/size_helper.dart';
import '../../../providers/home_provider.dart';
import 'clue_beacon.dart';

class CampusMap extends StatelessWidget {
  const CampusMap({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context);

    Widget getCellChild(int x, int y) {
      for (int i = 0; i < homeProvider.cluesCollected.length; i++) {
        if (homeProvider.cluesCollected[i].checkCoordinates(y, x)) {
          return ClueBeacon(clue: homeProvider.cluesCollected[i]);
        }
      }
      return const SizedBox();
    }

    return InteractiveViewer(
      constrained: false,
      maxScale: 3,
      child: DelayedDisplay(
        slidingBeginOffset: const Offset(0, 0),
        fadingDuration: const Duration(seconds: 1),
        child: Container(
          width: SizeHelper(context).width * 2.5,
          height: SizeHelper(context).height * 1.5,
          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(
                'assets/images/map.jpg',
              ),
            ),
          ),
          child: Table(
            children: List.generate(
              kRowCount,
              (row) => TableRow(
                children: List.generate(
                  kColumnCount,
                  (column) => SizedBox(
                    height: SizeHelper(context).height * 1.5 / kRowCount,
                    width: SizeHelper(context).width * 1.5 / kColumnCount,
                    child: getCellChild(row, column),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
