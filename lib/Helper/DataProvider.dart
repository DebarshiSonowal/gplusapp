import 'package:flutter/material.dart';
import 'package:gplusapp/Model/article.dart';
import 'package:gplusapp/Model/opinion.dart';
import 'package:gplusapp/Model/profile.dart';
import 'package:gplusapp/Model/video_news.dart';

class DataProvider extends ChangeNotifier {
  int currentIndex = 0;
  Profile? profile;

  List<Opinion> opinions = [];
  List<Article> home_albums = [], home_exclusive = [];
  List<VideoNews> home_weekly = [];
  List<Opinion> latestOpinions = [];

  setHomeAlbum(List<Article> list) {
    home_albums = list;
    notifyListeners();
  }

  setHomeExecl(List<Article> list) {
    home_exclusive = list;
    notifyListeners();
  }

  setVideoWeekly(List<VideoNews> list) {
    home_weekly = list;
    notifyListeners();
  }

  setOpinions(List<Opinion> list) {
    opinions = list;
    notifyListeners();
  }

  setLatestOpinions(List<Opinion> list) {
    latestOpinions = list;
    notifyListeners();
  }

  setProfile(Profile prof) {
    profile = prof;
    notifyListeners();
  }

  setCurrent(int i) {
    currentIndex = i;
    notifyListeners();
  }
}
