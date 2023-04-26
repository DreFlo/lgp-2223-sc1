import 'package:intl/intl.dart';

class DateFormatter {
  static DateFormat dateFormat = DateFormat('dd/MM/yyyy');

  static String format(DateTime date) {
    return dateFormat.format(date);
  }

  static DateTime day(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }
}
