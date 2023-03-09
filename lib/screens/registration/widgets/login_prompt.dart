import 'package:flutter/material.dart';

import '../../../global/widgets/text_link_widget.dart';
import '../../../providers/navigation_provider.dart';

class LoginPrompt extends StatelessWidget {
  const LoginPrompt({
    Key? key,
    required this.liquidNavProvider,
  }) : super(key: key);

  final NavigationProvider liquidNavProvider;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Already have an account? ",
          style: TextStyle(
            fontSize: 15.4,
            color: Colors.white,
          ),
        ),
        TextLinkWidget(
          text: "Login Now",
          onClick: () {
            FocusScope.of(context).unfocus();
            liquidNavProvider.liquidController.animateToPage(page: 2);
          },
        ),
      ],
    );
  }
}
