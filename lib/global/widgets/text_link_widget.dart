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
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 12,
          color: Colors.white,
        ),
        textAlign: TextAlign.start,
      ),
      onTap: () => onClick(),
    );
  }
}
