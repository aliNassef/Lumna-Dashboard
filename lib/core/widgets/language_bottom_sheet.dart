import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lumna_admin/core/translation/locale_keys.g.dart';

import '../navigation/app_navigation.dart';

class LanguageBottomSheet extends StatelessWidget {
  const LanguageBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            LocaleKeys.choose_language.tr(),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          _LanguageTile(
            title: LocaleKeys.english.tr(),
            locale: const Locale('en'),
          ),

          _LanguageTile(
            title: LocaleKeys.arabic.tr(),
            locale: const Locale('ar'),
          ),
        ],
      ),
    );
  }
}

class _LanguageTile extends StatelessWidget {
  final String title;
  final Locale locale;

  const _LanguageTile({
    required this.title,
    required this.locale,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      onTap: () {
        _changeLanguage(context, locale);
        context.pop();
      },
    );
  }

  void _changeLanguage(BuildContext context, Locale locale) {
    context.setLocale(locale);
  }
}
