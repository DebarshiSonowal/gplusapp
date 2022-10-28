import 'dart:convert';

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

  Future<void> setFilter(String filters) async {
    print('set filters ${filters.toString()}');
    await sharedpreferences.setString("filter", filters);
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

  Future<void> setGuwahatiConnect() async {
    await sharedpreferences.setBool("isGuwahatiConnect", true);
  }

  get isGuwahatiConnect =>
      sharedpreferences.getBool("isGuwahatiConnect") ?? false;

  get isCitizenJournalist =>
      sharedpreferences.getBool("isCitizenJournalist") ?? false;

  get isClassified => sharedpreferences.getBool("isClassified") ?? false;

  get isBigDeal => sharedpreferences.getBool("isBigDeal") ?? false;

  get isLoggedIn => sharedpreferences.getBool("isLoggedIn") ?? false;

  get isOnBoarding => sharedpreferences.getBool("isOnBoarding") ?? false;

  get token => sharedpreferences.getString("token") ?? "";

  get filters => sharedpreferences.getString("filter") ?? "";

  // void logout() {}
  Future<void> logout() async {
    await sharedpreferences.clear();
  }
}
