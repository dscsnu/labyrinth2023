import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../../global/constants/colors.dart';
import '../../global/size_helper.dart';
import '../../global/widgets/popup_alert.dart';
import '../../global/widgets/rounded_loading_button.dart';
import '../../global/widgets/text_input_widget.dart';
import '../../providers/navigation_provider.dart';
import '../../services/authentication_service.dart';
import '../login/widgets/reset_prompt.dart';
import 'widgets/add_new_member.dart';
import 'widgets/login_prompt.dart';

class MemberRegistrationScreen extends StatefulWidget {
  const MemberRegistrationScreen({Key? key}) : super(key: key);

  @override
  _MemberRegistrationScreenState createState() =>
      _MemberRegistrationScreenState();
}

class _MemberRegistrationScreenState extends State<MemberRegistrationScreen>
    with AutomaticKeepAliveClientMixin<MemberRegistrationScreen> {
  List<String> members = ["", ""];
  List<TextEditingController> memberController = [
    TextEditingController(),
    TextEditingController()
  ];
  final _teamController = TextEditingController();
  final _buttonController = RoundedLoadingButtonController();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var liquidNavProvider = Provider.of<NavigationProvider>(context);

    return WillPopScope(
      onWillPop: () async {
        liquidNavProvider.pageController.jumpToPage(0);
        return false;
      },
      child: Container(
        color: kBackgroundColor,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () =>
                      liquidNavProvider.pageController.animateToPage(
                    0,
                    duration: const Duration(milliseconds: 700),
                    curve: Curves.decelerate,
                  ),
                ),
              ),
              SizedBox(
                height: SizeHelper(context).height * 0.09,
              ),
              const Text(
                "Registration",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 35,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              const Text(
                "Register with your SNIoE ID/personal mail",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: SizeHelper(context).height * 0.05,
              ),
              TextInputWidget(
                labelText: "Team Name",
                hintText: "Team#9812",
                icon: Icons.group,
                controller: _teamController,
                maxCharLength: 8,
                isMember: true,
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: members.length,
                padding: const EdgeInsets.all(0),
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  return TextInputWidget(
                    labelText: "Member #" + (index + 1).toString(),
                    hintText: "Member Name",
                    icon: Icons.person,
                    controller: memberController[index],
                    isMember: true,
                    onChanged: (String s) {
                      members[index] = s;
                    },
                  );
                },
              ),
              SizedBox(
                height: SizeHelper(context).height * 0.08,
              ),
              AddNewMember(
                add: (members.length == 2),
                onClick: () {
                  setState(
                    () {
                      if (members.length == 2) {
                        memberController.add(TextEditingController());
                        members.add("");
                      } else {
                        members.removeAt(2);
                        memberController.removeAt(2);
                      }
                    },
                  );
                },
              ),
              (members.length < 4)
                  ? SizedBox(
                      height: SizeHelper(context).height * 0.08,
                    )
                  : const SizedBox(),
              Container(
                width: SizeHelper(context).width * 0.6,
                padding: const EdgeInsets.all(25),
                child: LoadingRoundedButton(
                  text: "Create Account",
                  buttonController: _buttonController,
                  onClick: () async {

                    RegExp regEx = RegExp(r"[a-zA-Z_]");
                    if(!members.every((element) => regEx.hasMatch(element))) {
                      showDialog(
                        context: context,
                        builder: (context) => PopupAlert(
                          bodyText: "Member names are invalid",
                          onConfirm: () => Navigator.pop(context),
                          buttonText: 'Try Again',
                          cancelOrNo: false,
                        ),
                      );
                      _buttonController.reset();
                      return;
                    }

                    String registrationResult =
                        await AuthenticationService.register(
                      _teamController.text,
                      AuthenticationService.password,
                      AuthenticationService.email,
                      members,
                    );

                    if (registrationResult == "ok") {
                      liquidNavProvider.liquidController.animateToPage(page: 3);
                    } else {
                      _buttonController.reset();
                      showDialog(
                        context: context,
                        builder: (context) => PopupAlert(
                          bodyText: registrationResult,
                          onConfirm: () => Navigator.pop(context),
                          buttonText: 'Try Again',
                          cancelOrNo: false,
                        ),
                      );
                    }
                  },
                ),
              ),
              LoginPrompt(hasAccount: true, liquidNavProvider: liquidNavProvider),
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
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
