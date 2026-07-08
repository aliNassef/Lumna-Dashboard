import 'package:flutter/material.dart';

import '../../../../core/extensions/color_extensions.dart';
import '../../../../core/extensions/typography_extension.dart';

class DateCell extends StatelessWidget {
  const DateCell({super.key, required this.date});

  final String date;

  @override
  Widget build(BuildContext context) {
    return Text(
      date,
      style: context.typography.medium12.copyWith(
        color: context.colors.primaryContainer,
      ),
    );
  }
}
