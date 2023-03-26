# API Calls Summary

## TMDB
0. Import library
```dart
import 'package:tmdb_api/tmdb_api.dart';
```

1. Create instance: 
```dart
final tmdb = TMDB(ApiKeys('API key', 'apiReadAccessTokenv4'));
```
2. Any call will start with "await tmdb.v3" (don't forget to put async in the function)

**Trending**
Possible to get the trending media for the day or week:
```dart
Map trending_result = await tmdb.v3.trending.getTrending(mediaType = MediaType.all,timeWindow = TimeWindow.day);
```
MediaType can be all, movie, tv or person
TimeWindow can be day or week

To get the results use trending_result['results']

**Genres**
To get genres for movies: 
```dart
Map result = await tmdb.v3.genres.getMovieList();
```

To get genres for tv shows:
```dart
Map result = await tmdb.v3.genres.getTvList();
```

**Search**
```dart
Map result = await tmdb.v3.search.queryCollections('Batman');
```

Search for movies:
```dart
Map result = await tmdb.v3.search.queryMovies('Batman');
//get the results using: var result = result['results'];
```

Search for Tv shows:
```dart
Map result = await tmdb.v3.search.queryTvShows('Justice League');
//get the results using: var result = result['results'];
```

Search for both Tv shows and Movies:
```dart
Map result = await tmdb.v3.search.queryMulti('Justice League');
//get the results using: var result = result['results'];
```

**Discover**
Discover movies:
```dart
Map result = await tmdb.v3.discover.getMovies();
```

Discover tv shows:
```dart
Map result = await tmdb.v3.search.getTvShows();
```

**Movies**
Get list of movies in theatres:
```dart
Map result = await tmdb.v3.movies.getNowPlaying();
```

Get list of current popular movies:
```dart
Map result = await tmdb.v3.movies.getPopular();
```

Get top rated movies:
```dart
Map result = await tmdb.v3.movies.getTopRated();
```

Get upcoming movies in theatres:
```dart
Map result = await tmdb.v3.movies.getUpcoming();
```

**TV**
Get latest tv shows:
```dart
Map result = await tmdb.v3.tv.getLatest();
```

Get popular tv shows:
```dart
Map result = await tmdb.v3.tv.getPopular();
```

Get top rated movies:
```dart
Map result = await tmdb.v3.tv.getTopRated();
```

Get list of tv shows that are airing today:
```dart
Map result = await tmdb.v3.tv.getAiringToday();
```

Get list of shows that are currently on air:
```dart
Map result = await tmdb.v3.tv.getOnTheAir();
```

Get episode details (need to have id of the tv show):
```dart
Map result = await tmdb.v3.tvEpisodes.getDetails(103, 1, 1,language: 'en-US', appendToResponse: 'videos,images')
//tvId, season number, episode number
```

Get season details (also needs id of the tv show):
```dart
Map result = await tmdb.v3.tvSeason.getDetails(103, 1, language: 'en-US', appendToResponse: 'videos,images')
//tvId, season number
```

## Google Books API

## Usage

0. Import library:
```dart
import 'package:books_finder/books_finder.dart';
```

### Querying books

To query books, just call the function `queryBooks`:

```dart
final List<Book> books = await queryBooks(
 'twilight',
 queryType: QueryType.intitle,
 maxResults: 3,
 printType: PrintType.books,
 orderBy: OrderBy.relevance,
);
```

You can change a few parameters to make your query more specific:

| Parameter          | Description                                | Nullable |
| ------------------ | ------------------------------------------ | -------- |
| queryType          | Keywords to search in particular fields    | Yes      |
| maxResults         | Set the max amount of results              | No       |
| startIndex         | for pagination                             | No       |
| langRestrict       | Retrict the query to a specific language   | Yes      |
| orderBy            | Order the query by newest or relevance     | Yes      |
| printType          | Filter by books, magazines or both         | Yes      |
| reschemeImageLinks | Rescheme image urls from `http` to `https` | No       |

If you already have a `Book` object, you can call `book.info` to get all the book infos:

```dart
final info = book.info;
```

| Parameter                                       | Description                                 |
| ----------------------------------------------- | ------------------------------------------- |
| title (`String`)                                | Title of the book                           |
| subtitle (`String`)                             | The subtile of the book                     |
| authors (`List<String>`)                        | All the authors names                       |
| publisher (`String`)                            | The publisher name                          |
| publishedDate (`DateTime`)                      | The date it was published                   |
| rawPublishedDate (`String`)                     | The date it was published in raw format     |
| description (`String`)                          | Description of the book                     |
| pageCount (`int`)                               | The amount of pages                         |
| categories (`List<String>`)                     | The categories the book is in               |
| averageRating (`double`)                        | The average rating of the book              |
| ratingsCount (`int`)                            | The amount of people that rated it          |
| maturityRating (`String`)                       | The maturity rating                         |
| contentVersion (`String`)                       | The version of the content                  |
| industryIdentifier (`List<IndustryIdentifier>`) | The identifiers of the book (isbn)          |
| imageLinks (`List<Map<String, Uri>>`)           | The links with the avaiable image resources |
| language (`String`)                             | The language code of the book               |




