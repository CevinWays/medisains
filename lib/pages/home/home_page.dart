import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medisains/helpers/constant_color.dart';
import 'package:medisains/pages/home/fragment_content_page.dart';
import 'package:medisains/pages/home/fragment_home_page.dart';
import 'package:medisains/pages/home/fragment_profile_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    FragmentHomePage(),
    FragmentContentPage(),
    FragmentProfilePage()
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: _children[_currentIndex],
        bottomNavigationBar: _widgetFooterSection(),
      ),
    );
  }

  Widget _widgetFooterSection() {
    return BottomNavigationBar(
        selectedItemColor: primaryColor,
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: "Explore",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: "Profile",
          ),
        ]
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Future<bool> _onWillPop() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Konfirmasi Keluar', style: TextStyle(color: primaryColor, fontSize: 20.0)),
        content: Text('Apakah anda ingin keluar?'),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              // this line exits the app.
              SystemChannels.platform.invokeMethod('SystemNavigator.pop');
            },
            child: Text('YA', style: TextStyle(fontSize: 18.0, color: primaryColor)),
          ),
          FlatButton(
            color: primaryColor,
            onPressed: () => Navigator.pop(context),
            // this line dismisses the dialog
            child: Text('TIDAK', style: TextStyle(fontSize: 18.0, color: Colors.white)),
          )
        ],
      ),
    ) ?? false;
  }
}
