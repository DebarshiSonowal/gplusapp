import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:gplusapp/Helper/Storage.dart';
import 'package:gplusapp/Model/profile.dart';
import 'package:gplusapp/Navigation/Navigate.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:path_provider/path_provider.dart';

import '../Model/about_us.dart';
import '../Model/address.dart';
import '../Model/advertise.dart';
import '../Model/article.dart';
import '../Model/article_desc.dart';
import '../Model/citizen_journalist.dart';
import '../Model/comment.dart';
import '../Model/guwahati_connect.dart';
import '../Model/classified.dart';
import '../Model/classified_category.dart';
import '../Model/contact_us.dart';
import '../Model/deal_details.dart';
import '../Model/e_paper.dart';
import '../Model/generic_response.dart';

// import '../Model/login_response.dart';
import '../Model/membership.dart';
import '../Model/opinion.dart';
import '../Model/poll_of_the_week.dart';
import '../Model/promoted_deal.dart';
import '../Model/redeem_details.dart';
import '../Model/redeem_history.dart';
import '../Model/refer_earn_response.dart';
import '../Model/search_result.dart';
import '../Model/shop_category.dart';
import '../Model/top_picks.dart';
import '../Model/topick.dart';
import '../Model/video_news.dart';

class ApiProvider {
  ApiProvider._();

  static final ApiProvider instance = ApiProvider._();
  final String baseUrl = "http://gplus.shecure.co.in/api/v1";

  // final String baseUrl = "http://develop.guwahatiplus.com/api/v1";
  final String homeUrl = "https://www.guwahatiplus.com/api/v1";
  final String path = "/books";

  Dio? dio;

  // Future<LoginResponse> login(mobile) async {
  //   var data = {
  //     'mobile': mobile,
  //   };
  //
  //   var url = "$baseUrl/login";
  //   dio = Dio(option);
  //   debugPrint(url.toString());
  //   debugPrint(jsonEncode(data));
  //
  //   try {
  //     Response? response = await dio?.post(url, data: jsonEncode(data));
  //     debugPrint("login response: ${response?.data}");
  //     if (response?.statusCode == 200 || response?.statusCode == 201) {
  //       return LoginResponse.fromJson(response?.data);
  //     } else {
  //       debugPrint("login error: ${response?.data}");
  //       return LoginResponse.withError(
  //           response?.data['message'] ?? "Something went wrong");
  //     }
  //   } on DioError catch (e) {
  //     debugPrint("login response: ${e.response}");
  //     return LoginResponse.withError(e.message.toString());
  //   }
  // }

