import 'package:floor/floor.dart';
import 'package:src/models/media/review.dart';

@dao
abstract class ReviewDao {
  @Query('SELECT * FROM review')
  Future<List<Review>> findAllReviews();

  @Query('SELECT * FROM review WHERE id = :id')
  Stream<Review?> findReviewById(int id);

  @insert
  Future<void> insertReview(Review review);

  @insert
  Future<void> insertReviews(List<Review> reviews);

  @update
  Future<void> updateReview(Review review);

  @update
  Future<void> updateReviews(List<Review> reviews);

  @delete
  Future<void> deleteReview(Review review);
}
