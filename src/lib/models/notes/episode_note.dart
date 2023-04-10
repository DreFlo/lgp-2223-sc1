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
    ),
    ForeignKey(
      childColumns: ['id'],
      parentColumns: ['id'],
      entity: Note,
    ),
  ],
)
class EpisodeNote {
  @PrimaryKey()
  final int id;

  @ColumnInfo(name: 'episode_id')
  final int episodeId;

  EpisodeNote({
    required this.id,
    required this.episodeId,
  });
}
