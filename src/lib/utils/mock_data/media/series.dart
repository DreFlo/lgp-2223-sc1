import 'package:src/models/media/media_series_super_entity.dart';
import 'package:src/utils/enums.dart';

final mockSeries = [
  MediaSeriesSuperEntity(
      id: 1,
      name: 'The Wire',
      description:
          'A look at the Baltimore drug scene as seen through the eyes of drug dealers and law enforcement',
      linkImage: '',
      status: Status.goingThrough,
      favorite: true,
      genres: 'drama',
      release: DateTime(2002, 6, 2),
      xp: 1000,
      participants:
          'Dominic West, Lance Reddick, Sonja Sohn, Wendell Pierce, Idris Elba',
      tagline: 'The streets are watching')
];
