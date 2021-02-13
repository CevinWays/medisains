import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:medisains/app.dart';
import 'package:medisains/helpers/constant_color.dart';
import 'package:medisains/helpers/constant_routes.dart';
import 'package:medisains/helpers/datetime_helper.dart';
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
    _contentBloc.add(RecommendationInDetailEvent(contentModel: widget.contentModel));
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
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("Detail Content",style: TextStyle(color: Colors.black)),
          elevation: 0.0,
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back,color: Colors.black,),),
          actions: [
            widget.contentModel.uid == App().sharedPreferences.getString("uid")
                ? Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: InkWell(
                  onTap: ()async{
                    await _deleteDialog();
                  },
                  child: Icon(Icons.delete,color: primaryColor,size: 24,)),
            ) : Container()
          ],
        ),
        body: Container(
          padding: EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.symmetric(vertical: 8),
                  child: Text("Judul", textAlign: TextAlign.start, style: TextStyle(fontWeight: FontWeight.bold),),
                ),
                Container(
                  child: Text(
                      widget.contentModel.title
                  ),
                ),
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
                  child: Text("Date Created", textAlign: TextAlign.start, style: TextStyle(fontWeight: FontWeight.bold),),
                ),
                Container(
                  child: Text(
                      DateTimeHelper.dateTimeFormatFromString(widget.contentModel.createDate)
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
                  itemSize: 20,
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
                  updateOnDrag: false,
                  onRatingUpdate: null,
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
                widget.contentModel.imageUrl != null
                    && widget.contentModel.imageUrl != "" ? Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(bottom: 16,top: 8),
                  child: Card(
                    child: ListTile(
                      leading: Container(
                        child: Icon(Icons.description_outlined,size: 25,color: primaryColor),
                      ),
                      title: Text(widget.contentModel.docUrl.split('/').last.toString(),
                        overflow: TextOverflow.ellipsis,),
                      trailing: InkWell(
                          onTap: () async {
                            await _launchURL();
                          },
                          child: Icon(Icons.open_in_new_outlined)),
                    ),
                  ),
                ) : Container(child: Text("Tidak ada asset dokumen"),),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.symmetric(vertical: 8),
                  child: Text("Rekomendasi Lainnya", textAlign: TextAlign.start, style: TextStyle(fontWeight: FontWeight.bold),),
                ),
                Container(
                  height: 230,
                    width: MediaQuery.of(context).size.width,
                    child: _widgetDetailCategory()),
              ],
            ),
          )
        ),
        floatingActionButton: widget.contentModel.uid == App().sharedPreferences.getString("uid")
            ? FloatingActionButton(
          backgroundColor: primaryColor,
          child: Icon(Icons.edit),
          onPressed: (){
            Navigator.pushNamed(context, editContentPage,arguments: widget.contentModel);
          },
        ) : Container(),
      ),
    );
  }

  Widget _widgetDetailCategory(){
    return BlocBuilder(
      cubit: _contentBloc,
      builder: (context,state){
        return state is RecommendationInDetailState && state.listRecommContentDetail.length > 0 ? ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: state is RecommendationInDetailState && state.listRecommContentDetail.length > 0 ? state.listRecommContentDetail.length : null,
          itemBuilder: (context,int index){
            ContentModel contentModel = state is RecommendationInDetailState && state.listRecommContentDetail.length > 0 ? state.listRecommContentDetail[index] : null;
            return InkWell(
              onTap: () {
                Navigator.pushNamed(context, contentPage, arguments: contentModel);
              },
              child: Container(
                padding: EdgeInsets.all(16),
                margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black38,
                          blurRadius: 2,
                          spreadRadius: 0.2,
                          offset:Offset(0,2)
                      )
                    ]
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: [
                        Text(contentModel.title,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: textDark)),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 6,left: 8),
                              child: Text(double.parse(contentModel.rating.toString()).toString(),style: TextStyle(fontSize: 14,color: textDark,fontWeight: FontWeight.w300)),
                            ),
                            RatingBar.builder(
                              itemSize: 18,
                              initialRating: double.parse(contentModel.rating.toString()),
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 1,
                              itemPadding: EdgeInsets.only(right: 4),
                              itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: primaryColor,
                              ),
                              updateOnDrag: false,
                              onRatingUpdate: null,
                            ),
                          ],
                        ),
                      ],
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    ),
                    SizedBox(height: 5),
                    Text(contentModel.category,style: TextStyle(fontSize: 12,color: disableTextGreyColor)),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(Icons.person_outline,color: Colors.grey,size: 20),
                        Padding(
                          padding: const EdgeInsets.only(left: 16),
                          child: Text(contentModel.authorName,style: TextStyle(color: textDark),),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.school_outlined,color: Colors.grey,size: 20),
                        Padding(
                          padding: const EdgeInsets.only(left: 16),
                          child: Text(contentModel.instance),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.date_range_outlined,color: Colors.grey,size: 20),
                        Padding(
                            padding: const EdgeInsets.only(left: 16),
                            child: Text(DateTimeHelper.dateTimeFormatFromString(contentModel.createDate),
                            )),
                      ],
                    ),
                    SizedBox(height: 4),
                    Divider(),
                    Text("Description",style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: Colors.black)),
                    SizedBox(height: 5),
                    Container(
                        width: 150,
                        child: Text(contentModel.desc,style: TextStyle(fontSize: 12),overflow: TextOverflow.ellipsis,)),
                  ],
                ),
              ),
            );
          },
        ) : Center(child: Container(),);
      },
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
