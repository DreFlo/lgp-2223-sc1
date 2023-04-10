import 'package:floor/floor.dart';

@Entity(
  tableName: 'badge',
)
class Badge {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  final String name;

  final String description;

  @ColumnInfo(name: 'image_path')
  final String imagePath;

  Badge(
      {this.id,
      required this.name,
      required this.description,
      required this.imagePath});
}
