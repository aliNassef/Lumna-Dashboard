import 'package:flutter/material.dart';

extension ColorExtensions on BuildContext {
  ColorScheme get colors => Theme.of(this).colorScheme;
}
