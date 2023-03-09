import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';

import '../../../global/constants/colors.dart';
import '../../../global/constants/values.dart';
import '../size_helper.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final Widget? child;
  final Function onClick;
  const RoundedButton({
    Key? key,
    required this.text,
    this.child,
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
          padding: const EdgeInsets.symmetric(vertical: 12),
          width: SizeHelper(context).width * 0.55,
          decoration: BoxDecoration(
            gradient: kButtonGradient,
            borderRadius: BorderRadius.circular(kRoundedCornerValue),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                text,
                style: const TextStyle(
                  fontSize: 20.0,
                  letterSpacing: 0.4,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(
                  width:
                      (child != null) ? SizeHelper(context).width * 0.03 : 0),
              child ?? const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
