import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Model/temp.dart';

class Storage {
  // shared_preferences
  Storage._();

  static final Storage instance = Storage._();
  late SharedPreferences sharedpreferences;

  temp? signUpdata;

  setSignUpData(temp data){
    signUpdata = data;
  }

  Future<void> initializeStorage() async {
    sharedpreferences = await SharedPreferences.getInstance();
  }

  Future<void> setUser(String token) async {
    print('set token ${token}');
    await sharedpreferences.setString("token", token);
    await sharedpreferences.setBool("isLoggedIn", true);
  }

  Future<void> setOnBoarding() async {
    await sharedpreferences.setBool("isOnBoarding", true);
  }

  get isLoggedIn => sharedpreferences.getBool("isLoggedIn") ?? false;

  get isOnBoarding => sharedpreferences.getBool("isOnBoarding") ?? false;

  get token => sharedpreferences.getString("token") ?? "";

  // void logout() {}
  Future<void> logout() async {
    await sharedpreferences.clear();
  }
}
