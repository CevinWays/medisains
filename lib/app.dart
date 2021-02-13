import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class App {
  static App _instance;
  final String appTitle;
  SharedPreferences sharedPreferences;

  App.configure({@required this.appTitle}) {
    _instance = this;
  }

  factory App() {
    if (_instance == null) {
      throw UnimplementedError("Aplikasi perlu dikonfigurasi");
    }
    return _instance;
  }

  Future<Null> init() async {
    sharedPreferences = await SharedPreferences.getInstance();

    // Pass all uncaught errors to Crashlytics.
    Function originalOnError = FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails errorDetails) async {
      await FirebaseCrashlytics.instance.recordFlutterError(errorDetails);
      // Forward to original handler.
      originalOnError(errorDetails);
    };
  }
}