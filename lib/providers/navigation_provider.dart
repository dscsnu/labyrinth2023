import 'package:flutter/material.dart';
import 'package:liquid_swipe/liquid_swipe.dart';

class NavigationProvider extends ChangeNotifier {
  final LiquidController _liquidController = LiquidController();
  LiquidController get liquidController => _liquidController;

  final PageController _registrationPageController = PageController();
  PageController get pageController => _registrationPageController;
}
