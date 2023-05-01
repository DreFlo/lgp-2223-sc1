import 'package:src/models/media/media.dart';
import 'package:src/models/media/movie.dart';
import 'package:src/models/media/video.dart';
import 'package:src/utils/enums.dart';

class MediaVideoMovieSuperEntity extends Media {
  final int duration;
  final String tagline;
  final int tmdbId;

  MediaVideoMovieSuperEntity({
    int? id,
    required String name,
    required String description,
    required String linkImage,
    required Status status,
    required bool favorite,
    required String genres,
    required DateTime release,
    required int xp,
    required this.duration,
    required String participants,
    required this.tagline,
    required this.tmdbId,
  }) : super(
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
            type: MediaDBTypes.movie);

  MediaVideoMovieSuperEntity.fromMediaAndVideoAndMovie(
      Media media, Video video, Movie movie)
      : duration = video.duration,
        tagline = movie.tagline,
        tmdbId = video.tmdbId,
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
            type: MediaDBTypes.movie);

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
        type: MediaDBTypes.movie);
  }

  Video toVideo() {
    return Video(id: id!, duration: duration, tmdbId: tmdbId);
  }

  Movie toMovie() {
    return Movie(
      id: id!,
      tagline: tagline,
    );
  }

  MediaVideoMovieSuperEntity copyWith({
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
    String? participants,
    String? tagline,
    int? tmdbId,
  }) {
    return MediaVideoMovieSuperEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      linkImage: linkImage ?? this.linkImage,
      status: status ?? this.status,
      favorite: favorite ?? this.favorite,
      genres: genres ?? this.genres,
      release: release ?? this.release,
      xp: xp ?? this.xp,
      duration: duration ?? this.duration,
      participants: participants ?? this.participants,
      tagline: tagline ?? this.tagline,
      tmdbId: tmdbId ?? this.tmdbId,
    );
  }

  MediaVideoMovieSuperEntity.fromJson(Map<String, dynamic> json)
      : duration = json['duration'],
        tagline = json['tagline'],
        tmdbId = json['tmdbId'],
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
            type: MediaDBTypes.movie);
}
