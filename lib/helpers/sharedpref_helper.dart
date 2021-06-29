import 'package:firebase_auth/firebase_auth.dart';
import 'package:medisains/app.dart';

class SharedPrefHelper {
  static saveUserInfo(User user, {String name, String email}) {
    App().sharedPreferences.setString('uid', user.uid);
    App().sharedPreferences.setString(
        'displayName', user.displayName != null ? user.displayName : name);
    App()
        .sharedPreferences
        .setString('email', user.email != null ? user.email : email);
    App().sharedPreferences.setString('phoneNumber', user.phoneNumber);
    App().sharedPreferences.setString('photoUrl', user.photoURL);
  }

  static bool isUserLogin() {
    String _uid = App().sharedPreferences.getString('uid');

    return _uid != null ? true : false;
  }

  static deleteUserInfo() {
    App().sharedPreferences.remove('uid');
    App().sharedPreferences.remove('display_name');
    App().sharedPreferences.remove('email');
    App().sharedPreferences.remove('phone_number');
    App().sharedPreferences.remove('photo_url');
  }
}
