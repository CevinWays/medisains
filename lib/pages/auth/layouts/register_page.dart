import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:medisains/helpers/constant_color.dart';
import 'package:medisains/helpers/toast_helper.dart';
import 'package:medisains/helpers/validator_helper.dart';
import 'package:medisains/pages/auth/bloc/bloc.dart';
import 'package:medisains/pages/auth/layouts/login_page.dart';
import 'package:medisains/pages/home/home_page.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool hidePassword = true;
  bool hideConfPassword = true;
  bool isAgree = false;
  AuthBloc _authBloc;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    _authBloc = AuthBloc(InitialAuthState());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      cubit: _authBloc,
      listener: (context, state) {
        if (state is RegisterState)
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => HomePage()));
        else if (state is RegisterGoogleState)
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => HomePage()));
        else if (state is AuthErrorState)
          Fluttertoast.showToast(msg: state.msg);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: _widgetContentSection(),
        bottomNavigationBar: _widgetFooterSection(),
      ),
    );
  }

  Widget _widgetContentSection() {
    return Form(
      key: _formKey,
      child: Container(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(vertical: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Selamat Datang,",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 28)),
                    Text("Buat akun baru",
                        style: TextStyle(
                            color: disableTextGreyColor, fontSize: 20)),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: TextFormField(
                        controller: _usernameController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: "Username",
                          hintText: "Your Username",
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: primaryColor),
                          ),
                          labelStyle:
                              TextStyle(color: Colors.black, fontSize: 16.0),
                        ),
                        validator: (String value) =>
                            ValidatorHelper.validatorUsername(
                                value: value, label: "Username"),
                      ),
                    ),
                    Container(
                      child: TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (String value) =>
                            ValidatorHelper.validateEmail(value: value),
                        decoration: InputDecoration(
                          labelText: "Email",
                          hintText: "Your Email",
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: primaryColor),
                          ),
                          labelStyle:
                              TextStyle(color: Colors.black, fontSize: 16.0),
                        ),
                      ),
                    ),
                    TextFormField(
                      controller: _passwordController,
                      keyboardType: TextInputType.text,
                      obscureText: hidePassword,
                      validator: (String value) =>
                          ValidatorHelper.validatorPassword(
                              value: value, label: "Password"),
                      decoration: InputDecoration(
                          labelText: "Password",
                          hintText: "Your Password",
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: primaryColor),
                          ),
                          labelStyle:
                              TextStyle(color: Colors.black, fontSize: 16.0),
                          suffixIcon: IconButton(
                              icon: Icon(
                                  !hidePassword
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: primaryColor),
                              onPressed: () {
                                setState(() {
                                  hidePassword = !hidePassword;
                                });
                              })),
                    ),
                    TextFormField(
                      controller: _confirmPasswordController,
                      keyboardType: TextInputType.text,
                      obscureText: hideConfPassword,
                      validator: (String value) =>
                          ValidatorHelper.validatorPassword(
                              value: value, label: "Konfirmasi Password"),
                      decoration: InputDecoration(
                          labelText: "Confirm Password",
                          hintText: "Your Password",
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: primaryColor),
                          ),
                          labelStyle:
                              TextStyle(color: Colors.black, fontSize: 16.0),
                          suffixIcon: IconButton(
                              icon: Icon(
                                  !hideConfPassword
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: primaryColor),
                              onPressed: () {
                                setState(() {
                                  hideConfPassword = !hideConfPassword;
                                });
                              })),
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              ),
              BlocBuilder(
                cubit: _authBloc,
                builder: (context, state) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    child: FlatButton(
                      padding: EdgeInsets.all(16),
                      onPressed: () {
                        if(isAgree == true){
                          state is LoadingState
                              ? null
                              : _register();
                        }else{
                          Fluttertoast.showToast(msg: "Silahkan klik setuju dengan kebijakan dan privasi terlebih dahulu");
                        }
                      },
                      color: state is LoadingState
                          ? disableTextGreyColor
                          : primaryColor,
                      child: Text(
                        "DAFTAR",
                        style: TextStyle(
                            color: state is LoadingState
                                ? darkGreyColor
                                : Colors.white),
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
              _widgetPrivacyPolicy(),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.all(16),
                child: Text(
                  "atau",
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                child: _widgetButtonGoogle(),
                margin: EdgeInsets.all(16),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _widgetPrivacyPolicy() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          Expanded(
              child: Checkbox(
            value: isAgree,
            onChanged: (checked) {
              setState(() {
                isAgree = !isAgree;
              });
            },
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            activeColor: primaryColor,
          )),
          Expanded(
            flex: 14,
            child: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: <Widget>[
                      Text(
                        'Saya setuju dengan ',
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey),
                      ),
                      GestureDetector(
                        onTap: () {
                        },
                        child: Text(
                          'syarat dan kondisi ',
                          style: TextStyle(
                              fontSize: 14,
                              color: primaryColor),
                        ),
                      ),
                      Text(
                        'serta ',
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: (){
                    },
                    child: Text(
                      'kebijakan privasi medisains',
                      style: TextStyle(
                          fontSize: 14,
                          color: primaryColor),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _widgetFooterSection() {
    return Container(
      padding: EdgeInsets.all(16),
      child: GestureDetector(
        onTap: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginPage())),
        child: Text("Sudah punya akun ? Masuk",
            style: TextStyle(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center),
      ),
    );
  }

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (value.isEmpty)
      return 'Email Tidak Boleh Kosong';
    else if (!regex.hasMatch(value))
      return 'Masukkan Email yang valid';
    else
      return null;
  }

  _register() {
    if (_confirmPasswordController.text != _passwordController.text)
      Fluttertoast.showToast(msg: "Konfirmasi password harus sama dengan password");
    else if (_formKey.currentState.validate())
      _authBloc.add(RegisterEvent(
          email: _emailController.text,
          password: _passwordController.text,
          username: _usernameController.text));
  }

  _navigateToLogin() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
  }

  Widget _widgetButtonGoogle() {
    return FlatButton(
      onPressed: () {
        _authBloc.add(RegisterGoogleEvent());
      },
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(
                image: AssetImage("assets/images/img_google.png"),
                height: 30.0),
            Container(
              margin: EdgeInsets.only(left: 15),
              child: Text(
                "Daftar dengan Google",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
