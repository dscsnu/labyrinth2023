import 'package:flutter/material.dart';

const kBackgroundColor = Color(0xFF140223);
const kTextColor = Colors.white;
const kIconColor = Colors.black;
const kSecondaryOrange = Color(0xFFFF8A00);
const kPrimaryOrange = Color(0xFFFF8200);
const kPrimaryViolet = Color(0xFF15003D);
// Used for popup/rule-sheet boundaries

const kGradientColor1 = Color(0xFFFF8A00);
const kGradientColor2 = Color(0xFFff0006);

const LinearGradient kPurpleGradient = LinearGradient(
  colors: [
    Color(0xFF4C0053),
    Color(0xFF15003D),
  ],
);

const LinearGradient kButtonGradient = LinearGradient(
  colors: [
    Color(0xFFFF8A00),
    Color(0xFFff0006),
  ],
);

const LinearGradient kBorderGradient = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [
    Color(0xFFFF8A00),
    Color(0xFFff0006),
  ],
);

final Shader linearGradient = const LinearGradient(
  colors: <Color>[Color(0xFFFF8A00), Color(0xFFff0006)],
).createShader(const Rect.fromLTWH(0.0, 0.0, 0.0, 0.0));

