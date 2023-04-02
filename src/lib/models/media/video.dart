import 'package:floor/floor.dart';
import 'package:src/models/media/media.dart';
import 'package:src/utils/enums.dart';

@Entity(
  tableName: 'video',
)
class Video extends Media {
  final int duration;

  Video({
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
  }) : super(
            id: id,
            name: name,
            description: description,
            linkImage: linkImage,
            status: status,
            favorite: favorite,
            genres: genres,
            release: release,
            xp: xp);
}
