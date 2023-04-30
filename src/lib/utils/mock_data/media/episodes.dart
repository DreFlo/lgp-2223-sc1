import 'package:src/models/media/media_video_episode_super_entity.dart';
import 'package:src/utils/enums.dart';

final mockEpisodes = [
  MediaVideoEpisodeSuperEntity(
      id: 2,
      name: 'The Target',
      description:
          'Baltimore Det. Jimmy McNulty finds himself in hot water with his superior Major William Rawls after a drug dealer, D\'Angelo Barksdale who is charged with three murders, is acquitted. McNulty knows the judge in question and although it\'s not his case, he\'s called into chambers to explain what happened. Obviously key witnesses recanted their police statements on the stand but McNulty doesn\'t underplay Barksdale\'s role in at least 7 other murders. When the judge\'s raises his concerns at the senior levels of the police department, they have a new investigation on their hands. Lt. Cedric Daniels is put in charge with Kima Greggs as the lead detective. As for Barksdale, he finds himself demoted to a low-level dealer after his arrest and he obviously has to prove himself yet again.',
      linkImage: '',
      status: Status.done,
      favorite: true,
      genres: 'drama',
      release: DateTime(2002, 6, 2),
      xp: 50,
      participants:
          'Dominic West, Lance Reddick, Sonja Sohn, Wendell Pierce, Idris Elba',
      duration: 60,
      number: 1,
      seasonId: 1,
      tmdbId: 121),
  MediaVideoEpisodeSuperEntity(
      id: 3,
      name: 'The Detail',
      description:
          'Lt. Daniels puts his team together but the extra help he\'s asked includes several less than stellar officers. It also includes McNulty, who is obviously in the doghouse. When one of the witnesses against D\'Angelo Barksdale is found dead, McNulty and his homicide partner \'Bunk\' Moreland bring him in for questioning. They have no evidence that he had anything to do with the killing but their instincts tell them otherwise. When news of the witnesses death hits the press, Major Rawls is convinced that McNulty is again responsible. Three of the newly assigned detectives, Hec, Prez and Carver decide to go to the towers and flex a little muscle only to have it turn into a major disaster.',
      linkImage: '',
      status: Status.done,
      favorite: true,
      genres: 'drama',
      release: DateTime(2002, 6, 9),
      xp: 50,
      participants:
          'Dominic West, Lance Reddick, Sonja Sohn, Wendell Pierce, Idris Elba',
      duration: 60,
      number: 2,
      seasonId: 1,
      tmdbId: 122),
];
