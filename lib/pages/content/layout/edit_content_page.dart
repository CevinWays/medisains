import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:medisains/app.dart';
import 'package:medisains/helpers/constant_color.dart';
import 'package:medisains/helpers/constant_routes.dart';
import 'package:medisains/helpers/datetime_helper.dart';
import 'package:medisains/helpers/validator_helper.dart';
import 'package:medisains/pages/content/model/content_model.dart';

class EditContentPage extends StatefulWidget {
  final ContentModel contentModel;

  const EditContentPage({Key key, this.contentModel}) : super(key: key);

  @override
  _EditContentPageState createState() => _EditContentPageState();
}

class _EditContentPageState extends State<EditContentPage> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descController = TextEditingController();
  TextEditingController _catController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String dateTimeNow = DateTimeHelper.currentDate();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _titleController.text = widget.contentModel.title;
    _descController.text = widget.contentModel.desc;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Content"),
        backgroundColor: primaryColor,
        centerTitle: true,
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
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (String value)=> ValidatorHelper.validatorEmpty(label: "Judul",value: value),
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
                        controller: _catController,
                        keyboardType: TextInputType.text,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
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
                        autovalidateMode: AutovalidateMode.onUserInteraction,
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
      bottomSheet: Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.all(16),
        child: FlatButton(
          padding: EdgeInsets.all(16),
          onPressed: () {
            _saveEditedContent();
          },
          color: primaryColor,
          child: Text(
            "Update",
            style: TextStyle(color: Colors.white),
          ),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4), side: BorderSide(color: primaryColor)),
        ),
      ),
    );
  }

  _saveEditedContent() {
    CollectionReference contents = FirebaseFirestore.instance.collection('content');
    contents.doc(widget.contentModel.idCont).update(
      {
        "id_cont" : widget.contentModel.idCont,
        'title' : _titleController.text,
        'desc' : _descController.text,
        'category' : _catController.text,
        'author_name' : App().sharedPreferences.getString("displayName"),
        'photo_url' : App().sharedPreferences.getString("photoUrl"),
        'update_date' : dateTimeNow,
      }
    ).then((value) => Fluttertoast.showToast(msg: "Berhasil perbaharui content"));
    Navigator.popAndPushNamed(context, homePage);
  }
}
