import 'package:flutter/material.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

import '../../../global/size_helper.dart';

class NoInternetScreen extends StatelessWidget {
  const NoInternetScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.asset('assets/images/dino.png'),
          SizedBox(
            height: SizeHelper(context).height * 0.045,
          ),
          GradientText(
            'No Internet',
            gradientDirection: GradientDirection.ltr,
            style: const TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 38.0,
            ),
            colors: const [
              Color(0xFFff0006),
              Color(0xFFFF8A00),
            ],
          ),
          SizedBox(
            height: SizeHelper(context).height * 0.04,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: SizeHelper(context).width * 0.14),
            child: const Text(
              "Please check your internet settings and app permissions",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                letterSpacing: 2.5,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
