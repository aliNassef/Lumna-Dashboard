import 'package:flutter/material.dart';

extension MediaQuerySize on BuildContext {
  double get height => MediaQuery.sizeOf(this).height;
  double get width => MediaQuery.sizeOf(this).width;
}
