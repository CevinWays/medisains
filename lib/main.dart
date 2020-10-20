import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medisains/app.dart';
import 'package:medisains/helpers/constant_color.dart';
import 'package:medisains/main_app.dart';

Future<Null> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: primaryColor
  ));
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  App.configure(appTitle: 'Medisains');
  await App().init();
  await Firebase.initializeApp();
  runApp(MainApp());
}