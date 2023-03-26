import 'package:floor/floor.dart';
import 'package:src/models/notes/note.dart';
import 'package:src/models/student/subject.dart';

@Entity(
  tableName: 'subject_note',
    foreignKeys: [
    ForeignKey(
      childColumns: ['subject_id'],
      parentColumns: ['id'],
      entity: Subject,
    )
  ],
)
class SubjectNote extends Note {

  @ColumnInfo(name: 'subject_id')
  final int subjectId;

  SubjectNote({
    int? id,
    required String title,
    required String content,
    required DateTime date,
    required this.subjectId,
  }): super(id: id, title: title, content: content, date: date);
}
