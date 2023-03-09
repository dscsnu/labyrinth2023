import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/colors.dart';

class TextInputWidget extends StatefulWidget {
  final String labelText, hintText;
  final bool? isPassword, isMember, isNumber;
  final IconData? icon;
  final TextEditingController? controller;
  final Function? onChanged;
  final int? maxCharLength;
  final bool? backgroundBlack;

  const TextInputWidget({
    Key? key,
    required this.labelText,
    required this.hintText,
    this.isPassword,
    this.icon,
    this.controller,
    this.onChanged,
    this.maxCharLength,
    this.isMember,
    this.isNumber,
    this.backgroundBlack = true,
  }) : super(key: key);

  @override
  State<TextInputWidget> createState() => _TextInputWidgetState();
}

class _TextInputWidgetState extends State<TextInputWidget> {
  bool _passwordVisible = false;

  @override
  void initState() {
    super.initState();
    if (!(widget.isPassword ?? false)) {
      _passwordVisible = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
      child: Column(
        children: [
          // Row(
          //   children: [
          //     SizedBox(width: (widget.icon != null) ? 10 : 0),
          //     (widget.icon != null)
          //         ? Container(
          //             child: Icon(
          //               widget.icon,
          //               size: 12.5,
          //             ),
          //             padding: const EdgeInsets.all(2.5),
          //             decoration: BoxDecoration(
          //               borderRadius: BorderRadius.circular(30),
          //               gradient: kButtonGradient,
          //             ),
          //           )
          //         : const SizedBox(),
          //     const SizedBox(width: 10),
          //     Text(
          //       widget.labelText,
          //       style: const TextStyle(
          //         color: Colors.white,
          //       ),
          //     ),
          //   ],
          // ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: (widget.backgroundBlack ?? true) ? const Color(0xFF313233) : Colors.white,
              borderRadius: BorderRadius.circular(13),
              border: Border.all(
                color: (widget.backgroundBlack ?? true) ? Colors.white : const Color(0xFF313233),
                width: 1,
              ),
            ),
            padding: const EdgeInsets.fromLTRB(20, 5, 10, 5),
            child: TextFormField(
              inputFormatters: [
                LengthLimitingTextInputFormatter(widget.maxCharLength),
              ],
              textCapitalization: (widget.isMember ?? false)
                  ? TextCapitalization.words
                  : TextCapitalization.none,
              controller: widget.controller,
              onChanged: (String s) {
                if (widget.onChanged != null) {
                  widget.onChanged!(s);
                }
              },
              style: const TextStyle(
                color: kTextColor,
              ),
              decoration: InputDecoration(
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(13.0),
                ),
                hintText: widget.hintText,
                hintStyle: TextStyle(
                  color: (widget.backgroundBlack ?? true) ? kTextColor : Colors.black,
                  fontSize: 14,
                ),
                suffixIcon: (widget.isPassword ?? false)
                    ? IconButton(
                        icon: Icon(
                          _passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: const Color(0xFF757478),
                        ),
                        onPressed: () {
                          setState(
                            () {
                              _passwordVisible = !_passwordVisible;
                            },
                          );
                        },
                      )
                    : const SizedBox(
                        width: 0,
                        height: 0,
                      ),
              ),
              obscureText: !_passwordVisible,
              enableSuggestions: _passwordVisible,
              autocorrect: _passwordVisible,
              keyboardType: (widget.isNumber ?? false) ? TextInputType.number : TextInputType.text,
            ),
          ),
        ],
      ),
    );
  }
}
