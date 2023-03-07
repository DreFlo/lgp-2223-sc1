import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied()
abstract class Env {
  @EnviedField(varName: 'TMDB_API_KEY', obfuscate: true)
  static final tmdbApiKey = _Env.tmdbApiKey;
}
