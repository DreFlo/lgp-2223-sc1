import 'package:flutter/material.dart';
import 'package:src/daos/media/media_dao.dart';
import 'package:src/models/media/media_book_super_entity.dart';
import 'package:src/models/notes/note_book_note_super_entity.dart';
import 'package:src/pages/catalog_search/list_media_search/list_media_search.dart';
import 'package:src/pages/leisure/media_pages/book_page.dart';
import 'package:src/utils/enums.dart';
import 'package:src/utils/leisure/media_page_helpers.dart';
import 'package:src/utils/service_locator.dart';
import 'package:src/widgets/leisure/media_image_widgets/book_image.dart';
import 'package:src/widgets/leisure/media_image_widgets/media_image.dart';
import 'package:src/widgets/leisure/media_page_buttons/book_page_button.dart';

// List<String> leisureTags = [];
//       if (item.info.maturityRating != null && item.info.maturityRating != '') {
//         leisureTags.add(item.info.maturityRating);
//       }
//       if (item.info.categories != null && item.info.categories.length != 0) {
//         leisureTags.addAll(item.info.categories);
//       }
//       if (item.info.publisher != null && item.info.publisher != '') {
//         leisureTags.add(item.info.publisher);
//       }
//       if (item.info.publishedDate != null) {
//         leisureTags.add(item.info.publishedDate.year.toString());
//       }

//       String photo = item.info.imageLinks['thumbnail'].toString();
//       getStatusFromDB(item);

class ListBookSearch extends ListMediaSearch<MediaBookSuperEntity> {
  const ListBookSearch({Key? key, required List<MediaBookSuperEntity> media})
      : super(key: key, media: media);

  @override
  ListBookSearchState createState() => ListBookSearchState();
}

class ListBookSearchState extends ListMediaSearchState<MediaBookSuperEntity> {
  List<NoteBookNoteSuperEntity> bookNotes = [];

  @override
  BookPage showMediaPageBasedOnType(
      MediaBookSuperEntity item) {
    return BookPage(
        media: item, toggleFavorite: toggleFavorite);
  }

  @override
  MediaImageWidget<MediaBookSuperEntity> showWidget(MediaBookSuperEntity item) {
    return BookImageWidget(image: item.linkImage);
  }

  @override
  Future<MediaStatus> getMediaInfoFromDB(MediaBookSuperEntity item) async {
    String photo = item.linkImage;

    final mediaExists =
        await serviceLocator<MediaDao>().countMediaByPhoto(photo);

    if (mediaExists == 0) {
      statusFavorite =
          MediaStatus(status: Status.nothing, favorite: false, id: 0);
      return statusFavorite;
    }

    final media = await serviceLocator<MediaDao>().findMediaByPhoto(photo);
    review = await loadReviews(media!.id ?? 0);
    bookNotes = await loadBookNotes(media.id ?? 0);

    statusFavorite = MediaStatus(
        status: media.status, favorite: media.favorite, id: media.id ?? 0);
    return statusFavorite;
  }

  @override
  BookPageButton showMediaPageButton(MediaBookSuperEntity item) {
    return BookPageButton(item: item, mediaId: statusFavorite.id);
  }
}
