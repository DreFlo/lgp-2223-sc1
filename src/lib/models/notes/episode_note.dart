import 'package:floor/floor.dart';
import 'package:src/models/notes/note.dart';
import 'package:src/models/media/episode.dart';

@Entity(
  tableName: 'episode_note',
  foreignKeys: [
    ForeignKey(
      childColumns: ['episode_id'],
      parentColumns: ['id'],
      entity: Episode,
    )
  ],
)
class EpisodeNote extends Note {
  @ColumnInfo(name: 'episode_id')
  final int episodeId;

  EpisodeNote({
    int? id,
    required String title,
    required String content,
    required DateTime date,
    required this.episodeId,
  }) : super(id: id, title: title, content: content, date: date);
}
