import 'package:floor/floor.dart';
import 'package:src/models/user_badge.dart';

@dao
abstract class UserBadgeDao {
  @Query('SELECT * FROM user_badge')
  Future<List<UserBadge>> findAllUserBadges();

  @Query(
      'SELECT * FROM user_badge WHERE user_id = :userId AND badge_id = :badgeId')
  Future<UserBadge?> findUserBadgeByIds(int userId, int badgeId);

  @Query('SELECT * FROM user_badge WHERE user_id = :userId')
  Future<List<UserBadge>> findUserBadgesByUserId(int userId);

  @Query('SELECT badge_id FROM user_badge WHERE user_id = :userId')
  Future<List<int>> findUserBadgeIdsByUserId(int userId);

  @Query('SELECT * FROM user_badge WHERE badge_id = :badgeId')
  Future<List<UserBadge>> findUserBadgesByBadgeId(int badgeId);

  @insert
  Future<int> insertUserBadge(UserBadge userBadge);

  @insert
  Future<void> insertUserBadges(List<UserBadge> userBadges);

  @update
  Future<void> updateUserBadge(UserBadge userBadge);

  @update
  Future<void> updateUserBadges(List<UserBadge> userBadges);

  @delete
  Future<void> deleteUserBadge(UserBadge userBadge);
}
