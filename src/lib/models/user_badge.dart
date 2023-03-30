import 'package:floor/floor.dart';
import 'package:src/models/user.dart';
import 'package:src/models/badge.dart';

@Entity(tableName: 'user_badge', primaryKeys: ['user_id', 'badge_id'])
class UserBadge {
  @ForeignKey(childColumns: ['user_id'], parentColumns: ['id'], entity: User)
  @ColumnInfo(name: 'user_id')
  final int userId;

  @ForeignKey(childColumns: ['badge_id'], parentColumns: ['id'], entity: Badge)
  @ColumnInfo(name: 'badge_id')
  final int badgeId;

  UserBadge({required this.userId, required this.badgeId});
}
