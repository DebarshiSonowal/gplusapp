

import 'package:flutter/material.dart';

class DataProvider extends ChangeNotifier{

  int currentIndex=0;

  setCurrent(int i){
    currentIndex = i;
    notifyListeners();
  }


}