import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../core/translation/locale_keys.g.dart';

class NavBarItemData {
  final String label;
  final IconData icon;

  const NavBarItemData({required this.label, required this.icon});
}

final List<NavBarItemData> navBarItems = [
  NavBarItemData(
    label: LocaleKeys.home.tr(),
    icon: Icons.home_outlined,
  ),
  NavBarItemData(
    label: LocaleKeys.products.tr(),
    icon: Icons.category,
  ),
NavBarItemData(
    label: LocaleKeys.orders.tr(),
    icon: Icons.delivery_dining,
  ),
  NavBarItemData(
    label: LocaleKeys.account.tr(),
    icon: Icons.person_outline_rounded,
  ),
];
