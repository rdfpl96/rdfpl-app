import 'package:shared_preferences/shared_preferences.dart';

class SessionManager{
  static String KEY_UserId = "user_id";
  static String KEY_FName = "f_name";
  static String KEY_LName = "l_name";
  static String KEY_Email = "email";
  static String KEY_Mobile = "mobile";
  static String KEY_Token = "token";
  static String KEY_Session = "session";

  late SharedPreferences _prefs;

  void storeUserDetails(String user_id,String fname,String lname,String email,String mobile,String token)async{
    _prefs = await SharedPreferences.getInstance();
    _prefs.setString(KEY_UserId, user_id);
    _prefs.setString(KEY_FName, fname);
    _prefs.setString(KEY_LName, lname);
    _prefs.setString(KEY_Email, email);
    _prefs.setString(KEY_Mobile, mobile);
    _prefs.setString(KEY_Token, token);
  }
  Future<String?> getString(String key) async {
    _prefs = await SharedPreferences.getInstance();
    return _prefs.getString(key);
  }

  void logout()async{
    _prefs=await SharedPreferences.getInstance();
    _prefs.clear();
  }

  void updateSession(String cookie)async {
    _prefs = await SharedPreferences.getInstance();
    _prefs.setString(KEY_Session, cookie);
  }
}