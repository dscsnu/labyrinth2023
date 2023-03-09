import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../constants/colors.dart';
import '../constants/values.dart';

class LoadingRoundedButton extends StatefulWidget {
  final String text;
  final Icon? icon;
  final Function onClick;
  final RoundedLoadingButtonController buttonController;

  const LoadingRoundedButton({
    Key? key,
    required this.text,
    this.icon,
    required this.onClick,
    required this.buttonController,
  }) : super(key: key);

  @override
  State<LoadingRoundedButton> createState() => _LoadingRoundedButtonState();
}

class _LoadingRoundedButtonState extends State<LoadingRoundedButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kSecondary,
        borderRadius: BorderRadius.circular(kRoundedCornerValue),
      ),
      child: RoundedLoadingButton(
        elevation: 0,
        height: 65,
        borderRadius: kRoundedCornerValue,
        valueColor: Colors.black,
        color: Colors.transparent,
        successColor: Colors.transparent,
        controller: widget.buttonController,
        onPressed: () => widget.onClick(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.text,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
                letterSpacing: 0.4,
              ),
            ),
            const SizedBox(width: 10),
            widget.icon ?? const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
