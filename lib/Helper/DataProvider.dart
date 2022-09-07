import 'package:flutter/material.dart';
import 'package:gplusapp/Model/advertise.dart';
import 'package:gplusapp/Model/article.dart';
import 'package:gplusapp/Model/deal_details.dart';
import 'package:gplusapp/Model/opinion.dart';
import 'package:gplusapp/Model/profile.dart';
import 'package:gplusapp/Model/promoted_deal.dart';
import 'package:gplusapp/Model/shop_category.dart';
import 'package:gplusapp/Model/top_picks.dart';
import 'package:gplusapp/Model/video_news.dart';

import '../Model/membership.dart';
import '../Model/redeem_details.dart';
import '../Model/topick.dart';

class DataProvider extends ChangeNotifier {
  int currentIndex = 0;
  Profile? profile;

  List<Opinion> opinions = [];
  List<Article> home_albums = [], home_exclusive = [], news_from = [];
  List<VideoNews> home_weekly = [], video_news = [];
  List<Opinion> latestOpinions = [];
  List<Membership> memberships = [];
  List<TopPicks> home_toppicks = [];
  List<PromotedDeal> deals=[];
  List<ShopCategory> category=[];
  List<Advertise> ads=[];
  DealDetails? details;
  RedeemDetails? redeemDetails;
  List<Topick> topicks = [];
  List<GeoTopick> geoTopicks = [];

  setTopicks(List<Topick> list) {
    topicks = list;
    notifyListeners();
  }
  setGeoTopicks(List<GeoTopick> list) {
    geoTopicks = list;
    notifyListeners();
  }

  setMembership(List<Membership> list) {
    memberships = list;
    debugPrint(list.toString());
    notifyListeners();
  }
  setPromotedDeals(List<PromotedDeal> list) {
    deals = list;
    // debugPrint(list.toString());
    notifyListeners();
  }
  setShopCategory(List<ShopCategory> list) {
    category = list;
    // debugPrint(list.toString());
    notifyListeners();
  }

  setHomeAlbum(List<Article> list) {
    home_albums = list;
    notifyListeners();
  }
  setAds(List<Advertise> list) {
    ads = list;
    notifyListeners();
  }
  setHomeTopPicks(List<TopPicks> list) {
    home_toppicks = list;
    notifyListeners();
  }

  setHomeExecl(List<Article> list) {
    home_exclusive = list;
    notifyListeners();
  }

  setNewsFrom(List<Article> list) {
    news_from = list;
    notifyListeners();
  }

  setVideoWeekly(List<VideoNews> list) {
    home_weekly = list;
    notifyListeners();
  }

  setVideoNews(List<VideoNews> list) {
    video_news = list;
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
  setDealDetails(DealDetails data) {
   details = data;
    notifyListeners();
  }
  setRedeemDetails(RedeemDetails data) {
    redeemDetails = data;
    notifyListeners();
  }

  setCurrent(int i) {
    currentIndex = i;
    notifyListeners();
  }
}
