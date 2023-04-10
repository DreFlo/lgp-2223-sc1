import 'package:src/daos/media/media_dao.dart';
import 'package:src/daos/media/book_dao.dart';
import 'package:src/models/media/media_book_super_entity.dart';
import 'package:src/utils/service_locator.dart';
import 'package:src/utils/exceptions.dart';

class MediaBookSuperDao {
  static final MediaBookSuperDao _singleton = MediaBookSuperDao._internal();

  factory MediaBookSuperDao() {
    return _singleton;
  }

  MediaBookSuperDao._internal();

  Future<int> insertMediaBookSuperEntity(
      MediaBookSuperEntity mediaBookSuperEntity) async {
    if (mediaBookSuperEntity.id != null) {
      throw DatabaseOperationWithId(
          "Id can't be passed to insert for MediaSeriesSuperEntity");
    }

    final media = mediaBookSuperEntity.toMedia();

    int mediaId = await serviceLocator<MediaDao>().insertMedia(media);

    final mediaBookSuperEntityWithId =
        mediaBookSuperEntity.copyWith(id: mediaId);

    final book = mediaBookSuperEntityWithId.toBook();

    await serviceLocator<BookDao>().insertBook(book);

    return mediaId;
  }

  Future<void> updateMediaBookSuperEntity(
      MediaBookSuperEntity mediaBookSuperEntity) async {
    if (mediaBookSuperEntity.id == null) {
      throw DatabaseOperationWithoutId(
          "Id can't be null for update in MediaBookSuperEntity");
    }

    final media = mediaBookSuperEntity.toMedia();

    await serviceLocator<MediaDao>().updateMedia(media);

    final book = mediaBookSuperEntity.toBook();

    await serviceLocator<BookDao>().updateBook(book);
  }

  Future<void> deleteMediaBookSuperEntity(
      MediaBookSuperEntity mediaBookSuperEntity) async {
    if (mediaBookSuperEntity.id == null) {
      throw DatabaseOperationWithoutId(
          "Id can't be null for update in MediaBookSuperEntity");
    }

    final media = mediaBookSuperEntity.toMedia();

    await serviceLocator<MediaDao>().deleteMedia(media);
  }
}

final mediaBookSuperDao = MediaBookSuperDao();
