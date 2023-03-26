import 'package:floor/floor.dart';
import 'package:src/models/media/media.dart';
import 'package:src/utils/enums.dart';

@Entity(
  tableName: 'review',
  foreignKeys: [
    ForeignKey(
      childColumns: ['media_id'],
      parentColumns: ['id'],
      entity: Media,
    )
  ],
)
class Review {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  @ColumnInfo(name: 'start_date')
  final DateTime startDate;

  @ColumnInfo(name: 'end_date')
  final DateTime endDate;

  final String review;

  final int rating;

  final Emoji emoji;

  @ColumnInfo(name: 'media_id')
  final int mediaId;

  Review({
    this.id,
    required this.startDate,
    required this.endDate,
    required this.review,
    required this.rating,
    required this.emoji,
    required this.mediaId,
  });
}
