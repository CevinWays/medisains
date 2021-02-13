import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class CrashlyticsHelper {
  static Future<void> log(String data) async {
    await FirebaseCrashlytics.instance.log(data);
  }

  static Future<void> crash(e, StackTrace stackTrace, dynamic reason) async {
    await FirebaseCrashlytics.instance
        .recordError(e, stackTrace, reason: reason, printDetails: true);
  }

  static Future<void> customKey(String key, dynamic value) async {
    await FirebaseCrashlytics.instance.setCustomKey(key, value);
  }

  static Future<void> setUserIdentifier(String data) async {
    await FirebaseCrashlytics.instance.setUserIdentifier(data);
  }
}
