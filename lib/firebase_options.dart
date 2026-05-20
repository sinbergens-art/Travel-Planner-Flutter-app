// ignore_for_file: lines_longer_than_80_chars
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return ios; // macOS uses same config as iOS
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions not configured for this platform.',
        );
    }
  }

  // ⚠️ Web — add later if needed
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'YOUR_WEB_API_KEY',
    appId: 'YOUR_WEB_APP_ID',
    messagingSenderId: '100018703491',
    projectId: 'travel-planner-301d0',
    authDomain: 'travel-planner-301d0.firebaseapp.com',
    storageBucket: 'travel-planner-301d0.firebasestorage.app',
  );

  // ⚠️ Android — add later if needed
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'YOUR_ANDROID_API_KEY',
    appId: 'YOUR_ANDROID_APP_ID',
    messagingSenderId: '100018703491',
    projectId: 'travel-planner-301d0',
    storageBucket: 'travel-planner-301d0.firebasestorage.app',
  );

  // ✅ iOS — travel-planner-301d0
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAIlxaHFrE3aJtEndUcMW9eEnvtyKWn2-A',
    appId: '1:100018703491:ios:1ab4c13111bf6c4fc4dfb6',
    messagingSenderId: '100018703491',
    projectId: 'travel-planner-301d0',
    storageBucket: 'travel-planner-301d0.firebasestorage.app',
    iosBundleId: 'com.example.travelPlanner',
  );
}
