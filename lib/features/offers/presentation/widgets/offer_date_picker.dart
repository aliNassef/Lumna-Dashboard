import 'package:flutter/material.dart';

abstract class OfferDatePicker {
  static Future<DateTime?> pick({
    required BuildContext context,
    required DateTime? startsAt,
    required DateTime? endsAt,
    required bool isStart,
  }) {
    final now = DateTime.now();
    final initialDate = isStart ? startsAt ?? now : endsAt ?? startsAt ?? now;
    return showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 5),
    );
  }
}
