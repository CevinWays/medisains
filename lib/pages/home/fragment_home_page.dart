import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:medisains/app.dart';
import 'package:medisains/helpers/constant_color.dart';
import 'package:medisains/helpers/constant_routes.dart';
import 'package:medisains/helpers/datetime_helper.dart';
import 'package:medisains/pages/content/bloc/bloc.dart';
import 'package:medisains/pages/content/layout/search_content_page.dart';
import 'package:medisains/pages/content/model/content_model.dart';
import 'package:medisains/pages/profile/profile_page.dart';

class FragmentHomePage extends StatelessWidget {
  ContentBloc _contentBloc;

  @override
  Widget build(BuildContext context) {
    _contentBloc = ContentBloc(InitialContentState());
    _contentBloc.add(ReadContentEvent());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _widgetAppBarSection(context),
      body: Container(
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        padding: EdgeInsets.all(16),
        child: _widgetBodySection(context),
      ),
    );
  }

  Widget _widgetAppBarSection(BuildContext context) {
    return AppBar(
      elevation: 0.0,
      backgroundColor: Colors.white,
      leading: Container(
          margin: EdgeInsets.only(left: 16),
          child: SvgPicture.asset("assets/images/ic_medisains_basic.svg")),
      title: Text(
        "Medisains",
        style: TextStyle(
            color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.bold),
      ),
      actions: <Widget>[
        App().sharedPreferences.getString("photoUrl") != null
            ? Container(
                width: 32,
                height: 32,
                margin: EdgeInsets.only(right: 16),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        fit: BoxFit.contain,
                        image: CachedNetworkImageProvider(
                          App().sharedPreferences.getString("photoUrl"),
                        ))),
                child: InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ProfilePage()));
                  },
                ),
              )
            : Icon(Icons.account_circle, color: Colors.grey, size: 32),
      ],
    );
  }

  Widget _widgetBodySection(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 8, bottom: 16, right: 4, left: 4),
            child: TextFormField(
              readOnly: true,
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SearchContentPage())),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(left: 14.0),
                hintText: "Search contents",
                hintStyle: TextStyle(
                  color: disableTextGreyColor,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: primaryColor,
                ),
                fillColor: Colors.white,
                hoverColor: Colors.white,
                filled: true,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(
                    color: Colors.white,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
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
          ),
          Flexible(
            child: Container(
                width: MediaQuery.of(context).size.width,
                child: CarouselSlider(
                  options: CarouselOptions(
                    height: 120.0,
                    autoPlay: true,
                    viewportFraction: 1.0,
                    autoPlayInterval: Duration(seconds: 5),
                  ),
                  items: [1, 2, 3, 4, 5].map((i) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
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
                          child: Image.asset(
                            "assets/images/img_medisains_ads.png",
                            scale: 2,
                          ),
                        );
                      },
                    );
                  }).toList(),
                )),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.symmetric(vertical: 16),
            child: Text(
              "My Categories",
              textAlign: TextAlign.start,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          _widgetCategory(context),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(top: 32, bottom: 16),
            child: Text(
              "Recommended",
              textAlign: TextAlign.start,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          _widgetRecommend(context),
          BlocBuilder(
              cubit: _contentBloc,
              builder: (context, state) {
                return state is ReadContentState &&
                        state.listContentModel.length > 0
                    ? Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.only(top: 32, bottom: 16),
                        child: Text(
                          "My Contents",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      )
                    : Container();
              }),
          BlocBuilder(
            cubit: _contentBloc,
            builder: (context, state) {
              return state is ReadContentState &&
                      state.listContentModel.length > 0
                  ? _widgetMedicines()
                  : Container();
            },
          ),
        ],
      ),
    );
  }

  Widget _widgetMedicines() {
    CollectionReference fireStoreContent =
        FirebaseFirestore.instance.collection("content");
    return StreamBuilder<QuerySnapshot>(
      stream: fireStoreContent.snapshots(includeMetadataChanges: true),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text("Terjadi Kesalahan"));
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (!snapshot.hasData) {
          return Center(child: Text("Data belum tersedia"));
        } else if (snapshot.data == null) {
          return Center(child: Text("Data belum tersedia"));
        } else {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: snapshot.data.docs.map((DocumentSnapshot item) {
                  return item.data()["uid"] ==
                          App().sharedPreferences.getString("uid")
                      ? InkWell(
                          onTap: () {
                            ContentModel _contentModel =
                                ContentModel.fromJson(item.data());
                            Navigator.pushNamed(context, contentPage,
                                arguments: _contentModel);
                          },
                          child: Container(
                            width: 300,
                            padding: EdgeInsets.all(16),
                            margin: EdgeInsets.symmetric(
                                horizontal: 5.0, vertical: 5.0),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black38,
                                      blurRadius: 2,
                                      spreadRadius: 0.2,
                                      offset: Offset(0, 2))
                                ]),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        item.data()['title'],
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: textDark),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 6),
                                          child: Text(
                                              double.parse(item
                                                      .data()['rating']
                                                      .toString())
                                                  .toString(),
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: textDark,
                                                  fontWeight: FontWeight.w300)),
                                        ),
                                        RatingBar.builder(
                                          itemSize: 18,
                                          initialRating: double.parse(
                                              item.data()['rating'].toString()),
                                          minRating: 1,
                                          direction: Axis.horizontal,
                                          allowHalfRating: true,
                                          itemCount: 1,
                                          itemPadding:
                                              EdgeInsets.only(right: 4),
                                          itemBuilder: (context, _) => Icon(
                                            Icons.star_rounded,
                                            color: primaryColor,
                                          ),
                                          updateOnDrag: false,
                                          onRatingUpdate: null,
                                        ),
                                      ],
                                    ),
                                  ],
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                ),
                                SizedBox(height: 5),
                                Text(item.data()['category'],
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: disableTextGreyColor)),
                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    Icon(Icons.person_outline,
                                        color: Colors.grey, size: 20),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 16),
                                      child: Text(
                                        item.data()['author_name'],
                                        style: TextStyle(color: textDark),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(Icons.school_outlined,
                                        color: Colors.grey, size: 20),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 16),
                                      child: Text(item.data()['instance']),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(Icons.date_range_outlined,
                                        color: Colors.grey, size: 20),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 16),
                                      child: Text(DateTimeHelper
                                          .dateTimeFormatFromString(
                                              item.data()['create_date'])),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 4),
                                Divider(),
                                Text("Description",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black)),
                                SizedBox(height: 5),
                                Text(
                                  item.data()['desc'],
                                  style: TextStyle(fontSize: 12),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        )
                      : Container();
                }).toList()),
          );
        }
      },
    );
  }

  Widget _widgetRecommend(BuildContext context) {
    CollectionReference fireStoreContent =
        FirebaseFirestore.instance.collection("content");
    return StreamBuilder<QuerySnapshot>(
      stream: fireStoreContent.snapshots(includeMetadataChanges: true),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text("Terjadi Kesalahan"));
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (!snapshot.hasData) {
          return Center(child: Text("Data belum tersedia"));
        } else if (snapshot.data == null) {
          return Center(child: Text("Data belum tersedia"));
        } else {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: snapshot.data.docs.map((DocumentSnapshot item) {
                  return item.data()["isRecommend"] == true
                      ? InkWell(
                          onTap: () {
                            ContentModel _contentModel =
                                ContentModel.fromJson(item.data());
                            Navigator.pushNamed(context, contentPage,
                                arguments: _contentModel);
                          },
                          child: Container(
                            width: 300,
                            padding: EdgeInsets.all(16),
                            margin: EdgeInsets.symmetric(
                                horizontal: 5.0, vertical: 5.0),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black38,
                                      blurRadius: 2,
                                      spreadRadius: 0.2,
                                      offset: Offset(0, 2))
                                ]),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  children: [
                                    Container(
                                        width: 200,
                                        child: Text(
                                          item.data()['title'],
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: textDark),
                                          overflow: TextOverflow.ellipsis,
                                        )),
                                    Row(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 6),
                                          child: Text(
                                              double.parse(item
                                                      .data()['rating']
                                                      .toString())
                                                  .toString(),
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: textDark,
                                                  fontWeight: FontWeight.w300)),
                                        ),
                                        RatingBar.builder(
                                          itemSize: 18,
                                          initialRating: double.parse(
                                              item.data()['rating'].toString()),
                                          minRating: 1,
                                          direction: Axis.horizontal,
                                          allowHalfRating: true,
                                          itemCount: 1,
                                          itemPadding:
                                              EdgeInsets.only(right: 4),
                                          itemBuilder: (context, _) => Icon(
                                            Icons.star_rounded,
                                            color: primaryColor,
                                          ),
                                          updateOnDrag: false,
                                          onRatingUpdate: null,
                                        ),
                                      ],
                                    ),
                                  ],
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                ),
                                SizedBox(height: 5),
                                Text(item.data()['category'],
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: disableTextGreyColor)),
                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    Icon(Icons.person_outline,
                                        color: Colors.grey, size: 20),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 16),
                                      child: Text(
                                        item.data()['author_name'],
                                        style: TextStyle(color: textDark),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(Icons.school_outlined,
                                        color: Colors.grey, size: 20),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 16),
                                      child: Text(item.data()['instance']),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(Icons.date_range_outlined,
                                        color: Colors.grey, size: 20),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 16),
                                      child: Text(DateTimeHelper
                                          .dateTimeFormatFromString(
                                              item.data()['create_date'])),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 4),
                                Divider(),
                                Text("Description",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black)),
                                SizedBox(height: 5),
                                Text(
                                  item.data()['desc'],
                                  style: TextStyle(fontSize: 12),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        )
                      : Container();
                }).toList()),
          );
        }
      },
    );
  }

  Widget _widgetCategory(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Row(
          children: [
            InkWell(
              onTap: () => Navigator.pushNamed(context, categoryPage,
                  arguments: ContentModel(
                      category: "Penyakit",
                      uid: App().sharedPreferences.getString("uid"))),
              child: Column(
                children: <Widget>[
                  Container(
                    width: 80,
                    height: 80,
                    margin:
                        EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
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
                    child: Icon(
                      Icons.coronavirus_rounded,
                      color: primaryColor,
                      size: 30,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                      child: Text(
                    "Penyakit",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ))
                ],
              ),
            ),
            InkWell(
              onTap: () => Navigator.pushNamed(context, categoryPage,
                  arguments: ContentModel(
                      category: "Obat",
                      uid: App().sharedPreferences.getString("uid"))),
              child: Column(
                children: <Widget>[
                  Container(
                    width: 80,
                    height: 80,
                    margin:
                        EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
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
                    child: Icon(
                      Icons.medical_services_rounded,
                      color: primaryColor,
                      size: 30,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                      child: Text(
                    "Obat",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ))
                ],
              ),
            ),
            InkWell(
              onTap: () => Navigator.pushNamed(context, categoryPage,
                  arguments: ContentModel(
                      category: "Kesehatan",
                      uid: App().sharedPreferences.getString("uid"))),
              child: Column(
                children: <Widget>[
                  Container(
                    width: 80,
                    height: 80,
                    margin:
                        EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
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
                    child: Icon(
                      Icons.favorite,
                      color: primaryColor,
                      size: 30,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                      child: Text(
                    "Kesehatan",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ))
                ],
              ),
            ),
            InkWell(
              onTap: () => Navigator.pushNamed(context, categoryPage,
                  arguments: ContentModel(
                      category: "Lainnya",
                      uid: App().sharedPreferences.getString("uid"))),
              child: Column(
                children: <Widget>[
                  Container(
                    width: 80,
                    height: 80,
                    margin:
                        EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
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
                    child: Icon(
                      Icons.accessibility_new_outlined,
                      color: primaryColor,
                      size: 30,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                      child: Text(
                    "Lainnya",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
