import 'package:flutter/material.dart';
import 'package:google_place/google_place.dart';
import 'package:gplusapp/Model/about_us.dart';
import 'package:gplusapp/Model/address.dart';
import 'package:gplusapp/Model/advertise.dart';
import 'package:gplusapp/Model/article.dart';
import 'package:gplusapp/Model/citizen_journalist.dart';
import 'package:gplusapp/Model/classified.dart';
import 'package:gplusapp/Model/classified_category.dart';
import 'package:gplusapp/Model/deal_details.dart';
import 'package:gplusapp/Model/locality.dart';
import 'package:gplusapp/Model/opinion.dart';
import 'package:gplusapp/Model/poll_of_the_week.dart';
import 'package:gplusapp/Model/profile.dart';
import 'package:gplusapp/Model/promoted_deal.dart';
import 'package:gplusapp/Model/redeem_history.dart';
import 'package:gplusapp/Model/refer_earn_response.dart';
import 'package:gplusapp/Model/search_result.dart';
import 'package:gplusapp/Model/shop_category.dart';
import 'package:gplusapp/Model/top_picks.dart';
import 'package:gplusapp/Model/video_news.dart';
import 'package:gplusapp/UI/citizen_journalist/citizen_journalist_page.dart';
import 'package:gplusapp/UI/others/contact_us_page.dart';
import '../Model/referEarnHistory.dart';
import '../Model/search_result.dart' as search;
import '../Model/contact_us.dart';
import '../Model/guwahati_connect.dart';
import '../Model/membership.dart';
import '../Model/redeem_details.dart';
import '../Model/shop.dart';
import '../Model/topick.dart';

class DataProvider extends ChangeNotifier {
  int currentIndex = 0;
  Profile? profile, author;

  List<Opinion> opinions = [];
  List<Article> home_albums = [],
      home_exclusive = [],
      news_from = [],
      suggestion = [];
  List<VideoNews> home_weekly = [], video_news = [];
  List<Opinion> latestOpinions = [];
  List<Membership> memberships = [];
  List<TopPicks> home_toppicks = [];
  List<PromotedDeal> deals = [];
  List<ShopCategory> category = [];
  List<Advertise> ads = [];
  DealDetails? details;
  RedeemDetails? redeemDetails;
  List<Topick> topicks = [], mytopicks = [];
  List<GeoTopick> geoTopicks = [], mygeoTopicks = [];
  List<Classified> classified = [];
  List<ClassifiedCategory> classified_category = [];
  List<Locality> locality = [];
  ReferEarn? referEarn;
  List<ReferEarnHistory> referHistory = [];
  Article? selectedArticle;
  Opinion? opinion;
  AboutUs? aboutUs;
  ContactUs? contactUs;
  PollOfTheWeek? pollOfTheWeek;
  List<Address>? addresses = [];
  List<GuwahatiConnect> guwahatiConnect = [];
  List<CitizenJournalist> citizenlist = [];
  List<RedeemHistory> history = [];
  List<search.SearchResult> searchlist = [];
  Classified? selectedClassified;
  List<Shop> shops = [];

  setCitizenJournalist(List<CitizenJournalist> list) {
    citizenlist = list;
    notifyListeners();
  }

  setReferEarnHistory(List<ReferEarnHistory> list) {
    referHistory = list;
    notifyListeners();
  }

  setShops(List<Shop> list) {
    shops = list;
    notifyListeners();
  }

  setClassifiedDetails(Classified data) {
    selectedClassified = data;
    notifyListeners();
  }

  setRedeemHistory(List<RedeemHistory> list) {
    history = list;
    notifyListeners();
  }

  setSearchResult(List<search.SearchResult> list) {
    searchlist = list;
    notifyListeners();
  }

  setArticleDetails(Article data) {
    selectedArticle = data;
    notifyListeners();
  }

  setOpinionDetails(Opinion data) {
    opinion = data;
    notifyListeners();
  }

  setPollOfTheWeek(PollOfTheWeek data) {
    pollOfTheWeek = data;
    notifyListeners();
  }

  setAboutUs(AboutUs data) {
    aboutUs = data;
    notifyListeners();
  }

  setContactUs(ContactUs data) {
    contactUs = data;
    notifyListeners();
  }

  setReferEarn(ReferEarn data) {
    referEarn = data;
    notifyListeners();
  }

  setClassified(List<Classified> list) {
    classified = list;
    notifyListeners();
  }

  setGuwahatiConnect(List<GuwahatiConnect> list) {
    guwahatiConnect = list;
    notifyListeners();
  }

  setAddressess(List<Address> list) {
    addresses = list;
    notifyListeners();
  }

  setClassifiedCategory(List<ClassifiedCategory> list) {
    classified_category = list;
    notifyListeners();
  }

  setLocality(List<Locality> list) {
    locality = list;
    notifyListeners();
  }

  setTopicks(List<Topick> list) {
    topicks = list;
    notifyListeners();
  }

  setGeoTopicks(List<GeoTopick> list) {
    geoTopicks = list;
    notifyListeners();
  }

  setMyTopicks(List<Topick> list) {
    mytopicks = list;
    notifyListeners();
  }

  setMyGeoTopicks(List<GeoTopick> list) {
    mygeoTopicks = list;
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

  setSuggestion(List<Article> list) {
    suggestion = list;
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

  setAuthor(Profile prof) {
    author = prof;
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
