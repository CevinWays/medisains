import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medisains/app.dart';
import 'package:medisains/helpers/constant_color.dart';
import 'package:medisains/pages/auth/bloc/bloc.dart';
import 'package:medisains/pages/auth/models/user_model.dart';
import 'package:medisains/pages/profile/edit_profile_page.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  AuthBloc _authBloc;
  UserModel userModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _authBloc = AuthBloc(InitialAuthState());
    _authBloc.add(ReadUserDataEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      cubit: _authBloc,
      listener: (context,state){},
      child: BlocBuilder(
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
                Navigator.push(context, MaterialPageRoute(builder: (context)=> EditProfilePage(isWizard: false,)));
              },
            ),
          );
        },
      ),
    );
  }

  Widget _widgetContentSection(state){
    return Container(
      margin: EdgeInsets.all(16),
      child: ListView(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.person_outline,color: blueColor),
            title: Text("Username"),
            trailing: Text(App().sharedPreferences.getString("displayName") != null
                ? App().sharedPreferences.getString("displayName")
                : "Username",style: TextStyle(fontWeight: FontWeight.bold)
            ) ,
          ),
          ListTile(
            leading: Icon(Icons.email_outlined,color: Colors.deepPurpleAccent,),
            title: Text("Email"),
            trailing: Text(App().sharedPreferences.getString("email") != null
                ? App().sharedPreferences.getString("email")
                : "Email",style: TextStyle(fontWeight: FontWeight.bold)
            ),
          ),ListTile(
            leading: Icon(Icons.school_outlined,color: primaryColor),
            title: Text("Pendidikan"),
            trailing: Text(state is ReadUserDataState && state.userModel.education != null ? state.userModel.education : "Belum ada data",style: TextStyle(fontWeight: FontWeight.bold)
            ),
          ),ListTile(
            leading: Icon(Icons.toggle_off, color: Colors.greenAccent),
            title: Text("Gender"),
            trailing: Text(state is ReadUserDataState && state.userModel.gender != null ? state.userModel.gender : "Belum ada data",style: TextStyle(fontWeight: FontWeight.bold)
            ),
          ),ListTile(
            leading: Icon(Icons.work_outline_rounded,color: Colors.amberAccent),
            title: Text("Instansi"),
            trailing: Text(state is ReadUserDataState && state.userModel.instansi != null ? state.userModel.instansi : "Belum ada data",style: TextStyle(fontWeight: FontWeight.bold)
            ),
          ),ListTile(
            leading: Icon(Icons.location_on_outlined, color: Colors.deepOrangeAccent),
            title: Text("Location"),
            trailing: Text(state is ReadUserDataState && state.userModel.location != null ? state.userModel.location : "Belum ada data",style: TextStyle(fontWeight: FontWeight.bold)
            ),
          ),ListTile(
            leading: Icon(Icons.phone_iphone_outlined, color: Colors.black),
            title: Text("No Hp"),
            trailing: Text(state is ReadUserDataState && state.userModel.noHp != null ? state.userModel.noHp : "Belum ada data",style: TextStyle(fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }
}
