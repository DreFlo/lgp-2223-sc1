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
      onDelete: ForeignKeyAction.cascade,
      onUpdate: ForeignKeyAction.restrict,
    ),
    ForeignKey(
      childColumns: ['id'],
      parentColumns: ['id'],
      entity: Note,
      onDelete: ForeignKeyAction.cascade,
      onUpdate: ForeignKeyAction.restrict,
    ),
  ],
)
class SubjectNote {
  @PrimaryKey()
  final int id;

  @ColumnInfo(name: 'subject_id')
  final int subjectId;

  SubjectNote({
    required this.id,
    required this.subjectId,
  });
}
