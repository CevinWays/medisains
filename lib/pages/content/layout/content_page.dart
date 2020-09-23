import 'package:flutter/material.dart';
import 'package:medisains/helpers/constant_color.dart';

class ContentPage extends StatefulWidget {
  @override
  _ContentPageState createState() => _ContentPageState();
}

class _ContentPageState extends State<ContentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cancer",style: TextStyle(color: Colors.white)),
        backgroundColor: primaryColor,
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.symmetric(vertical: 8),
              child: Text("Deskripsi", textAlign: TextAlign.start, style: TextStyle(fontWeight: FontWeight.bold),),
            ),
            Container(
              child: Text(
                "Osteoporosis Case Study. A 76‐year old female presents to your office 8 weeks out after open "
                    "reduction and internal fixation of a left displaced intertrochanteric fracture. The patient "
                    "sustained the fracture from a standing height fall after slipping in her bathroom. Osteoporosis Case Study. "
                    "A 76‐year old female presents to your office 8 weeks out after open reduction and  internal fixation of a "
                    "left displaced intertrochanteric fracture. The patient sustained the fracture from a standing height "
                    "fall after slipping in her bathroom..."
              ),
            )
          ],
        )
      ),
    );
  }
}
