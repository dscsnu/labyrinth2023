import 'package:flutter/material.dart';
import 'package:labyrinth/global/constants/colors.dart';

import '../../../global/widgets/text_link_widget.dart';
import '../../../providers/navigation_provider.dart';

class LoginPrompt extends StatelessWidget {
  final bool hasAccount;
  
  const LoginPrompt({
    Key? key,
    required this.hasAccount,
    required this.liquidNavProvider,
  }) : super(key: key);

  final NavigationProvider liquidNavProvider;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          (hasAccount) ? "Already have an account? " : "Don't have an account? ",
          style: const TextStyle(
            fontSize: 13,
            color: kTextColor,
          ),
        ),
        TextLinkWidget(
          text: (hasAccount) ? "Login Now" : "Register Now",
          onClick: () {
            FocusScope.of(context).unfocus();
            liquidNavProvider.liquidController.animateToPage(page: (hasAccount) ? 2 : 1);
          },
        ),
      ],
    );
  }
}
