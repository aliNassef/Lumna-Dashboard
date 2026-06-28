import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: 'lib/env/.env')
abstract class Env {
  @EnviedField(varName: 'SupabaseUrl', obfuscate: true)
  static final String supbabseUrl = _Env.supbabseUrl;
  @EnviedField(varName: 'AnonKey', obfuscate: true)
  static final String anonKey = _Env.anonKey;
  @EnviedField(varName: 'MabBoxAccessKey', obfuscate: true)
  static final String mabBoxAccessKey = _Env.mabBoxAccessKey;
}
