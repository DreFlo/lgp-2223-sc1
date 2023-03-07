import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied()
abstract class Env {
  @EnviedField(varName: 'OMDB_API_KEY')
  static const omdbApiKey = _Env.omdbApiKey;
}
