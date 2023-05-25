import 'package:floor/floor.dart';

class DateTimeConverter extends TypeConverter<DateTime, int> {
  @override
  DateTime decode(int databaseValue) {
    return DateTime.fromMillisecondsSinceEpoch(databaseValue);
  }

  @override
  int encode(DateTime value) {
    return value.millisecondsSinceEpoch;
  }
}

class DateTimeNullableConverter extends TypeConverter<DateTime?, int> {
  @override
  DateTime decode(int? databaseValue) {
    return databaseValue == null
        ? DateTime.now()
        : DateTime.fromMillisecondsSinceEpoch(databaseValue);
  }

  @override
  int encode(DateTime? value) {
    return value == null
        ? DateTime.now().millisecondsSinceEpoch
        : value.millisecondsSinceEpoch;
  }
}

class ListConverter extends TypeConverter<List<int>, String> {
  @override
  List<int> decode(String databaseValue) {
    return databaseValue.split(',').map((e) => int.parse(e)).toList();
  }

  @override
  String encode(List<int> value) {
    return value.join(',');
  }
}
