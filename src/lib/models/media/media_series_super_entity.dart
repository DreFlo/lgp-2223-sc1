import 'package:src/models/media/media.dart';
import 'package:src/models/media/series.dart';
import 'package:src/utils/enums.dart';

class MediaSeriesSuperEntity {
  final int? id;
  final String name;
  final String description;
  final String linkImage;
  final Status status;
  final bool favorite;
  final String genres;
  final DateTime release;
  final int xp;
  final String participants;
  final String tagline;
  final int numberEpisodes;
  final int numberSeasons;

  MediaSeriesSuperEntity(
      {this.id,
      required this.name,
      required this.description,
      required this.linkImage,
      required this.status,
      required this.favorite,
      required this.genres,
      required this.release,
      required this.xp,
      required this.participants,
      required this.tagline,
      required this.numberEpisodes,
      required this.numberSeasons});

  MediaSeriesSuperEntity.fromMediaAndSeries(Media media, Series series)
      : id = media.id,
        name = media.name,
        description = media.description,
        linkImage = media.linkImage,
        status = media.status,
        favorite = media.favorite,
        genres = media.genres,
        release = media.release,
        xp = media.xp,
        participants = media.participants,
        tagline = series.tagline,
        numberEpisodes = series.numberEpisodes,
        numberSeasons = series.numberSeasons;

  Media toMedia() {
    return Media(
      id: id,
      name: name,
      description: description,
      linkImage: linkImage,
      status: status,
      favorite: favorite,
      genres: genres,
      release: release,
      participants: participants,
      xp: xp,
    );
  }

  Series toSeries() {
    return Series(
        id: id!,
        tagline: tagline,
        numberEpisodes: numberEpisodes,
        numberSeasons: numberSeasons);
  }

  MediaSeriesSuperEntity copyWith({
    int? id,
    String? name,
    String? description,
    String? linkImage,
    Status? status,
    bool? favorite,
    String? genres,
    DateTime? release,
    int? xp,
    String? participants,
    String? tagline,
    int? numberEpisodes,
    int? numberSeasons,
  }) {
    return MediaSeriesSuperEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      linkImage: linkImage ?? this.linkImage,
      status: status ?? this.status,
      favorite: favorite ?? this.favorite,
      genres: genres ?? this.genres,
      release: release ?? this.release,
      xp: xp ?? this.xp,
      participants: participants ?? this.participants,
      tagline: tagline ?? this.tagline,
      numberEpisodes: numberEpisodes ?? this.numberEpisodes,
      numberSeasons: numberSeasons ?? this.numberSeasons,
    );
  }
}
