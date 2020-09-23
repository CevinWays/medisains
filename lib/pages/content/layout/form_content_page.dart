import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medisains/helpers/constant_color.dart';
import 'package:medisains/helpers/toast_helper.dart';
import 'package:medisains/helpers/validator_helper.dart';
import 'package:medisains/pages/content/bloc/bloc.dart';

class FormContentPage extends StatefulWidget {
  @override
  _FormContentPageState createState() => _FormContentPageState();
}

class _FormContentPageState extends State<FormContentPage> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descController = TextEditingController();
  ContentBloc _contentBloc;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    _contentBloc = ContentBloc(InitialContentState());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      cubit: _contentBloc,
      listener: (context,state){
        if(state is CreateContentState)
          Navigator.pop(context);
        else if(state is ContentErrorState)
          ToastHelper.showFlutterToast(state.message);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("New Content",style: TextStyle(color: Colors.black),),
          elevation: 0.0,
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
        ),
        body: Form(
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
                      Container(
                        child: TextFormField(
                          controller: _titleController,
                          keyboardType: TextInputType.text,
                          validator: (String value)=>ValidatorHelper.validatorEmpty(label: "Judul",value: value),
                          decoration: InputDecoration(
                            labelText: "Judul",
                            hintText: "Judul",
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: primaryColor),
                            ),
                            labelStyle: TextStyle(color: Colors.black, fontSize: 16.0),
                          ),
                        ),
                      ),
                      Container(
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            labelText: "Kategori Penyakit",
                            hintText: "Kategori",
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: primaryColor),
                            ),
                            labelStyle: TextStyle(color: Colors.black, fontSize: 16.0),
                          ),
                        ),
                      ),
                      Container(
                        child: TextFormField(
                          controller: _descController,
                          keyboardType: TextInputType.text,
                          validator: (String value)=>ValidatorHelper.validatorEmpty(label: "Studi kasus",value: value),
                          decoration: InputDecoration(
                            labelText: "Studi Kasus",
                            hintText: "Studi Kasus",
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: primaryColor),
                            ),
                            labelStyle: TextStyle(color: Colors.black, fontSize: 16.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.all(16),
          child: FlatButton(
            padding: EdgeInsets.all(16),
            onPressed: () => _createContent(),
            color: primaryColor,
            child: Text(
              "Submit",
              style: TextStyle(color: Colors.white),
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4), side: BorderSide(color: primaryColor)),
          ),
        ),
      ),
    );
  }

  void _createContent(){
    if(_formKey.currentState.validate())
      _contentBloc.add(CreateContentEvent(
          title: _titleController.text,
          desc: _descController.text));
  }
}
