import 'package:floor/floor.dart';
import 'package:src/models/badges.dart';

@dao
abstract class BadgesDao {
  @Query('SELECT * FROM badge')
  Future<List<Badges>> findAllBadges();

  @Query('SELECT * FROM badge WHERE id = :id')
  Future<Badges?> findBadgeById(int id);

  @insert
  Future<int> insertBadge(Badges badge);

  @insert
  Future<void> insertBadges(List<Badges> badges);

  @update
  Future<void> updateBadge(Badges badge);

  @update
  Future<void> updateBadges(List<Badges> badges);

  @delete
  Future<void> deleteBadge(Badges badge);
}
