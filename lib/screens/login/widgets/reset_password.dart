import 'package:flutter/material.dart';
import 'package:labyrinth/global/widgets/circular_icon_button.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../../../global/size_helper.dart';
import '../../../global/widgets/bottom_sheet.dart';
import '../../../global/widgets/popup_alert.dart';
import '../../../global/widgets/rounded_loading_button.dart';
import '../../../global/widgets/text_input_widget.dart';
import '../../../global/widgets/text_link_widget.dart';
import '../../../services/authentication_service.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final _passwordController = TextEditingController(),
      _confirmController = TextEditingController(),
      _tokenController = TextEditingController();
  final _buttonController = RoundedLoadingButtonController();

  @override
  Widget build(BuildContext context) {
    return BottomSheetLayout(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerRight,
              child: CircularIconButton(
                icon: Icons.keyboard_arrow_down,
                onClick: () {
                  Navigator.pop(context);
                },
              ),
            ),
            Container(
              height: SizeHelper(context).height * 0.025,
            ),
            const Text(
              "Reset Password",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 35,
              ),
            ),
            SizedBox(
              height: SizeHelper(context).height * 0.025,
            ),
            TextInputWidget(
              labelText: "Token",
              hintText: "Enter the 6 digit code",
              icon: Icons.token,
              controller: _tokenController,
              maxCharLength: 6,
              isNumber: true,
            ),
            TextInputWidget(
              labelText: "New password",
              hintText: "Enter your new password",
              icon: Icons.password,
              isPassword: true,
              controller: _passwordController,
            ),
            TextInputWidget(
              labelText: "Confirm new password",
              hintText: "Re-enter your new password here",
              isPassword: true,
              icon: Icons.password,
              controller: _confirmController,
            ),
            SizedBox(
              height: SizeHelper(context).height * 0.02,
            ),
            Container(
              width: SizeHelper(context).width * 0.6,
              padding: const EdgeInsets.all(25),
              child: LoadingRoundedButton(
                text: "Reset Password",
                buttonController: _buttonController,
                onClick: () async {
                  String resetResult = await AuthenticationService.reset(
                    _tokenController.text,
                    _passwordController.text,
                  );
                  if (resetResult == 'ok') {
                    _buttonController.success();
                    Navigator.pop(context);
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) => PopupAlert(
                        bodyText: resetResult,
                        onConfirm: () => Navigator.pop(context),
                        buttonText: 'Try again',
                      ),
                    );
                    _buttonController.reset();
                  }
                },
              ),
            ),
            SizedBox(
              height: SizeHelper(context).height * 0.02,
            ),
            Wrap(
              direction: Axis.horizontal,
              alignment: WrapAlignment.center,
              children: [
                const Text(
                  "Remember your password? ",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                TextLinkWidget(
                  text: "Login/Register now",
                  onClick: () {
                    FocusScope.of(context).unfocus();
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            SizedBox(
              height: SizeHelper(context).height * 0.02 +
                      SizeHelper(context).bottom,
            ),
          ],
        ),
      ),
    );
  }
}
