import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:medisains/app.dart';
import 'package:medisains/helpers/constant_color.dart';
import 'package:medisains/helpers/constant_routes.dart';
import 'package:medisains/helpers/datetime_helper.dart';
import 'package:medisains/pages/content/bloc/bloc.dart';
import 'package:medisains/pages/content/model/content_model.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class ContentPage extends StatefulWidget {
  final ContentModel contentModel;

  const ContentPage({Key key, this.contentModel}) : super(key: key);

  @override
  _ContentPageState createState() => _ContentPageState();
}

class _ContentPageState extends State<ContentPage> {
  ContentBloc _contentBloc;
  TextEditingController _commentController = TextEditingController();
  double initRating;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initRating = 1;
    _contentBloc = ContentBloc(InitialContentState());
    _contentBloc
        .add(RecommendationInDetailEvent(contentModel: widget.contentModel));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      cubit: _contentBloc,
      listener: (context, state) {
        if (state is DeleteContentState) {
          Fluttertoast.showToast(msg: "Berhasil hapus content");
          Navigator.popAndPushNamed(context, homePage);
        } else if (state is ContentErrorState) {
          Fluttertoast.showToast(msg: state.message);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
          actions: [
            widget.contentModel.uid == App().sharedPreferences.getString("uid")
                ? Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: InkWell(
                        onTap: () async {
                          await _deleteDialog();
                        },
                        child: Icon(
                          Icons.delete,
                          color: primaryColor,
                          size: 24,
                        )),
                  )
                : Container()
          ],
        ),
        body: Container(
            padding: EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(8),
                    child: Text(widget.contentModel.category,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.white)),
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Container(
                    child: Text(
                      widget.contentModel.title,
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Container(
                    child: Text(
                      "ISSN / eISSN: 0125-9695 / 2338-3453",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Card(
                    elevation: 2.0,
                    child: Container(
                      padding: EdgeInsets.all(16),
                      child: IntrinsicHeight(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Icon(
                                  Icons.person_outline,
                                  color: primaryColor,
                                ),
                                Text(widget.contentModel.authorName,
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                            VerticalDivider(
                              width: 5,
                              thickness: 1,
                            ),
                            Column(
                              children: [
                                Icon(
                                  Icons.star_rounded,
                                  color: yellowColor,
                                ),
                                Text(
                                    double.parse(widget.contentModel.rating)
                                        .toString(),
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                            VerticalDivider(
                              width: 5,
                              thickness: 1,
                            ),
                            Column(
                              children: [
                                Icon(
                                  Icons.date_range_rounded,
                                  color: blueColor,
                                ),
                                Text(
                                    DateTimeHelper.dateTimeFormatFromString(
                                        widget.contentModel.createDate),
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(top: 16, bottom: 8),
                    child: Text(
                      "Abstrak",
                      textAlign: TextAlign.start,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                      widget.contentModel.desc,
                      style: TextStyle(fontWeight: FontWeight.w400),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Container(
                          child: FlatButton(
                            padding: EdgeInsets.all(8),
                            onPressed: () => _copyReference(context),
                            color: Colors.white,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.content_copy,
                                  color: primaryColor,
                                ),
                                Text(
                                  "Buat referensi",
                                  style: TextStyle(color: primaryColor),
                                ),
                              ],
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: BorderSide(color: primaryColor)),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: Container(
                          child: FlatButton(
                            padding: EdgeInsets.all(8),
                            onPressed: () async => await _share(),
                            color: Colors.white,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.share_outlined,
                                  color: Colors.blueAccent,
                                ),
                                Text(
                                  "Share",
                                  style: TextStyle(color: Colors.blueAccent),
                                ),
                              ],
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: BorderSide(color: blueColor)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(top: 16, bottom: 8),
                    child: Text(
                      "Asset",
                      textAlign: TextAlign.start,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () async {
                          widget.contentModel.docUrl != null &&
                                  widget.contentModel.docUrl != ""
                              ? await _launchURL()
                              : Fluttertoast.showToast(
                                  msg: "Belum ada dokumen");
                        },
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(
                                  top: 16, left: 16, right: 16, bottom: 16),
                              margin: EdgeInsets.symmetric(
                                  vertical: 5.0, horizontal: 5.0),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black38,
                                        blurRadius: 2,
                                        spreadRadius: 0.2,
                                        offset: Offset(0, 2))
                                  ]),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.description_outlined,
                                    color: primaryColor,
                                    size: 30,
                                  ),
                                  Text("Preview",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w300,
                                          color: Colors.grey,
                                          fontSize: 12))
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          widget.contentModel.docUrl != null &&
                                  widget.contentModel.docUrl != ""
                              ? _openImage()
                              : Fluttertoast.showToast(
                                  msg: "Belum ada dokumen");
                        },
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(
                                  top: 16, left: 16, right: 16, bottom: 16),
                              margin: EdgeInsets.symmetric(
                                  vertical: 5.0, horizontal: 5.0),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black38,
                                        blurRadius: 2,
                                        spreadRadius: 0.2,
                                        offset: Offset(0, 2))
                                  ]),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.image_outlined,
                                    color: primaryColor,
                                    size: 30,
                                  ),
                                  Text("Preview",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w300,
                                          color: Colors.grey,
                                          fontSize: 12))
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () =>
                            Fluttertoast.showToast(msg: "Belum tersedia"),
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(
                                  top: 16, left: 16, right: 16, bottom: 16),
                              margin: EdgeInsets.symmetric(
                                  vertical: 5.0, horizontal: 5.0),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black38,
                                        blurRadius: 2,
                                        spreadRadius: 0.2,
                                        offset: Offset(0, 2))
                                  ]),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.video_collection_outlined,
                                    color: primaryColor,
                                    size: 30,
                                  ),
                                  Text("Preview",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w300,
                                          color: Colors.grey,
                                          fontSize: 12))
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(top: 16, bottom: 8),
                    child: Text(
                      "Beri Penilaian",
                      textAlign: TextAlign.start,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 8),
                    child: RatingBar.builder(
                      itemSize: 22,
                      initialRating: initRating,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemPadding: EdgeInsets.only(right: 4),
                      itemBuilder: (context, _) => Icon(
                        Icons.star_rounded,
                        color: primaryColor,
                      ),
                      onRatingUpdate: (rating) {
                        print(rating);
                      },
                    ),
                  ),
                  Container(
                    child: Card(
                      elevation: 2.0,
                      child: Container(
                        padding: EdgeInsets.all(8),
                        child: TextFormField(
                          controller: _commentController,
                          keyboardType: TextInputType.text,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          maxLines: 3,
                          decoration: InputDecoration(
                            enabledBorder: InputBorder.none,
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            hintText: "Komentar anda",
                            labelStyle:
                                TextStyle(color: Colors.black, fontSize: 16.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(horizontal: 3),
                    child: FlatButton(
                      padding: EdgeInsets.all(8),
                      onPressed: () {
                        setState(() {
                          initRating = 1;
                          _commentController.text = "";
                        });
                        Fluttertoast.showToast(
                            msg: 'Terimakasih sudah memberikan penilaian');
                      },
                      color: primaryColor,
                      child: Text(
                        "Beri Komentar",
                        style: TextStyle(color: Colors.white),
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                          side: BorderSide(color: primaryColor)),
                    ),
                  ),
                ],
              ),
            )),
        floatingActionButton:
            widget.contentModel.uid == App().sharedPreferences.getString("uid")
                ? FloatingActionButton(
                    backgroundColor: primaryColor,
                    child: Icon(Icons.edit),
                    onPressed: () {
                      Navigator.pushNamed(context, editContentPage,
                          arguments: widget.contentModel);
                    },
                  )
                : Container(),
      ),
    );
  }

  Future<void> _deleteDialog() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Hapus Content"),
            content: Text('Yakin ingin menghapus content ini?'),
            actions: [
              FlatButton(
                padding: EdgeInsets.all(7),
                onPressed: () {
                  _contentBloc.add(
                      DeleteContentEvent(contentModel: widget.contentModel));
                },
                child: Text('Ya',
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.grey,
                    )),
              ),
              FlatButton(
                padding: EdgeInsets.all(7),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Tidak',
                    style: TextStyle(
                      fontSize: 18.0,
                      color: primaryColor,
                    )),
              ),
            ],
          );
        });
  }

  _launchURL() async {
    String url = widget.contentModel.docUrl;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _openImage() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: widget.contentModel.imageUrl != null &&
                widget.contentModel.imageUrl != ""
            ? Container(
                width: 300,
                height: 300,
                margin: EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    image: DecorationImage(
                        fit: BoxFit.contain,
                        image: CachedNetworkImageProvider(
                          widget.contentModel.imageUrl,
                        ))),
                child: InkWell(
                  onTap: () {},
                ),
              )
            : Container(
                child: Text("Tidak ada asset gambar"),
              ),
        actions: <Widget>[
          FlatButton(
            color: primaryColor,
            onPressed: () => Navigator.pop(context),
            // this line dismisses the dialog
            child: Text('Tutup',
                style: TextStyle(fontSize: 18.0, color: Colors.white)),
          )
        ],
      ),
    );
  }

  _copyReference(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Container(
          child: SelectableText(
            widget.contentModel.authorName +
                "." +
                widget.contentModel.title +
                "." +
                widget.contentModel.createDate,
            cursorWidth: 2,
            showCursor: true,
            toolbarOptions: ToolbarOptions(copy: true, selectAll: true),
          ),
        ),
        actions: <Widget>[
          FlatButton(
            color: primaryColor,
            onPressed: () => Navigator.pop(context),
            // this line dismisses the dialog
            child: Text('Tutup',
                style: TextStyle(fontSize: 18.0, color: Colors.white)),
          )
        ],
      ),
    );
  }

  Future<void> _share() async {
    await Share.share(widget.contentModel.desc,
        subject: widget.contentModel.title);
  }
}
