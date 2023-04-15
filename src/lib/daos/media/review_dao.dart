import 'package:floor/floor.dart';
import 'package:src/models/media/review.dart';

@dao
abstract class ReviewDao {
  @Query('SELECT * FROM review')
  Future<List<Review>> findAllReviews();

  @Query('SELECT * FROM review WHERE id = :id')
  Stream<Review?> findReviewById(int id);


  @Query('SELECT COUNT() FROM review WHERE media_id = :mediaId')
  Future<int?> countReviewsByMediaId(int mediaId);

  @Query('SELECT * FROM review WHERE media_id = :mediaId')
  Stream<Review?> findReviewByMediaId(
      int mediaId); //each media can only have one review

  @insert
  Future<int> insertReview(Review review);

  @insert
  Future<void> insertReviews(List<Review> reviews);

  @update
  Future<void> updateReview(Review review);

  @update
  Future<void> updateReviews(List<Review> reviews);

  @delete
  Future<void> deleteReview(Review review);
}
