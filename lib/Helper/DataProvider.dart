

import 'package:flutter/material.dart';
import 'package:gplusapp/Model/profile.dart';

class DataProvider extends ChangeNotifier{

  int currentIndex=0;
  Profile? profile;

  setProfile(Profile prof){
    profile = prof;
    notifyListeners();
  }

  setCurrent(int i){
    currentIndex = i;
    notifyListeners();
  }


}