  Future<LoginResponse> login(mobile) async {
    var data = {
      'mobile': mobile,
    };
    BaseOptions option =
        BaseOptions(connectTimeout: 80000, receiveTimeout: 80000, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Storage.instance.token}'
      // 'APP-KEY': ConstanceData.app_key
    });
    var url = "${baseUrl}/login";
    dio = Dio(option);
    debugPrint(url.toString());
    debugPrint(jsonEncode(data));

    try {
      Response? response = await dio?.post(url, data: jsonEncode(data));
      debugPrint("login response: ${response?.data}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return LoginResponse.fromJson(response?.data);
      } else {
        debugPrint("login  error: ${response?.data}");
        return LoginResponse.withError();
      }
    } on DioError catch (e) {
      debugPrint("login  response: ${e.response}");
      return LoginResponse.withError();
    }
  }

  Future<SearchResultResponse> search(search, type) async {
    var data = {
      'search': search,
      'type': type,
    };
    BaseOptions option =
        BaseOptions(connectTimeout: 80000, receiveTimeout: 80000, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Storage.instance.token}'
      // 'APP-KEY': ConstanceData.app_key
    });
    var url = "${baseUrl}/";
    dio = Dio(option);
    debugPrint(url.toString());
    debugPrint(jsonEncode(data));

    try {
      Response? response = await dio?.get(
        url,
        queryParameters: data,
      );
      debugPrint("SearchResultResponse response: ${response?.data}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return SearchResultResponse.fromJson(response?.data);
      } else {
        debugPrint("SearchResultResponse  error: ${response?.data}");
        return SearchResultResponse.withError("Something went wrong");
      }
    } on DioError catch (e) {
      debugPrint("SearchResultResponse response: ${e.response}");
      return SearchResultResponse.withError(e.message);
    }
  }

  Future<ProfileResponse> getprofile() async {
    var url = "${baseUrl}/profile";
    BaseOptions option =
        BaseOptions(connectTimeout: 80000, receiveTimeout: 80000, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Storage.instance.token}'
      // 'APP-KEY': ConstanceData.app_key
    });
    dio = Dio(option);
    debugPrint(url.toString());
    // debugPrint(jsonEncode(data));

    try {
      Response? response = await dio?.get(
        url,
      );
      debugPrint("Profile response: ${response?.data}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return ProfileResponse.fromJson(response?.data);
      } else {
        debugPrint("Profile error: ${response?.data}");
        return ProfileResponse.withError("Something went wrong");
      }
    } on DioError catch (e) {
      debugPrint("Profile response: ${e.response}");
      return ProfileResponse.withError(e.message);
    }
  }

  Future<CommentResponse> getComments(comment_for_id, comment_for) async {
    var url = "${baseUrl}/comment";
    BaseOptions option =
        BaseOptions(connectTimeout: 80000, receiveTimeout: 80000, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Storage.instance.token}'
      // 'APP-KEY': ConstanceData.app_key
    });
    dio = Dio(option);
    debugPrint(url.toString());
    var data = {
      'comment_for_id': comment_for_id,
      'comment_for': comment_for,
    };
    debugPrint(jsonEncode(data));

    try {
      Response? response = await dio?.get(
        url,
        queryParameters: data,
      );
      debugPrint("CommentResponse response: ${response?.data}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return CommentResponse.fromJson(response?.data);
      } else {
        debugPrint("CommentResponse error: ${response?.data}");
        return CommentResponse.withError("Something went wrong");
      }
    } on DioError catch (e) {
      debugPrint("CommentResponse response: ${e.response}");
      return CommentResponse.withError(e.message);
    }
  }

  Future<ProfileResponse> createProfile(
    address_id,
    mobile,
    f_name,
    l_name,
    email,
    dob,
    address,
    longitude,
    latitude,
    topic_ids,
    geo_ids,
    has_deal_notify_perm,
    has_ghy_connect_notify_perm,
    has_classified_notify_perm,
    gender,
  ) async {
    BaseOptions option =
        BaseOptions(connectTimeout: 80000, receiveTimeout: 80000, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Storage.instance.token}'
      // 'APP-KEY': ConstanceData.app_key
    });
    var data = {
      'mobile': mobile,
      'f_name': f_name,
      'l_name': l_name,
      'email': email,
      'dob': dob,
      'gender': gender == 'Male'
          ? 1
          : gender == 'Female'
              ? 2
              : 0,
      'address': address,
      'longitude': longitude,
      'latitude': latitude,
      'address_id': address_id,
      'topic_ids': topic_ids,
      'geo_ids': geo_ids,
      'has_deal_notify_perm': has_deal_notify_perm,
      'has_ghy_connect_notify_perm': has_ghy_connect_notify_perm,
      'has_classified_notify_perm': has_classified_notify_perm,
    };
    var url = "${baseUrl}/profile";
    dio = Dio(option);
    debugPrint(url.toString());
    debugPrint(jsonEncode(data));

    try {
      Response? response = await dio?.post(url, data: jsonEncode(data));
      debugPrint("create Profile response: ${response?.data}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return ProfileResponse.fromJson(response?.data);
      } else {
        debugPrint("create Profile error: ${response?.data}");
        return ProfileResponse.withError("Something went wrong");
      }
    } on DioError catch (e) {
      debugPrint("create Profile error: ${e.response}");
      return ProfileResponse.withError(e.message);
    }
  }

  Future<ArticleResponse> getArticle(categ_name) async {
    // var data = {
    //   // 'mobile': mobile,
    // };
    BaseOptions option =
        BaseOptions(connectTimeout: 80000, receiveTimeout: 80000, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Storage.instance.token}'
      // 'APP-KEY': ConstanceData.app_key
    });
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

  Future<AddressResponse> getAddress() async {
    // var data = {
    //   // 'mobile': mobile,
    // };
    BaseOptions option =
        BaseOptions(connectTimeout: 80000, receiveTimeout: 80000, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Storage.instance.token}'
      // 'APP-KEY': ConstanceData.app_key
    });
    var url = "${baseUrl}/address-list";
    dio = Dio(option);
    debugPrint(url.toString());
    // debugPrint(jsonEncode(data));

    try {
      Response? response = await dio?.get(
        url,
      );
      debugPrint("address-list response: ${response?.data}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return AddressResponse.fromJson(response?.data);
      } else {
        debugPrint("address-list error: ${response?.data}");
        return AddressResponse.withError("Something Went Wrong");
      }
    } on DioError catch (e) {
      debugPrint("address-list response: ${e.response}");
      return AddressResponse.withError(e.message);
    }
  }

  Future<AddressResponse> postAddress(address, lat, lang) async {
    var data = {
      'address': address,
      'latitude': lat,
      'longitude': lang,
    };
    BaseOptions option =
        BaseOptions(connectTimeout: 80000, receiveTimeout: 80000, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Storage.instance.token}'
      // 'APP-KEY': ConstanceData.app_key
    });
    var url = "${baseUrl}/address";
    dio = Dio(option);
    debugPrint(url.toString());
    // debugPrint(jsonEncode(data));

    try {
      Response? response = await dio?.post(
        url,
        data: data,
      );
      debugPrint("address response: ${response?.headers}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return AddressResponse.fromJson(response?.data);
      } else {
        debugPrint("address error: ${response?.data}");
        return AddressResponse.withError("Something Went Wrong");
      }
    } on DioError catch (e) {
      debugPrint("address response: ${e.response} ${e.response?.headers}");
      return AddressResponse.withError(e.message);
    }
  }

  Future<ArticleDetailsResponse> getArticleDetails(categ_name, slug) async {
    // var data = {
    //   // 'mobile': mobile,
    // };
    BaseOptions option =
        BaseOptions(connectTimeout: 80000, receiveTimeout: 80000, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Storage.instance.token}'
      // 'APP-KEY': ConstanceData.app_key
    });
    var url = "${homeUrl}/${categ_name}/${slug}";
    dio = Dio(option);
    debugPrint(url.toString());
    // debugPrint(jsonEncode(data));

    try {
      Response? response = await dio?.get(
        url,
      );
      debugPrint("Article Details response: ${response?.data}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return ArticleDetailsResponse.fromJson(response?.data);
      } else {
        debugPrint("Article Details error: ${response?.data}");
        return ArticleDetailsResponse.withError("Something Went Wrong");
      }
    } on DioError catch (e) {
      debugPrint("Article Details response: ${e.response}");
      return ArticleDetailsResponse.withError(e.message);
    }
  }

  Future<OpinionResponse> getOpinion(per_page, page) async {
    var data = {
      'category': 'opinion',
      'per_page': per_page,
      'page': page,
    };
    BaseOptions option =
        BaseOptions(connectTimeout: 80000, receiveTimeout: 80000, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Storage.instance.token}'
      // 'APP-KEY': ConstanceData.app_key
    });
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
    BaseOptions option =
        BaseOptions(connectTimeout: 80000, receiveTimeout: 80000, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Storage.instance.token}'
      // 'APP-KEY': ConstanceData.app_key
    });
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
    BaseOptions option =
        BaseOptions(connectTimeout: 80000, receiveTimeout: 80000, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Storage.instance.token}'
      // 'APP-KEY': ConstanceData.app_key
    });
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
    BaseOptions option =
        BaseOptions(connectTimeout: 80000, receiveTimeout: 80000, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Storage.instance.token}'
      // 'APP-KEY': ConstanceData.app_key
    });
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
    BaseOptions option =
        BaseOptions(connectTimeout: 80000, receiveTimeout: 80000, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Storage.instance.token}'
      // 'APP-KEY': ConstanceData.app_key
    });
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
    BaseOptions option =
        BaseOptions(connectTimeout: 80000, receiveTimeout: 80000, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Storage.instance.token}'
      // 'APP-KEY': ConstanceData.app_key
    });
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
    BaseOptions option =
        BaseOptions(connectTimeout: 80000, receiveTimeout: 80000, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Storage.instance.token}'
      // 'APP-KEY': ConstanceData.app_key
    });
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
    BaseOptions option =
        BaseOptions(connectTimeout: 80000, receiveTimeout: 80000, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Storage.instance.token}'
      // 'APP-KEY': ConstanceData.app_key
    });
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
    BaseOptions option =
        BaseOptions(connectTimeout: 80000, receiveTimeout: 80000, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Storage.instance.token}'
      // 'APP-KEY': ConstanceData.app_key
    });
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
    BaseOptions option =
        BaseOptions(connectTimeout: 80000, receiveTimeout: 80000, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Storage.instance.token}'
      // 'APP-KEY': ConstanceData.app_key
    });
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
    BaseOptions option =
        BaseOptions(connectTimeout: 80000, receiveTimeout: 80000, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Storage.instance.token}'
      // 'APP-KEY': ConstanceData.app_key
    });
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
    BaseOptions option =
        BaseOptions(connectTimeout: 80000, receiveTimeout: 80000, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Storage.instance.token}'
      // 'APP-KEY': ConstanceData.app_key
    });
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
    BaseOptions option =
        BaseOptions(connectTimeout: 80000, receiveTimeout: 80000, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Storage.instance.token}'
      // 'APP-KEY': ConstanceData.app_key
    });
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

  Future<RedeemHistoryResponse> getRedeemHistory() async {
    // var data = {
    //   'category': 'opinion',
    //   'per_page': per_page,
    //   'page': page,
    // };
    BaseOptions option =
        BaseOptions(connectTimeout: 80000, receiveTimeout: 80000, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Storage.instance.token}'
      // 'APP-KEY': ConstanceData.app_key
    });
    var url = "${baseUrl}/app/big-deal-history";
    dio = Dio(option);
    debugPrint(url.toString());
    var data = {'Authorization': 'Bearer ${Storage.instance.token}'};
    debugPrint(jsonEncode(data));

    try {
      Response? response = await dio?.get(
        url,
        // queryParameters: data,
      );
      debugPrint("RedeemHistoryResponse response: ${response?.data}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return RedeemHistoryResponse.fromJson(response?.data);
      } else {
        debugPrint("RedeemHistoryResponse error: ${response?.data}");
        return RedeemHistoryResponse.withError("Something Went Wrong");
      }
    } on DioError catch (e) {
      debugPrint("RedeemHistoryResponse response: ${e.response}");
      return RedeemHistoryResponse.withError(e.message);
    }
  }

  Future<AdvertiseResponse> getAdvertise() async {
    // var data = {
    //   'category': 'opinion',
    //   'per_page': per_page,
    //   'page': page,
    // };
    BaseOptions option =
        BaseOptions(connectTimeout: 80000, receiveTimeout: 80000, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Storage.instance.token}'
      // 'APP-KEY': ConstanceData.app_key
    });
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
    BaseOptions option =
        BaseOptions(connectTimeout: 80000, receiveTimeout: 80000, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Storage.instance.token}'
      // 'APP-KEY': ConstanceData.app_key
    });
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
    BaseOptions option =
        BaseOptions(connectTimeout: 80000, receiveTimeout: 80000, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Storage.instance.token}'
      // 'APP-KEY': ConstanceData.app_key
    });
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

  Future<ClassifiedResponse> getClassified() async {
    var url = "${baseUrl}/app/classified/my-list";
    BaseOptions option =
        BaseOptions(connectTimeout: 80000, receiveTimeout: 80000, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Storage.instance.token}'
      // 'APP-KEY': ConstanceData.app_key
    });
    dio = Dio(option);
    debugPrint(url.toString());
    var data = {'Authorization': 'Bearer ${Storage.instance.token}'};
    debugPrint(jsonEncode(data));

    try {
      Response? response = await dio?.get(
        url,
        // queryParameters: data,
      );
      debugPrint("ClassifiedResponse response: ${response?.data}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return ClassifiedResponse.fromJson(response?.data);
      } else {
        debugPrint("ClassifiedResponse error: ${response?.data}");
        return ClassifiedResponse.withError("Something Went Wrong");
      }
    } on DioError catch (e) {
      debugPrint("ClassifiedResponse response: ${e.response}");
      return ClassifiedResponse.withError(e.message);
    }
  }

  Future<ClassifiedCategoryResponse> getClassifiedCategory() async {
    var url = "${baseUrl}/app/classifies-categories-localities";
    BaseOptions option =
        BaseOptions(connectTimeout: 80000, receiveTimeout: 80000, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Storage.instance.token}'
      // 'APP-KEY': ConstanceData.app_key
    });
    dio = Dio(option);
    debugPrint(url.toString());
    var data = {'Authorization': 'Bearer ${Storage.instance.token}'};
    debugPrint(jsonEncode(data));

    try {
      Response? response = await dio?.get(
        url,
        // queryParameters: data,
      );
      debugPrint("ClassifiedCategoryResponse response: ${response?.data}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return ClassifiedCategoryResponse.fromJson(response?.data);
      } else {
        debugPrint("ClassifiedCategoryResponse error: ${response?.data}");
        return ClassifiedCategoryResponse.withError("Something Went Wrong");
      }
    } on DioError catch (e) {
      debugPrint("ClassifiedCategoryResponse response: ${e.response}");
      return ClassifiedCategoryResponse.withError(e.message);
    }
  }

  Future<ReferEarnResponse> getReferAndEarn() async {
    var url = "${baseUrl}/app/get-refer-n-earn";
    BaseOptions option =
        BaseOptions(connectTimeout: 80000, receiveTimeout: 80000, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Storage.instance.token}'
      // 'APP-KEY': ConstanceData.app_key
    });
    dio = Dio(option);
    debugPrint(url.toString());
    var data = {'Authorization': 'Bearer ${Storage.instance.token}'};
    debugPrint(jsonEncode(data));

    try {
      Response? response = await dio?.get(
        url,
        // queryParameters: data,
      );
      debugPrint("ReferEarnResponse response: ${response?.data}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return ReferEarnResponse.fromJson(response?.data);
      } else {
        debugPrint("ReferEarnResponse error: ${response?.data}");
        return ReferEarnResponse.withError("Something Went Wrong");
      }
    } on DioError catch (e) {
      debugPrint("ReferEarnResponse response: ${e.response}");
      return ReferEarnResponse.withError(e.message);
    }
  }

  Future<AboutUsResponse> getAboutUs() async {
    var url = "${baseUrl}/app/pages/about";
    BaseOptions option =
        BaseOptions(connectTimeout: 80000, receiveTimeout: 80000, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Storage.instance.token}'
      // 'APP-KEY': ConstanceData.app_key
    });
    dio = Dio(option);
    debugPrint(url.toString());
    var data = {'Authorization': 'Bearer ${Storage.instance.token}'};
    debugPrint(jsonEncode(data));

    try {
      Response? response = await dio?.get(
        url,
        // queryParameters: data,
      );
      debugPrint("AboutUsResponse response: ${response?.data}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return AboutUsResponse.fromJson(response?.data);
      } else {
        debugPrint("AboutUsResponse error: ${response?.data}");
        return AboutUsResponse.withError("Something Went Wrong");
      }
    } on DioError catch (e) {
      debugPrint("AboutUsResponse response: ${e.response}");
      return AboutUsResponse.withError(e.message);
    }
  }

  Future<AboutUsResponse> getPrivacyPolicy() async {
    var url = "${baseUrl}/app/pages/privacy-n-policy";
    BaseOptions option =
        BaseOptions(connectTimeout: 80000, receiveTimeout: 80000, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Storage.instance.token}'
      // 'APP-KEY': ConstanceData.app_key
    });
    dio = Dio(option);
    debugPrint(url.toString());
    var data = {'Authorization': 'Bearer ${Storage.instance.token}'};
    debugPrint(jsonEncode(data));

    try {
      Response? response = await dio?.get(
        url,
        // queryParameters: data,
      );
      debugPrint("privacy-n-policy response: ${response?.data}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return AboutUsResponse.fromJson(response?.data);
      } else {
        debugPrint("privacy-n-policy error: ${response?.data}");
        return AboutUsResponse.withError("Something Went Wrong");
      }
    } on DioError catch (e) {
      debugPrint("privacy-n-policy response: ${e.response}");
      return AboutUsResponse.withError(e.message);
    }
  }

  Future<ContactUsResponse> getContactUs() async {
    var url = "${baseUrl}/app/pages/contact";
    BaseOptions option =
        BaseOptions(connectTimeout: 80000, receiveTimeout: 80000, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Storage.instance.token}'
      // 'APP-KEY': ConstanceData.app_key
    });
    dio = Dio(option);
    debugPrint(url.toString());
    var data = {'Authorization': 'Bearer ${Storage.instance.token}'};
    debugPrint(jsonEncode(data));

    try {
      Response? response = await dio?.get(
        url,
        // queryParameters: data,
      );
      debugPrint("ContactUsResponse response: ${response?.data}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return ContactUsResponse.fromJson(response?.data);
      } else {
        debugPrint("ContactUsResponse error: ${response?.data}");
        return ContactUsResponse.withError("Something Went Wrong");
      }
    } on DioError catch (e) {
      debugPrint("ContactUsResponse response: ${e.response}");
      return ContactUsResponse.withError(e.message);
    }
  }

  Future<GuwahatiConnectResponse> getGuwahatiConnect() async {
    var url = "${baseUrl}/app/guwahati-connect";
    BaseOptions option =
        BaseOptions(connectTimeout: 80000, receiveTimeout: 80000, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Storage.instance.token}'
      // 'APP-KEY': ConstanceData.app_key
    });
    dio = Dio(option);
    debugPrint(url.toString());
    var data = {'Authorization': 'Bearer ${Storage.instance.token}'};
    debugPrint(jsonEncode(data));

    try {
      Response? response = await dio?.get(
        url,
        // queryParameters: data,
      );
      debugPrint("guwahati-connect response: ${response?.data}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return GuwahatiConnectResponse.fromJson(response?.data);
      } else {
        debugPrint("guwahati-connect error: ${response?.data}");
        return GuwahatiConnectResponse.withError("Something Went Wrong");
      }
    } on DioError catch (e) {
      debugPrint("guwahati-connect error: ${e.response}");
      return GuwahatiConnectResponse.withError(e.message);
    }
  }

  Future<CitizenJournalistResponse> getCitizenJournalistDraft() async {
    var url = "${baseUrl}/app/citizen-journalist-list/draft";
    BaseOptions option =
        BaseOptions(connectTimeout: 80000, receiveTimeout: 80000, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Storage.instance.token}'
      // 'APP-KEY': ConstanceData.app_key
    });
    dio = Dio(option);
    debugPrint(url.toString());
    var data = {'Authorization': 'Bearer ${Storage.instance.token}'};
    debugPrint(jsonEncode(data));

    try {
      Response? response = await dio?.get(
        url,
        // queryParameters: data,
      );
      debugPrint("citizen-journalist-list response: ${response?.data}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return CitizenJournalistResponse.fromJson(response?.data);
      } else {
        debugPrint("citizen-journalist-list error: ${response?.data}");
        return CitizenJournalistResponse.withError("Something Went Wrong");
      }
    } on DioError catch (e) {
      debugPrint("citizen-journalist-list error: ${e.response}");
      return CitizenJournalistResponse.withError(e.message);
    }
  }

  Future<PollOfTheWeekResponse> getPollOfTheWeek() async {
    var url = "${baseUrl}/app/poll-question";
    BaseOptions option =
        BaseOptions(connectTimeout: 80000, receiveTimeout: 80000, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Storage.instance.token}'
      // 'APP-KEY': ConstanceData.app_key
    });
    dio = Dio(option);
    debugPrint(url.toString());
    var data = {'Authorization': 'Bearer ${Storage.instance.token}'};
    debugPrint(jsonEncode(data));

    try {
      Response? response = await dio?.get(
        url,
        // queryParameters: data,
      );
      debugPrint("PollOfTheWeekResponse: ${response?.data}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return PollOfTheWeekResponse.fromJson(response?.data);
      } else {
        debugPrint("PollOfTheWeekResponse error: ${response?.data}");
        return PollOfTheWeekResponse.withError("Something Went Wrong");
      }
    } on DioError catch (e) {
      debugPrint("PollOfTheWeekResponse response: ${e.response}");
      return PollOfTheWeekResponse.withError(e.message);
    }
  }

  Future<GenericResponse> postPollOfTheWeek(
      poll_question_id, ans_option) async {
    var url = "${baseUrl}/app/post-poll-answer";
    BaseOptions option =
        BaseOptions(connectTimeout: 80000, receiveTimeout: 80000, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Storage.instance.token}'
      // 'APP-KEY': ConstanceData.app_key
    });
    dio = Dio(option);
    debugPrint(url.toString());
    var data = {
      'poll_question_id': poll_question_id,
      'ans_option': ans_option,
    };
    //attachment_list[0][file_data]
    //attachment_list[0][file_type]
    // debugPrint(jsonEncode(data));

    try {
      Response? response = await dio?.post(
        url,
        data: data,
        // queryParameters: data,
      );
      debugPrint("postPollOfTheWeek response: ${response?.data}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return GenericResponse.fromJson(response?.data);
      } else {
        debugPrint("postPollOfTheWeek error: ${response?.data}");
        return GenericResponse.withError("Something Went Wrong");
      }
    } on DioError catch (e) {
      debugPrint("postPollOfTheWeek error: ${e.response}");
      return GenericResponse.withError(e.message);
    }
  }

  Future<GenericResponse> postLike(comment_id, is_liked) async {
    var url = "${baseUrl}/app/like";
    BaseOptions option =
        BaseOptions(connectTimeout: 80000, receiveTimeout: 80000, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Storage.instance.token}'
      // 'APP-KEY': ConstanceData.app_key
    });
    dio = Dio(option);
    debugPrint(url.toString());
    var data = {
      'comment_id': comment_id,
      'is_liked': is_liked,
    };
    //attachment_list[0][file_data]
    //attachment_list[0][file_type]
    // debugPrint(jsonEncode(data));

    try {
      Response? response = await dio?.post(
        url,
        data: data,
        // queryParameters: data,
      );
      debugPrint("postLike response: ${response?.data}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return GenericResponse.fromJson(response?.data);
      } else {
        debugPrint("postLike error: ${response?.data}");
        return GenericResponse.withError("Something Went Wrong");
      }
    } on DioError catch (e) {
      debugPrint("postLike error: ${e.response}");
      return GenericResponse.withError(e.message);
    }
  }

  Future<GenericResponse> postComment(
      comment_for_id, comment_for, comment) async {
    var url = "${baseUrl}/app/comment";
    BaseOptions option =
        BaseOptions(connectTimeout: 80000, receiveTimeout: 80000, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Storage.instance.token}'
      // 'APP-KEY': ConstanceData.app_key
    });
    dio = Dio(option);
    debugPrint(url.toString());
    var data = {
      'comment_for_id': comment_for_id,
      'comment_for': comment_for,
      'comment': comment,
    };
    //attachment_list[0][file_data]
    //attachment_list[0][file_type]
    // debugPrint(jsonEncode(data));

    try {
      Response? response = await dio?.post(
        url,
        data: data,
        // queryParameters: data,
      );
      debugPrint("postComment response: ${response?.data}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return GenericResponse.fromJson(response?.data);
      } else {
        debugPrint("postComment error: ${response?.data}");
        return GenericResponse.withError("Something Went Wrong");
      }
    } on DioError catch (e) {
      debugPrint("postComment error: ${e.response}");
      return GenericResponse.withError(e.message);
    }
  }

  Future<GenericResponse> postClassified(classified_category_id, locality_id,
      title, description, price, List<File> files) async {
    var url = "${baseUrl}/app/classified";
    BaseOptions option =
        BaseOptions(connectTimeout: 80000, receiveTimeout: 80000, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Storage.instance.token}'
      // 'APP-KEY': ConstanceData.app_key
    });
    dio = Dio(option);
    debugPrint(url.toString());
    FormData data = FormData.fromMap({
      'classified_category_id': classified_category_id,
      'locality_id': locality_id,
      'title': title,
      'description': description,
      'price': price,
    });
    for (int i = 0; i < files.length; i++) {
      var type = lookupMimeType(files[i].path, headerBytes: [0xFF, 0xD8])!;
      MultipartFile file = await MultipartFile.fromFile(
        files[i].path,
        filename: files[i].path.split("/").last,
        contentType:
            MediaType(type.split('/').first, type.split('/').last), //important
      );
      // data[''] = file;
      data.files.add(MapEntry('attachment_list[${i}][file_data]', file));
      data.fields.add(MapEntry('attachment_list[${i}][file_type]', type));
    }
    //attachment_list[0][file_data]
    //attachment_list[0][file_type]
    // debugPrint(jsonEncode(data));

    try {
      Response? response = await dio?.post(
        url,
        data: data,
        // queryParameters: data,
      );
      debugPrint("postClassified response: ${response?.data}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return GenericResponse.fromJson(response?.data);
      } else {
        debugPrint("postClassified error: ${response?.data}");
        return GenericResponse.withError("Something Went Wrong");
      }
    } on DioError catch (e) {
      debugPrint("postClassified error: ${e.response}");
      return GenericResponse.withError(e.message);
    }
  }

  Future<GenericResponse> postCitizenJournalist(
      title, story, List<File> files) async {
    var url = "${baseUrl}/app/citizen-journalist";
    BaseOptions option =
        BaseOptions(connectTimeout: 80000, receiveTimeout: 80000, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Storage.instance.token}'
      // 'APP-KEY': ConstanceData.app_key
    });
    dio = Dio(option);
    debugPrint(url.toString());
    FormData data = FormData.fromMap({
      'title': title,
      'story': story,
    });
    for (int i = 0; i < files.length; i++) {
      var type = lookupMimeType(files[i].path, headerBytes: [0xFF, 0xD8])!;
      MultipartFile file = await MultipartFile.fromFile(
        files[i].path,
        filename: files[i].path.split("/").last,
        contentType:
            MediaType(type.split('/').first, type.split('/').last), //important
      );
      // data[''] = file;
      data.files.add(MapEntry('attachment_list[${i}][file_data]', file));
      data.fields.add(MapEntry('attachment_list[${i}][file_type]', type));
    }
    //attachment_list[0][file_data]
    //attachment_list[0][file_type]
    // debugPrint(jsonEncode(data));

    try {
      Response? response = await dio?.post(
        url,
        data: data,
        // queryParameters: data,
      );
      debugPrint("postCitizenJournalist response: ${response?.data}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return GenericResponse.fromJson(response?.data);
      } else {
        debugPrint("postCitizenJournalist error: ${response?.data}");
        return GenericResponse.withError("Something Went Wrong");
      }
    } on DioError catch (e) {
      debugPrint("postCitizenJournalist error: ${e.response}");
      return GenericResponse.withError(e.message);
    }
  }

  Future<GenericResponse> postGuwhahatiConnect(
      question, List<File> files) async {
    var url = "${baseUrl}/app/guwahati-connect";
    BaseOptions option =
        BaseOptions(connectTimeout: 80000, receiveTimeout: 80000, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Storage.instance.token}'
      // 'APP-KEY': ConstanceData.app_key
    });
    dio = Dio(option);
    debugPrint(url.toString());
    FormData data = FormData.fromMap({
      'question': question,
    });
    for (int i = 0; i < files.length; i++) {
      var type = lookupMimeType(files[i].path, headerBytes: [0xFF, 0xD8])!;
      MultipartFile file = await MultipartFile.fromFile(
        files[i].path,
        filename: files[i].path.split("/").last,
        contentType:
            MediaType(type.split('/').first, type.split('/').last), //important
      );
      // data[''] = file;
      data.files.add(MapEntry('attachment_list[${i}][file_data]', file));
      data.fields.add(MapEntry('attachment_list[${i}][file_type]', type));
    }
    //attachment_list[0][file_data]
    //attachment_list[0][file_type]
    // debugPrint(jsonEncode(data));

    try {
      Response? response = await dio?.post(
        url,
        data: data,
        // queryParameters: data,
      );
      debugPrint("postguwahati-connect response: ${response?.data}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return GenericResponse.fromJson(response?.data);
      } else {
        debugPrint("postguwahati-connect error: ${response?.data}");
        return GenericResponse.withError("Something Went Wrong");
      }
    } on DioError catch (e) {
      debugPrint("postguwahati-connect error: ${e.response}");
      return GenericResponse.withError(e.message);
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
