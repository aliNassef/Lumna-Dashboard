import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/translation/locale_keys.g.dart';

class NotificationSelectionAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const NotificationSelectionAppBar({
    super.key,
    required this.selectedCount,
    required this.allSelected,
    required this.onToggleSelectAll,
    required this.onMarkSelectedAsRead,
    required this.onExitSelectionMode,
  });

  final int selectedCount;
  final bool allSelected;
  final VoidCallback onToggleSelectAll;
  final VoidCallback onMarkSelectedAsRead;
  final VoidCallback onExitSelectionMode;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.close),
        onPressed: onExitSelectionMode,
      ),
      title: Text(
        LocaleKeys.selected_count.tr(
          namedArgs: {'count': selectedCount.toString()},
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(allSelected ? Icons.deselect : Icons.select_all),
          onPressed: onToggleSelectAll,
        ),
        if (selectedCount > 0)
          IconButton(
            icon: const Icon(Icons.done_all),
            onPressed: onMarkSelectedAsRead,
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
