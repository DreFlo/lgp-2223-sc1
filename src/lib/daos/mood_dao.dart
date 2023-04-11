import 'package:floor/floor.dart';
import 'package:src/models/mood.dart';

@dao
abstract class MoodDao {
  @Query('SELECT * FROM mood')
  Future<List<Mood>> findAllMoods();

  @Query('SELECT * FROM mood WHERE id = :id')
  Future<Mood?> findMoodById(int id);

  @insert
  Future<int> insertMood(Mood mood);

  @insert
  Future<void> insertMoods(List<Mood> moods);

  @update
  Future<void> updateMood(Mood mood);

  @update
  Future<void> updateMoods(List<Mood> moods);

  @delete
  Future<void> deleteMood(Mood mood);
}
