import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

class FirebaseController {
  static bool isInitialized = false;
  static late FirebaseApp app;
  Future<void> initialize() async {
    try {
      if (!isInitialized) {
        app = await Firebase.initializeApp();
        FirebaseAnalytics analytic = FirebaseAnalytics.instance;
        await FirebaseCrashlytics.instance
            .setCrashlyticsCollectionEnabled(!kDebugMode);
        await analytic.setAnalyticsCollectionEnabled(!kDebugMode);
        if (!kDebugMode) {
          FirebaseAnalyticsObserver(analytics: analytic);
          FlutterError.onError =
              FirebaseCrashlytics.instance.recordFlutterError;
          // analyticObserve = [FirebaseAnalyticsObserver(analytics: analytic)];
        }
        isInitialized = true;
      }
    } catch (e) {}
  }

  Future<bool> logOut() async {
    await FirebaseAuth.instance.signOut();
    try {
      await FirebaseAuth.instance.signOut();
      return true;
    } catch (e) {
      return false;
    }
  }
}
