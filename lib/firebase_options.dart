// Generated manually from Firebase console configuration.
// For additional platforms run `flutterfire configure`.

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'FirebaseOptions have not been configured for web. '
        'Run `flutterfire configure` to generate configuration.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
      case TargetPlatform.linux:
        throw UnsupportedError(
          'FirebaseOptions have not been configured for ${defaultTargetPlatform.name}. '
          'Run `flutterfire configure` to generate configuration.',
        );
      default:
        throw UnsupportedError(
          'FirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAlXTyC6AO4mNzWaG2EHyQgOx6QwFuR5GM',
    appId: '1:11608640547:android:40089cb0c8955f4bf6b596',
    messagingSenderId: '11608640547',
    projectId: 'note-pad-app-fa4c9',
    storageBucket: 'note-pad-app-fa4c9.firebasestorage.app',
  );
}
