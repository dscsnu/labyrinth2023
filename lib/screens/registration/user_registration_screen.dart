import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../../global/size_helper.dart';
import '../../global/widgets/popup_alert.dart';
import '../../global/widgets/rounded_loading_button.dart';
import '../../global/widgets/text_input_widget.dart';
import '../../providers/navigation_provider.dart';
import '../../services/authentication_service.dart';
import '../login/widgets/reset_prompt.dart';
import 'widgets/login_prompt.dart';

class UserRegistrationScreen extends StatefulWidget {
  const UserRegistrationScreen({Key? key}) : super(key: key);

  @override
  _UserRegistrationScreenState createState() => _UserRegistrationScreenState();
}

class _UserRegistrationScreenState extends State<UserRegistrationScreen>
    with AutomaticKeepAliveClientMixin<UserRegistrationScreen> {
  final _emailController = TextEditingController(),
      _passwordController = TextEditingController(),
      _confirmController = TextEditingController();
  final _buttonController = RoundedLoadingButtonController();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var liquidNavProvider = Provider.of<NavigationProvider>(context);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  liquidNavProvider.liquidController.animateToPage(page: 2);
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: const [
                    SizedBox(width: 10),
                    Icon(
                      Icons.arrow_back, 
                      color: Colors.white,
                      size: 17,
                    ),
                    SizedBox(width: 5),
                    Text(
                      "Back",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Image.asset(
                "assets/images/Frame 47.png",
                width: SizeHelper(context).width * 0.7,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Registration",
                  style: TextStyle(
                    fontFamily: "NeueMachina",
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 35,
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  "Registration with your SNU Email down below",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 20),
                TextInputWidget(
                  labelText: "Email ID",
                  hintText: "Enter a valid email ID here",
                  icon: Icons.alternate_email,
                  controller: _emailController,
                ),
                TextInputWidget(
                  labelText: "Password",
                  hintText: "Enter your password here",
                  isPassword: true,
                  icon: Icons.password,
                  controller: _passwordController,
                ),
                TextInputWidget(
                  labelText: "Confirm Password",
                  hintText: "Re-enter your password here",
                  isPassword: true,
                  icon: Icons.password,
                  controller: _confirmController,
                ),
                SizedBox(
                  height: SizeHelper(context).height * 0.01,
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: LoadingRoundedButton(
                    text: "Next",
                    icon: const Icon(Icons.arrow_forward, color: Colors.black),
                    buttonController: _buttonController,
                    onClick: () {
                      AuthenticationService.email = _emailController.text.trim();
                      AuthenticationService.password = _passwordController.text;

                      _buttonController.success();
                      liquidNavProvider.pageController.animateToPage(
                        1,
                        curve: Curves.decelerate,
                        duration: const Duration(milliseconds: 700),
                      );
                      _buttonController.reset();
                    },
                  ),
                ),
                SizedBox(
                  height: SizeHelper(context).height * 0.02,
                ),
                LoginPrompt(hasAccount: true, liquidNavProvider: liquidNavProvider),
                SizedBox(
                  height: SizeHelper(context).height * 0.017,
                ),
                const ResetPrompt(),
                SizedBox(
                  height: SizeHelper(context).height * 0.08,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
