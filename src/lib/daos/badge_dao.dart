import 'package:floor/floor.dart';
import 'package:src/models/badge.dart';

@dao
abstract class BadgeDao {
  @Query('SELECT * FROM badge')
  Future<List<Badge>> findAllBadges();

  @Query('SELECT * FROM badge WHERE id = :id')
  Future<Badge?> findBadgeById(int id);

  @insert
  Future<int> insertBadge(Badge badge);

  @update
  Future<void> updateBadge(Badge badge);

  @update
  Future<void> updateBadges(List<Badge> badges);

  @delete
  Future<void> deleteBadge(Badge badge);
}
