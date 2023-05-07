import 'package:floor/floor.dart';

@Entity(
  tableName: 'badge',
)
class Badge {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  final String name;

  final String description;

  final String icon;

  final String colors; // list of colors separated with ','

  final String fact;

  Badge(
      {this.id,
      required this.name,
      required this.description,
      required this.icon,
      required this.colors,
      required this.fact});
}
