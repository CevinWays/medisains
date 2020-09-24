import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medisains/helpers/constant_color.dart';
import 'package:medisains/helpers/toast_helper.dart';
import 'package:medisains/helpers/validator_helper.dart';
import 'package:medisains/pages/auth/bloc/bloc.dart';
import 'package:medisains/pages/auth/layouts/register_page.dart';
import 'package:medisains/pages/home/home_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool hidePassword = true;
  AuthBloc _authBloc;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

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
      listener: (context,state){
        if(state is LoginState)
          Navigator.push(context, MaterialPageRoute(builder: (context)=> HomePage()));
        else if(state is AuthErrorState)
          ToastHelper.showFlutterToast(state.msg);
      },
      child: WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: _widgetContentSection(),
          bottomNavigationBar: _widgetFooterSection(),
        ),
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
                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 28)),
                    Text("Masuk untuk lanjutkan",
                        style: TextStyle(color: disableTextGreyColor, fontSize: 20)),
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
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (String value) => ValidatorHelper.validateEmail(value: value),
                        decoration: InputDecoration(
                          labelText: "Email",
                          hintText: "Your Email",
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: primaryColor),
                          ),
                          labelStyle: TextStyle(color: Colors.black, fontSize: 16.0),
                        ),
                      ),
                    ),
                    TextFormField(
                      controller: _passwordController,
                      keyboardType: TextInputType.text,
                      obscureText: hidePassword,
                      validator: (String value) => ValidatorHelper.validatorEmpty(value: value,label: "Password"),
                      decoration: InputDecoration(
                          labelText: "Password",
                          hintText: "Your Password",
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: primaryColor),
                          ),
                          labelStyle: TextStyle(color: Colors.black, fontSize: 16.0),
                          suffixIcon: IconButton(
                              icon: Icon(!hidePassword ? Icons.visibility : Icons.visibility_off, color: primaryColor),
                              onPressed: () {
                                setState(() {
                                  hidePassword = !hidePassword;
                                });
                              })),
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              ),
              BlocBuilder(
                cubit: _authBloc,
                builder: (context,state){
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    child: FlatButton(
                      padding: EdgeInsets.all(16),
                      onPressed: () => state is LoadingState ? null : _login(),
                      color: state is LoadingState ? disableTextGreyColor : primaryColor,
                      child: Text(
                        "MASUK",
                        style: TextStyle(color: state is LoadingState ? darkGreyColor :  Colors.white),
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4), side: BorderSide(color: state is LoadingState ? disableTextGreyColor : primaryColor)),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _widgetFooterSection(){
    return Container(
      padding: EdgeInsets.all(16),
      child: GestureDetector(
        onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (context)=>RegisterPage())),
        child: Text("Belum punya akun ? Daftar",
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

  _login() {
    if(_formKey.currentState.validate())
      _authBloc.add(LoginEvent(email: _emailController.text,password: _passwordController.text));
  }

  _navigateToRegister() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterPage()));
  }

  Future<bool> _onWillPop() {
    return SystemChannels.platform.invokeMethod('SystemNavigator.pop') ?? false;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}