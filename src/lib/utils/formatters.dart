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

String formatEventTime(DateTime eventTime) {
  String? day = eventTime.day.toString().padLeft(2, '0'),
      month = eventTime.month.toString().padLeft(2, '0'),
      year = eventTime.year.toString(),
      minute = eventTime.minute.toString().padLeft(2, '0');

  // Convert start and end times to DateTime objects
  final dateTime = DateTime(eventTime.year, eventTime.month, eventTime.day,
      eventTime.hour, eventTime.minute);

  final hour = DateFormat('h').format(dateTime);
  final amPm = DateFormat('a').format(dateTime);

  return "$day/$month/$year $hour:$minute$amPm";
}
