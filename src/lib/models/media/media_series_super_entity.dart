import 'package:src/models/media/media.dart';
import 'package:src/models/media/series.dart';
import 'package:src/utils/enums.dart';

class MediaSeriesSuperEntity extends Media {
  final String tagline;
  final int numberEpisodes;
  final int numberSeasons;
  final int tmdbId;
  final int duration;

  MediaSeriesSuperEntity(
      {int? id,
      required String name,
      required String description,
      required String linkImage,
      required Status status,
      required bool favorite,
      required String genres,
      required DateTime release,
      required int xp,
      required String participants,
      required this.tagline,
      required this.numberEpisodes,
      required this.numberSeasons,
      required this.duration,
      required this.tmdbId})
      : super(
          id: id,
          name: name,
          description: description,
          linkImage: linkImage,
          status: status,
          favorite: favorite,
          genres: genres,
          release: release,
          xp: xp,
          participants: participants,
        );

  MediaSeriesSuperEntity.fromMediaAndSeries(Media media, Series series)
      : tagline = series.tagline,
        numberEpisodes = series.numberEpisodes,
        numberSeasons = series.numberSeasons,
        tmdbId = series.tmdbId,
        duration = series.duration,
        super(
          id: media.id,
          name: media.name,
          description: media.description,
          linkImage: media.linkImage,
          status: media.status,
          favorite: media.favorite,
          genres: media.genres,
          release: media.release,
          xp: media.xp,
          participants: media.participants,
        );

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
        numberSeasons: numberSeasons,
        duration: duration,
        tmdbId: tmdbId);
  }

  MediaSeriesSuperEntity copyWith(
      {int? id,
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
      int? tmdbId,
      int? duration}) {
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
      tmdbId: tmdbId ?? this.tmdbId,
      duration: duration ?? this.duration,
    );
  }

  MediaSeriesSuperEntity.fromJson(Map<String, dynamic> json)
      : tagline = json['tagline'],
        numberEpisodes = json['numberEpisodes'],
        numberSeasons = json['numberSeasons'],
        tmdbId = json['tmdbId'],
        duration = json['duration'],
        super(
          id: json['id'],
          name: json['name'],
          description: json['description'],
          linkImage: json['linkImage'],
          status: json['status'],
          favorite: json['favorite'],
          genres: json['genres'],
          release: json['release'],
          xp: json['xp'],
          participants: json['participants'],
        );
}
