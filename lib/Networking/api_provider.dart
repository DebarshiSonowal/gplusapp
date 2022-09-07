import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:gplusapp/Helper/Storage.dart';
import 'package:gplusapp/Model/profile.dart';
import 'package:gplusapp/Navigation/Navigate.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import '../Model/advertise.dart';
import '../Model/article.dart';
import '../Model/article_desc.dart';
import '../Model/deal_details.dart';
import '../Model/e_paper.dart';
import '../Model/generic_response.dart';
import '../Model/login_response.dart';
import '../Model/membership.dart';
import '../Model/opinion.dart';
import '../Model/promoted_deal.dart';
import '../Model/redeem_details.dart';
import '../Model/shop_category.dart';
import '../Model/top_picks.dart';
import '../Model/topick.dart';
import '../Model/video_news.dart';

class ApiProvider {
  ApiProvider._();

  static final ApiProvider instance = ApiProvider._();
  final String baseUrl = "http://gplus.shecure.co.in/api/v1";
  final String homeUrl = "https://www.guwahatiplus.com/api/v1";
  final String path = "/books";

  Dio? dio;

  BaseOptions option =
      BaseOptions(connectTimeout: 80000, receiveTimeout: 80000, headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer ${Storage.instance.token}'
    // 'APP-KEY': ConstanceData.app_key
  });

  Future<LoginResponse> login(mobile) async {
    var data = {
      'mobile': mobile,
    };

    var url = "$baseUrl/login";
    dio = Dio(option);
    debugPrint(url.toString());
    debugPrint(jsonEncode(data));

    try {
      Response? response = await dio?.post(url, data: jsonEncode(data));
      debugPrint("login response: ${response?.data}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return LoginResponse.fromJson(response?.data);
      } else {
        debugPrint("login error: ${response?.data}");
        return LoginResponse.withError(
            response?.data['message'] ?? "Something went wrong");
      }
    } on DioError catch (e) {
      debugPrint("login response: ${e.response}");
      return LoginResponse.withError(e.message.toString());
    }
  }

  Future<ProfileResponse> getprofile(mobile) async {
    var data = {
      'mobile': mobile,
    };

    var url = "${baseUrl}/login";
    dio = Dio(option);
    debugPrint(url.toString());
    debugPrint(jsonEncode(data));

    try {
      Response? response = await dio?.post(url, data: jsonEncode(data));
      debugPrint("Profile response: ${response?.data}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return ProfileResponse.fromJson(response?.data);
      } else {
        debugPrint("Profile error: ${response?.data}");
        return ProfileResponse.withError();
      }
    } on DioError catch (e) {
      debugPrint("Profile response: ${e.response}");
      return ProfileResponse.withError();
    }
  }

  Future<GenericResponse> createProfile(
      mobile, f_name, l_name, email, dob, address, longitude, latitude) async {
    var data = {
      'mobile': mobile,
      'f_name': f_name,
      'l_name': l_name,
      'email': email,
      'dob': dob,
      'address': address,
      'longitude': longitude,
      'latitude': latitude,
    };

    var url = "${baseUrl}/new-personal-details";
    dio = Dio(option);
    debugPrint(url.toString());
    debugPrint(jsonEncode(data));

    try {
      Response? response = await dio?.post(url, data: jsonEncode(data));
      debugPrint("create Profile response: ${response?.data}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return GenericResponse.fromJson(response?.data);
      } else {
        debugPrint("create Profile error: ${response?.data}");
        return GenericResponse.withError("Something went wrong");
      }
    } on DioError catch (e) {
      debugPrint("create Profile error: ${e.response}");
      return GenericResponse.withError(e.message);
    }
  }

  Future<ArticleResponse> getArticle(categ_name) async {
    // var data = {
    //   // 'mobile': mobile,
    // };

    var url = "${homeUrl}/${categ_name}";
    dio = Dio(option);
    debugPrint(url.toString());
    // debugPrint(jsonEncode(data));

    try {
      Response? response = await dio?.get(
        url,
      );
      debugPrint("Article response: ${response?.data}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return ArticleResponse.fromJson(response?.data);
      } else {
        debugPrint("Article error: ${response?.data}");
        return ArticleResponse.withError("Something Went Wrong");
      }
    } on DioError catch (e) {
      debugPrint("Article response: ${e.response}");
      return ArticleResponse.withError(e.message);
    }
  }

  Future<OpinionResponse> getOpinion(per_page, page) async {
    var data = {
      'category': 'opinion',
      'per_page': per_page,
      'page': page,
    };

    var url = "${homeUrl}/opinion-list";
    dio = Dio(option);
    debugPrint(url.toString());
    debugPrint(jsonEncode(data));

    try {
      Response? response = await dio?.get(
        url,
        queryParameters: data,
      );
      debugPrint("Article response: ${response?.data}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return OpinionResponse.fromJson(response?.data);
      } else {
        debugPrint("Article error: ${response?.data}");
        return OpinionResponse.withError("Something Went Wrong");
      }
    } on DioError catch (e) {
      debugPrint("Article response: ${e.response}");
      return OpinionResponse.withError(e.message);
    }
  }

  Future<ArticleDescResponse> getArticleDesc(categ_name, slur) async {
    // var data = {
    //   // 'mobile': mobile,
    // };

    var url = "${baseUrl}/${categ_name}/${slur}";
    dio = Dio(option);
    debugPrint(url.toString());
    // debugPrint(jsonEncode(data));

    try {
      Response? response = await dio?.get(
        url,
      );
      debugPrint("Article desc response: ${response?.data}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return ArticleDescResponse.fromJson(response?.data);
      } else {
        debugPrint("Article desc error: ${response?.data}");
        return ArticleDescResponse.withError("Something Went Wrong");
      }
    } on DioError catch (e) {
      debugPrint("Article desc response: ${e.response}");
      return ArticleDescResponse.withError(e.message);
    }
  }

  Future<ArticleResponse> getHomeAlbum() async {
    // var data = {
    //   // 'mobile': mobile,
    // };

    var url = "${homeUrl}/app/latest-news";
    dio = Dio(option);
    debugPrint(url.toString());
    // debugPrint(jsonEncode(data));

    try {
      Response? response = await dio?.get(
        url,
      );
      debugPrint("HomeAlbum response: ${response?.data}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return ArticleResponse.fromJson(response?.data);
      } else {
        debugPrint("HomeAlbum error: ${response?.data}");
        return ArticleResponse.withError("Something Went Wrong");
      }
    } on DioError catch (e) {
      debugPrint("HomeAlbum response: ${e.response}");
      return ArticleResponse.withError(e.message);
    }
  }

  Future<VideoNewsResponse> getWeekly() async {
    // var data = {
    //   // 'mobile': mobile,
    // };

    var url = "${homeUrl}/app/weekly-videos";
    dio = Dio(option);
    debugPrint(url.toString());
    // debugPrint(jsonEncode(data));

    try {
      Response? response = await dio?.get(
        url,
      );
      debugPrint("Weekly response: ${response?.data}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return VideoNewsResponse.fromJson(response?.data);
      } else {
        debugPrint("Weekly error: ${response?.data}");
        return VideoNewsResponse.withError("Something Went Wrong");
      }
    } on DioError catch (e) {
      debugPrint("Weekly response: ${e.response}");
      return VideoNewsResponse.withError(e.message);
    }
  }

  Future<LatestOpinionResponse> getLatestOpinion() async {
    // var data = {
    //   'category': 'opinion',
    //   'per_page': per_page,
    //   'page': page,
    // };

    var url = "${homeUrl}/app/latest-opinions";
    dio = Dio(option);
    debugPrint(url.toString());
    // debugPrint(jsonEncode(data));

    try {
      Response? response = await dio?.get(
        url,
        // queryParameters: data,
      );
      debugPrint("latest-opinions response: ${response?.data}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return LatestOpinionResponse.fromJson(response?.data);
      } else {
        debugPrint("latest-opinions error: ${response?.data}");
        return LatestOpinionResponse.withError("Something Went Wrong");
      }
    } on DioError catch (e) {
      debugPrint("latest-opinions response: ${e.response}");
      return LatestOpinionResponse.withError(e.message);
    }
  }

  Future<E_paperRepsonse> getEpaper() async {
    // var data = {
    //   'category': 'opinion',
    //   'per_page': per_page,
    //   'page': page,
    // };

    var url = "${homeUrl}/get-epaper";
    dio = Dio(option);
    debugPrint(url.toString());
    // debugPrint(jsonEncode(data));

    try {
      Response? response = await dio?.get(
        url,
        // queryParameters: data,
      );
      debugPrint("E_paper response: ${response?.data}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return E_paperRepsonse.fromJson(response?.data);
      } else {
        debugPrint("E_paper error: ${response?.data}");
        return E_paperRepsonse.withError("Something Went Wrong");
      }
    } on DioError catch (e) {
      debugPrint("E_paper response: ${e.response}");
      return E_paperRepsonse.withError(e.message);
    }
  }

  Future<VideoNewsResponse> getVideoNews() async {
    // var data = {
    //   // 'mobile': mobile,
    // };

    var url = "${homeUrl}/app/video-news";
    dio = Dio(option);
    debugPrint(url.toString());
    // debugPrint(jsonEncode(data));

    try {
      Response? response = await dio?.get(
        url,
      );
      debugPrint("video-news response: ${response?.data}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return VideoNewsResponse.fromJson(response?.data);
      } else {
        debugPrint("video-news error: ${response?.data}");
        return VideoNewsResponse.withError("Something Went Wrong");
      }
    } on DioError catch (e) {
      debugPrint("video-news response: ${e.response}");
      return VideoNewsResponse.withError(e.message);
    }
  }

  Future<MembershipResponse> getMembership() async {
    // var data = {
    //   'category': 'opinion',
    //   'per_page': per_page,
    //   'page': page,
    // };

    var url = "${baseUrl}/app/subscriptions";
    dio = Dio(option);
    debugPrint(url.toString());
    var data = {'Authorization': 'Bearer ${Storage.instance.token}'};
    debugPrint(jsonEncode(data));

    try {
      Response? response = await dio?.get(
        url,
        // queryParameters: data,
      );
      debugPrint("subscriptions response: ${response?.data}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return MembershipResponse.fromJson(response?.data);
      } else {
        debugPrint("subscriptions error: ${response?.data}");
        return MembershipResponse.withError("Something Went Wrong");
      }
    } on DioError catch (e) {
      debugPrint("subscriptions response: ${e.response}");
      return MembershipResponse.withError(e.message);
    }
  }

  Future<PromotedDealResponse> getPromotedDeals() async {
    var url = "${baseUrl}/app/promoted-deal-list";
    dio = Dio(option);
    debugPrint(url.toString());
    var data = {'Authorization': 'Bearer ${Storage.instance.token}'};
    debugPrint(jsonEncode(data));

    try {
      Response? response = await dio?.get(
        url,
        // queryParameters: data,
      );
      debugPrint("promoted-deal-list response: ${response?.data}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return PromotedDealResponse.fromJson(response?.data);
      } else {
        debugPrint("promoted-deal-list error: ${response?.data}");
        return PromotedDealResponse.withError("Something Went Wrong");
      }
    } on DioError catch (e) {
      debugPrint("promoted-deal-list error: ${e.response}");
      return PromotedDealResponse.withError(e.message);
    }
  }

  Future<DealDetailsResponse> getDealDetails(id) async {
    var url = "${baseUrl}/app/deal-details/$id";
    dio = Dio(option);
    debugPrint(url.toString());
    var data = {'Authorization': 'Bearer ${Storage.instance.token}'};
    debugPrint(jsonEncode(data));

    try {
      Response? response = await dio?.get(
        url,
        // queryParameters: data,
      );
      debugPrint("DealDetailsResponse response: ${response?.data}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return DealDetailsResponse.fromJson(response?.data);
      } else {
        debugPrint("DealDetailsResponse error: ${response?.data}");
        return DealDetailsResponse.withError("Something Went Wrong");
      }
    } on DioError catch (e) {
      debugPrint("DealDetailsResponse error: ${e.response}");
      return DealDetailsResponse.withError(e.message);
    }
  }

  Future<RedeemDetailsResponse> redeemCupon(id, code) async {
    var url = "${baseUrl}/app/apply-coupon/$id";
    dio = Dio(option);
    debugPrint(url.toString());
    var data = {'coupon_code': code};
    debugPrint(jsonEncode(data));

    try {
      Response? response = await dio?.post(
        url,
        data: data,
        // queryParameters: data,
      );
      debugPrint("RedeemDetailsResponse response: ${response?.data}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return RedeemDetailsResponse.fromJson(response?.data);
      } else {
        debugPrint("RedeemDetailsResponse error: ${response?.data}");
        return RedeemDetailsResponse.withError("Something Went Wrong");
      }
    } on DioError catch (e) {
      debugPrint("RedeemDetailsResponse error: ${e.response}");
      return RedeemDetailsResponse.withError(e.message);
    }
  }

  Future<GenericResponse> enterPreferences(mobile, topicks, geotopicks) async {
    var url = "${baseUrl}/app/topic-geo";
    dio = Dio(option);
    debugPrint(url.toString());
    var data = {
      'mobile': mobile,
      'topic_ids': topicks,
      'geo_ids': geotopicks,
    };
    debugPrint(jsonEncode(data));

    try {
      Response? response = await dio?.post(
        url,
        data: data,
        // queryParameters: data,
      );
      debugPrint("enterPreferences response: ${response?.data}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return GenericResponse.fromJson(response?.data);
      } else {
        debugPrint("enterPreferences error: ${response?.data}");
        return GenericResponse.withError("Something Went Wrong");
      }
    } on DioError catch (e) {
      debugPrint("enterPreferences error: ${e.response}");
      return GenericResponse.withError(e.message);
    }
  }

  Future<ShopCategoryResponse> getShopCategory() async {
    // var data = {
    //   'category': 'opinion',
    //   'per_page': per_page,
    //   'page': page,
    // };

    var url = "${baseUrl}/app/shop-categories";
    dio = Dio(option);
    debugPrint(url.toString());
    var data = {'Authorization': 'Bearer ${Storage.instance.token}'};
    debugPrint(jsonEncode(data));

    try {
      Response? response = await dio?.get(
        url,
        // queryParameters: data,
      );
      debugPrint("shop-categories response: ${response?.data}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return ShopCategoryResponse.fromJson(response?.data);
      } else {
        debugPrint("shop-categories error: ${response?.data}");
        return ShopCategoryResponse.withError("Something Went Wrong");
      }
    } on DioError catch (e) {
      debugPrint("shop-categories response: ${e.response}");
      return ShopCategoryResponse.withError(e.message);
    }
  }

  Future<AdvertiseResponse> getAdvertise() async {
    // var data = {
    //   'category': 'opinion',
    //   'per_page': per_page,
    //   'page': page,
    // };

    var url = "${homeUrl}/advertise";
    dio = Dio(option);
    debugPrint(url.toString());
    var data = {'Authorization': 'Bearer ${Storage.instance.token}'};
    debugPrint(jsonEncode(data));

    try {
      Response? response = await dio?.get(
        url,
        // queryParameters: data,
      );
      debugPrint("advertise response: ${response?.data}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return AdvertiseResponse.fromJson(response?.data);
      } else {
        debugPrint("advertise error: ${response?.data}");
        return AdvertiseResponse.withError("Something Went Wrong");
      }
    } on DioError catch (e) {
      debugPrint("advertise error: ${e.response}");
      return AdvertiseResponse.withError(e.message);
    }
  }

  Future<TopPicksResponse> getTopPicks() async {
    var url = "${baseUrl}/app/top-picks";
    dio = Dio(option);
    debugPrint(url.toString());
    var data = {'Authorization': 'Bearer ${Storage.instance.token}'};
    debugPrint(jsonEncode(data));

    try {
      Response? response = await dio?.get(
        url,
        // queryParameters: data,
      );
      debugPrint("toppicks response: ${response?.data}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return TopPicksResponse.fromJson(response?.data);
      } else {
        debugPrint("toppicks error: ${response?.data}");
        return TopPicksResponse.withError("Something Went Wrong");
      }
    } on DioError catch (e) {
      debugPrint("toppicks response: ${e.response}");
      return TopPicksResponse.withError(e.message);
    }
  }

  Future<TopickResponse> getTopicks() async {
    var url = "${baseUrl}/app/topic-geo";
    dio = Dio(option);
    debugPrint(url.toString());
    var data = {'Authorization': 'Bearer ${Storage.instance.token}'};
    debugPrint(jsonEncode(data));

    try {
      Response? response = await dio?.get(
        url,
        // queryParameters: data,
      );
      debugPrint("topicks response: ${response?.data}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return TopickResponse.fromJson(response?.data);
      } else {
        debugPrint("topicks error: ${response?.data}");
        return TopickResponse.withError("Something Went Wrong");
      }
    } on DioError catch (e) {
      debugPrint("topicks response: ${e.response}");
      return TopickResponse.withError(e.message);
    }
  }

  Future download2(String url) async {
    Navigation.instance.goBack();
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var tempDir = "/storage/emulated/0/Download";
    String fullPath = tempDir + "/" + url.split("/")[8];
    print('full path ${fullPath}');
    try {
      Response? response = await dio?.get(
        url,
        onReceiveProgress: showDownloadProgress,
        //Received data with List<int> s
        options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            validateStatus: (status) {
              return status! < 500;
            }),
      );
      print(response?.headers);
      File file = File(fullPath);
      var raf = file.openSync(mode: FileMode.write);
      // response.data is List<int> type
      raf.writeFromSync(response?.data);
      await raf.close();
      Future.delayed(Duration(seconds: 2), () {
        showCompleteDownload(fullPath);
      });
    } catch (e) {
      print(e);
    }
  }

  void showDownloadProgress(received, total) async {
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    if (total != -1) {
      print((received / total * 100).toStringAsFixed(0) + "%");
      await Future<void>.delayed(const Duration(seconds: 1), () async {
        final AndroidNotificationDetails androidPlatformChannelSpecifics =
            AndroidNotificationDetails('progress channel', 'progress channel',
                channelShowBadge: false,
                importance: Importance.max,
                priority: Priority.high,
                onlyAlertOnce: true,
                showProgress: true,
                maxProgress: total,
                progress: received);
        final NotificationDetails platformChannelSpecifics =
            NotificationDetails(android: androidPlatformChannelSpecifics);
        await flutterLocalNotificationsPlugin.show(
            0, 'Saving E-paper', 'Downloading', platformChannelSpecifics,
            payload: 'item x');
      });
    }
  }

  void showCompleteDownload(fullPath) async {
    debugPrint("Completed");
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin.cancelAll().then((value) async {
      const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'progress channel',
        'progress channel',
        channelShowBadge: false,
        importance: Importance.max,
        priority: Priority.high,
        onlyAlertOnce: true,
        showProgress: false,
      );
      const NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);
      await flutterLocalNotificationsPlugin.show(1, 'Epaper Downloaded',
          'Saved Successfully', platformChannelSpecifics,
          payload: fullPath);
    });
  }
}
