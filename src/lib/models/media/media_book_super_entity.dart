import 'package:src/models/media/media.dart';
import 'package:src/models/media/book.dart';
import 'package:src/utils/enums.dart';

class MediaBookSuperEntity {
  final int? id;
  final String name;
  final String description;
  final String linkImage;
  final Status status;
  final bool favorite;
  final String genres;
  final DateTime release;
  final int xp;
  final String authors;
  final int totalPages;
  final int? progressPages;

  MediaBookSuperEntity({
    this.id,
    required this.name,
    required this.description,
    required this.linkImage,
    required this.status,
    required this.favorite,
    required this.genres,
    required this.release,
    required this.xp,
    required this.authors,
    required this.totalPages,
    this.progressPages = 0,
  });

  MediaBookSuperEntity.fromMediaAndBook(Media media, Book book)
      : id = media.id,
        name = media.name,
        description = media.description,
        linkImage = media.linkImage,
        status = media.status,
        favorite = media.favorite,
        genres = media.genres,
        release = media.release,
        xp = media.xp,
        authors = book.authors,
        totalPages = book.totalPages,
        progressPages = book.progressPages;

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

  Book toBook() {
    return Book(
      id: id!,
      authors: authors,
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
    String? authors,
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
      authors: authors ?? this.authors,
      totalPages: totalPages ?? this.totalPages,
      progressPages: progressPages ?? this.progressPages,
    );
  }
}
