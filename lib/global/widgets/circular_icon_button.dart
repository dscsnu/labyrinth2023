import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';

import '../constants/colors.dart';
import '../constants/values.dart';

class CircularIconButton extends StatelessWidget {
  final Function onClick;
  final IconData? icon;
  final bool? withBorder;
  final double? size;
  const CircularIconButton({
    Key? key,
    this.icon,
    required this.onClick,
    this.withBorder,
    this.size
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Bounce(
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: size ?? 20.0,
        child: ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (Rect bounds) {
            return const LinearGradient(
              colors: <Color>[
                kGradientColor1,
                kGradientColor2,
              ],
              tileMode: TileMode.repeated,
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ).createShader(bounds);
          },
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(kRoundedCornerValue),
              border: Border.all(
                width: (withBorder ?? true) ? 2 : 0,
              ),
            ),
            child: Icon(
              icon ?? Icons.close,
              //color: kPrimaryOrange,
              size: 25,
            ),
          ),
        ),
      ),
      duration: const Duration(milliseconds: 100),
      onPressed: () => onClick(),
    );
  }
}
