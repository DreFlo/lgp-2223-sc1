import 'package:src/pages/catalog_search/media.dart';
import 'package:src/pages/leisure/media_page.dart';
import 'package:src/widgets/leisure/media_page_button.dart';

showWidget(dynamic item, String title) {
  if (item.linkImage != null) {
    if (title == 'All Books') {
      return Media(image: item.linkImage, type: 'book');
    } else {
      return Media(image: item.linkImage, type: 'video');
    }
  }
}

showMediaPageBasedOnType(dynamic item, String title, int duration) {
  List<String> leisureTags = [];

  leisureTags.add(item.release.year.toString());
  leisureTags.addAll(item.genres.split(','));

  List<String> cast = [];
  cast.addAll(item.participants.split(', '));

  if (title == 'All Books') {
    return MediaPage(
      title: item.name,
      synopsis: item.description,
      type: 'Book',
      length: [item.totalPages],
      cast: cast,
      image: item.linkImage,
      status: item.status,
      isFavorite: item.favorite,
      leisureTags: leisureTags,
    );
  } else if (title == 'All Movies') {
    leisureTags.add(item.tagline);

    return MediaPage(
      title: item.name,
      synopsis: item.description,
      type: 'Movie',
      length: [item.duration],
      cast: cast,
      image: item.linkImage,
      status: item.status,
      isFavorite: item.favorite,
      leisureTags: leisureTags,
    );
  } else if (title == 'All TV Shows') {
    leisureTags.add(item.tagline);

    return MediaPage(
      title: item.name,
      synopsis: item.description,
      type: 'TV Show',
      length: [item.numberSeasons, item.numberEpisodes, duration], //get from DB
      cast: cast,
      image: item.linkImage,
      status: item.status,
      isFavorite: item.favorite,
      leisureTags: leisureTags,
    );
  }
}

showMediaPageButton(dynamic item, String title) {
  if (title == 'All Books') {
    return MediaPageButton(item: item, type:'Book'); 
  } else if (title == 'All Movies') {
    return MediaPageButton(item: item, type:'Movie'); 
  } else {
    return MediaPageButton(item: item, type:'TV Show'); 
  }
}
