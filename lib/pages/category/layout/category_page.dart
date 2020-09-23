import 'package:flutter/material.dart';
import 'package:medisains/helpers/constant_color.dart';
import 'package:medisains/helpers/constant_routes.dart';

class CategoryPage extends StatefulWidget {
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {

  List<Map> listContentData = [
    {
      "title" : "Osteoporosis",
      "subtitle" : "Kondisi saat kualitas kepadatan tulang..",
    },
    {
      "title" : "Cancer",
      "subtitle" : "Kondisi saat kualitas kepadatan tulang..",
    },
    {
      "title" : "Hipotermia",
      "subtitle" : "Kondisi saat kualitas kepadatan tulang..",
    },
    {
      "title" : "Diabetes",
      "subtitle" : "Kondisi saat kualitas kepadatan tulang..",
    },
    {
      "title" : "Katarak",
      "subtitle" : "Kondisi saat kualitas kepadatan tulang..",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        title: Text("Cancer",style: TextStyle(color: Colors.black),),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        actions: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 16),
            alignment: Alignment.centerRight,
            child: Icon(Icons.search, color: Colors.black,),
          ),
        ],
      ),
      body: Container(
          padding: EdgeInsets.all(16),
          child: _widgetDetailCategory(listContentData)),
    );
  }

  Widget _widgetDetailCategory(List listContentData){
    return SingleChildScrollView(
      child: Column(
          children: listContentData.map((i){
            return InkWell(
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
                          Text(i["title"],style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold)),
                          SizedBox(height: 5),
                          Text(i["subtitle"],style: TextStyle(fontSize: 12),),
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
            );
          }
          ).toList()),
    );
  }
}
