import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';

import '../constants/colors.dart';
import '../constants/values.dart';

class CircularIconButton extends StatelessWidget {
  final Function onClick;
  final IconData? icon;
  final Widget? iconWidget;
  final bool? sleek;
  final double? size;
  const CircularIconButton({
    Key? key,
    this.icon,
    this.iconWidget,
    required this.onClick,
    this.sleek,
    this.size
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Bounce(
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: size ?? 20.0,
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: (sleek ?? false) ? kBackgroundColor : Colors.transparent,
            borderRadius: BorderRadius.circular(kRoundedCornerValue),
            border: Border.all(
              width: (sleek ?? false) ? 1 : 2,
              color: kPrimary.withOpacity((sleek ?? false) ? 0.6 : 1)
            ),
          ),
          child: iconWidget ?? Icon(
            icon ?? Icons.close,
            color: kPrimary.withOpacity((sleek ?? false) ? 0.6 : 1),
            size: 25,
          ),
        ),
      ),
      duration: const Duration(milliseconds: 100),
      onPressed: () => onClick(),
    );
  }
}
