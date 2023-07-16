import 'package:shared_preferences/shared_preferences.dart';

class SessionManager{

  static final SessionManager _session = SessionManager._internal();
  late final SharedPreferences sharedPreferences;

  factory SessionManager(){
    return SessionManager._session;
  }

  SessionManager._internal();

  String getToken(SharedPreferences preferences){
    return preferences.getString("token") ?? "";
  }

  void saveToken(SharedPreferences sharedPreferences, String token) async {
    await sharedPreferences.setString("token", token);
  }

}