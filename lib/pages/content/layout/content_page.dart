import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:medisains/app.dart';
import 'package:medisains/helpers/constant_color.dart';
import 'package:medisains/helpers/constant_routes.dart';
import 'package:medisains/pages/content/model/content_model.dart';

class ContentPage extends StatefulWidget {
  final ContentModel contentModel;

  const ContentPage({Key key, this.contentModel}) : super(key: key);
  @override
  _ContentPageState createState() => _ContentPageState();
}

class _ContentPageState extends State<ContentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.contentModel.title,style: TextStyle(color: Colors.white)),
        backgroundColor: primaryColor,
        centerTitle: true,
        actions: [
          widget.contentModel.uid == App().sharedPreferences.getString("uid")
              ? Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: InkWell(
                onTap: ()async{
                  await _deleteDialog();
                },
                child: Icon(Icons.delete,color: Colors.white,size: 24,)),
          ) : Container()
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.symmetric(vertical: 8),
              child: Text("Deskripsi", textAlign: TextAlign.start, style: TextStyle(fontWeight: FontWeight.bold),),
            ),
            Container(
              child: Text(
                  widget.contentModel.desc
              ),
            )
          ],
        )
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        child: Icon(Icons.edit),
        onPressed: (){
          Navigator.pushNamed(context, editContentPage,arguments: widget.contentModel);
        },
      ),
    );
  }

  Future<void> _deleteDialog() {
    return showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text("Hapus Content"),
            content: Text('Yakin ingin menghapus content ini?'),
            actions: [
              FlatButton(
                padding: EdgeInsets.all(7),
                onPressed: () {
                  CollectionReference contents = FirebaseFirestore.instance.collection('content');
                  contents.doc(widget.contentModel.idCont).delete().then((value) => Fluttertoast.showToast(msg: "Berhasil hapus content"));
                  Navigator.popAndPushNamed(context, homePage);
                },
                child: Text('Ya',
                    style: TextStyle(
                      fontSize: 18.0, color: Colors.grey,)),
              ),
              FlatButton(
                padding: EdgeInsets.all(7),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Tidak',
                    style: TextStyle(
                      fontSize: 18.0, color: primaryColor,)),
              ),
            ],
          );
        }
    );
  }
}
