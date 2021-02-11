import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medisains/app.dart';
import 'package:medisains/helpers/constant_color.dart';
import 'package:medisains/pages/auth/bloc/bloc.dart';
import 'package:medisains/pages/profile/edit_profile_page.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  AuthBloc _authBloc;

  @override
  void initState() {
    // TODO: implement initState
    _authBloc = AuthBloc(InitialAuthState());
    _authBloc.add(ReadUserDataEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      cubit: _authBloc,
      builder: (context,state){
        return Scaffold(
          appBar: AppBar(
            elevation: 0.0,
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.arrow_back,color: Colors.black,),),
            title: Text("Informasi Pengguna",style: TextStyle(color: Colors.black),),
          ),
          backgroundColor: Colors.white,
          body: _widgetContentSection(state),
          floatingActionButton: FloatingActionButton(
            backgroundColor: primaryColor,
            child: Icon(Icons.edit),
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=> EditProfilePage()));
            },
          ),
        );
      },
    );
  }

  Widget _widgetContentSection(state){
    return Container(
      margin: EdgeInsets.all(16),
      child: ListView(
        children: <Widget>[
          ListTile(
            title: Text("Username"),
            trailing: Text(App().sharedPreferences.getString("displayName")) ,
          ),
          ListTile(
            title: Text("Email"),
            trailing: Text(App().sharedPreferences.getString("email")),
          ),
        ],
      ),
    );
  }
}
