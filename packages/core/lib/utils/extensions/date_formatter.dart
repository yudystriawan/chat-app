import 'package:intl/intl.dart';

extension DateTimeX on DateTime {
  /// default format `12 Aug 2023 11:59`
  String toStringFormatted([String? pattern = 'dd MMM yyyy hh:mm']) {
    return DateFormat(pattern).format(this);
  }

  /// format String date time
  /// return `today`, `yesterday` or `dd/MM/yy`
  String toStringDate() {
    final now = DateTime.now();

    final currentDateTime = DateTime(now.year, now.month, now.day);

    final compareDateTime = DateTime(year, month, day);

    if (currentDateTime == compareDateTime) return 'Today';

    if (compareDateTime == currentDateTime.subtract(const Duration(days: 1))) {
      return 'Yesterday';
    }

    return toStringFormatted('dd/MM/yy');
  }
}
