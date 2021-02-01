import 'package:flutter/material.dart';
import 'package:medisains/app.dart';
import 'package:medisains/helpers/constant_color.dart';
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
    );
  }
}
