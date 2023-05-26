import 'package:src/models/media/media_book_super_entity.dart';
import 'package:src/utils/enums.dart';

final mockBooks = [
  MediaBookSuperEntity(
    id: 4,
    name: 'The Lord of the Rings',
    description:
        'The Lord of the Rings is an epic high fantasy novel written by English author and scholar J. R. R. Tolkien. The story began as a sequel to Tolkien\'s 1937 fantasy novel The Hobbit, but eventually developed into a much larger work. Written in stages between 1937 and 1949, The Lord of the Rings is one of the best-selling novels ever written, with over 150 million copies sold.',
    linkImage:
        'http://books.google.com/books/content?id=GfrqzgEACAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api',
    status: Status.goingThrough,
    favorite: true,
    genres: 'fantasy',
    release: DateTime(1954, 7, 29),
    xp: 10000,
    participants: 'J. R. R. Tolkien',
    totalPages: 1216,
  ),
  MediaBookSuperEntity(
    id: 7,
    name: 'Mistborn: The Final Empire',
    description:
        'Three years prior to the start of the novel, a half-skaa thief named Kelsier discovered that he was Mistborn and escapes the Pits of Hathsin, a brutal prison camp of the Lord Ruler. He returned to Luthadel, the capital city of the Final Empire, where he rounded up his old thieving crew for a new job: to overthrow the Final Empire by stealing its treasury and collapsing its economy.',
    linkImage:
        'http://books.google.com/books/content?id=t_ZYYXZq4RgC&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api',
    status: Status.goingThrough,
    favorite: true,
    genres: 'fantasy',
    release: DateTime(2006, 7, 17),
    xp: 0,
    participants: 'Brandon Sanderson',
    totalPages: 647,
  ),
  MediaBookSuperEntity(
    id: 8,
    name: 'Mistborn: The Well Of Ascension',
    description:
        "The Final Empire is in turmoil as various regions descend into anarchy following the Lord Ruler's death and the disappearance of the Steel Ministry. Elend Venture has claimed the crown of the capital city, Luthadel, and attempts to restore order, but various hostile forces converge on the city. Three armies lay siege to Luthadel because of its rumored wealth of Atium and political influence. The first army is led by Straff Venture - head of House Venture, and Elend's father. The second army is led by Ashweather Cett, self-declared king of the Western Dominance. The third army consists of Koloss, massive, brutish blue creatures once controlled by the Lord Ruler, and is led by Elend's former friend Jastes, who is buying the Koloss' obedience with counterfeit coins.",
    linkImage:
        'http://books.google.com/books/content?id=Y-41Q9zk32kC&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api',
    status: Status.goingThrough,
    favorite: true,
    genres: 'fantasy',
    release: DateTime(2007, 8, 21),
    xp: 0,
    participants: 'Brandon Sanderson',
    totalPages: 781,
  ),
];
