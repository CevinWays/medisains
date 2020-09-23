import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:medisains/app.dart';
import './bloc.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final auth.FirebaseAuth firebaseAuth = auth.FirebaseAuth.instance;
  final CollectionReference fireStoreUsers = FirebaseFirestore.instance.collection("category");

  CategoryBloc(CategoryState initialState) : super(initialState);
  @override
  CategoryState get initialState => InitialCategoryState();

  @override
  Stream<CategoryState> mapEventToState(CategoryEvent event,) async* {
    if(event is CreateCategoryEvent){
      yield* _mapCreateCategory(event);
    }else if(event is ReadCategoryEvent)
      yield* _mapReadCategory();
  }

  Stream<CategoryState> _mapCreateCategory(CreateCategoryEvent event) async*{
    try{
      yield InitialCategoryState();
      auth.User currentUser = firebaseAuth.currentUser;
      DocumentReference documentReference = fireStoreUsers.doc(currentUser.uid);
      if(documentReference.id != null){
        await documentReference.set({
          'title' : event.title,
          'desc' : event.desc,
          'uid' : currentUser.uid
        });
        yield CreateCategoryState();
      }else{
        yield CategoryErrorState("Gagal membuat data");
      }
    }catch(e){
      yield CategoryErrorState(e.toString());
    }
  }

  Stream<CategoryState> _mapReadCategory() async*{
    try{
      yield InitialCategoryState();
      await fireStoreUsers.doc(App().sharedPreferences.getString('uid')).get().then((querySnapshot) async{
        await fireStoreUsers
            .doc(querySnapshot.id)
            .collection("category")
            .get().then((querySnapshot){
              querySnapshot.docs.forEach((result){
                print(result.data());
              });
        });
      });
      yield ReadCategoryState();
    }catch(e){
      yield CategoryErrorState(e.toString());
    }
  }
}
