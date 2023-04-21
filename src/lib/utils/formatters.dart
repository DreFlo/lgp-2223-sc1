import 'package:intl/intl.dart';

String formatDeadline(DateTime deadline) {
  Map<int, String> suffixes = {
    1: 'st',
    2: 'nd',
    3: 'rd',
  };

  String ordinalDay = (deadline.day >= 11 && deadline.day <= 13)
      ? 'th'
      : suffixes[deadline.day % 10] ?? 'th';

  return DateFormat("MMM d'$ordinalDay' - ha")
      .format(deadline)
      .replaceAll('AM', 'am')
      .replaceAll('PM', 'pm');
}