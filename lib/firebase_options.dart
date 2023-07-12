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
    apiKey: 'AIzaSyCucCZTtPDn1krsk4135gL7I0kxPIJYhsc',
    appId: '1:828300291753:web:04945bc3c81f815fc443b8',
    messagingSenderId: '828300291753',
    projectId: 'biblechallenge-81cae',
    authDomain: 'biblechallenge-81cae.firebaseapp.com',
    storageBucket: 'biblechallenge-81cae.appspot.com',
    measurementId: 'G-FHZYK4XGVX',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBMEm5sLVp1oMA1lD8V9--njigpHsFhuX4',
    appId: '1:828300291753:android:7b529558687c4d31c443b8',
    messagingSenderId: '828300291753',
    projectId: 'biblechallenge-81cae',
    storageBucket: 'biblechallenge-81cae.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDt77E8EnZEiS9TUMrL77v4pUPGjH5Ssa8',
    appId: '1:828300291753:ios:eb5510b0711d1998c443b8',
    messagingSenderId: '828300291753',
    projectId: 'biblechallenge-81cae',
    storageBucket: 'biblechallenge-81cae.appspot.com',
    iosClientId: '828300291753-1l12c3pe3k9j2ee7lqu8ebagjt09rt19.apps.googleusercontent.com',
    iosBundleId: 'com.example.socialmedia',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDt77E8EnZEiS9TUMrL77v4pUPGjH5Ssa8',
    appId: '1:828300291753:ios:5f7f0e174fa69e4cc443b8',
    messagingSenderId: '828300291753',
    projectId: 'biblechallenge-81cae',
    storageBucket: 'biblechallenge-81cae.appspot.com',
    iosClientId: '828300291753-mres12rosbqsd5ms5nsb0vmcg7t71pqv.apps.googleusercontent.com',
    iosBundleId: 'com.example.socialmedia.RunnerTests',
  );
}
