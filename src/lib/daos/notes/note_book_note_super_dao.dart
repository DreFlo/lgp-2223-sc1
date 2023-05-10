import 'package:src/daos/notes/note_dao.dart';
import 'package:src/daos/notes/book_note_dao.dart';
import 'package:src/models/notes/note.dart';
import 'package:src/models/notes/note_book_note_super_entity.dart';
import 'package:src/utils/service_locator.dart';
import 'package:src/utils/exceptions.dart';

class NoteBookNoteSuperDao {
  static final NoteBookNoteSuperDao _singleton =
      NoteBookNoteSuperDao._internal();

  factory NoteBookNoteSuperDao() {
    return _singleton;
  }

  NoteBookNoteSuperDao._internal();

  Future<List<NoteBookNoteSuperEntity>> findNoteBookNoteByBookId(int bookId) {
    return serviceLocator<BookNoteDao>()
        .findBookNoteByBookId(bookId)
        .then((bookNotesList) async {
      List<NoteBookNoteSuperEntity> noteBookNoteSuperEntities = [];

      for (var bookNote in bookNotesList) {
        final noteStream = serviceLocator<NoteDao>().findNoteById(bookNote.id);
        Note? firstNonNullNote =
            await noteStream.firstWhere((note) => note != null);
        Note note = firstNonNullNote!;
        noteBookNoteSuperEntities.add(
            NoteBookNoteSuperEntity.fromNoteBookNoteEntity(bookNote, note));
      }
      return noteBookNoteSuperEntities;
    });
  }

  Future<int> insertNoteBookNoteSuperEntity(
    NoteBookNoteSuperEntity noteBookNoteSuperEntity,
  ) async {
    final note = noteBookNoteSuperEntity.toNote();

    int noteId = await serviceLocator<NoteDao>().insertNote(note);

    final noteBookNoteSuperEntityWithId =
        noteBookNoteSuperEntity.copyWith(id: noteId);

    final bookNote = noteBookNoteSuperEntityWithId.toBookNote();

    await serviceLocator<BookNoteDao>().insertBookNote(bookNote);

    return noteId;
  }

  Future<void> insertNoteBookNoteSuperEntities(
    List<NoteBookNoteSuperEntity> noteBookNoteSuperEntities,
  ) async {
    for (var noteBookNoteSuperEntity in noteBookNoteSuperEntities) {
      await insertNoteBookNoteSuperEntity(noteBookNoteSuperEntity);
    }
  }

  Future<void> updateNoteBookNoteSuperEntity(
    NoteBookNoteSuperEntity noteBookNoteSuperEntity,
  ) async {
    if (noteBookNoteSuperEntity.id == null) {
      throw DatabaseOperationWithoutId(
          "Id can't be null for update for NoteBookNoteSuperEntity");
    }

    final note = noteBookNoteSuperEntity.toNote();

    await serviceLocator<NoteDao>().updateNote(note);

    final bookNote = noteBookNoteSuperEntity.toBookNote();

    await serviceLocator<BookNoteDao>().updateBookNote(bookNote);
  }

  Future<void> deleteNoteBookNoteSuperEntity(
    NoteBookNoteSuperEntity noteBookNoteSuperEntity,
  ) async {
    if (noteBookNoteSuperEntity.id == null) {
      throw DatabaseOperationWithoutId(
          "Id can't be null for update for NoteBookNoteSuperEntity");
    }
    
    final note = noteBookNoteSuperEntity.toNote();

    await serviceLocator<NoteDao>().deleteNote(note);
  }
}

final noteBookNoteSuperDao = NoteBookNoteSuperDao();
