import 'package:src/models/media/media.dart';
import 'package:src/models/media/book.dart';
import 'package:src/utils/enums.dart';

class MediaBookSuperEntity extends Media {
  final int totalPages;
  final int? progressPages;

  MediaBookSuperEntity({
    int? id,
    required String name,
    required String description,
    required String linkImage,
    required Status status,
    required bool favorite,
    required String genres,
    required DateTime release,
    required int xp,
    required String participants,
    required this.totalPages,
    this.progressPages = 0,
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

  MediaBookSuperEntity.fromMediaAndBook(Media media, Book book)
      : totalPages = book.totalPages,
        progressPages = book.progressPages,
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
      xp: xp,
      participants: participants,
    );
  }

  Book toBook() {
    return Book(
      id: id!,
      totalPages: totalPages,
      progressPages: progressPages,
    );
  }

  MediaBookSuperEntity copyWith({
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
    int? totalPages,
    int? progressPages,
  }) {
    return MediaBookSuperEntity(
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
      totalPages: totalPages ?? this.totalPages,
      progressPages: progressPages ?? this.progressPages,
    );
  }
}
