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
  }
}