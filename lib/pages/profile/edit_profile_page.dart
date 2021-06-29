import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:medisains/app.dart';
import 'package:medisains/helpers/constant_color.dart';
import 'package:medisains/helpers/validator_helper.dart';
import 'package:medisains/pages/auth/bloc/bloc.dart';
import 'package:medisains/pages/home/home_page.dart';

class EditProfilePage extends StatefulWidget {
  final bool isWizard;

  const EditProfilePage({Key key, this.isWizard}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  AuthBloc _authBloc;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _educationController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _instansiController = TextEditingController();
  TextEditingController _noHpController = TextEditingController();
  String dropDownGender;
  String dropDownLocation;
  List<String> listLocation = [
    'Jakarta',
    'Jawa Timur',
    'Jawa Barat',
    'Jawa Tengah',
    'Sumatra',
    'Kalimantan',
    'Sulawesi',
    'Papua',
    'Lainnya'
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _authBloc = AuthBloc(InitialAuthState());
    _nameController.text = App().sharedPreferences.getString("displayName");
    _emailController.text = App().sharedPreferences.getString("email");
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      cubit: _authBloc,
      listener: (context, state) {
        if (state is UpdateProfileState) {
          if (widget.isWizard) {
            Fluttertoast.showToast(msg: "Berhasil melengkapi data pengguna");
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => HomePage()));
          } else {
            Fluttertoast.showToast(msg: "Berhasil perbaharui data profile");
            Navigator.pop(context);
          }
        } else if (state is AuthErrorState) {
          Fluttertoast.showToast(msg: state.msg);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            widget.isWizard ? "Lengkapi Data Diri" : "Edit Profile",
            style: TextStyle(color: Colors.black),
          ),
          elevation: 0.0,
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          leading: widget.isWizard
              ? Container()
              : IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                ),
        ),
        body: BlocBuilder(
          cubit: _authBloc,
          builder: (context, state) {
            return state is LoadingState
                ? Center(child: CircularProgressIndicator())
                : Form(
                    key: _formKey,
                    child: Container(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(top: 32),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Card(
                                  elevation: 2.0,
                                  child: Container(
                                    padding: EdgeInsets.only(right: 8, left: 8),
                                    child: TextFormField(
                                      readOnly: true,
                                      controller: _nameController,
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                        hintText: "Nama",
                                        enabledBorder: InputBorder.none,
                                        border: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        labelStyle: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16.0),
                                      ),
                                    ),
                                  ),
                                ),
                                Card(
                                  elevation: 2.0,
                                  child: Container(
                                    padding: EdgeInsets.only(right: 8, left: 8),
                                    child: TextFormField(
                                      readOnly: true,
                                      controller: _emailController,
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                        hintText: "Email",
                                        enabledBorder: InputBorder.none,
                                        border: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        labelStyle: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16.0),
                                      ),
                                    ),
                                  ),
                                ),
                                Card(
                                  elevation: 2.0,
                                  child: Container(
                                    padding: EdgeInsets.only(right: 8, left: 8),
                                    child: TextFormField(
                                      controller: _educationController,
                                      keyboardType: TextInputType.text,
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      validator: (String value) =>
                                          ValidatorHelper.validatorEmpty(
                                              label: "Pendidikan Terakhir",
                                              value: value),
                                      decoration: InputDecoration(
                                        hintText: "Pendidikan Terakhir",
                                        enabledBorder: InputBorder.none,
                                        border: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        labelStyle: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16.0),
                                      ),
                                    ),
                                  ),
                                ),
                                Card(
                                  elevation: 2.0,
                                  child: Container(
                                    padding: EdgeInsets.only(right: 8, left: 8),
                                    child: TextFormField(
                                      controller: _instansiController,
                                      keyboardType: TextInputType.text,
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      validator: (String value) =>
                                          ValidatorHelper.validatorEmpty(
                                              label: "Instansi", value: value),
                                      decoration: InputDecoration(
                                        hintText: "Instansi",
                                        enabledBorder: InputBorder.none,
                                        border: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        labelStyle: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16.0),
                                      ),
                                    ),
                                  ),
                                ),
                                Card(
                                  elevation: 2.0,
                                  child: Container(
                                    padding: EdgeInsets.only(left: 8, right: 8),
                                    width: MediaQuery.of(context).size.width,
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        hint: Text("Jenis Kelamin"),
                                        value: dropDownGender,
                                        icon: Icon(Icons.arrow_drop_down),
                                        iconSize: 24,
                                        elevation: 16,
                                        style: TextStyle(color: Colors.black),
                                        onChanged: (String newValue) {
                                          setState(() {
                                            dropDownGender = newValue;
                                          });
                                        },
                                        items: <String>[
                                          'laki-laki',
                                          'perempuan'
                                        ].map<DropdownMenuItem<String>>(
                                            (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                ),
                                Card(
                                  elevation: 2.0,
                                  child: Container(
                                    padding: EdgeInsets.only(right: 8, left: 8),
                                    child: TextFormField(
                                      controller: _noHpController,
                                      keyboardType: TextInputType.phone,
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      validator: (String value) =>
                                          ValidatorHelper.validatorPhoneNum(
                                              label: "No Hp", value: value),
                                      decoration: InputDecoration(
                                        hintText: "No Hp",
                                        enabledBorder: InputBorder.none,
                                        border: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        labelStyle: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16.0),
                                      ),
                                    ),
                                  ),
                                ),
                                Card(
                                  elevation: 2.0,
                                  child: Container(
                                    padding: EdgeInsets.only(left: 8, right: 8),
                                    width: MediaQuery.of(context).size.width,
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        hint: Text("Lokasi"),
                                        value: dropDownLocation,
                                        icon: Icon(Icons.arrow_drop_down),
                                        iconSize: 24,
                                        elevation: 16,
                                        style: TextStyle(color: Colors.black),
                                        onChanged: (String newValue) {
                                          setState(() {
                                            dropDownLocation = newValue;
                                          });
                                        },
                                        items: listLocation
                                            .map<DropdownMenuItem<String>>(
                                                (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
          },
        ),
        bottomSheet: BlocBuilder(
          cubit: _authBloc,
          builder: (context, state) {
            return Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.all(16),
              child: FlatButton(
                padding: EdgeInsets.all(16),
                onPressed: state is LoadingState
                    ? null
                    : () {
                        _saveEditedProfile();
                      },
                color:
                    state is LoadingState ? disableTextGreyColor : primaryColor,
                child: Text(
                  widget.isWizard ? "Submit" : "Update",
                  style: TextStyle(
                      color:
                          state is LoadingState ? darkGreyColor : Colors.white),
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                    side: BorderSide(
                        color: state is LoadingState
                            ? disableTextGreyColor
                            : primaryColor)),
              ),
            );
          },
        ),
      ),
    );
  }

  _saveEditedProfile() {
    if (dropDownLocation != null && dropDownGender != null) {
      if (_formKey.currentState.validate()) {
        _authBloc.add(UpdateProfileEvent(
            noHp: _noHpController.text,
            gender: dropDownGender,
            instansi: _instansiController.text,
            location: dropDownLocation,
            education: _educationController.text));
      }
    } else {
      Fluttertoast.showToast(msg: "Lengkapi data terlebih dahulu");
    }
  }
}
