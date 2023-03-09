import 'dart:async';

import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../global/size_helper.dart';
import '../../global/widgets/rounded_loading_button.dart';
import '../../providers/home_provider.dart';
import '../../providers/navigation_provider.dart';
import '../home/home_screen.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  final buttonController = RoundedLoadingButtonController();

  _checkLogin() async {
    return (await SharedPreferences.getInstance()).getBool('isLoggedIn');
  }

  @override
  Widget build(BuildContext context) {
    var liquidNavProvider = Provider.of<NavigationProvider>(context);
    var homeProvider = Provider.of<HomeProvider>(context);

    return SafeArea(
      child: Scaffold(
        body: GestureDetector(
          onTap: () async {
            (await _checkLogin()) ?? false
                ? Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        homeProvider.refreshHomeScreen();
                        return const HomeScreen();
                      },
                    ),
                    (route) => false,
                  )
                : liquidNavProvider.liquidController
                    .animateToPage(
                    page: 1,
                    duration: 1000,
                  );
          },
          child: SizedBox(
            // width: SizeHelper(context).width,
            height: SizeHelper(context).height,
            child: Image.asset("assets/images/splash.png"),
          ),
        ),
      ),
    );
  }
}
