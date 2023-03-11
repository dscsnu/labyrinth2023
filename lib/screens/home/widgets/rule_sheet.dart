import 'package:flutter/material.dart';
import 'package:labyrinth/global/size_helper.dart';

import '../../../global/constants/colors.dart';
import '../../../services/rules_service.dart';

class RuleSheet extends StatefulWidget {
  final ScrollController scrollController;
  const RuleSheet({
    Key? key, 
    required this.scrollController,
  }) : super(key: key);

  @override
  State<RuleSheet> createState() => _RuleSheetState();
}

class _RuleSheetState extends State<RuleSheet> {
  List<dynamic> rules = [];

  @override
  void initState() {
    super.initState();
    getRules();
  }

  getRules() async {
    rules = await RuleService.getRules();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeHelper(context).width,
      padding: const EdgeInsets.all(15.0),
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(35),
          topRight: Radius.circular(35),
        ),
        color: Colors.white,
      ),
      child: ListView(
        controller: widget.scrollController,
        shrinkWrap: true,
        children: [
          Center(
            child: Container(
              height: 4,
              width: SizeHelper(context).width * 0.3,
              decoration: const BoxDecoration(
                color: Color(0xFF121314),
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Center(
            child: Text(
              'Rules',
              style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 10.0),
          (rules.isNotEmpty)
              ? Builder(
                builder: (context) {
                  List<Widget> _children = [];
                  for (String rule in rules) {
                    _children.add(
                      Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.all(10.0),
                            decoration: const BoxDecoration(
                              gradient: kTestGradient,
                              shape: BoxShape.circle,
                            ),
                            child: const CircleAvatar(
                              backgroundColor: Colors.transparent,
                              radius: 4.0,
                            ),
                          ),
                          const SizedBox(width: 10.0),
                          Expanded(
                            child: Text(
                              rule,
                              style: const TextStyle(
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );

                    _children.add(const SizedBox(height: 10.0));
                  }
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: _children,
                  );
                },
              )
              : const Center(
                  child: CircularProgressIndicator(
                    color: kPrimary,
                  ),
                ),
          const SizedBox(height: 20.0),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 60),
          //   child: RoundedButton(
          //     text: 'Got it!',
          //     onClick: () => Navigator.pop(context),
          //   ),
          // ),
        ],
      ),
    );
  }
}
