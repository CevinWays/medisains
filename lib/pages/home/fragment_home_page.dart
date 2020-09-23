import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_svg/svg.dart';
import 'package:medisains/app.dart';
import 'package:medisains/helpers/constant_color.dart';
import 'package:medisains/helpers/constant_routes.dart';

class FragmentHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _widgetAppBarSection(),
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
                backgroundColor: yellowColor,
                onTap: () => Navigator.pushNamed(context, contentFormPage)
            ),
            SpeedDialChild(
                child: Icon(Icons.class_),
                backgroundColor: redColor,
                label: "Category",
                onTap: () => Navigator.pushNamed(context, categoryFormPage)
            ),
          ],
        )
    );
  }

  Widget _widgetAppBarSection(){
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
        Container(
          margin: EdgeInsets.only(right: 16),
          alignment: Alignment.centerRight,
          child: Icon(Icons.search, color: Colors.black,),
        ),
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
            margin: EdgeInsets.symmetric(vertical: 8),
            child: Text("My Category", textAlign: TextAlign.start, style: TextStyle(fontWeight: FontWeight.bold),),
          ),
          _widgetCategory(),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.symmetric(vertical: 8),
            child: Text("My Content", textAlign: TextAlign.start, style: TextStyle(fontWeight: FontWeight.bold),),
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
                  onTap: () => Navigator.pushNamed(context, contentPage),
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: 70,
                          height: 70,
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
                          child: Icon(Icons.image,color: primaryColor,),
                        ),
                        Container(
                          height: 70,
                          margin: EdgeInsets.only(left: 4),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(item.data()['title'],style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold)),
                              SizedBox(height: 5),
                              Text(item.data()['desc'],style: TextStyle(fontSize: 12),),
                              SizedBox(height: 5),
                              Row(
                                children: <Widget>[
                                  Icon(Icons.description, color: primaryColor, size: 20,),
                                  Text("4 Artikel"),
                                  SizedBox(width: 5),
                                  Icon(Icons.play_circle_outline, color: primaryColor, size: 20),
                                  Text("3 Video"),
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ) : Container();
              }
              ).toList()
          );
        }

      },
    );
  }

  Widget _widgetCategory(){
    CollectionReference fireStoreCategory = FirebaseFirestore.instance.collection("category");
    return StreamBuilder<QuerySnapshot>(
        stream: fireStoreCategory.snapshots(includeMetadataChanges: true),
        builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot){

          if (snapshot.hasError) {
            return Center(child: Text("Terjadi Kesalahan"));
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }else{
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: snapshot.data.docs.map((DocumentSnapshot item) {
                    return item.data()["uid"] == App().sharedPreferences.getString("uid") ? InkWell(
                      onTap: () => Navigator.pushNamed(context, categoryPage),
                      child: Column(
                        children: <Widget>[
                          Container(
                            width: 150,
                            height: 70,
                            margin: EdgeInsets.symmetric(vertical: 5.0,horizontal: 5.0),
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
                            child: Icon(Icons.image,color: primaryColor,),
                          ),
                          Container(
                            padding: EdgeInsets.all(8),
                            margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                            child: Text(item.data()["title"], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          ),
                          Divider()
                        ],
                      ),
                    ) : Container();
                  }).toList(),
                ),
              ),
            );
          }

        }
    );
  }
}
