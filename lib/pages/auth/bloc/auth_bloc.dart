import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:medisains/app.dart';
import 'package:medisains/helpers/sharedpref_helper.dart';
import 'package:medisains/pages/auth/models/user_model.dart';
import 'bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  UserModel userModel = UserModel();
  auth.FirebaseAuth _firebaseAuth = auth.FirebaseAuth.instance;
  auth.UserCredential _userCredential;
  CollectionReference firestoreUsers = FirebaseFirestore.instance.collection('users');

  AuthBloc(AuthState initialState) : super(initialState);
  @override
  AuthState get initialState => InitialAuthState();

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    if(event is RegisterEvent)
      yield* _mapRegister(event);
    else if(event is LoginEvent)
      yield* _mapLogin(event);
    else if(event is LogoutEvent)
      yield* _mapLogout();
    else if(event is ReadUserDataEvent)
      yield* _mapReadUserData();
  }

  Stream<AuthState> _mapRegister(RegisterEvent event) async*{
    try{
      yield InitialAuthState();
      yield LoadingState();
      _userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: event.email,
          password: event.password
      );
      
      if(_userCredential.user != null){
        DocumentReference documentReference = firestoreUsers.doc(_userCredential.user.uid);
        if(documentReference.id != null){
          documentReference.set({
            'email' : event.email,
            'username' : event.username,
            'uid' : _userCredential.user.uid
          });
          SharedPrefHelper.saveUserInfo(_userCredential.user);
          yield RegisterState();
        }else{
          yield AuthErrorState("Gagal membuat akun");
        }
      }else{
        yield AuthErrorState("Gagal membuat akun");
      }
    }on auth.FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        yield AuthErrorState('Kata sandi lemah.');
      } else if (e.code == 'email-already-in-use') {
        yield AuthErrorState('Akun sudah pernah di daftarkan');
      }
    }catch(e){
      yield AuthErrorState(e.toString());
    }
  }

  Stream<AuthState> _mapLogin(LoginEvent event) async*{
    try{
      yield InitialAuthState();
      yield LoadingState();
      _userCredential = await _firebaseAuth.signInWithEmailAndPassword(
          email: event.email,
          password: event.password
      );
      if(_userCredential.user != null){
        SharedPrefHelper.saveUserInfo(_userCredential.user);
        yield LoginState();
      }else{
        yield AuthErrorState("Gagal Login");
      }
    }on auth.FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        yield AuthErrorState('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        yield AuthErrorState('Wrong password provided for that user.');
      }
    } catch(e){
      yield AuthErrorState(e.toString());
    }
  }

  Stream<AuthState> _mapLogout() async*{
    yield InitialAuthState();
    try{
      _firebaseAuth.signOut();
      SharedPrefHelper.deleteUserInfo();
      yield LogoutState();
    }catch(e){
      yield AuthErrorState(e.toString());
    }
  }

  Stream<AuthState> _mapReadUserData() async*{
    yield InitialAuthState();
    try{
      await firestoreUsers.doc(App().sharedPreferences.getString('uid')).get().then((querySnapshot){
        this.userModel = UserModel.fromJson(querySnapshot.data());
      });
      yield ReadUserDataState(email: userModel.email,username: userModel.username);
    }catch(e){
      yield AuthErrorState(e.toString());
    }
  }
}
