import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:labyrinth/screens/registration/widgets/login_prompt.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../../global/constants/colors.dart';
import '../../global/size_helper.dart';
import '../../global/widgets/popup_alert.dart';
import '../../global/widgets/rounded_loading_button.dart';
import '../../global/widgets/text_input_widget.dart';
import '../../global/widgets/text_link_widget.dart';
import '../../providers/home_provider.dart';
import '../../providers/navigation_provider.dart';
import '../../services/authentication_service.dart';
import '../home/home_screen.dart';
import 'widgets/forgot_password.dart';
import 'widgets/reset_prompt.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _teamController = TextEditingController(),
      _passwordController = TextEditingController();
  final _buttonController = RoundedLoadingButtonController();

  @override
  Widget build(BuildContext context) {
    var liquidNavProvider = Provider.of<NavigationProvider>(context);
    var homeProvider = Provider.of<HomeProvider>(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: kBackgroundColor,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
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
                    Image.asset(
                      "assets/images/lets_register.png",
                      width: SizeHelper(context).width * 0.7,
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    TextInputWidget(
                      labelText: "Team Name",
                      hintText: "Enter your team's name here",
                      icon: Icons.group,
                      controller: _teamController,
                      maxCharLength: 8,
                      isMember: true,
                    ),
                    TextInputWidget(
                      labelText: "Password",
                      hintText: "Enter your password",
                      isPassword: true,
                      icon: Icons.password,
                      controller: _passwordController,
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.fromLTRB(0, 0, 25, 0),
                      child: TextLinkWidget(
                        text: "Forgot Password?",
                        onClick: () {
                          FocusScope.of(context).unfocus();
                          showModalBottomSheet(
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            context: context,
                            builder: (context) => BackdropFilter(
                              child: const ForgotPassword(),
                              filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: SizeHelper(context).height * 0.01,
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(0, 25, 0, 25),
                      child: LoadingRoundedButton(
                        text: "Login",
                        buttonController: _buttonController,
                        onClick: () async {
                          // String loginResult = await AuthenticationService.login(
                          //   _teamController.text.trim(),
                          //   _passwordController.text,
                          // );
                          // TODO: Add back auth lol
                          String loginResult = 'ok';
                          if (loginResult == 'ok') {
                            _buttonController.success();
                            homeProvider.refreshHomeScreen();
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HomeScreen(),
                              ),
                              (route) => false,
                            );
                          } else {
                            _buttonController.reset();
                            showDialog(
                              context: context,
                              builder: (context) => PopupAlert(
                                bodyText: loginResult,
                                onConfirm: () => Navigator.pop(context),
                                buttonText: 'Try Again',
                                cancelOrNo: false,
                              ),
                            );
                          }
                        },
                      ),
                    ),
                    LoginPrompt(hasAccount: false, liquidNavProvider: liquidNavProvider),
                    SizedBox(
                      height: SizeHelper(context).height * 0.02,
                    ),
                    const ResetPrompt(),
                    SizedBox(
                      height: SizeHelper(context).height * 0.02,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
