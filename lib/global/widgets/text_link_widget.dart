import 'package:flutter/material.dart';

import '../constants/colors.dart';

class TextLinkWidget extends StatelessWidget {
  final String text;
  final Function onClick;

  const TextLinkWidget({
    Key? key,
    required this.text,
    required this.onClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 15.4,
          foreground: Paint()
            ..shader = kButtonGradient.createShader(
              const Rect.fromLTWH(0.0, 0.0, 200.0, 100.0),
            ),
        ),
        textAlign: TextAlign.start,
      ),
      onTap: () => onClick(),
    );
  }
}
