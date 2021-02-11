import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:medisains/helpers/constant_color.dart';
import 'package:medisains/helpers/constant_routes.dart';
import 'package:medisains/helpers/datetime_helper.dart';
import 'package:medisains/pages/content/bloc/bloc.dart';
import 'package:medisains/pages/content/model/content_model.dart';

class SearchContentPage extends StatefulWidget {
  @override
  _SearchContentPageState createState() => _SearchContentPageState();
}

class _SearchContentPageState extends State<SearchContentPage> {
  ContentBloc _contentBloc;
  TextEditingController _searcText = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _contentBloc = ContentBloc(InitialContentState());
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _searcText = TextEditingController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        title: Text("Search",style: TextStyle(color: Colors.black),),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
      ),
      body: Container(
          padding: EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 8,bottom: 16,right: 4,left: 4),
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.sentences,
                    autofocus: true,
                    controller: _searcText,
                    onEditingComplete: (){
                      _contentBloc.add(SearchContentEvent(searchText: _searcText.text));
                    },
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.only(left: 14.0),
                      hintText: "Search contents",
                      hintStyle: TextStyle(color: disableTextGreyColor,),
                      prefixIcon: Icon(Icons.search,color: primaryColor,),
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
                            offset:Offset(0,2)
                        )
                      ]
                  ),
                ),
                _widgetDetailCategory(),
              ],
            ),
          )),
    );
  }

  Widget _widgetDetailCategory(){
    return BlocBuilder(
        cubit: _contentBloc,
        builder: (context,state){
          return state is SearchContentState && state.listContentSearchResult.length > 0 ? ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: state is SearchContentState && state.listContentSearchResult.length > 0 ? state.listContentSearchResult.length : null,
            itemBuilder: (context,int index){
              ContentModel contentModel = state is SearchContentState && state.listContentSearchResult.length > 0 ? state.listContentSearchResult[index] : null;
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
                                padding: const EdgeInsets.only(right: 6),
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
                      Text(contentModel.desc,style: TextStyle(fontSize: 12),overflow: TextOverflow.ellipsis,),
                    ],
                  ),
                ),
              );
            },
          ) : Container(child: Center(child: Text('Belum ada hasil pencarian'),));
        }
    );
  }
}
