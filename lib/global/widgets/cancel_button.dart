import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';

import '../constants/colors.dart';
import '../constants/values.dart';

class CancelButton extends StatelessWidget {
  final String text;
  final IconData? icon;
  final Function onClick;

  const CancelButton({
    Key? key,
    required this.text,
    this.icon,
    required this.onClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Bounce(
      duration: const Duration(milliseconds: 300),
      onPressed: () => onClick(),
      child: Material(
        borderRadius: BorderRadius.circular(kRoundedCornerValue),
        child: Container(
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            gradient: kPurpleGradient,
            border: Border.all(color: kPrimaryOrange),
            borderRadius: BorderRadius.circular(kRoundedCornerValue),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                text,
                style: const TextStyle(
                  fontSize: 18.0,
                  letterSpacing: 0.4,
                  fontWeight: FontWeight.bold,
                  color: kPrimaryOrange,
                ),
              ),
              SizedBox(width: (icon != null) ? 10 : 0),
              (icon != null) ? Icon(icon) : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
