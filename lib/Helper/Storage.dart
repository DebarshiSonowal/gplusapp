import 'package:shared_preferences/shared_preferences.dart';

import '../Model/temp.dart';

class Storage {
  // shared_preferences
  Storage._();

  static final Storage instance = Storage._();
  late SharedPreferences sharedpreferences;

  temp? signUpdata;

  Future<void> initializeStorage() async {
    sharedpreferences = await SharedPreferences.getInstance();
  }

  Future<void> setUser(String token) async {
    await sharedpreferences.setString("token", token);
    await sharedpreferences.setBool("isLoggedIn", true);
  }

  Future<void> setOnBoarding() async {
    await sharedpreferences.setBool("isOnBoarding", true);
  }

  get isLoggedIn => sharedpreferences.getBool("isLoggedIn") ?? false;

  get isOnBoarding => sharedpreferences.getBool("isOnBoarding") ?? false;

  get token => sharedpreferences.getString("token") ?? "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOlwvXC9ncGx1cy5zaGVjdXJlLmNvLmluXC9hcGlcL3YxXC9sb2dpbiIsImlhdCI6MTY2MjM4NDY4MywiZXhwIjoxNjYyMzg4MjgzLCJuYmYiOjE2NjIzODQ2ODMsImp0aSI6InBRak1jWGdPeXZxdFJmcEQiLCJzdWIiOjk3MjAwLCJwcnYiOiIyM2JkNWM4OTQ5ZjYwMGFkYjM5ZTcwMWM0MDA4NzJkYjdhNTk3NmY3In0.QAbdCGHODCCyg23HEpozDi6BlFQEZiJXl7qbDueaYgU";

  // void logout() {}
  Future<void> logout() async {
    await sharedpreferences.clear();
  }
}
