import 'package:floor/floor.dart';
import 'package:src/models/media/media.dart';
import 'package:src/utils/enums.dart';

@Entity(
  tableName: 'series',
)
class Series extends Media {
  Series({
    int? id,
    required String name,
    required String description,
    required String linkImage,
    required Status status,
    required bool favorite,
    required String genres,
    required DateTime release,
    required int xp,
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
