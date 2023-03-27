import 'package:flutter/material.dart';
import 'package:gplusapp/Model/about_us.dart';
import 'package:gplusapp/Model/address.dart';
import 'package:gplusapp/Model/advertise.dart';
import 'package:gplusapp/Model/article.dart';
import 'package:gplusapp/Model/bookmark_item.dart';
import 'package:gplusapp/Model/citizen_journalist.dart';
import 'package:gplusapp/Model/classified.dart';
import 'package:gplusapp/Model/classified_category.dart';
import 'package:gplusapp/Model/deal_details.dart';
import 'package:gplusapp/Model/grievence_redresal_send.dart';
import 'package:gplusapp/Model/locality.dart';
import 'package:gplusapp/Model/opinion.dart';
import 'package:gplusapp/Model/poll_of_the_week.dart';
import 'package:gplusapp/Model/profile.dart';
import 'package:gplusapp/Model/promoted_deal.dart';
import 'package:gplusapp/Model/redeem_history.dart';
import 'package:gplusapp/Model/refer_earn_response.dart';
import 'package:gplusapp/Model/report_model.dart';
import 'package:gplusapp/Model/shop_category.dart';
import 'package:gplusapp/Model/swtich_status.dart';
import 'package:gplusapp/Model/top_picks.dart';
import 'package:gplusapp/Model/video_news.dart';

import '../Model/blocked_user.dart';
import '../Model/contact_us.dart';
import '../Model/guwahati_connect.dart';
import '../Model/membership.dart';
import '../Model/notification_in_device.dart';
import '../Model/redeem_details.dart';
import '../Model/referEarnHistory.dart';
import '../Model/search_result.dart' as search;
import '../Model/shop.dart';
import '../Model/story.dart';
import '../Model/topick.dart';

class DataProvider extends ChangeNotifier {
  int currentIndex = 0;
  Profile? profile;
  AuthorProfile? author;
  List<GrievenceRedresalSend> grievences = [];
  List<BlockedUser> blockedUsers = [
    // BlockedUser(),
  ];
  List<ReportModel> reportCategories = [];
  List<NotificationInDevice> notifications = [];
  List<Opinion> opinions = [];
  List<Story> stories = [];
  List<Article> home_albums = [],
      home_exclusive = [],
      news_from = [],
      suggestion = [],
      authors_news = [];
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
  List<GuwahatiConnect> guwahatiConnect = [], myGuwahatiConnect = [];
  List<CitizenJournalist> citizenlist = [];
  List<RedeemHistory> history = [];
  List<search.SearchResult> searchlist = [];
  List<search.OthersSearchResult> othersearchlist = [];
  Classified? selectedClassified;
  List<Shop> shops = [];
  SwitchStatus? status;
  List<BookmarkItem> bookmarks = [];
  bool hideReferEarn = false;
  GuwahatiConnect? specificGuwahatiConnect;
  String ad_image = "";
  String citizenJournalist = "",
      deal = "",
      classifiedMsg = "",
      refer_earn = "",
      connect = "",
      redeem = "",
      refer_history_msg = "",
      invite = "",
      paywall = "";

  setCitizenJournalistText(String txt) {
    citizenJournalist = txt;
    notifyListeners();
  }

  setGuwahatiConnectSpecific(GuwahatiConnect val) {
    specificGuwahatiConnect = val;
    notifyListeners();
  }

  setDealText(String txt) {
    deal = txt;
    notifyListeners();
  }

  setPaywallText(String txt) {
    paywall = txt;
    notifyListeners();
  }

  setReferEarnText(String txt) {
    refer_earn = txt;
    notifyListeners();
  }

  setGuwahatiText(String txt) {
    connect = txt;
    notifyListeners();
  }

  setHide(val) {
    hideReferEarn = val;
    notifyListeners();
  }

  setRedeemText(String txt) {
    redeem = txt;
    notifyListeners();
  }

  setClassifiedText(String txt) {
    classifiedMsg = txt;
    notifyListeners();
  }

  setCitizenJournalist(List<CitizenJournalist> list) {
    citizenlist = list;
    notifyListeners();
  }

  setBlockedUsers(List<BlockedUser> list) {
    debugPrint("MY LENGTH ${list.length}");
    blockedUsers = list;
    notifyListeners();
  }

  setReportModel(List<ReportModel> list) {
    print("list set ${list}");
    reportCategories = list;
    notifyListeners();
  }

  setNotificationInDevice(List<NotificationInDevice> list) {
    notifications = list;
    notifyListeners();
  }

  removeNotificationInDevice(NotificationInDevice item) {
    notifications.remove(item);
    notifyListeners();
  }

  setBookmarkItems(List<BookmarkItem> list) {
    bookmarks = list;
    notifyListeners();
  }

  setReferEarnHistory(List<ReferEarnHistory> list, String msg, String txt) {
    referHistory = list;
    refer_history_msg = msg;
    invite = txt;
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

  setGrievences(List<GrievenceRedresalSend> list) {
    grievences = list;
    notifyListeners();
  }

  setOtherSearchlist(List<search.OthersSearchResult> list) {
    othersearchlist = list;
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

  setMyGuwahatiConnect(List<GuwahatiConnect> list) {
    myGuwahatiConnect = list;
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
    print("GEO got it ${list.length}");
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

  setStories(List<Story> list) {
    stories = list;
    notifyListeners();
  }

  setAds(List<Advertise> list) {
    ads = list;
    notifyListeners();
  }

  setAdImage(String url) {
    ad_image = url;
    notifyListeners();
  }

  setHomeTopPicks(List<TopPicks> list) {
    home_toppicks = list;
    notifyListeners();
  }

  setAuthorsNews(List<Article> list) {
    authors_news = list;
    notifyListeners();
  }

  addHomeTopPicks(List<TopPicks> list) {
    home_toppicks.addAll(list);
    notifyListeners();
  }

  setHomeExecl(List<Article> list) {
    home_exclusive = list;
    notifyListeners();
  }

  addHomeExecl(List<Article> list) {
    home_exclusive.addAll(list);
    notifyListeners();
  }

  setNewsFrom(List<Article> list) {
    news_from = list;
    notifyListeners();
  }

  addNewsFrom(List<Article> list) {
    news_from.addAll(list);
    notifyListeners();
  }

  setSuggestion(List<Article> list) {
    suggestion = list;
    notifyListeners();
  }

  addSuggestion(List<Article> list) {
    suggestion.addAll(list);
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

  addVideoNews(List<VideoNews> list) {
    video_news.addAll(list);
    notifyListeners();
  }

  setOpinions(List<Opinion> list) {
    opinions = list;
    notifyListeners();
  }

  setMoreOpinions(List<Opinion> list) {
    opinions.addAll(list);
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

  setAuthor(AuthorProfile prof) {
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

  void setSwitch(SwitchStatus? val) {
    status = val;
    notifyListeners();
  }
}
