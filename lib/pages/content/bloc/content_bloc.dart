import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:medisains/app.dart';
import 'package:medisains/helpers/crashlytics_helper.dart';
import 'package:medisains/helpers/datetime_helper.dart';
import 'package:medisains/pages/content/model/content_model.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import './bloc.dart';

class ContentBloc extends Bloc<ContentEvent, ContentState> {
  final auth.FirebaseAuth firebaseAuth = auth.FirebaseAuth.instance;
  final CollectionReference fireStoreUsers = FirebaseFirestore.instance.collection("content");
  String dateTimeNow = DateTimeHelper.currentDate();

  ContentBloc(ContentState initialState) : super(initialState);
  @override
  ContentState get initialState => InitialContentState();

  @override
  Stream<ContentState> mapEventToState(ContentEvent event) async* {
    if(event is ReadContentEvent){
      yield* _mapReadContent(event);
    }
    else if(event is CreateContentEvent){
      yield* _mapCreateContent(event);
    }
    else if(event is SearchContentEvent){
      yield* _mapSearchContent(event);
    }
    else if(event is UpdateContentEvent){
      yield* _mapUpdateContent(event);
    }
    else if(event is DeleteContentEvent){
      yield* _mapDeleteContent(event);
    }
    else if(event is RecommendationInDetailEvent){
      yield* _mapRecommendInDetail(event);
    }
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
    }catch(e,stackTrace){
      yield ContentErrorState(e.toString());
      await CrashlyticsHelper.crash(e, stackTrace, "read content");
      await CrashlyticsHelper.setUserIdentifier(event.uid);
    }
  }

  Stream<ContentState> _mapCreateContent(CreateContentEvent event) async*{
    try{
      yield InitialContentState();
      yield LoadingState();
      auth.User currentUser = firebaseAuth.currentUser;
      DocumentReference documentReference = fireStoreUsers.doc();

      firebase_storage.FirebaseStorage storage =
          firebase_storage.FirebaseStorage.instance;

      var snapShot = await storage.ref().child('images')
          .child(App().sharedPreferences.getString('uid'))
          .child(documentReference.id)
          .putFile(event.fileImage);

      var imageUrl = await snapShot.ref.getDownloadURL();

      var snapShotDoc = await storage.ref().child('docs')
          .child(App().sharedPreferences.getString('uid'))
          .child(documentReference.id)
          .putFile(event.fileDoc);

      var docUrl = await snapShotDoc.ref.getDownloadURL();

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
          'imageUrl' : imageUrl.toString(),
          'docUrl' : docUrl.toString()
        });
        yield CreateContentState();
      }else{
        yield ContentErrorState("Gagal membuat data");
      }
    }catch(e,stackTrace){
      yield ContentErrorState(e.toString());
      await CrashlyticsHelper.crash(e, stackTrace, "create content");
      await CrashlyticsHelper.setUserIdentifier(App().sharedPreferences.getString("uid"));
    }
  }

  Stream<ContentState> _mapSearchContent(SearchContentEvent event) async*{
    try{
      yield InitialContentState();

      List<DocumentSnapshot> listMySearchContent = List<DocumentSnapshot>();
      List<ContentModel> listSearchContentModel = List<ContentModel>();
      List<ContentModel> listSearchContentModelTemp = List<ContentModel>();

      listMySearchContent = (await fireStoreUsers.get()).docs;

      listMySearchContent.forEach((item) {
        listSearchContentModel.add(ContentModel.fromJson(item.data()));
      });

      listSearchContentModelTemp = listSearchContentModel.where((i) => i.title.contains(event.searchText)).toList();

      yield SearchContentState(listContentSearchResult: listSearchContentModelTemp);
    }catch(e,stackTrace){
      yield ContentErrorState(e.toString());
      await CrashlyticsHelper.crash(e, stackTrace, "search content");
      await CrashlyticsHelper.setUserIdentifier(App().sharedPreferences.getString("uid"));
    }
  }

  Stream<ContentState>_mapUpdateContent(UpdateContentEvent event) async*{
    try{
      yield InitialContentState();
      yield LoadingState();

      firebase_storage.FirebaseStorage storage =
          firebase_storage.FirebaseStorage.instance;
      var imageUrl;
      var docUrl;

      try{
        if(event.fileImage != null){
          var snapShot = await storage
              .ref()
              .child('images')
              .child(App().sharedPreferences.getString('uid'))
              .child(event.contentModel.idCont)
              .putFile(event.fileImage);

          imageUrl = await snapShot.ref.getDownloadURL();
        }

        if(event.fileDoc != null){
          var snapShotDoc = await storage
              .ref()
              .child('docs')
              .child(App().sharedPreferences.getString('uid'))
              .child(event.contentModel.idCont)
              .putFile(event.fileDoc);

          docUrl = await snapShotDoc.ref.getDownloadURL();
        }
      } catch(e){
        debugPrint('Tidak ada perubahan asset, menggunakan data existing...');
      }

      await fireStoreUsers.doc(event.contentModel.idCont).update({
        "id_cont": event.contentModel.idCont,
        'title': event.title,
        'desc': event.desc,
        'category': event.category,
        'author_name': App().sharedPreferences.getString("displayName"),
        'photo_url': App().sharedPreferences.getString("photoUrl"),
        'update_date': dateTimeNow,
        'imageUrl': imageUrl != null ? imageUrl.toString() : event.contentModel.imageUrl,
        'docUrl': docUrl != null ? docUrl.toString() : event.contentModel.docUrl,
      });

      yield UpdateContentState();
    }catch(e,stackTrace){
      yield ContentErrorState("Gagal update data, coba lagi");
      await CrashlyticsHelper.crash(e, stackTrace, "update content");
      await CrashlyticsHelper.setUserIdentifier(App().sharedPreferences.getString("uid"));
    }
  }

  Stream<ContentState> _mapDeleteContent(DeleteContentEvent event) async*{
    try{
      yield InitialContentState();
      yield LoadingState();

      await fireStoreUsers.doc(event.contentModel.idCont).delete();

      yield DeleteContentState();
    }catch(e,stackTrace){
      yield ContentErrorState("Gagal delete data, coba lagi");
      await CrashlyticsHelper.crash(e, stackTrace, "delete content");
      await CrashlyticsHelper.setUserIdentifier(App().sharedPreferences.getString("uid"));
    }
  }

  Stream<ContentState> _mapRecommendInDetail(RecommendationInDetailEvent event) async*{
    try{
      yield InitialContentState();
      yield LoadingState();

      List<DocumentSnapshot> listContent;
      List<ContentModel> listContentModel = List<ContentModel>();

      listContent = (await fireStoreUsers.limit(5).where('category',isEqualTo: event.contentModel.category).get()).docs;

      listContent.forEach((item) {
        listContentModel.add(ContentModel.fromJson(item.data()));
      });

      yield RecommendationInDetailState(listRecommContentDetail: listContentModel);
    }catch(e,stackTrace){
      yield ContentErrorState("Gagal mendapatkan data");
      await CrashlyticsHelper.crash(e, stackTrace, "recommend detail content");
      await CrashlyticsHelper.setUserIdentifier(App().sharedPreferences.getString("uid"));
    }
  }
}
