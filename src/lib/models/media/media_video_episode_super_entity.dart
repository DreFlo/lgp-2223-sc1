import 'package:src/models/media/episode.dart';
import 'package:src/models/media/media.dart';
import 'package:src/models/media/video.dart';
import 'package:src/utils/enums.dart';

class MediaVideoEpisodeSuperEntity extends Media {
  final int duration;
  final int number;
  final int seasonId;

  MediaVideoEpisodeSuperEntity(
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
      required this.duration,
      required this.number,
      required this.seasonId})
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

  MediaVideoEpisodeSuperEntity.fromMediaAndVideoAndEpisode(
      Media media, Video video, Episode episode)
      : duration = video.duration,
        number = episode.number,
        seasonId = episode.seasonId,
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

  Video toVideo() {
    return Video(
      id: id!,
      duration: duration,
    );
  }

  Episode toEpisode() {
    return Episode(
      id: id!,
      number: number,
      seasonId: seasonId,
    );
  }

  MediaVideoEpisodeSuperEntity copyWith({
    int? id,
    String? name,
    String? description,
    String? linkImage,
    Status? status,
    bool? favorite,
    String? genres,
    DateTime? release,
    int? xp,
    int? duration,
    int? number,
    int? seasonId,
    String? participants,
  }) {
    return MediaVideoEpisodeSuperEntity(
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
      duration: duration ?? this.duration,
      number: number ?? this.number,
      seasonId: seasonId ?? this.seasonId,
    );
  }

  MediaVideoEpisodeSuperEntity.fromJson(Map<String, dynamic> json)
      : duration = json['duration'],
        number = json['number'],
        seasonId = json['seasonId'],
        super(
          id: json['id'],
          name: json['name'],
          description: json['description'],
          linkImage: json['linkImage'],
          status: Status.values[json['status']],
          favorite: json['favorite'],
          genres: json['genres'],
          release: DateTime.parse(json['release']),
          xp: json['xp'],
          participants: json['participants'],
        );
}
