import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied()
abstract class Env {
  @EnviedField(varName: 'TMDB_API_KEY', obfuscate: true)
  static final tmdbApiKey = _Env.tmdbApiKey;

  @EnviedField(varName: 'GOOGLE_BOOKS_API_KEY', obfuscate: true)
  static final googleBooksApiKey = _Env.googleBooksApiKey;

  @EnviedField(varName: 'TMDB_API_URL', obfuscate: true)
  static final tmdbApiUrl = _Env.tmdbApiUrl;

  @EnviedField(varName: 'GOOGLE_BOOKS_API_URL', obfuscate: true)
  static final googleBooksApiUrl = _Env.googleBooksApiUrl;
}
