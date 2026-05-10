 import 'package:easy_localization/easy_localization.dart';

import '../extensions/color_extensions.dart';
import '../translation/locale_keys.g.dart';
import 'package:flutter/material.dart';
import '../../../../core/utils/shape.dart';

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({super.key, this.onChanged});
  final void Function(String)? onChanged;
  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      onTapOutside: (_) => FocusScope.of(context).unfocus(),
      keyboardType: TextInputType.text,

      decoration: InputDecoration(
        hintText: LocaleKeys.orders_search.tr(),
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Shape.extraLarge),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: context.colors.onPrimary,
      ),
    );
  }
}
