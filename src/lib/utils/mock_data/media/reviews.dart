import 'package:src/models/media/review.dart';
import 'package:src/utils/enums.dart';

// Media ids being hardcoded, may lead to some problems in the future
final mockReviews = [
  Review(
    id: 1,
    startDate: DateTime(2021, 1, 1),
    endDate: DateTime(2021, 1, 1),
    review: 'Very memories. Much nostalgia. Wow.',
    emoji: Reaction.like,
    mediaId: 5,
  )
];