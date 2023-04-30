import 'package:src/models/notes/note_episode_note_super_entity.dart';

final mockEpisodeNotes = [
  NoteEpisodeNoteSuperEntity(
      id: 2,
      title: 'S01E01', //S04E03 -> title supposed to follow this format
      content: 'This is a note about an episode.',
      date: DateTime.now(),
      episodeId: 2)
];
