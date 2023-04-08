import 'package:src/models/media/episode.dart';
import 'package:src/models/media/media.dart';
import 'package:src/models/media/video.dart';
import 'package:src/utils/enums.dart';

class MediaVideoEpisodeSuperEntity {
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
  final int duration;
  final int number;
  final int seasonId;

  MediaVideoEpisodeSuperEntity(
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
      required this.duration,
      required this.number,
      required this.seasonId});

  MediaVideoEpisodeSuperEntity.fromMediaAndVideoAndEpisode(
      Media media, Video video, Episode episode)
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
        duration = video.duration,
        number = episode.number,
        seasonId = episode.seasonId;

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
}
