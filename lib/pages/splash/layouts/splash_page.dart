import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medisains/pages/home/home_page.dart';
import 'package:medisains/pages/onboarding/onboarding_page.dart';
import 'package:medisains/pages/splash/bloc/splash_export.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  SplashBloc _splashBloc = SplashBloc(SplashInitState());

  @override
  void initState() {
    // TODO: implement initState
    _splashBloc.add(LoadNextPageEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      cubit: _splashBloc,
      listener: (context, state) {
        if (state is GoToHomePageState)
          _navigateToHome();
        else if (state is GotoOnBoardingState) _navigateToOnBoardingPage();
      },
      child: _widgetSplashLayout(),
    );
  }

  _navigateToOnBoardingPage() {
    var _duration = const Duration(seconds: 3);
    return Timer(_duration, () {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => OnBoardingPage()));
    });
  }

  _navigateToHome() {
    var _duration = const Duration(seconds: 3);
    return Timer(_duration, () {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    });
  }

  Widget _widgetSplashLayout() {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
            child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SvgPicture.asset("assets/images/ic_medisains_basic.svg"),
            Container(
              margin: EdgeInsets.only(top: 20.0),
              child: Text(
                "Medisains",
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        )),
      ),
    );
  }
}
