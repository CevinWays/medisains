import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:medisains/app.dart';
import 'package:medisains/helpers/constant_color.dart';
import 'package:medisains/helpers/constant_routes.dart';
import 'package:medisains/helpers/toast_helper.dart';
import 'package:medisains/pages/auth/bloc/bloc.dart';
import 'package:medisains/pages/auth/layouts/login_page.dart';
import 'package:medisains/pages/profile/profile_page.dart';

class FragmentProfilePage extends StatefulWidget {
  @override
  _FragmentProfilePageState createState() => _FragmentProfilePageState();
}

class _FragmentProfilePageState extends State<FragmentProfilePage> {
  AuthBloc _authBloc;
  List<Map<dynamic,dynamic>> listProfileData;
  List<Map<dynamic,dynamic>> listProfileSettings;

  @override
  void initState() {
    // TODO: implement initState
    _authBloc = AuthBloc(InitialAuthState());
    listProfileData = [
      {
        "icon" : Icons.account_circle,
        "title" : "Informasi Pengguna",
        Function : _navigateToUserInformation
      },
      {
        "icon" : Icons.question_answer,
        "title" : "Forum Diskusi",
        Function : _comingSoon
      },

      {
        "icon" : Icons.menu_book_outlined,
        "title" : "Buku Panduan",
        Function : _comingSoon
      },
    ];

    listProfileSettings = [
      {
        "icon" : Icons.settings,
        "title" : "Ubah Password",
        Function : _resetPass
      },
      {
        "icon" : Icons.exit_to_app,
        "title" : "Keluar",
        Function : _logout
      },
    ];
    _authBloc.add(ReadUserDataEvent());
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return BlocListener(
      cubit: _authBloc,
      listener: (context,state){
        if(state is LogoutState)
          Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginPage()));
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
        ),
        body: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            children: <Widget>[
              Container(
                width: 80,
                height: 80,
                margin: EdgeInsets.only(right: 16),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        fit: BoxFit.contain,
                        image: CachedNetworkImageProvider(
                          App().sharedPreferences.getString("photoUrl"),
                        )
                    )
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 16),
                child: Column(
                  children: <Widget>[
                    BlocBuilder(
                      cubit: _authBloc,
                      builder: (context,state){
                        return Text( App().sharedPreferences.getString("displayName"),
                          style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold, color: Colors.black),
                        );
                      },
                    ),
                    Text(
                        "S1 Kedokteran"
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 16),
                child: Column(
                  children: listProfileData.map((i){
                    return Builder(
                      builder: (BuildContext context) {
                        return ListTile(
                          onTap: i[Function],
                          leading: Icon(i["icon"], color: primaryColor,),
                          title: Text(i["title"]),
                          trailing: Icon(Icons.arrow_forward_ios, color: primaryColor, size: 20,),
                        );
                      },
                    );
                  }).toList(),
                ),
              ),
              Divider(height: 2,),
              Container(
                margin: EdgeInsets.only(top: 16),
                child: Column(
                  children: listProfileSettings.map((i){
                    return Builder(
                      builder: (BuildContext context) {
                        return ListTile(
                          onTap: i[Function],
                          leading: Icon(i["icon"], color: darkGreyColor,),
                          title: Text(i["title"]),
                        );
                      },
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _comingSoon(){
    Fluttertoast.showToast(msg: "Coming Soon");
  }

  void _navigateToUserInformation(){
    Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfilePage()));
  }

  void _logout(){
    _authBloc.add(LogoutEvent());
  }

  void _resetPass(){
    Navigator.pushNamed(context, resetPassPage);
  }
}
