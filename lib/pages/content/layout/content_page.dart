import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:medisains/app.dart';
import 'package:medisains/helpers/constant_color.dart';
import 'package:medisains/helpers/constant_routes.dart';
import 'package:medisains/pages/content/bloc/bloc.dart';
import 'package:medisains/pages/content/model/content_model.dart';
import 'package:url_launcher/url_launcher.dart';

class ContentPage extends StatefulWidget {
  final ContentModel contentModel;

  const ContentPage({Key key, this.contentModel}) : super(key: key);
  @override
  _ContentPageState createState() => _ContentPageState();
}

class _ContentPageState extends State<ContentPage> {
  ContentBloc _contentBloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _contentBloc = ContentBloc(InitialContentState());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      cubit: _contentBloc,
      listener: (context,state){
        if(state is DeleteContentState){
          Fluttertoast.showToast(msg: "Berhasil hapus content");
          Navigator.popAndPushNamed(context, homePage);
        }
        else if(state is ContentErrorState){
          Fluttertoast.showToast(msg: state.message);
        }
      },
      child: Scaffold(
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
                child: Text("Author", textAlign: TextAlign.start, style: TextStyle(fontWeight: FontWeight.bold),),
              ),
              Container(
                child: Text(
                    widget.contentModel.authorName
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.symmetric(vertical: 8),
                child: Text("Create Date", textAlign: TextAlign.start, style: TextStyle(fontWeight: FontWeight.bold),),
              ),
              Container(
                child: Text(
                    widget.contentModel.createDate
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.symmetric(vertical: 8),
                child: Text("Category", textAlign: TextAlign.start, style: TextStyle(fontWeight: FontWeight.bold),),
              ),
              Container(
                child: Text(
                    widget.contentModel.category
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.symmetric(vertical: 8),
                child: Text("Rating", textAlign: TextAlign.start, style: TextStyle(fontWeight: FontWeight.bold),),
              ),
              RatingBar.builder(
                itemSize: 32,
                initialRating: double.parse(widget.contentModel.rating),
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: primaryColor,
                ),
                onRatingUpdate: (rating) {
                  print(rating);
                },
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.symmetric(vertical: 8),
                child: Text("Deskripsi", textAlign: TextAlign.start, style: TextStyle(fontWeight: FontWeight.bold),),
              ),
              Container(
                child: Text(
                    widget.contentModel.desc
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.symmetric(vertical: 8),
                child: Text("Asset Gambar", textAlign: TextAlign.start, style: TextStyle(fontWeight: FontWeight.bold),),
              ),
              widget.contentModel.imageUrl != null
                  && widget.contentModel.imageUrl != "" ? Container(
                width: 100,
                height: 100,
                margin: EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    image: DecorationImage(
                        fit: BoxFit.contain,
                        image: CachedNetworkImageProvider(
                          widget.contentModel.imageUrl,
                        )
                    )
                ),
                child: InkWell(
                  onTap: (){

                  },),
              ) : Container(child: Text("Tidak ada asset gambar"),),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.symmetric(vertical: 8),
                child: Text("Asset Dokumen", textAlign: TextAlign.start, style: TextStyle(fontWeight: FontWeight.bold),),
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
                    Container(
                      width: 150,
                      child: FlatButton(
                        padding: EdgeInsets.all(16),
                        onPressed: () async {
                          await _launchURL();
                        },
                        color: primaryColor,
                        child: Text(
                          "Open Document",
                          style: TextStyle(color: Colors.white),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4)),
                      ),
                    )
                  ],
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
                  _contentBloc.add(DeleteContentEvent(contentModel: widget.contentModel));
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

  _launchURL() async {
    String url = widget.contentModel.docUrl;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
