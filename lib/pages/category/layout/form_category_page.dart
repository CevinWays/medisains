import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medisains/helpers/constant_color.dart';
import 'package:medisains/helpers/toast_helper.dart';
import 'package:medisains/helpers/validator_helper.dart';
import 'package:medisains/pages/category/bloc/bloc.dart';

class FormCategoryPage extends StatefulWidget {
  @override
  _FormCategoryPageState createState() => _FormCategoryPageState();
}

class _FormCategoryPageState extends State<FormCategoryPage> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descController = TextEditingController();
  CategoryBloc _categoryBloc;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    _categoryBloc = CategoryBloc(InitialCategoryState());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      cubit: _categoryBloc,
      listener: (context,state){
        if(state is CreateCategoryState)
          Navigator.pop(context);
        else if(state is CategoryErrorState)
          ToastHelper.showFlutterToast(state.message);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("New Category",style: TextStyle(color: Colors.black),),
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
                          validator: (String value) => ValidatorHelper.validatorEmpty(label: "Nama Kategori",value: value),
                          decoration: InputDecoration(
                            labelText: "Nama Kategori Penyakit",
                            hintText: "Nama Kategori",
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
                          validator: (String value) => ValidatorHelper.validatorEmpty(label: "Deskripsi",value: value),
                          decoration: InputDecoration(
                            labelText: "Deskripsi Singkat",
                            hintText: "Deskripsi",
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
            onPressed: () => _createCategory(),
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

  void _createCategory(){
    if(_formKey.currentState.validate())
      _categoryBloc.add(CreateCategoryEvent(
          title: _titleController.text,
          desc: _descController.text
      ));
  }
}
