import 'package:src/models/media/media_video_movie_super_entity.dart';
import 'package:src/utils/enums.dart';

final mockMovies = [
  MediaVideoMovieSuperEntity(
      id: 5,
      name: 'The Fast and the Furious',
      description:
          'Brian\'s a cop. Dom is a thief. They love each other very much but must learn to look past their differences if the relationship is to last',
      linkImage: '/lgCEntS9mHagxdL5hb3qaV49YTd.jpg',
      status: Status.planTo,
      favorite: false,
      genres: 'romance',
      release: DateTime(2001, 6, 22),
      xp: 100,
      duration: 106,
      participants:
          'Paul Walker, Vin Diesel, Michelle Rodriguez, Toyota Supra, Honda Civic',
      tagline: 'Vroom vroom'),
  MediaVideoMovieSuperEntity(
    id: 6,
    name: 'Arrival',
    description: 'Aliens have landed on Earth and are here to stay',
    linkImage: '/x2FJsf1ElAgr63Y3PNPtJrcmpoe.jpg',
    status: Status.done,
    favorite: true,
    genres: 'romance',
    release: DateTime(2016, 11, 11),
    xp: 100,
    duration: 106,
    participants: 'Amy Adams, Jeremy Renner, Forest Whitaker',
    tagline: 'Words. Phrases. Time.',
  )
];
