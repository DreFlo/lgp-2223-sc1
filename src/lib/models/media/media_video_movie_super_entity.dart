import 'package:src/models/media/media.dart';
import 'package:src/models/media/movie.dart';
import 'package:src/models/media/video.dart';
import 'package:src/utils/enums.dart';

class MediaVideoMovieSuperEntity {
  final int? id;
  final String name;
  final String description;
  final String linkImage;
  final Status status;
  final bool favorite;
  final String genres;
  final String participants;
  final DateTime release;
  final int xp;
  final int duration;
  final String tagline;

  MediaVideoMovieSuperEntity({
    this.id,
    required this.name,
    required this.description,
    required this.linkImage,
    required this.status,
    required this.favorite,
    required this.genres,
    required this.release,
    required this.xp,
    required this.duration,
    required this.participants,
    required this.tagline,
  });

  MediaVideoMovieSuperEntity.fromMediaAndVideoAndMovie(
      Media media, Video video, Movie movie)
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
        tagline = movie.tagline;

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
    );
  }

  MediaVideoMovieSuperEntity.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        description = json['description'],
        linkImage = json['linkImage'],
        status = Status.values[json['status']],
        favorite = json['favorite'],
        genres = json['genres'],
        release = DateTime.parse(json['release']),
        xp = json['xp'],
        duration = json['duration'],
        participants = json['participants'],
        tagline = json['tagline'];
}
