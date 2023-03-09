import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../global/constants/colors.dart';
import '../../providers/navigation_provider.dart';
import 'member_registration_screen.dart';
import 'user_registration_screen.dart';

class RegistrationScreen extends StatelessWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var liquidNavProvider = Provider.of<NavigationProvider>(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: kBackgroundColor,
        body: PageView(
          controller: liquidNavProvider.pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: const [
            UserRegistrationScreen(),
            MemberRegistrationScreen(),
          ],
        ),
      ),
    );
  }
}
