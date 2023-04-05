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
  final DateTime release;
  final int xp;
  final int duration;

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
  });

  MediaVideoMovieSuperEntity.fromMediaAndVideo(Media media, Video video)
      : id = media.id,
        name = media.name,
        description = media.description,
        linkImage = media.linkImage,
        status = media.status,
        favorite = media.favorite,
        genres = media.genres,
        release = media.release,
        xp = media.xp,
        duration = video.duration;

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
    );
  }
}
