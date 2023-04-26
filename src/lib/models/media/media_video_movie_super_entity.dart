import 'package:src/models/media/media.dart';
import 'package:src/models/media/movie.dart';
import 'package:src/models/media/video.dart';
import 'package:src/utils/enums.dart';

class MediaVideoMovieSuperEntity extends Media {
  final int duration;
  final String tagline;

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
        );

  MediaVideoMovieSuperEntity.fromMediaAndVideoAndMovie(
      Media media, Video video, Movie movie)
      : duration = video.duration,
        tagline = movie.tagline,
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
      : duration = json['duration'],
        tagline = json['tagline'],
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
