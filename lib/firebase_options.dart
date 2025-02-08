// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
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
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBrygLPV2UdB-hd3BgCXhoppZ0LdYE6aUI',
    appId: '1:36747361614:web:a6e8bd3cdd4582ba1fb21f',
    messagingSenderId: '36747361614',
    projectId: 'legal-remit-9458c',
    authDomain: 'legal-remit-9458c.firebaseapp.com',
    storageBucket: 'legal-remit-9458c.appspot.com',
    measurementId: 'G-4FMS14PME0',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAft7WmLMvtGzS5JKuzZ4A1bwDk3dv7Luk',
    appId: '1:792128093627:android:9e8daff596ada3b83a989e',
    messagingSenderId: '792128093627',
    projectId: 'flutter-notification-8ebdb',
    storageBucket: 'flutter-notification-8ebdb.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAq5OBY5Jv3TU0x9BM9lhh95XYS5qfG0Ks',
    appId: '1:792128093627:ios:02e671a58c64f6b93a989e',
    messagingSenderId: '792128093627',
    projectId: 'flutter-notification-8ebdb',
    storageBucket: 'flutter-notification-8ebdb.firebasestorage.app',
    iosBundleId: 'com.example.nottie',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDN7tcqscUfHY2bPiFa2bLpe_Pyno2ebq4',
    appId: '1:36747361614:ios:28739a17beb78d581fb21f',
    messagingSenderId: '36747361614',
    projectId: 'legal-remit-9458c',
    storageBucket: 'legal-remit-9458c.appspot.com',
    iosBundleId: 'com.example.legalremit',
  );
}
