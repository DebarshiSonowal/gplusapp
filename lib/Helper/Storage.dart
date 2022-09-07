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

  get token => sharedpreferences.getString("token") ?? "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOlwvXC9ncGx1cy5zaGVjdXJlLmNvLmluXC9hcGlcL3YxXC9sb2dpbiIsImlhdCI6MTY2MjQ3OTIwNiwiZXhwIjoxNjYzOTkxMjA2LCJuYmYiOjE2NjI0NzkyMDYsImp0aSI6IkhNMU1GcG1WMnRpZzhzTnIiLCJzdWIiOjk3MjAwLCJwcnYiOiIyM2JkNWM4OTQ5ZjYwMGFkYjM5ZTcwMWM0MDA4NzJkYjdhNTk3NmY3In0.T1TOW7h1R1PIgtnRV4oXeMwL6mq5cRWIKWvKiibpEGU";

  // void logout() {}
  Future<void> logout() async {
    await sharedpreferences.clear();
  }
}
