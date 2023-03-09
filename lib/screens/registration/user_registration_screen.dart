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
        children: [
          SizedBox(
            height: SizeHelper(context).height * 0.1,
          ),
          const Text(
            "Registration",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 35,
            ),
          ),
          const SizedBox(height: 15),
          const Text(
            "Register with your SNIoE ID/personal mail",
          ),
          SizedBox(
            height: SizeHelper(context).height * 0.05,
          ),
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
            width: SizeHelper(context).width * 0.6,
            padding: const EdgeInsets.all(25),
            child: LoadingRoundedButton(
              text: "Next",
              buttonController: _buttonController,
              onClick: () {
                String s = validate();
                if (s == "ok") {
                  AuthenticationService.email = _emailController.text.trim();
                  AuthenticationService.password = _passwordController.text;

                  _buttonController.success();
                  liquidNavProvider.pageController.animateToPage(
                    1,
                    curve: Curves.decelerate,
                    duration: const Duration(milliseconds: 700),
                  );
                  _buttonController.reset();
                } else {
                  _buttonController.reset();
                  showDialog(
                    context: context,
                    builder: (context) => PopupAlert(
                      bodyText: s,
                      onConfirm: () => Navigator.pop(context),
                      cancelOrNo: false,
                      buttonText: 'Try Again',
                    ),
                  );
                }
              },
            ),
          ),
          SizedBox(
            height: SizeHelper(context).height * 0.02,
          ),
          LoginPrompt(liquidNavProvider: liquidNavProvider),
          SizedBox(
            height: SizeHelper(context).height * 0.017,
          ),
          const ResetPrompt(),
          SizedBox(
            height: SizeHelper(context).height * 0.08,
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  String validate() {
    var regex = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

    if(_emailController.text.isEmpty || !regex.hasMatch(_emailController.text)){
      return "Email is invalid";
    } else if(_passwordController.text.isEmpty || _passwordController.text.length < 6) {
      return "Password is invalid. Must contain at least 5 characters";
    } else if(_passwordController.text != _confirmController.text) {
      return "Password does not match";
    }
    return "ok";
  }
}
