import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';

import '../../../global/widgets/circular_icon_button.dart';

class AddNewMember extends StatelessWidget {
  final Function onClick;
  final bool add;
  const AddNewMember({
    Key? key,
    required this.onClick,
    required this.add,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Bounce(
      onPressed: () => onClick(),
      duration: const Duration(milliseconds: 100),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            (add) ? "Add new member" : "Remove member",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          CircularIconButton(
            icon: (add) ? Icons.add : Icons.remove,
            onClick: () => onClick(),
          ),
        ],
      ),
    );
  }
}
