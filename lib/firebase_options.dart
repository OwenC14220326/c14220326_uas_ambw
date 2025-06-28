import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: "AIzaSyA1_oRIXDCfO2OrU1ckITrJfyh-eZ08eII",
    authDomain: "ambw-simplerecipekeeper.firebaseapp.com",
    projectId: "ambw-simplerecipekeeper",
    storageBucket: "ambw-simplerecipekeeper.appspot.com",
    messagingSenderId: "173012233940",
    appId: "1:173012233940:web:fdc9c0259ab6382e5b9541",
    measurementId: "G-5T4CG1ES86",
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: "AIzaSyA1_oRIXDCfO2OrU1ckITrJfyh-eZ08eII",
    appId: "1:173012233940:web:fdc9c0259ab6382e5b9541",
    messagingSenderId: "173012233940",
    projectId: "ambw-simplerecipekeeper",
    storageBucket: "ambw-simplerecipekeeper.appspot.com",
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: "AIzaSyA1_oRIXDCfO2OrU1ckITrJfyh-eZ08eII",
    appId: "1:173012233940:web:fdc9c0259ab6382e5b9541",
    messagingSenderId: "173012233940",
    projectId: "ambw-simplerecipekeeper",
    storageBucket: "ambw-simplerecipekeeper.appspot.com",
    iosClientId: "",
    iosBundleId: "",
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: "AIzaSyA1_oRIXDCfO2OrU1ckITrJfyh-eZ08eII",
    appId: "1:173012233940:web:fdc9c0259ab6382e5b9541",
    messagingSenderId: "173012233940",
    projectId: "ambw-simplerecipekeeper",
    storageBucket: "ambw-simplerecipekeeper.appspot.com",
    iosClientId: "",
    iosBundleId: "",
  );
}
