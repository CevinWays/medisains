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

  static String dateFormat(String date){
    String format =  formatDate(
        DateTime(
            int.parse(date.split("/")[0]),
            int.parse(date.split("/")[1]),
            int.parse(date.split("/")[2])
        ), [dd, ' ', M, ' ', yy]);
    return format;
  }

  static String dateFormatSeparator(date){
    String format =  formatDate(
        DateTime(
            int.parse(date.split("-")[0]),
            int.parse(date.split("-")[1]),
            int.parse(date.split("-")[2])),
        [dd, ' ', MM, ' ', yyyy]);
    return format;
  }

  static String dateTimeFormatFromString(String date) {
    String format = formatDate(
        DateTime(
          int.parse(date.toString().split(" ").first.split("-")[0]),
          int.parse(date.toString().split(" ").first.split("-")[1]),
          int.parse(date.toString().split(" ").first.split("-")[2]),
          int.parse(date.toString().split(" ").last.split(":")[0]),
          int.parse(date.toString().split(" ").last.split(":")[1]),
          int.parse(date.toString().split(" ").last.split(":")[2])),
        [dd, '/', mm, '/', yyyy]);
    return format;
  }

  static String dateTimeMoreShort(String date) {
    String format = formatDate(
        DateTime(
            int.parse(date.toString().split(" ").first.split("-")[0]),
            int.parse(date.toString().split(" ").first.split("-")[1]),
            int.parse(date.toString().split(" ").first.split("-")[2]),
            int.parse(date.toString().split(" ").last.split(":")[0]),
            int.parse(date.toString().split(" ").last.split(":")[1]),
            int.parse(date.toString().split(" ").last.split(":")[2])),
        [d, '/', m, '/', yy]);
    return format;
  }

  static String dateFormatsSeparator(String date){
    String _format =  formatDate(
        DateTime(
            int.parse(date.toString().split(" ").first.split("-")[0]),
            int.parse(date.toString().split(" ").first.split("-")[1]),
            int.parse(date.toString().split(" ").first.split("-")[2]),
            int.parse(date.toString().split(" ").last.split(":")[0]),
            int.parse(date.toString().split(" ").last.split(":")[1]),
            int.parse(date.toString().split(" ").last.split(":")[2])),
        [dd, ' ', M, ' ', yyyy]);
    return _format;
  }
}