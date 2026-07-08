import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/extensions/color_extensions.dart';
import '../../../../core/extensions/typography_extension.dart';
import '../../../../core/utils/spacer.dart';

class CustomerCell extends StatelessWidget {
  const CustomerCell({
    super.key,
    required this.name,
    required this.initials,
  });

  final String name;
  final String initials;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: context.colors.primary,
          backgroundImage: initials != 'N/A' ? NetworkImage(initials) : null,
        ),
        const Gap(Spacing.medium),
        Expanded(
          child: Text(
            name,
            overflow: TextOverflow.ellipsis,
            style: context.typography.bold14,
          ),
        ),
      ],
    );
  }
}
