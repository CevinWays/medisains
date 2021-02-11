import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_document_picker/flutter_document_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medisains/app.dart';
import 'package:medisains/helpers/constant_color.dart';
import 'package:medisains/helpers/constant_routes.dart';
import 'package:medisains/helpers/datetime_helper.dart';
import 'package:medisains/helpers/validator_helper.dart';
import 'package:medisains/pages/content/bloc/bloc.dart';
import 'package:medisains/pages/content/model/content_model.dart';
import 'package:permission_handler/permission_handler.dart';

class EditContentPage extends StatefulWidget {
  final ContentModel contentModel;

  const EditContentPage({Key key, this.contentModel}) : super(key: key);

  @override
  _EditContentPageState createState() => _EditContentPageState();
}

class _EditContentPageState extends State<EditContentPage> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String dateTimeNow = DateTimeHelper.currentDate();
  File _image;
  File _doc;
  final picker = ImagePicker();
  ContentBloc _contentBloc;
  String dropdownValue;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _contentBloc = ContentBloc(InitialContentState());
    _titleController.text = widget.contentModel.title;
    _descController.text = widget.contentModel.desc;
    dropdownValue = widget.contentModel.category;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      cubit: _contentBloc,
      listener: (context,state){
        if(state is UpdateContentState){
          Fluttertoast.showToast(msg: "Berhasil perbaharui content");
          Navigator.popAndPushNamed(context, homePage);
        }
        else if(state is ContentErrorState){
          Fluttertoast.showToast(msg: state.message);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("Edit Content",style: TextStyle(color: Colors.black),),
          elevation: 0.0,
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back,color: Colors.black,),),
        ),
        body: BlocBuilder(
          cubit: _contentBloc,
          builder: (context,state){
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
                              padding: EdgeInsets.only(right:8,left: 8 ),
                              child: TextFormField(
                                controller: _titleController,
                                keyboardType: TextInputType.text,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                validator: (String value)=>ValidatorHelper.validatorEmpty(label: "Judul",value: value),
                                decoration: InputDecoration(
                                  hintText: "Judul",
                                  enabledBorder: InputBorder.none,
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  labelStyle: TextStyle(color: Colors.black, fontSize: 16.0),
                                ),
                              ),
                            ),
                          ),
                          Card(
                            elevation: 2.0,
                            child: Container(
                              padding: EdgeInsets.only(left: 8,right: 8),
                              width: MediaQuery.of(context).size.width,
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  hint: Text("Pilih Kategori"),
                                  value: dropdownValue,
                                  icon: Icon(Icons.arrow_drop_down),
                                  iconSize: 24,
                                  elevation: 16,
                                  style: TextStyle(color: Colors.black),
                                  onChanged: (String newValue) {
                                    setState(() {
                                      dropdownValue = newValue;
                                    });
                                  },
                                  items: <String>['Lainnya', 'Penyakit', 'Obat', 'Kesehatan']
                                      .map<DropdownMenuItem<String>>((String value) {
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
                              padding: EdgeInsets.all(8),
                              child: TextFormField(
                                controller: _descController,
                                keyboardType: TextInputType.text,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                maxLines: 3,
                                validator: (String value)=>ValidatorHelper.validatorEmpty(label: "Deskripsi",value: value),
                                decoration: InputDecoration(
                                  enabledBorder: InputBorder.none,
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  hintText: "Deskripsi Singkat",
                                  labelStyle: TextStyle(color: Colors.black, fontSize: 16.0),

                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.only(top: 16),
                            child: Card(
                              child: ListTile(
                                leading: Container(
                                    child: _image == null
                                        ? widget.contentModel.imageUrl != null && widget.contentModel.imageUrl != ""
                                        ? Container(
                                      width: 25,
                                      height: 25,
                                      margin: EdgeInsets.symmetric(vertical: 8),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(8.0),
                                          image: DecorationImage(
                                              fit: BoxFit.contain,
                                              image: CachedNetworkImageProvider(
                                                widget.contentModel.imageUrl,
                                              ))),
                                    ) : Icon(Icons.image_outlined,size: 25,color: primaryColor)
                                        : Container(child: Image.file(_image,width: 25,height: 25,),)
                                ),
                                title: Text(_image == null
                                    ? widget.contentModel.imageUrl != null && widget.contentModel.imageUrl != ""
                                    ? widget.contentModel.imageUrl.split('/').last.toString()
                                    : 'Pilih Gambar'
                                    : _image.path.split('/').last.toString(),
                                  overflow: TextOverflow.ellipsis,),
                                trailing: InkWell(
                                    onTap: () async {
                                      await getImage();
                                    },
                                    child:  _image == null ? Icon(Icons.attach_file_outlined) : Icon(Icons.check_circle, color: blueColor,)),
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.only(bottom: 16,top: 8),
                            child: Card(
                              child: ListTile(
                                leading: Container(
                                  child: Icon(Icons.description_outlined,size: 25,color: primaryColor),
                                ),
                                title: Text(_doc == null
                                    ? widget.contentModel.docUrl != null && widget.contentModel.docUrl != ""
                                    ? widget.contentModel.docUrl.split('/').last.toString()
                                    : 'Pilih Dokumen'
                                    : _doc.path.split('/').last.toString(),
                                  overflow: TextOverflow.ellipsis,),
                                trailing: InkWell(
                                    onTap: () async {
                                      await getDocument();
                                    },
                                    child: _doc == null ? Icon(Icons.attach_file_outlined) : Icon(Icons.check_circle, color: blueColor,)),
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
          cubit: _contentBloc,
          builder: (context,state){
            return Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.all(16),
              child: FlatButton(
                padding: EdgeInsets.all(16),
                onPressed: state is LoadingState ? null : () {
                  _saveEditedContent();
                },
                color: state is LoadingState ? disableTextGreyColor : primaryColor,
                child: Text(
                  "Update",
                  style: TextStyle(color: state is LoadingState ? darkGreyColor : Colors.white),
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                    side: BorderSide(color: state is LoadingState ? disableTextGreyColor : primaryColor)),
              ),
            );
          },
        ),
      ),
    );
  }

  _saveEditedContent() {
    _contentBloc.add(UpdateContentEvent(
      title: _titleController.text,
      desc: _descController.text,
      category: dropdownValue,
      contentModel: widget.contentModel,
      fileImage: _image,
      fileDoc: _doc,
    ));
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
