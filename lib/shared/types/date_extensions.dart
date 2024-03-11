import 'package:intl/intl.dart';

extension DateTimeX on DateTime {
  String toFormattedString([String? format]) {
    String defaultFormat = 'EEEE, d MMMM yyyy hh:mm a';
    if (format != null) {
      defaultFormat = format;
    }

    return DateFormat(defaultFormat).format(this);
  }
}
