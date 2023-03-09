import 'package:flutter/material.dart';

import '../../global/constants/colors.dart';
import '../constants/colors.dart';
import 'cancel_button.dart';
import 'rounded_button.dart';

class PopupAlert extends StatelessWidget {
  final String bodyText;
  final Function onConfirm;
  final String buttonText;
  final bool cancelOrNo;

  const PopupAlert({
    Key? key,
    required this.bodyText,
    required this.onConfirm,
    required this.buttonText,
    this.cancelOrNo = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.0),
          gradient: kPurpleGradient,
          border: Border.all(color: kPrimaryOrange),
        ),
        height: 210,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              bodyText,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            Row(
              children: <Widget>[
                cancelOrNo
                    ? Expanded(
                        child: CancelButton(
                          text: "Cancel",
                          onClick: () => Navigator.pop(context),
                        ),
                      )
                    : const SizedBox(),
                const SizedBox(width: 10),
                Expanded(
                  child: RoundedButton(
                    text: buttonText,
                    onClick: () {
                      onConfirm();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
