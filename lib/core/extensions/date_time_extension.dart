import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  String get monthDayYearText {
    final localDate = toLocal();
    return DateFormat('d / M / y').format(localDate);
  }

  String get orderDisplayText {
    final localDate = toLocal();
    final now = DateTime.now();
    final isToday =
        localDate.year == now.year &&
        localDate.month == now.month &&
        localDate.day == now.day;

    final time = DateFormat('hh:mm a').format(localDate);
    if (isToday) {
      return 'Today, $time';
    }

    return DateFormat('dd MMM, hh:mm a').format(localDate);
  }

  String get orderDetailsDisplayText {
    final localDate = toLocal();
    return DateFormat('MMMM d, y \'at\' hh:mm a').format(localDate);
  }
}
