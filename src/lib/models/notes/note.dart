import 'package:floor/floor.dart';

@Entity(
  tableName: 'note',
)
class Note {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  final String title;

  final String content;

  final DateTime date;

  Note({
    this.id,
    required this.title,
    required this.content,
    required this.date,
  });
}
