import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Model/temp.dart';

class Storage {
  // shared_preferences
  Storage._();

  static final Storage instance = Storage._();
  late SharedPreferences sharedpreferences;

  temp? signUpdata;

  setSignUpData(temp data) {
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

  Future<void> setToken(String token) async {
    debugPrint('set token ${token}');
    await sharedpreferences.setString("token", token);
  }

  // Future<void> setLogInStatus(int val) async {
  //   await sharedpreferences.setInt("logInStatus", val);
  // }

  Future<void> setFilter(String filters) async {
    print('set filters ${filters.toString()}');
    await sharedpreferences.setString("filter", filters);
  }

  Future<void> setFullScreenAd(bool val) async {
    // print('set filters ${filters.toString()}');
    await sharedpreferences.setBool("fullscreen", val);
  }

  Future<void> setOnBoarding() async {
    await sharedpreferences.setBool("isOnBoarding", true);
  }

  Future<void> setBigDeal() async {
    await sharedpreferences.setBool("isBigDeal", true);
  }

  Future<void> setClassified() async {
    await sharedpreferences.setBool("isClassified", true);
  }

  Future<void> setCitizenJournalist() async {
    await sharedpreferences.setBool("isCitizenJournalist", true);
  }

  Future<void> setDarkMode(bool selected) async {
    await sharedpreferences.setBool("dark", selected);
    print('setDarkMode');
  }

  Future<void> setLastDisplayed(String val) async {
    await sharedpreferences.setString("lastDisplayed", val);
  }

  Future<void> setGuwahatiConnect() async {
    await sharedpreferences.setBool("isGuwahatiConnect", true);
  }

  Future<void> setIsNew(bool val) async {
    await sharedpreferences.setBool("isNew", val);
  }

  get isGuwahatiConnect =>
      sharedpreferences.getBool("isGuwahatiConnect") ?? false;

  get isCitizenJournalist =>
      sharedpreferences.getBool("isCitizenJournalist") ?? false;

  get isClassified => sharedpreferences.getBool("isClassified") ?? false;

  get isBigDeal => sharedpreferences.getBool("isBigDeal") ?? false;

  get isLoggedIn => sharedpreferences.getBool("isLoggedIn") ?? false;

  get isDarkMode => sharedpreferences.getBool("dark") ?? false;

  get isFullScreenAd => sharedpreferences.getBool("fullscreen") ?? false;

  get isNew => sharedpreferences.getBool("isNew") ?? false;

  // get logInStatus => sharedpreferences.getInt("logInStatus") ?? 0;

  get isOnBoarding => sharedpreferences.getBool("isOnBoarding") ?? false;

  get token => sharedpreferences.getString("token") ?? "";

  get lastDisplayed => sharedpreferences.getString("lastDisplayed") ?? "";

  get filters => sharedpreferences.getString("filter") ?? "";

  // void logout() {}
  Future<void> logout() async {
    await sharedpreferences.clear();
  }
}
