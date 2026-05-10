import 'dart:async';
import '../../logging/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

enum DeepLinkType { resetPassword, emailConfirmation, googleLogin, unknown }

class DeepLinkResult {
  const DeepLinkResult({required this.type, this.session});

  final DeepLinkType type;
  final Session? session;
}

/// Singleton service that listens to Supabase auth deep link events
/// and exposes a stream your router or cubit can react to.
///
/// Usage:
///   DeepLinkService.instance.init();
///   DeepLinkService.instance.stream.listen((result) { ... });
class DeepLinkService {
  DeepLinkService._();
  static final DeepLinkService instance = DeepLinkService._();

  final _controller = StreamController<DeepLinkResult>.broadcast();
  StreamSubscription<AuthState>? _subscription;
  bool _initialized = false;

  /// Call once in main() after Supabase.initialize().
  void init() {
    if (_initialized) return;
    _initialized = true;

    _subscription = Supabase.instance.client.auth.onAuthStateChange.listen(
      _handleAuthEvent,
    );
  }

  /// Stream of resolved deep link events.
  Stream<DeepLinkResult> get stream => _controller.stream;

  void _handleAuthEvent(AuthState data) {
    Logger.info('Received auth event: ${data.event}');
    switch (data.event) {
      case AuthChangeEvent.passwordRecovery:
        _controller.add(
          DeepLinkResult(
            type: DeepLinkType.resetPassword,
            session: data.session,
          ),
        );
        break;
      case AuthChangeEvent.signedIn:
        // Distinguish Google OAuth callback from normal sign in
        final provider = data.session?.user.appMetadata['provider'];
        if (provider == 'google') {
          _controller.add(
            DeepLinkResult(
              type: DeepLinkType.googleLogin,
              session: data.session,
            ),
          );
        }
        break;

      case AuthChangeEvent.userUpdated:
        // Fires after email confirmation link is clicked
        _controller.add(
          DeepLinkResult(
            type: DeepLinkType.emailConfirmation,
            session: data.session,
          ),
        );
        break;

      default:
        break;
    }
  }

  void dispose() {
    _subscription?.cancel();
    _controller.close();
  }
}
