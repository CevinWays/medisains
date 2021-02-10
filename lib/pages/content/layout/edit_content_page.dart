import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_document_picker/flutter_document_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medisains/app.dart';
import 'package:medisains/helpers/constant_color.dart';
import 'package:medisains/helpers/constant_routes.dart';
import 'package:medisains/helpers/datetime_helper.dart';
import 'package:medisains/helpers/validator_helper.dart';
import 'package:medisains/pages/content/model/content_model.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

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
  File _image;
  File _doc;
  final picker = ImagePicker();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _titleController.text = widget.contentModel.title;
    _descController.text = widget.contentModel.desc;
    _catController.text = widget.contentModel.category;
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
                        validator: (String value) =>
                            ValidatorHelper.validatorEmpty(
                                label: "Judul", value: value),
                        decoration: InputDecoration(
                          labelText: "Judul",
                          hintText: "Judul",
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: primaryColor),
                          ),
                          labelStyle:
                              TextStyle(color: Colors.black, fontSize: 16.0),
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
                          labelStyle:
                              TextStyle(color: Colors.black, fontSize: 16.0),
                        ),
                      ),
                    ),
                    Container(
                      child: TextFormField(
                        controller: _descController,
                        keyboardType: TextInputType.text,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (String value) =>
                            ValidatorHelper.validatorEmpty(
                                label: "Studi kasus", value: value),
                        decoration: InputDecoration(
                          labelText: "Deskripsi",
                          hintText: "Deskripsi",
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: primaryColor),
                          ),
                          labelStyle:
                              TextStyle(color: Colors.black, fontSize: 16.0),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 16),
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        children: [
                          _image == null
                              ? widget.contentModel.imageUrl != null && widget.contentModel.imageUrl != ""
                                  ? Container(
                                      width: 100,
                                      height: 100,
                                      margin: EdgeInsets.symmetric(vertical: 8),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          image: DecorationImage(
                                              fit: BoxFit.contain,
                                              image: CachedNetworkImageProvider(
                                                widget.contentModel.imageUrl,
                                              ))),
                                    )
                                  : Container(
                                      padding: EdgeInsets.all(16),
                                      child: Icon(
                                        Icons.image_outlined,
                                        size: 40,
                                        color: Colors.white,
                                      ),
                                      decoration: BoxDecoration(
                                        color: lightRedColor,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    )
                              : Container(
                                  child: Image.file(
                                    _image,
                                    width: 80,
                                    height: 80,
                                  ),
                                ),
                          SizedBox(
                            width: 16,
                          ),
                          Column(
                            children: [
                              Container(
                                  width: 150,
                                  child: _image == null
                                      ? widget.contentModel.imageUrl != null && widget.contentModel.imageUrl != ""
                                          ? Text(widget.contentModel.imageUrl,
                                              overflow: TextOverflow.ellipsis)
                                          : Text("No image selected")
                                      : Text(
                                          _image.path.toString(),
                                          overflow: TextOverflow.ellipsis,
                                        )),
                              SizedBox(
                                height: 8,
                              ),
                              Container(
                                width: 150,
                                child: FlatButton(
                                  padding: EdgeInsets.all(16),
                                  onPressed: () async {
                                    await getImage();
                                  },
                                  color: primaryColor,
                                  child: Text(
                                    "Pick Image",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4)),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 16),
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(16),
                            child: Icon(
                              Icons.description_outlined,
                              size: 40,
                              color: Colors.white,
                            ),
                            decoration: BoxDecoration(
                              color: lightRedColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          SizedBox(
                            width: 16,
                          ),
                          Column(
                            children: [
                              Container(
                                  width: 150,
                                  child: _doc == null
                                      ? Text(
                                          widget.contentModel.docUrl,
                                    overflow: TextOverflow.ellipsis,
                                        )
                                      : Text(
                                          _doc.path.toString(),
                                          overflow: TextOverflow.ellipsis,
                                        )),
                              SizedBox(
                                height: 8,
                              ),
                              Container(
                                width: 150,
                                child: FlatButton(
                                  padding: EdgeInsets.all(16),
                                  onPressed: () async {
                                    await getDocument();
                                  },
                                  color: primaryColor,
                                  child: Text(
                                    "Pick Document",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4)),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    )
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
          onPressed: () async {
            await _saveEditedContent();
          },
          color: primaryColor,
          child: Text(
            "Update",
            style: TextStyle(color: Colors.white),
          ),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
              side: BorderSide(color: primaryColor)),
        ),
      ),
    );
  }

  Future<void> _saveEditedContent() async {
    firebase_storage.FirebaseStorage storage =
        firebase_storage.FirebaseStorage.instance;
    var imageUrl;
    var docUrl;

    if(_image != null){
      var snapShot = await storage
          .ref()
          .child('images')
          .child(App().sharedPreferences.getString('uid'))
          .child(widget.contentModel.idCont)
          .putFile(_image);

      imageUrl = await snapShot.ref.getDownloadURL();
    }

    if(_doc != null){
      var snapShotDoc = await storage
          .ref()
          .child('docs')
          .child(App().sharedPreferences.getString('uid'))
          .child(widget.contentModel.idCont)
          .putFile(_doc);

      docUrl = await snapShotDoc.ref.getDownloadURL();
    }

    CollectionReference contents =
        FirebaseFirestore.instance.collection('content');
    contents.doc(widget.contentModel.idCont).update({
      "id_cont": widget.contentModel.idCont,
      'title': _titleController.text,
      'desc': _descController.text,
      'category': _catController.text,
      'author_name': App().sharedPreferences.getString("displayName"),
      'photo_url': App().sharedPreferences.getString("photoUrl"),
      'update_date': dateTimeNow,
      'imageUrl': imageUrl != null ? imageUrl.toString() : widget.contentModel.imageUrl,
      'docUrl': docUrl != null ? docUrl.toString() : widget.contentModel.docUrl,
    }).then(
        (value) => Fluttertoast.showToast(msg: "Berhasil perbaharui content"));
    Navigator.popAndPushNamed(context, homePage);
  }

  Future getImage() async {
    // await Permission.photos.request();
    await Permission.camera.request();

    // var permissionPhotosStatus = await Permission.photos.status;
    var permissionCameraStatus = await Permission.camera.status;

    if (permissionCameraStatus.isGranted) {
      final pickedFile = await picker.getImage(source: ImageSource.camera);
      setState(() {
        if (pickedFile != null) {
          _image = File(pickedFile.path);
        } else {
          print('No image selected.');
        }
      });
    } else {
      Fluttertoast.showToast(msg: "Tidak di izinkan, silahkan coba lagi");
    }
  }

  Future getDocument() async {
    // await Permission.photos.request();
    await Permission.storage.request();

    var permissionStorageStatus = await Permission.storage.status;

    if (permissionStorageStatus.isGranted) {
      FlutterDocumentPickerParams params = FlutterDocumentPickerParams(
        allowedFileExtensions: ['pdf'],
      );
      final path = await FlutterDocumentPicker.openDocument(params: params);
      setState(() {
        _doc = File(path);
      });
    } else {
      Fluttertoast.showToast(msg: "Tidak di izinkan, silahkan coba lagi");
    }
  }
}
