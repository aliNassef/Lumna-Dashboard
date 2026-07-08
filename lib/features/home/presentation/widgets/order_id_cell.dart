import 'package:flutter/material.dart';

import '../../../../core/extensions/color_extensions.dart';
import '../../../../core/extensions/typography_extension.dart';

class OrderIdCell extends StatelessWidget {
  const OrderIdCell({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context) {
    return Text(
      id,
      style: context.typography.bold14.copyWith(color: context.colors.primary),
    );
  }
}
