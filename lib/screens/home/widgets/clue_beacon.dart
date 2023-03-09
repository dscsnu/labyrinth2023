import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:provider/provider.dart';

import '../../../global/constants/colors.dart';
import '../../../models/clue.dart';
import '../../../providers/home_provider.dart';

class ClueBeacon extends StatelessWidget {
  final Clue clue;
  const ClueBeacon({
    Key? key,
    required this.clue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context);

    final beaconWidget = Bounce(
      onPressed: () {
        homeProvider.selectClue(clue);
      },
      duration: const Duration(milliseconds: 300),
      child: Container(
        decoration: const BoxDecoration(
          gradient: kButtonGradient,
          shape: BoxShape.circle,
        ),
        child: const CircleAvatar(
          radius: 8.0,
          backgroundColor: Colors.transparent,
        ),
      ),
    );

    return homeProvider.selectedClue == clue
        ? AvatarGlow(
            glowColor: kSecondaryOrange,
            endRadius: 60.0,
            child: beaconWidget,
          )
        : Padding(
            padding: const EdgeInsets.all(4.0),
            child: beaconWidget,
          );
  }
}
