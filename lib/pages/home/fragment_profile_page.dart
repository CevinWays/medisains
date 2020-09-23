import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medisains/helpers/constant_color.dart';
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
        Function : _changePass
      },
    ];

    listProfileSettings = [
      {
        "icon" : Icons.settings,
        "title" : "Ubah Password",
        Function : _changePass
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
                margin: EdgeInsets.only(bottom: 16),
                child: Column(
                  children: <Widget>[
                    BlocBuilder(
                      cubit: _authBloc,
                      builder: (context,state){
                        return Text(
                          state is ReadUserDataState
                              ? state.username
                              : "Username",
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

  void _changePass(){
    ToastHelper.showFlutterToast("Terjadi kesalahan");
  }

  void _navigateToUserInformation(){
    Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfilePage()));
  }

  void _logout(){
    _authBloc.add(LogoutEvent());
  }
}
