import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:medisains/app.dart';
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
      yield* _mapReadContent();
    else if(event is CreateContentEvent)
      yield* _mapCreateContent(event);
  }

  Stream<ContentState> _mapReadContent() async*{
    try{
      yield InitialContentState();
      await fireStoreUsers.doc(App().sharedPreferences.getString('uid')).get().then((querySnapshot) async{
        await fireStoreUsers
            .doc(querySnapshot.id)
            .collection("content")
            .get().then((querySnapshot){
          querySnapshot.docs.forEach((result){
            print(result.data());
          });
        });
      });
      yield ReadContentState();
    }catch(e){
      yield ContentErrorState(e.toString());
    }
  }

  Stream<ContentState> _mapCreateContent(CreateContentEvent event) async*{
    try{
      yield InitialContentState();
      auth.User currentUser = firebaseAuth.currentUser;
      DocumentReference documentReference = fireStoreUsers.doc(currentUser.uid);
      if(documentReference.id != null){
        await documentReference.set({
          'title' : event.title,
          'desc' : event.desc,
          'uid' : currentUser.uid
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
