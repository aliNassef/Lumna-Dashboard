import 'package:package_info_plus/package_info_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
//! remote config for forcing update app.
abstract interface class RemoteConfig {
  Future<bool> shouldForceUpdate();
}

class SupabaseRemoteConfigImpl implements RemoteConfig {
  final _supabase = Supabase.instance.client;

  @override
  Future<bool> shouldForceUpdate() async {
    try {
      final minVersion = await _fetchMinVersion();
      final currentVersion = await _getCurrentAppVersion();
      return _isVersionLower(currentVersion, minVersion);
    } catch (_) {
      return false; 
    }
  }

  Future<String> _fetchMinVersion() async {
    final data = await _supabase
        .from('app_config')
        .select('value')
        .eq('key', 'min_version')
        .single();

    return data['value'] as String;
  }

  Future<String> _getCurrentAppVersion() async {
    final info = await PackageInfo.fromPlatform();
    return info.version;
  }

  bool _isVersionLower(String current, String min) {
    final c = current.split('.').map(int.parse).toList();
    final m = min.split('.').map(int.parse).toList();

    for (int i = 0; i < 3; i++) {
      if (c[i] < m[i]) return true;
      if (c[i] > m[i]) return false;
    }
    return false;
  }
}