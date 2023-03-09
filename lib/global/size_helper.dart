import 'package:flutter/material.dart';

class SizeHelper {
  BuildContext context;

  SizeHelper(this.context);

  Size get size => MediaQuery.of(context).size;
  double get height => MediaQuery.of(context).size.height;
  double get width => MediaQuery.of(context).size.width;
  double get bottom => MediaQuery.of(context).viewInsets.bottom;
}
