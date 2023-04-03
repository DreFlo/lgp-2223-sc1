import 'package:src/models/notes/episode_note.dart';
import 'package:src/models/notes/note.dart';

class NoteEpisodeNoteSuperEntity {
  int? id;
  String title;
  String content;
  DateTime date;
  int episodeId;

  NoteEpisodeNoteSuperEntity({
    this.id,
    required this.title,
    required this.content,
    required this.date,
    required this.episodeId,
  });

  NoteEpisodeNoteSuperEntity.fromNoteEpisodeNoteEntity(
      EpisodeNote episodeNote, Note note)
      : id = note.id,
        title = note.title,
        content = note.content,
        date = note.date,
        episodeId = episodeNote.episodeId;

  Note toNote() {
    return Note(
      id: id,
      title: title,
      content: content,
      date: date,
    );
  }

  EpisodeNote toEpisodeNote() {
    return EpisodeNote(
      id: id!,
      episodeId: episodeId,
    );
  }

  NoteEpisodeNoteSuperEntity copyWith({
    int? id,
    String? title,
    String? content,
    DateTime? date,
    int? episodeId,
  }) {
    return NoteEpisodeNoteSuperEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      date: date ?? this.date,
      episodeId: episodeId ?? this.episodeId,
    );
  }
}
