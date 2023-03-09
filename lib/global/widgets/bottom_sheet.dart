import 'package:flutter/material.dart';
import 'package:labyrinth/global/size_helper.dart';


class BottomSheetLayout extends StatelessWidget {
  final Widget child;

  const BottomSheetLayout({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15.0),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(35),
          topRight: Radius.circular(35),
        ),
        color: Colors.white,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
              height: 4,
              width: SizeHelper(context).width * 0.3,
              decoration: const BoxDecoration(
                color: Color(0xFF121314),
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
            ),
            Container(
              height: 40,
            ),
          child,
        ],
      ),
    );
  }
}
