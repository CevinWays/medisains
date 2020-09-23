import 'package:firebase_auth/firebase_auth.dart';
import 'package:medisains/app.dart';

class SharedPrefHelper{
  static saveUserInfo(User user){
    App().sharedPreferences.setString('uid', user.uid);
    App().sharedPreferences.setString('displayName', user.displayName);
    App().sharedPreferences.setString('email', user.email);
    App().sharedPreferences.setString('phoneNumber', user.phoneNumber);
    App().sharedPreferences.setString('photoUrl', user.photoUrl);
  }

  static bool isUserLogin(){
    String _uid = App().sharedPreferences.getString('uid');

    return _uid != null ? true : false;
  }

  static deleteUserInfo(){
    App().sharedPreferences.remove('uid');
    App().sharedPreferences.remove('display_name');
    App().sharedPreferences.remove('email');
    App().sharedPreferences.remove('phone_number');
    App().sharedPreferences.remove('photo_url');
  }
}