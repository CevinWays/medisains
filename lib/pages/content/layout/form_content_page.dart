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
  String dropdownValue;

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
          title: Text("Create Content",style: TextStyle(color: Colors.black),),
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
            return state is LoadingState ? Center(child: CircularProgressIndicator()) : Form(
              key: _formKey,
              child: Container(
                padding: EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 16),
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
                                        ? Icon(Icons.image_outlined,size: 25,color: primaryColor)
                                        : Container(child: Image.file(_image,width: 25,height: 25,),)
                                  ),
                                  title: Text(_image == null ? 'Pilih Gambar' : _image.path.split('/').last.toString(),
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
                                  title: Text(_doc == null ? 'Pilih Dokumen' : _doc.path.split('/').last.toString(),
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
              ),
            ) ;
          },
        ),
        bottomSheet: BlocBuilder(
          cubit: _contentBloc,
          builder: (context,state){
            return Container(
              color: Colors.white,
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
        if(dropdownValue != null){
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
        }else{
          Fluttertoast.showToast(msg: 'Kategori tidak boleh kosong');
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
