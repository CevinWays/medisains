import 'package:date_format/date_format.dart';
import 'package:intl/intl.dart';

class DateTimeHelper {
  static String currentDate({List<String> dateFormat}) {
    String format = formatDate(
        DateTime.now(),
        dateFormat == null
            ? [yyyy, '-', mm, '-', dd, ' ', HH, ':', nn, ':', ss]
            : dateFormat);
    return format;
  }
}