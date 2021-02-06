import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:medisains/app.dart';
import 'package:medisains/helpers/datetime_helper.dart';
import 'package:medisains/helpers/sharedpref_helper.dart';
import 'package:medisains/helpers/validator_helper.dart';
import 'package:medisains/pages/auth/models/user_model.dart';
import 'package:medisains/pages/auth/repositories/auth_repository.dart';
import 'bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  UserModel userModel = UserModel();
  auth.FirebaseAuth _firebaseAuth = auth.FirebaseAuth.instance;
  auth.UserCredential _userCredential;
  CollectionReference firestoreUsers = FirebaseFirestore.instance.collection('users');
  String dateTimeNow = DateTimeHelper.currentDate();

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
    else if(event is LoginGoogleEvent)
      yield* _mapLoginGoogle();
    else if(event is RegisterGoogleEvent)
      yield* _mapRegisterGoogle();
    else if(event is ResetPassEvent)
      yield* _mapResetPassword(event);
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
            'uid' : _userCredential.user.uid,
            'create_date' : dateTimeNow,
            'update_date' : null,
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
      AuthRepository().signOutGoogle();
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

  Stream<AuthState> _mapLoginGoogle() async*{
    yield InitialAuthState();
    yield LoadingState();
    try{
      auth.User _user = await AuthRepository().loginWithGoogleService();
      await firestoreUsers.doc(_user.uid).get().then((querySnapShot){
        this.userModel = UserModel.fromJson(querySnapShot.data());
      });

      if(this.userModel.uid != "null"){
        if(_user != null){
          SharedPrefHelper.saveUserInfo(_user);
          yield LoginGoogleState();
        }else{
          yield AuthErrorState("Gagal Login, silahkan coba kembali");
        }
      }else{
        AuthRepository().signOutGoogle();
        yield AuthErrorState("Akun tidak ditemukan, daftar terlebih dahulu");
      }
    }catch(e){
      AuthRepository().signOutGoogle();
      SharedPrefHelper.deleteUserInfo();
      yield AuthErrorState(e.toString());
    }
  }

  Stream<AuthState> _mapRegisterGoogle() async*{
    yield InitialAuthState();
    yield LoadingState();
    try{
      auth.User _user = await AuthRepository().loginWithGoogleService();
      if(_user != null){
        DocumentReference documentReference = firestoreUsers.doc(_user.uid);
        if(documentReference.id != null){
          documentReference.set({
            'email' : _user.email,
            'username' : _user.displayName,
            'uid' : _user.uid,
            'create_date' : dateTimeNow,
            'update_date' : null,
          });
          SharedPrefHelper.saveUserInfo(_user);
          yield RegisterGoogleState();
        }else{
          yield AuthErrorState("Gagal membuat akun");
        }
      }else{
        yield AuthErrorState("Gagal Login, silahkan coba kembali");
      }
    }catch(e){
      yield AuthErrorState(e.toString());
    }
  }

  Stream<AuthState> _mapResetPassword(ResetPassEvent event) async*{
    yield InitialAuthState();
    try{
      String validateEmail = ValidatorHelper.validateEmail(value: event.email);
      if(validateEmail != "Email tidak boleh kosong" && validateEmail != "masukkan email yang valid"){
        if(event.email == App().sharedPreferences.getString("email")){
          _firebaseAuth.sendPasswordResetEmail(email: event.email);
          yield ResetPassState();
        }else{
          yield AuthErrorState("Email tidak sama dengan email user sekarang");
        }
      }else{
        yield AuthErrorState("Masukkan email yang valid");
      }
    }catch(e){
      yield AuthErrorState(e.toString());
    }
  }
}
