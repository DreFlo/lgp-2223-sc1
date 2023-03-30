import 'package:floor/floor.dart';
import 'package:src/models/user.dart';
import 'package:src/models/badge.dart';

@Entity(
  tableName: 'user_badge',
  primaryKeys: ['user_id', 'badge_id'],
  foreignKeys: [
    ForeignKey(
      childColumns: ['user_id'],
      parentColumns: ['id'],
      entity: User,
      onDelete: ForeignKeyAction.cascade,
      onUpdate: ForeignKeyAction.restrict,
    ),
    ForeignKey(
      childColumns: ['badge_id'],
      parentColumns: ['id'],
      entity: Badge,
      onDelete: ForeignKeyAction.cascade,
      onUpdate: ForeignKeyAction.restrict,
    )
  ]
)
class UserBadge {
  @ColumnInfo(name: 'user_id')
  final int userId;

  @ColumnInfo(name: 'badge_id')
  final int badgeId;

  UserBadge({required this.userId, required this.badgeId});
}
