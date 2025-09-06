// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// DefaultFirebaseOptions รองรับ Android, iOS, และ Web
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not configured for this platform.',
        );
    }
  }

  /// Android config
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBajc8ObIx2b7e3kqPcm3zUK-k_0dsMK5A',
    appId: '1:996403929174:android:6d445bfc9cc866448c9bf7',
    messagingSenderId: '996403929174',
    projectId: 'project-b0b27',
    storageBucket: 'project-b0b27.firebasestorage.app',
  );

  /// iOS config (ต้องเอาค่าจริงจาก GoogleService-Info.plist มาแทน)
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'YOUR_IOS_API_KEY',
    appId: 'YOUR_IOS_APP_ID',
    messagingSenderId: 'YOUR_IOS_SENDER_ID',
    projectId: 'project-b0b27',
    storageBucket: 'project-b0b27.firebasestorage.app',
    iosBundleId: 'com.example.yourapp',
  );

  /// Web config (ต้องเอาค่าจริงจาก Firebase console → Project settings → Web app)
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'YOUR_WEB_API_KEY',
    appId: 'YOUR_WEB_APP_ID',
    messagingSenderId: 'YOUR_WEB_SENDER_ID',
    projectId: 'project-b0b27',
    authDomain: 'project-b0b27.firebaseapp.com',
    storageBucket: 'project-b0b27.firebasestorage.app',
    measurementId: 'YOUR_MEASUREMENT_ID',
  );
}
