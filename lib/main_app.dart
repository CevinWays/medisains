import 'package:flutter/material.dart';
import 'package:medisains/helpers/constant_color.dart';
import 'package:medisains/pages/splash/layouts/splash_page.dart';
import 'package:medisains/routes/routes.dart';

class MainApp extends StatefulWidget {
  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Medisains',
      theme: ThemeData(
        highlightColor: primaryColor,
        focusColor: primaryColor,
        cursorColor: primaryColor,
        textSelectionColor: primaryColor,
        textSelectionHandleColor: primaryColor,
      ),
      onGenerateRoute: Routes.generateRoute,
      initialRoute: 'splashPage',
      routes: {
        'splashPage': (context) => SplashPage(),
      },
      home: SplashPage(),
    );
  }
}
