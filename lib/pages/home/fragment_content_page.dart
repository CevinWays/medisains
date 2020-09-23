
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:medisains/helpers/constant_color.dart';
import 'package:medisains/helpers/constant_routes.dart';
import 'package:medisains/pages/category/bloc/bloc.dart';
import 'package:medisains/pages/content/bloc/bloc.dart';

class FragmentContentPage extends StatefulWidget {
  @override
  _FragmentContentPageState createState() => _FragmentContentPageState();
}

class _FragmentContentPageState extends State<FragmentContentPage> {
  CategoryBloc _categoryBloc;
  ContentBloc _contentBloc;

  List listCategoryData = [
    "Penyakit Dalam",
    "THT",
    "Tulang",
    "Jantung",
    "Kulit dan Kelamin",
    "Kesehatan Mata",
  ];

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
  void initState() {
    // TODO: implement initState
    _categoryBloc = CategoryBloc(InitialCategoryState());
    _contentBloc = ContentBloc(InitialContentState());
    _categoryBloc.add(ReadCategoryEvent());
    _contentBloc.add(ReadContentEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: _widgetAppBarSection(),
          body: _widgetBodySection(listCategoryData, listContentData, context),
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
      ),
    );
  }

  Widget _widgetAppBarSection(){
    return AppBar(
      elevation: 0.0,
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      title: Text(
        "Content",
        style: TextStyle(color: Colors.black ,fontSize: 18.0, fontWeight: FontWeight.bold),
      ),
      actions: <Widget>[
        Container(
          margin: EdgeInsets.only(right: 16),
          alignment: Alignment.centerRight,
          child: Icon(Icons.search, color: Colors.black,),
        ),
      ],
      bottom: TabBar(
        indicatorPadding: EdgeInsets.symmetric(horizontal: 16),
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: primaryColor,
        unselectedLabelColor: Colors.black,
        indicatorColor: primaryColor,
        tabs: <Widget>[
          new Tab(text: "Content"),
          new Tab(text: "Category"),
        ],
      ),
    );
  }

  Widget _widgetBodySection(List listCategoryData,List listContentData,BuildContext context){
    return Container(
      padding: EdgeInsets.all(16),
      child: TabBarView(
        children: <Widget>[
          _widgetMedicines(listContentData, context),
          _widgetCategory(listCategoryData)
        ],
      ),
    );
  }

  Widget _widgetMedicines(List listContentData, BuildContext context){
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

  Widget _widgetCategory(List listCategoryData){
    return SingleChildScrollView(
      child: Column(
        children: listCategoryData.map((i){
          return Builder(
            builder: (BuildContext context) {
              return InkWell(
                onTap: () => Navigator.pushNamed(context, categoryPage),
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(8),
                        margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                        width: MediaQuery.of(context).size.width,
                        child: Text(i, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
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
                      ),
                      Divider()
                    ],
                  ),
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}
