import 'package:floor/floor.dart';
import 'package:src/models/media/video.dart';
import 'package:src/utils/enums.dart';

@Entity(
  tableName: 'movie',
)
class Movie extends Video {
  Movie({
    int? id,
    required String name,
    required String description,
    required String linkImage,
    required Status status,
    required bool favorite,
    required int duration,
  }) : super(
            id: id,
            name: name,
            description: description,
            linkImage: linkImage,
            status: status,
            favorite: favorite,
            duration: duration);
}
