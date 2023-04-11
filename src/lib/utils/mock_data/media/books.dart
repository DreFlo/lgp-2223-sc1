import 'package:src/models/media/media_book_super_entity.dart';
import 'package:src/utils/enums.dart';

final mockBooks = [
  MediaBookSuperEntity(
    id: 4,
    name: 'The Lord of the Rings',
    description:
        'The Lord of the Rings is an epic high fantasy novel written by English author and scholar J. R. R. Tolkien. The story began as a sequel to Tolkien\'s 1937 fantasy novel The Hobbit, but eventually developed into a much larger work. Written in stages between 1937 and 1949, The Lord of the Rings is one of the best-selling novels ever written, with over 150 million copies sold.',
    linkImage: '',
    status: Status.done,
    favorite: true,
    genres: 'fantasy',
    release: DateTime(1954, 7, 29),
    xp: 10000,
    participants: 'J. R. R. Tolkien',
    totalPages: 1216,
  ),
];
