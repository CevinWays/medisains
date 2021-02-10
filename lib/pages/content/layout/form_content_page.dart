import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  TextEditingController _catController = TextEditingController();
  ContentBloc _contentBloc;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  File _image;
  final picker = ImagePicker();

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
          Fluttertoast.showToast(msg: state.message);
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
                        child: TextFormField(
                          controller: _catController,
                          keyboardType: TextInputType.text,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(
                            labelText: "Kategori",
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
                          maxLines: 3,
                          validator: (String value)=>ValidatorHelper.validatorEmpty(label: "Studi kasus",value: value),
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
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
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

    File file = File(_image.path);

    if(_formKey.currentState.validate())
      _contentBloc.add(CreateContentEvent(
          category: _catController.text,
          title: _titleController.text,
          desc: _descController.text,
          file: file));
  }

  Future getImage() async {
    // await Permission.photos.request();
    await Permission.camera.request();

    // var permissionPhotosStatus = await Permission.photos.status;
    var permissionCameraStatus = await Permission.camera.status;

    if(permissionCameraStatus.isGranted){
      final pickedFile = await picker.getImage(source: ImageSource.camera);
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

}
