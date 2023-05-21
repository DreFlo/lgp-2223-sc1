import 'package:src/models/media/media_series_super_entity.dart';
import 'package:src/utils/enums.dart';

final mockSeries = [
  MediaSeriesSuperEntity(
      id: 1,
      name: 'The Wire',
      description:
          'A look at the Baltimore drug scene as seen through the eyes of drug dealers and law enforcement',
      linkImage: '/4lbclFySvugI51fwsyxBTOm4DqK.jpg',
      status: Status.goingThrough,
      favorite: true,
      genres: 'drama',
      release: DateTime(2002, 6, 2),
      xp: 1000,
      participants:
          'Dominic West, Lance Reddick, Sonja Sohn, Wendell Pierce, Idris Elba',
      tagline: 'The streets are watching',
      numberEpisodes: 60,
      numberSeasons: 5,
      duration: 60,
      tmdbId: 1438),
  MediaSeriesSuperEntity(
      id: 9,
      name: 'Snowpiercer',
      description:
          'Seven years after the world has become a frozen wasteland, the remnants of humanity inhabit a perpetually-moving train that circles the globe, where class warfare, social injustice and the politics of survival play out.',
      linkImage:
          'https://www.imdb.com/title/tt6156584/mediaviewer/rm4151300353/?ref_=tt_ov_i',
      status: Status.goingThrough,
      favorite: true,
      genres: 'drama',
      release: DateTime(2020, 05, 17),
      xp: 1000,
      participants: 'Daveed Diggs, Mickey Sumner, Alison Wright',
      tagline: 'These are our revolutions',
      numberEpisodes: 31,
      numberSeasons: 3,
      duration: 52,
      tmdbId: 79680),
];
