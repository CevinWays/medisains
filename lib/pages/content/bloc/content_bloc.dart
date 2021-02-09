import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:medisains/app.dart';
import 'package:medisains/helpers/datetime_helper.dart';
import 'package:medisains/pages/content/model/content_model.dart';
import './bloc.dart';

class ContentBloc extends Bloc<ContentEvent, ContentState> {
  final auth.FirebaseAuth firebaseAuth = auth.FirebaseAuth.instance;
  final CollectionReference fireStoreUsers = FirebaseFirestore.instance.collection("content");

  ContentBloc(ContentState initialState) : super(initialState);
  @override
  ContentState get initialState => InitialContentState();

  @override
  Stream<ContentState> mapEventToState(ContentEvent event) async* {
    if(event is ReadContentEvent)
      yield* _mapReadContent(event);
    else if(event is CreateContentEvent)
      yield* _mapCreateContent(event);
  }

  Stream<ContentState> _mapReadContent(ReadContentEvent event) async*{
    try{
      yield InitialContentState();
      List<DocumentSnapshot> listMyContent;
      List<ContentModel> listContentModel = List<ContentModel>();

      if(event.category != null){
        if(event.uid == App().sharedPreferences.getString("uid")){
          listMyContent = (await fireStoreUsers.where('uid',isEqualTo: event.uid).get()).docs;
          listMyContent.forEach((item) {
            listContentModel.add(ContentModel.fromJson(item.data()));
          });
          listContentModel = listContentModel.where((i) => i.category == event.category).toList();
        }else{
          listMyContent = (await fireStoreUsers.get()).docs;
          listMyContent.forEach((item) {
            listContentModel.add(ContentModel.fromJson(item.data()));
          });
          listContentModel = listContentModel.where((i) => i.category == event.category).toList();
        }
      }else{
        listMyContent = (await fireStoreUsers.where('uid',isEqualTo: App().sharedPreferences.getString("uid")).get()).docs;
        listMyContent.forEach((item) {
          listContentModel.add(ContentModel.fromJson(item.data()));
        });
      }
      yield ReadContentState(listContentModel: listContentModel);
    }catch(e){
      yield ContentErrorState(e.toString());
    }
  }

  Stream<ContentState> _mapCreateContent(CreateContentEvent event) async*{
    try{
      yield InitialContentState();
      auth.User currentUser = firebaseAuth.currentUser;
      DocumentReference documentReference = fireStoreUsers.doc();
      String dateTimeNow = DateTimeHelper.currentDate();
      if(documentReference.id != null){
        await documentReference.set({
          "id_cont" : documentReference.id,
          'title' : event.title,
          'desc' : event.desc,
          'uid' : currentUser.uid,
          'rating' : 1,
          'category' : event.category,
          'author_name' : App().sharedPreferences.getString("displayName"),
          'photo_url' : App().sharedPreferences.getString("photoUrl"),
          'create_date' : dateTimeNow,
          'update_date' : null,
          'instance' : 'Instansi Kesehatan',
          'isRecommend' : false,
        });
        yield CreateContentState();
      }else{
        yield ContentErrorState("Gagal membuat data");
      }
    }catch(e){
      yield ContentErrorState(e.toString());
    }
  }
}
