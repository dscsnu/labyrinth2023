import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../../../global/size_helper.dart';
import '../../../global/widgets/bottom_sheet.dart';
import '../../../global/widgets/circular_icon_button.dart';
import '../../../global/widgets/popup_alert.dart';
import '../../../global/widgets/rounded_loading_button.dart';
import '../../../global/widgets/text_input_widget.dart';
import '../../../services/authentication_service.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _emailController = TextEditingController();

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
            SizedBox(
              height: SizeHelper(context).height * 0.05,
            ),
            const Text(
              "Forgot Password",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 35,
              ),
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
            SizedBox(
              height: SizeHelper(context).height * 0.025,
            ),
            Container(
              width: SizeHelper(context).width * 0.6,
              padding: const EdgeInsets.all(25),
              child: LoadingRoundedButton(
                text: "Send email",
                buttonController: _buttonController,
                onClick: () async {
                  String resetRequestResult =
                      await AuthenticationService.resetRequest(_emailController.text.trim());
                  if (resetRequestResult == 'ok') {
                    _buttonController.success();
                    Navigator.pop(context);
                    showDialog(
                      context: context,
                      builder: (context) => PopupAlert(
                        bodyText:
                            'Enter the code you received in your email in the reset password section',
                        onConfirm: () => Navigator.pop(context),
                        buttonText: 'Got it',
                        cancelOrNo: false,
                      ),
                    );
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) => PopupAlert(
                        bodyText: resetRequestResult,
                        onConfirm: () => Navigator.pop(context),
                        buttonText: 'Try again',
                        cancelOrNo: false,
                      ),
                    );
                    _buttonController.reset();
                  }
                },
              ),
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
