import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_svg/svg.dart';
import 'package:medisains/app.dart';
import 'package:medisains/helpers/constant_color.dart';
import 'package:medisains/helpers/constant_routes.dart';
import 'package:medisains/helpers/datetime_helper.dart';
import 'package:medisains/pages/content/model/content_model.dart';
import 'package:medisains/pages/profile/profile_page.dart';

class FragmentHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _widgetAppBarSection(context),
      body: Container(
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        padding: EdgeInsets.all(16),
        child: _widgetBodySection(context),
      ),
        floatingActionButton: SpeedDial(
          child: Icon(Icons.add),
          animationSpeed: 1,
          backgroundColor: primaryColor,
          children: [
            SpeedDialChild(
                child: Icon(Icons.description),
                label: "Content",
                backgroundColor: blueColor,
                onTap: () => Navigator.pushNamed(context, contentFormPage)
            ),
          ],
        )
    );
  }

  Widget _widgetAppBarSection(BuildContext context){
    return AppBar(
      elevation: 0.0,
      backgroundColor: Colors.white,
      leading: Container(
          margin: EdgeInsets.only(left: 16),
          child: SvgPicture.asset("assets/images/ic_medisains_basic.svg")),
      title: Text(
        "Medisains",
        style: TextStyle(color: Colors.black ,fontSize: 18.0, fontWeight: FontWeight.bold),
      ),
      actions: <Widget>[
        App().sharedPreferences.getString("photoUrl") != null ? Container(
          width: 32,
          height: 32,
          margin: EdgeInsets.only(right: 16),
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                  fit: BoxFit.contain,
                  image: CachedNetworkImageProvider(
                    App().sharedPreferences.getString("photoUrl"),
                  )
              )
          ),
          child: InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfilePage()));
              },),
        ) : Icon(Icons.account_circle, color: Colors.grey,size: 32),
      ],
    );
  }

  Widget _widgetBodySection(BuildContext context){
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Flexible(
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: CarouselSlider(
                options: CarouselOptions(
                    height: 120.0,
                    autoPlay: true,
                    viewportFraction: 1.0,
                    autoPlayInterval: Duration(seconds: 3),
                ),
                items: [1,2,3,4,5].map((i) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black38,
                                    blurRadius: 2,
                                    spreadRadius: 0.2,
                                    offset:Offset(0,2)
                                )
                              ]
                          ),
                          child: Image.asset("assets/images/img_medisains_ads.png",scale: 2,),
                      );
                    },
                  );
                }).toList(),
              )
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.symmetric(vertical: 16),
            child: Text("My Categories", textAlign: TextAlign.start, style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
          ),
          _widgetCategory(context),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(top: 32,bottom: 16),
            child: Text("My Contents", textAlign: TextAlign.start, style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
          ),
          _widgetMedicines(),
        ],
      ),
    );
  }

  Widget _widgetMedicines(){
    CollectionReference fireStoreContent = FirebaseFirestore.instance.collection("content");
    return StreamBuilder<QuerySnapshot>(
      stream: fireStoreContent.snapshots(includeMetadataChanges: true),
      builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot){

        if (snapshot.hasError) {
          return Center(child: Text("Terjadi Kesalahan"));
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if(!snapshot.hasData){
          return Center(child: Text("Data belum tersedia"));
        } else if(snapshot.data == null){
          return Center(child: Text("Data belum tersedia"));
        } else{
          return ListView(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
              children: snapshot.data.docs.map((DocumentSnapshot item) {
                return item.data()["uid"] == App().sharedPreferences.getString("uid") ? InkWell(
                  onTap: () {
                    ContentModel _contentModel = ContentModel.fromJson(item.data());
                    Navigator.pushNamed(context, contentPage, arguments: _contentModel);
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
                            Text(item.data()['title'],style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: textDark)),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 6),
                                  child: Text(double.parse(item.data()['rating'].toString()).toString(),style: TextStyle(fontSize: 14,color: textDark,fontWeight: FontWeight.w300)),
                                ),
                                RatingBar.builder(
                                  itemSize: 18,
                                  initialRating: double.parse(item.data()['rating'].toString()),
                                  minRating: 1,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: 1,
                                  itemPadding: EdgeInsets.only(right: 4),
                                  itemBuilder: (context, _) => Icon(
                                    Icons.star,
                                    color: primaryColor,
                                  ),
                                  onRatingUpdate: (rating) {
                                    print(rating);
                                  },
                                ),
                              ],
                            ),
                          ],
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        ),
                        SizedBox(height: 5),
                        Text(item.data()['category'],style: TextStyle(fontSize: 12,color: disableTextGreyColor)),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(Icons.person_outline,color: Colors.grey,size: 20),
                            Padding(
                              padding: const EdgeInsets.only(left: 16),
                              child: Text(item.data()['author_name'],style: TextStyle(color: textDark),),
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.location_on_outlined,color: Colors.grey,size: 20),
                            Padding(
                              padding: const EdgeInsets.only(left: 16),
                              child: Text('Universitas Negeri Malang'),
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.date_range_outlined,color: Colors.grey,size: 20),
                            Padding(
                              padding: const EdgeInsets.only(left: 16),
                              child: Text(DateTimeHelper.dateTimeFormatFromString(item.data()['create_date'])),
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        Divider(),
                        Text("Description",style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: Colors.black)),
                        SizedBox(height: 5),
                        Text(item.data()['desc'],style: TextStyle(fontSize: 12),),
                      ],
                    ),
                  ),
                ) : Container();
                    // : Image.asset("assets/images/img_no_cat.png");
              }
              ).toList()
          );
        }

      },
    );
  }

  Widget _widgetCategory(BuildContext context){
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Row(
          children: [
            InkWell(
              onTap: () => null,
              child: Column(
                children: <Widget>[
                  Container(
                    width: 80,
                    height: 80,
                    margin: EdgeInsets.symmetric(vertical: 5.0,horizontal: 5.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black38,
                              blurRadius: 2,
                              spreadRadius: 0.2,
                              offset:Offset(0,2)
                          )
                        ]
                    ),
                    child: Icon(Icons.coronavirus_rounded,color: primaryColor,size: 30,),
                  ),
                  SizedBox(height: 5,),
                  Container(child: Text("Penyakit",style: TextStyle(fontWeight: FontWeight.w500),))
                ],
              ),
            ),InkWell(
              onTap: () => null,
              child: Column(
                children: <Widget>[
                  Container(
                    width: 80,
                    height: 80,
                    margin: EdgeInsets.symmetric(vertical: 5.0,horizontal: 5.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black38,
                              blurRadius: 2,
                              spreadRadius: 0.2,
                              offset:Offset(0,2)
                          )
                        ]
                    ),
                    child: Icon(Icons.medical_services_rounded,color: primaryColor,size: 30,),
                  ),
                  SizedBox(height: 5,),
                  Container(child: Text("Obat",style: TextStyle(fontWeight: FontWeight.w500),))
                ],
              ),
            ),InkWell(
              onTap: () => null,
              child: Column(
                children: <Widget>[
                  Container(
                    width: 80,
                    height: 80,
                    margin: EdgeInsets.symmetric(vertical: 5.0,horizontal: 5.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black38,
                              blurRadius: 2,
                              spreadRadius: 0.2,
                              offset:Offset(0,2)
                          )
                        ]
                    ),
                    child: Icon(Icons.accessibility_new_outlined,color: primaryColor,size: 30,),
                  ),
                  SizedBox(height: 5,),
                  Container(child: Text("Hidup Sehat",style: TextStyle(fontWeight: FontWeight.w500),))
                ],
              ),
            ),InkWell(
              onTap: () => null,
              child: Column(
                children: <Widget>[
                  Container(
                    width: 80,
                    height: 80,
                    margin: EdgeInsets.symmetric(vertical: 5.0,horizontal: 5.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black38,
                              blurRadius: 2,
                              spreadRadius: 0.2,
                              offset:Offset(0,2)
                          )
                        ]
                    ),
                    child: Icon(Icons.favorite,color: primaryColor,size: 30,),
                  ),
                  SizedBox(height: 5,),
                  Container(child: Text("Kesehatan",style: TextStyle(fontWeight: FontWeight.w500),))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
