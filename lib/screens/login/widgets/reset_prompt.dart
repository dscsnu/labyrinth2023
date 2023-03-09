import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../global/widgets/text_link_widget.dart';
import 'reset_password.dart';

class ResetPrompt extends StatelessWidget {
  const ResetPrompt({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Got a password reset token? ",
          style: TextStyle(
            fontSize: 15.4,
            color: Colors.white,
          ),
        ),
        TextLinkWidget(
          text: "Reset now",
          onClick: () {
            FocusScope.of(context).unfocus();
            showModalBottomSheet(
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              context: context,
              builder: (context) => BackdropFilter(
                child: const ResetPassword(),
                filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
              ),
            );
          },
        ),
      ],
    );
  }
}
