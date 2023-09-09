import 'package:intl/intl.dart';

extension DateTimeX on DateTime {
  /// default format `12 Aug 2023 11:59`
  String toStringFormatted([String? pattern = 'dd MMM yyyy hh:mm']) {
    return DateFormat(pattern).format(this);
  }
}
