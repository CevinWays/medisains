import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:medisains/helpers/constant_color.dart';
import 'package:medisains/pages/auth/layouts/login_page.dart';

class OnBoardingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _widgetHeaderSection(),
      body: _widgetContentSection(),
      bottomNavigationBar: _widgetFooterSection(context),
    );
  }

  Widget _widgetHeaderSection() {
    return AppBar(
      elevation: 0.0,
      backgroundColor: Colors.white,
      leading: Container(
          margin: EdgeInsets.only(left: 16),
          child: SvgPicture.asset("assets/images/ic_medisains_basic.svg",
              width: 30, height: 30)),
      title: Text(
        "Medisains",
        style: TextStyle(
            color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _widgetContentSection() {
    return Container(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SvgPicture.asset(
              "assets/images/img_doctors.svg",
              height: 200,
              width: 200,
            ),
            Container(
              margin: EdgeInsets.only(top: 32),
              child: Text(
                "Bersama medisains menjadi lebih mudah \n segera buat content penelitian mu",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _widgetFooterSection(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 8, bottom: 16, left: 8, right: 8),
      child: FlatButton(
        onPressed: () {
          _navigateToOnBoardingSecond(context);
        },
        color: primaryColor,
        child: Text(
          "LANJUT",
          style: TextStyle(color: Colors.white),
        ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
            side: BorderSide(color: primaryColor)),
      ),
    );
  }

  _navigateToOnBoardingSecond(BuildContext context) {
    return Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
  }
}
