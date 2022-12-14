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
    apiKey: 'AIzaSyDSDxF8pXn8r1r7nXIIK9WmnRmnOOE3D3E',
    appId: '1:756282867280:web:ff37c3d807f93788459b55',
    messagingSenderId: '756282867280',
    projectId: 'naxtrust-wallet',
    authDomain: 'naxtrust-wallet.firebaseapp.com',
    storageBucket: 'naxtrust-wallet.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA0mLDanDBpXEzXpMHEgAxhRiZyxEzFv8Y',
    appId: '1:756282867280:android:15c28cca82009ee4459b55',
    messagingSenderId: '756282867280',
    projectId: 'naxtrust-wallet',
    storageBucket: 'naxtrust-wallet.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA760Vr6pWixhBjxrgLojhhkKETfimb7ek',
    appId: '1:756282867280:ios:25648ccb11fd22d6459b55',
    messagingSenderId: '756282867280',
    projectId: 'naxtrust-wallet',
    storageBucket: 'naxtrust-wallet.appspot.com',
    iosClientId: '756282867280-0b16gc0a72bl01q45pkntpph9la2vo32.apps.googleusercontent.com',
    iosBundleId: 'com.example.naxtrustWallet',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyA760Vr6pWixhBjxrgLojhhkKETfimb7ek',
    appId: '1:756282867280:ios:25648ccb11fd22d6459b55',
    messagingSenderId: '756282867280',
    projectId: 'naxtrust-wallet',
    storageBucket: 'naxtrust-wallet.appspot.com',
    iosClientId: '756282867280-0b16gc0a72bl01q45pkntpph9la2vo32.apps.googleusercontent.com',
    iosBundleId: 'com.example.naxtrustWallet',
  );
}
