import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_document_picker/flutter_document_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medisains/app.dart';
import 'package:medisains/helpers/constant_color.dart';
import 'package:medisains/helpers/toast_helper.dart';
import 'package:medisains/helpers/validator_helper.dart';
import 'package:medisains/pages/content/bloc/bloc.dart';
import 'package:permission_handler/permission_handler.dart';

class FormContentPage extends StatefulWidget {
  @override
  _FormContentPageState createState() => _FormContentPageState();
}

class _FormContentPageState extends State<FormContentPage> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descController = TextEditingController();
  ContentBloc _contentBloc;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  File _image;
  File _doc;
  final picker = ImagePicker();
  String dropdownValue = 'Lainnya';

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
        if(state is CreateContentState){
          Fluttertoast.showToast(msg: "Sukses menambahkan content");
          Navigator.pop(context);
        }
        else if(state is ContentErrorState){
          Fluttertoast.showToast(msg: state.message);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("New Content",style: TextStyle(color: Colors.black),),
          elevation: 0.0,
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
        ),
        body: BlocBuilder(
          cubit: _contentBloc,
          builder: (context,state){
            return state is LoadingState ? Center(child: CircularProgressIndicator()) : Form(
              key: _formKey,
              child: Container(
                padding: EdgeInsets.all(16),
                child: SingleChildScrollView(
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
                              margin: EdgeInsets.only(top: 16),
                              width: MediaQuery.of(context).size.width,
                              child: DropdownButton<String>(
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
                                items: <String>['Penyakit', 'Obat', 'Kesehatan', 'Lainnya']
                                    .map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ),
                            Container(
                              child: TextFormField(
                                controller: _descController,
                                keyboardType: TextInputType.text,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                maxLines: 3,
                                validator: (String value)=>ValidatorHelper.validatorEmpty(label: "Deskripsi",value: value),
                                decoration: InputDecoration(
                                  labelText: "Deskripsi",
                                  hintText: "Deskripsi Singkat",
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: primaryColor),
                                  ),
                                  labelStyle: TextStyle(color: Colors.black, fontSize: 16.0),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 16),
                              width: MediaQuery.of(context).size.width,
                              child: Row(
                                children: [
                                  _image == null ? Container(
                                    padding: EdgeInsets.all(16),
                                    child: Icon(Icons.image_outlined,size: 40,color: Colors.white,),
                                    decoration: BoxDecoration(
                                      color: lightRedColor,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ) : Container(child: Image.file(_image,width: 80,height: 80,),),
                                  SizedBox(width: 16,),
                                  Column(
                                    children: [
                                      Container(
                                          width : 150,
                                          child: _image == null ? Text(
                                            "No image selected",)
                                              : Text(_image.path.toString(),
                                            overflow: TextOverflow.ellipsis,)
                                      ),
                                      SizedBox(height: 8,),
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
                                    child: Icon(Icons.description_outlined,size: 40,color: Colors.white,),
                                    decoration: BoxDecoration(
                                      color: lightRedColor,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  SizedBox(width: 16,),
                                  Column(
                                    children: [
                                      Container(
                                          width : 150,
                                          child: _doc == null ? Text(
                                            "No document selected",)
                                              : Text(_doc.path.toString(),
                                            overflow: TextOverflow.ellipsis,)
                                      ),
                                      SizedBox(height: 8,),
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
            ) ;
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
                onPressed: () => state is LoadingState ? null : _createContent(),
                color: state is LoadingState ? disableTextGreyColor : primaryColor,
                child: Text(
                  "Submit",
                  style: TextStyle(color: state is LoadingState ? darkGreyColor : Colors.white),
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4), side: BorderSide(color: state is LoadingState ? disableTextGreyColor : primaryColor)),
              ),
            );
          },
        ),
      ),
    );
  }

  void _createContent(){
    try{
      File fileImage;
      File fileDoc;

      if(_image.path !=null && _doc.path != null){
        fileImage = File(_image.path);
        fileDoc = File(_doc.path);
      }else{
        Fluttertoast.showToast(msg: 'Asset Gambar dan Dokumen diperlukan');
      }

      if(_formKey.currentState.validate()){
        if(fileImage != null && fileDoc != null){
          _contentBloc.add(CreateContentEvent(
              category: dropdownValue,
              title: _titleController.text,
              desc: _descController.text,
              fileImage: fileImage,
              fileDoc: fileDoc
          ));
        }else{
          Fluttertoast.showToast(msg: 'Asset Gambar dan Dokumen diperlukan');
        }
      }
    }catch (e){
      Fluttertoast.showToast(msg: 'Lengkapi semua data terlebih dahulu');
    }
  }

  Future getImage() async {
    // await Permission.photos.request();
    await Permission.camera.request();

    // var permissionPhotosStatus = await Permission.photos.status;
    var permissionCameraStatus = await Permission.camera.status;

    if(permissionCameraStatus.isGranted){
      final pickedFile = await picker.getImage(source: ImageSource.camera,maxWidth: 640,maxHeight: 480,imageQuality: 50);
      setState(() {
        if (pickedFile != null) {
          _image = File(pickedFile.path);
        } else {
          print('No image selected.');
        }
      });
    }else{
      Fluttertoast.showToast(msg: "Tidak di izinkan, silahkan coba lagi");
    }
  }

  Future getDocument() async{
    FlutterDocumentPickerParams params;
    String path;
    await Permission.storage.request();

    var permissionStorageStatus = await Permission.storage.status;

    if(permissionStorageStatus.isGranted){
      try{
        params = FlutterDocumentPickerParams(
          allowedFileExtensions: ['pdf'],
        );
        path = await FlutterDocumentPicker.openDocument(params: params);
        setState(() {
          _doc = File(path);
        });
      }catch(e){
        Fluttertoast.showToast(msg: 'Hanya format pdf yang di izinkan');
      }
    }else{
      Fluttertoast.showToast(msg: "Tidak di izinkan, silahkan coba lagi");
    }
  }

}
