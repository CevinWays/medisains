import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class FragmentHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    List listMyCategory = [
      "assets/images/img_jantung.png",
      "assets/images/img_mata.png",
      "assets/images/img_tht.png",
    ];

    List listMyContent = [
      "assets/images/img_ads_1.png",
      "assets/images/img_ads_2.png",
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _widgetAppBarSection(),
      body: Container(
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        padding: EdgeInsets.all(16),
        child: _widgetBodySection(context,listMyCategory,listMyContent),
      ),
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

  Widget _widgetBodySection(BuildContext context, List listMyCategory, List listMyContent){
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
          Container(
              width: MediaQuery.of(context).size.width,
              height: 100,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children : listMyCategory.map((i) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                          width: 100,
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
                          child: Image.asset(i,scale: 2),
                        );
                      },
                    );
                  }).toList(),
                ),
              )
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.symmetric(vertical: 8),
            child: Text("My Content", textAlign: TextAlign.start, style: TextStyle(fontWeight: FontWeight.bold),),
          ),
          Container(
              width: MediaQuery.of(context).size.width,
              height: 150,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children : listMyContent.map((i) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: 250,
                              height: 120,
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
                              child: Image.asset(i,scale: 1,),
                            ),
                            Container(
                              child: Text("Video : Work out can help body to loss..."),
                              padding: EdgeInsets.symmetric(horizontal: 6),
                            )
                          ],
                        );
                      },
                    );
                  }).toList(),
                ),
              )
          ),
        ],
      ),
    );
  }
}
