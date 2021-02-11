import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:medisains/app.dart';
import 'package:medisains/helpers/constant_color.dart';
import 'package:medisains/helpers/constant_routes.dart';
import 'package:medisains/helpers/datetime_helper.dart';
import 'package:medisains/pages/category/bloc/bloc.dart';
import 'package:medisains/pages/content/bloc/bloc.dart';
import 'package:medisains/pages/content/layout/search_content_page.dart';
import 'package:medisains/pages/content/model/content_model.dart';

class FragmentMyContentPage extends StatefulWidget {
  @override
  _FragmentMyContentPageState createState() => _FragmentMyContentPageState();
}

class _FragmentMyContentPageState extends State<FragmentMyContentPage> {
  CategoryBloc _categoryBloc;
  ContentBloc _contentBloc;

  @override
  void initState() {
    // TODO: implement initState
    _categoryBloc = CategoryBloc(InitialCategoryState());
    _contentBloc = ContentBloc(InitialContentState());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _widgetAppBarSection(),
      body: _widgetMedicines(),
    );
  }

  Widget _widgetAppBarSection(){
    return AppBar(
      elevation: 0.0,
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      title: Text(
        "My Content",
        style: TextStyle(color: Colors.black ,fontSize: 18.0, fontWeight: FontWeight.bold),
      ),
      actions: <Widget>[
        InkWell(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context)=> SearchContentPage())),
          child: Container(
            margin: EdgeInsets.only(right: 16),
            alignment: Alignment.centerRight,
            child: Icon(Icons.search, color: Colors.black,),
          ),
        ),
      ],
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
        }

        return ListView(
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
                            child: Text(item.data()['instance']),
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
                      Text(item.data()['desc'],style: TextStyle(fontSize: 12),overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
              ) : Container();
            }
            ).toList()
        );
      },
    );
  }
}
