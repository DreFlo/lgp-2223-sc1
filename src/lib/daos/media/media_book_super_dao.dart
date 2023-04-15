import 'package:src/daos/media/media_dao.dart';
import 'package:src/daos/media/book_dao.dart';
import 'package:src/models/media/media.dart';
import 'package:src/models/media/book.dart';
import 'package:src/models/media/media_book_super_entity.dart';
import 'package:src/utils/service_locator.dart';
import 'package:src/utils/exceptions.dart';

class MediaBookSuperDao {
  static final MediaBookSuperDao _singleton = MediaBookSuperDao._internal();

  factory MediaBookSuperDao() {
    return _singleton;
  }

  MediaBookSuperDao._internal();

  Future<MediaBookSuperEntity> findMediaBookByMediaId(int id) async {
    final mediaStream = serviceLocator<MediaDao>().findMediaById(id);
    Media? firstNonNullMedia =
        await mediaStream.firstWhere((media) => media != null);
    Media media = firstNonNullMedia!;
    final bookStream = serviceLocator<BookDao>().findBookById(media.id ?? 0);
    Book? firstNonNullBook =
        await bookStream.firstWhere((book) => book != null);
    Book book = firstNonNullBook!;

    return MediaBookSuperEntity.fromMediaAndBook(media, book);
  }

  Future<List<MediaBookSuperEntity>> findAllMediaBooks() {
    return serviceLocator<BookDao>().findAllBooks().then((booksList) async {
      List<MediaBookSuperEntity> mediaBooksSuperEntities = [];

      for (var book in booksList) {
        final mediaStream = serviceLocator<MediaDao>().findMediaById(book.id);
        Media? firstNonNullMedia =
            await mediaStream.firstWhere((media) => media != null);
        Media media = firstNonNullMedia!;

        mediaBooksSuperEntities
            .add(MediaBookSuperEntity.fromMediaAndBook(media, book));
      }

      return mediaBooksSuperEntities;
    });
  }

  Future<int> insertMediaBookSuperEntity(
      MediaBookSuperEntity mediaBookSuperEntity) async {
    final media = mediaBookSuperEntity.toMedia();

    int mediaId = await serviceLocator<MediaDao>().insertMedia(media);

    final mediaBookSuperEntityWithId =
        mediaBookSuperEntity.copyWith(id: mediaId);

    final book = mediaBookSuperEntityWithId.toBook();

    await serviceLocator<BookDao>().insertBook(book);

    return mediaId;
  }

  Future<void> insertMediaBookSuperEntities(
      List<MediaBookSuperEntity> mediaBookSuperEntities) async {
    for (var mediaBookSuperEntity in mediaBookSuperEntities) {
      await insertMediaBookSuperEntity(mediaBookSuperEntity);
    }
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
