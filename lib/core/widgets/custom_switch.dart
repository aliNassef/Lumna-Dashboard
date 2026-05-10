import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';

import '../extensions/color_extensions.dart';

class CustomSwitch extends StatefulWidget {
  const CustomSwitch({
    super.key,
    required this.onToggle,
    this.value,
  });
  final ValueChanged<bool> onToggle;
  final bool? value;

  @override
  State<CustomSwitch> createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch> {
  bool? value;
  @override
  void initState() {
    super.initState();
    value = widget.value ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return FlutterSwitch(
      width: 55.0,
      height: 30.0,
      valueFontSize: 0,
      toggleSize: 20.0,
      value: value!,
      activeColor: context.colors.primary,
      inactiveColor: context.colors.primaryContainer.withValues(
        alpha: 0.4,
      ),
      activeToggleColor: context.colors.onPrimary,
      inactiveToggleColor: context.colors.primary,
      borderRadius: 30.0,
      padding: 8.0,
      showOnOff: false,
      onToggle: (val) {
        setState(() => value = val);
        widget.onToggle(val);
      },
    );
  }
}
