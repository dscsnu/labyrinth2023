import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../constants/values.dart';

class BottomSheetLayout extends StatelessWidget {
  final Widget child;

  const BottomSheetLayout({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(15.0),
      padding: const EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(kRoundedCornerValue),
        gradient: kPurpleGradient,
        border: Border.all(
          color: kPrimaryOrange,
          width: 2.0,
        ),
      ),
      child: child,
    );
  }
}
