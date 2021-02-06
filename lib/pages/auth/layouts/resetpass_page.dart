import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:medisains/helpers/constant_color.dart';
import 'package:medisains/helpers/validator_helper.dart';
import 'package:medisains/pages/auth/bloc/bloc.dart';

class ResetPassPage extends StatefulWidget {
  @override
  _ResetPassPageState createState() => _ResetPassPageState();
}

class _ResetPassPageState extends State<ResetPassPage> {
  AuthBloc _authBloc;
  TextEditingController resetPassController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _authBloc = AuthBloc(InitialAuthState());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ubah Password"),
        backgroundColor: primaryColor,
      ),
      body: Container(
        margin: EdgeInsets.all(16),
        child: Column(
          children: [
            TextFormField(
              controller: resetPassController,
              keyboardType: TextInputType.emailAddress,
              validator: (String value) =>
                  ValidatorHelper.validateEmail(value: value),
              decoration: InputDecoration(
                labelText: "Email",
                hintText: "Your Email",
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: primaryColor),
                ),
                labelStyle: TextStyle(color: Colors.black, fontSize: 16.0),
              ),
            ),
            BlocBuilder(
              cubit: _authBloc,
              builder: (context,state){
                if (state is ResetPassState) {
                  Fluttertoast.showToast(
                      msg: "Ubah password berhasil, Silahkan cek email anda");
                } else if (state is AuthErrorState) {
                  Fluttertoast.showToast(msg: state.msg);
                }
                return Container(
                  margin: EdgeInsets.only(top: 16),
                  width: MediaQuery.of(context).size.width,
                  child: FlatButton(
                    padding: EdgeInsets.all(16),
                    onPressed: () => state is LoadingState ? null : _resetPass(resetPassController.text),
                    color:
                    state is LoadingState ? disableTextGreyColor : primaryColor,
                    child: Text(
                      "Kirim",
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
            )
          ],
        ),
      ),
    );
  }

  void _resetPass(String email){
    _authBloc.add(ResetPassEvent(email: email));
  }
}
