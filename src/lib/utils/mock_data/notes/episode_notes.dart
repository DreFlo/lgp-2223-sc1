import 'package:src/models/notes/note_episode_note_super_entity.dart';

final mockEpisodeNotes = [
  NoteEpisodeNoteSuperEntity(
      id: 2,
      title: 'S01E01', //S04E03 -> title supposed to follow this format
      content: 'This is a note about an episode.',
      date: DateTime.now().subtract(const Duration(days: 1)),
      episodeId: 2),
  NoteEpisodeNoteSuperEntity(
      id: 9,
      title: 'S01E01',
      content: 'Cool premise',
      date: DateTime.now(),
      episodeId: 10),
        NoteEpisodeNoteSuperEntity(
      id: 10,
      title: 'S01E02', 
      content: 'Poor train',
      date: DateTime.now().subtract(const Duration(days: 1)),
      episodeId: 11)
];
