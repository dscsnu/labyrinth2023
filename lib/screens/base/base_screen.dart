import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:provider/provider.dart';

import '../../providers/connectivity_provider.dart';
import '../../providers/navigation_provider.dart';
import '../landing/landing_screen.dart';
import '../login/login_screen.dart';
import '../no_internet/no_internet_screen.dart';
import '../registration/registration_screen.dart';

class BaseScreen extends StatelessWidget {
  const BaseScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var liquidNavProvider = Provider.of<NavigationProvider>(context);
    var connectivityProvider = Provider.of<ConnectivityProvider>(context);
    return Scaffold(
      body: connectivityProvider.connectivityStatus != ConnectivityResult.none
          ? LiquidSwipe(
              pages: const [
                LandingScreen(),
                RegistrationScreen(),
                LoginScreen(),
              ],
              waveType: WaveType.circularReveal,
              liquidController: liquidNavProvider.liquidController,
              disableUserGesture: true,
              enableLoop: false,
            )
          : const NoInternetScreen(),
    );
  }
}
