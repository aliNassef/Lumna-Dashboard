import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

abstract final class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) throw UnsupportedError('Web not configured.');
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
         return ios;
      default:
        throw UnsupportedError('Unsupported platform.');
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDNFbTHDhHexab3aQ2ZV9a9yvPlmjy6hKM',
    appId: '1:970520097045:android:2bc6c99e2ed4b5551af91c',
    messagingSenderId: '970520097045',
    projectId: 'safi-3d6e2',
    storageBucket: 'safi-3d6e2.firebasestorage.app',
  );
  
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBjnoD8rN_LEKwkJ2-8chdCQkf-qmpvE54',
    appId: '1:970520097045:ios:137aa0e9881ee1621af91c',
    messagingSenderId: '970520097045',
    projectId: 'safi-3d6e2',
    storageBucket: 'safi-3d6e2.firebasestorage.app',
    iosBundleId: 'com.example.ecommerceSupabaseProject',
  );
}
