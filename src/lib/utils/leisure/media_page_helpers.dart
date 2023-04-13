import 'package:src/pages/catalog_search/media.dart';
import 'package:src/pages/leisure/media_page.dart';

Map<String, String> notes = {
    'S04E03':
        "After Horde Prime takes Glimmer aboard his flagship, she loses her access to magic again in Season 5. This time her combat skills don't cut it against the much stronger antagonists of Horde Prime's clone army- Catra has to save her multiple times. Only until she returns to Etheria's surface does she get her powers back, though she does manage to cast spells on Krytis.",
    'S02E07': 'Bow is best boy.'
  };

showWidget(dynamic item, String title) {
  if (item.linkImage != null) {
    if (title == 'All Books') {
      return Media(image: item.linkImage, type: 'book');
    } else {
      return Media(image: item.linkImage, type: 'video');
    }
  }
}

showMediaPageBasedOnType(dynamic item, String title) {
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
        notes: notes, //get from DB
        status: item.status, //get from DB
        isFavorite: item.favorite, //get from DB
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
          notes: notes, //get from DB
          status: item.status, //get from DB
          isFavorite: item.favorite, //get from DB
          leisureTags: leisureTags,
      );
    } else if (title == 'All TV Shows') {
      leisureTags.add(item.tagline);
      
      return MediaPage(
          title: item.name,
          synopsis: item.description,
          type: 'TV Show',
          length: const [1,8,30], //get from DB
          cast: cast,
          image: item.linkImage,
          notes: notes, //get from DB
          status: item.status, //get from DB
          isFavorite: item.favorite, //get from DB
          leisureTags: leisureTags,
          );
    }
  }
