import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:gplusapp/Helper/Storage.dart';
import 'package:gplusapp/Model/bookmark_item.dart';
import 'package:gplusapp/Model/profile.dart';
import 'package:gplusapp/Navigation/Navigate.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

import '../Components/alert.dart';
import '../Model/about_us.dart';
import '../Model/address.dart';
import '../Model/advertise.dart';
import '../Model/article.dart';
import '../Model/article_desc.dart';
import '../Model/blocked_user.dart';
import '../Model/citizen_journalist.dart';
import '../Model/classified.dart';
import '../Model/classified_category.dart';
import '../Model/comment.dart';
import '../Model/contact_us.dart';
import '../Model/deal_details.dart';
import '../Model/e_paper.dart';
import '../Model/generic_response.dart';
import '../Model/grievence_redresal_send.dart';
import '../Model/guwahati_connect.dart';

// import '../Model/login_response.dart';
import '../Model/membership.dart';
import '../Model/message_response.dart';
import '../Model/notification_in_device.dart';
import '../Model/opinion.dart';
import '../Model/order.dart';
import '../Model/poll_of_the_week.dart';
import '../Model/promoted_deal.dart';
import '../Model/razorpay_key.dart';
import '../Model/redeem_details.dart';
import '../Model/redeem_history.dart';
import '../Model/referEarnHistory.dart';
import '../Model/refer_earn_response.dart';
import '../Model/report_model.dart';
import '../Model/search_result.dart';
import '../Model/shop.dart';
import '../Model/shop_category.dart';
import '../Model/story.dart';
import '../Model/swtich_status.dart';
import '../Model/top_picks.dart';
import '../Model/topick.dart';
import '../Model/video_news.dart';

class ApiProvider {
  ApiProvider._();

  static final ApiProvider instance = ApiProvider._();

  // final String baseUrl = "http://gplus.shecure.co.in/api/v1";
  final String baseUrl = "https://www.guwahatiplus.com/api/v1";

  final String baseUrl2 = "http://develop.guwahatiplus.com/api/v1";
  final String homeUrl = "https://www.guwahatiplus.com/api/v1";
  final String path = "/books";

  Dio? dio;

  Future<LoginResponse> login(mobile) async {
    var data = {
      'mobile': mobile,
    };
    BaseOptions option =
        BaseOptions(connectTimeout: 80000, receiveTimeout: 80000, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      // 'Authorization': 'Bearer ${Storage.instance.token}'
      // 'APP-KEY': ConstanceData.app_key
    });
    var url = "${baseUrl}/app/login";
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
    var url = "${baseUrl}/app/";
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
      if (e.response?.statusCode == 420) {
        Storage.instance.logout();
        Navigation.instance.navigateAndRemoveUntil('/login');
        showError("Oops! Your session expired. Please Login Again");
      }
      debugPrint("SearchResultResponse response: ${e.response}");
      return SearchResultResponse.withError(e.message);
    }
  }

  Future<OthersSearchResultResponse> Otherssearch(search, type) async {
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
    var url = "${baseUrl}/app/";
    dio = Dio(option);
    debugPrint(url.toString());
    debugPrint(jsonEncode(data));

    try {
      Response? response = await dio?.get(
        url,
        queryParameters: data,
      );
      debugPrint("OthersSearchResultResponse response: ${response?.data}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return OthersSearchResultResponse.fromJson(response?.data);
      } else {
        debugPrint("OthersSearchResultResponse  error: ${response?.data}");
        return OthersSearchResultResponse.withError("Something went wrong");
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 420) {
        Storage.instance.logout();
        Navigation.instance.navigateAndRemoveUntil('/login');
        showError("Oops! Your session expired. Please Login Again");
      }
      debugPrint("OthersSearchResultResponse response: ${e.response}");
      return OthersSearchResultResponse.withError(e.message);
    }
  }

  Future<ProfileResponse2> getprofile() async {
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
        return ProfileResponse2.fromJson(response?.data);
      } else {
        debugPrint("Profile error: ${response?.data}");
        return ProfileResponse2.withError("Something went wrong");
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 420) {
        Storage.instance.logout();
        Navigation.instance.navigateAndRemoveUntil('/login');
        showError("Oops! Your session expired. Please Login Again");
      }
      if (e.response?.statusCode == 450) {
        Storage.instance.logout();
        Navigation.instance.navigateAndRemoveUntil('/login');
        showError("Your blocked by our account. Please Contact G Plus Admin");
      }
      debugPrint("Profile error response: ${e.response}");
      return ProfileResponse2.withError(e.message);
    }
  }

  Future<AuthorResponse> getAuthor(id) async {
    var url = "${baseUrl}/app/author-detail/${id}";
    BaseOptions option =
        BaseOptions(connectTimeout: 80000, receiveTimeout: 80000, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Auth'
          ''
          ''
          ''
          'orization': 'Bearer ${Storage.instance.token}'
      // 'APP-KEY': ConstanceData.app_key
    });
    dio = Dio(option);
    debugPrint(url.toString());
    // debugPrint(jsonEncode(data));

    try {
      Response? response = await dio?.get(
        url,
      );
      // debugPrint("AuthorResponse response: ${response?.data}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return AuthorResponse.fromJson(response?.data);
      } else {
        debugPrint("AuthorResponse error: ${response?.data}");
        return AuthorResponse.withError("Something went wrong");
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 420) {
        Storage.instance.logout();
        Navigation.instance.navigateAndRemoveUntil('/login');
        showError("Oops! Your session expired. Please Login Again");
      }
      debugPrint("AuthorResponse response: ${e.response}");
      return AuthorResponse.withError(e.message);
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
      if (e.response?.statusCode == 420) {
        Storage.instance.logout();
        Navigation.instance.navigateAndRemoveUntil('/login');
        showError("Oops! Your session expired. Please Login Again");
      }
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
      referal,
      is_new) async {
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
      'referred_by_code': referal,
      'is_new': is_new
    };
    var url = "${baseUrl}/profile";
    dio = Dio(option);
    debugPrint(url.toString());
    debugPrint(jsonEncode(data));

    try {
      Response? response = await dio?.post(url, data: jsonEncode(data));
      debugPrint("create Profile response: ${response?.data}", wrapWidth: 1024);
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return ProfileResponse.fromJson(response?.data);
      } else {
        debugPrint(
            "create Profile error: ${response?.statusCode} ${response?.data}",
            wrapWidth: 1024);
        return ProfileResponse.withError(response?.data['message']??"Something went wrong");
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 420) {
        Storage.instance.logout();
        Navigation.instance.navigateAndRemoveUntil('/login');
        showError("Oops! Your session expired. Please Login Again");
      }
      debugPrint(
          "create Profile error: ${e.response?.statusCode ?? 0} ${e.response}",
          wrapWidth: 1024);
      return ProfileResponse.withError(e.response!.data['message']??"Something went wrong");
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
      debugPrint("Article response: ");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return ArticleResponse.fromJson(response?.data);
      } else {
        debugPrint("Article error: ${response?.data}");
        return ArticleResponse.withError("Something Went Wrong");
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 420) {
        Storage.instance.logout();
        Navigation.instance.navigateAndRemoveUntil('/login');
        showError("Oops! Your session expired. Please Login Again");
      }
      debugPrint("Article response: ${e.response}");
      return ArticleResponse.withError(e.message);
    }
  }

  Future<CategoryArticleResponse> getCategoryArticle(
      categ_name, page_no) async {
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
    var url = "${homeUrl}/topic/${categ_name}";
    dio = Dio(option);
    debugPrint(url.toString());
    var data = {
      'page': page_no,
      'per_page': 8,
    };
    debugPrint(jsonEncode(data));
    debugPrint(
        jsonEncode({'Authorization': 'Bearer ${Storage.instance.token}'}));

    try {
      Response? response = await dio?.get(
        url,
        queryParameters: data,
      );
      debugPrint("topics/${categ_name} Article response: ");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return CategoryArticleResponse.fromJson(response?.data);
      } else {
        debugPrint("topics/${categ_name} Article error: ${response?.data}");
        return CategoryArticleResponse.withError("Something Went Wrong");
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 420) {
        Storage.instance.logout();
        Navigation.instance.navigateAndRemoveUntil('/login');
        showError("Oops! Your session expired. Please Login Again");
      }
      debugPrint("topics/${categ_name} Article response: ${e.response}");
      return CategoryArticleResponse.withError(e.message);
    }
  }

  Future<ArticleResponse> getMoreArticle(
      categ_name, per_page, page, skip) async {
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
    var url = "${homeUrl}/${categ_name}/news1";
    dio = Dio(option);
    debugPrint(url.toString());
    var data = {
      'per_page': per_page,
      'page': page,
      'skip': skip,
    };
    debugPrint(jsonEncode(data));

    try {
      Response? response = await dio?.get(
        url,
        queryParameters: data,
      );
      // debugPrint("More Article response: ${response?.data}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return ArticleResponse.fromJson(response?.data);
      } else {
        debugPrint("More Article error: ${response?.data}");
        return ArticleResponse.withError("Something Went Wrong");
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 420) {
        Storage.instance.logout();
        Navigation.instance.navigateAndRemoveUntil('/login');
        showError("Oops! Your session expired. Please Login Again");
      }
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
      if (e.response?.statusCode == 420) {
        Storage.instance.logout();
        Navigation.instance.navigateAndRemoveUntil('/login');
        showError("Oops! Your session expired. Please Login Again");
      }
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
    debugPrint(jsonEncode(data));

    try {
      Response? response = await dio?.post(
        url,
        data: data,
      );
      debugPrint("address added response: ${response?.data}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return AddressResponse.fromJson(response?.data);
      } else {
        debugPrint("address error: ${response?.data}");
        return AddressResponse.withError("Something Went Wrong");
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 420) {
        Storage.instance.logout();
        Navigation.instance.navigateAndRemoveUntil('/login');
        showError("Oops! Your session expired. Please Login Again");
      }
      debugPrint("address response: ${e.response} ${e.response?.headers}");
      return AddressResponse.withError(e.message);
    }
  }

  Future<AddressResponse> updateAddress(address, lat, lang, id, title) async {
    var data = {
      'address': address,
      'latitude': lat,
      'longitude': lang,
      'title': title,
    };
    BaseOptions option =
        BaseOptions(connectTimeout: 80000, receiveTimeout: 80000, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Storage.instance.token}'
      // 'APP-KEY': ConstanceData.app_key
    });
    var url = "${baseUrl}/address/${id}";
    dio = Dio(option);
    debugPrint(url.toString());
    debugPrint(jsonEncode(data));

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
      if (e.response?.statusCode == 420) {
        Storage.instance.logout();
        Navigation.instance.navigateAndRemoveUntil('/login');
        showError("Oops! Your session expired. Please Login Again");
      }
      debugPrint("address response: ${e.response} ${e.response?.headers}");
      return AddressResponse.withError(e.message);
    }
  }

  Future<AddressResponse> deleteAddress(id) async {
    // var data = {
    //   'address': address,
    //   'latitude': lat,
    //   'longitude': lang,
    // };
    BaseOptions option =
        BaseOptions(connectTimeout: 80000, receiveTimeout: 80000, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Storage.instance.token}'
      // 'APP-KEY': ConstanceData.app_key
    });
    var url = "${baseUrl}/address-delete/${id}";
    dio = Dio(option);
    debugPrint(url.toString());
    // debugPrint(jsonEncode(data));

    try {
      Response? response = await dio?.post(
        url,
        // data: data,
      );
      debugPrint("address delete response: ${response?.data}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return AddressResponse.fromJson(response?.data);
      } else {
        debugPrint("address delete error: ${response?.data}");
        return AddressResponse.withError("Something Went Wrong");
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 420) {
        Storage.instance.logout();
        Navigation.instance.navigateAndRemoveUntil('/login');
        showError("Oops! Your session expired. Please Login Again");
      }
      debugPrint(
          "address delete response: ${e.response} ${e.response?.headers}");
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
    // var url = "${homeUrl}/${categ_name}/${slug}";
    var url = "${homeUrl}/${categ_name}/${slug}";
    dio = Dio(option);
    debugPrint(url.toString());
    debugPrint('${categ_name}');

    try {
      Response? response = await dio?.get(
        url,
      );
      debugPrint("Article Details response: ");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return ArticleDetailsResponse.fromJson(response?.data);
      } else {
        debugPrint("Article Details error: ${response?.data}");
        return ArticleDetailsResponse.withError("Something Went Wrong");
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 420) {
        Storage.instance.logout();
        Navigation.instance.navigateAndRemoveUntil('/login');
        showError("Oops! Your session expired. Please Login Again");
      }
      debugPrint("Article Details response: ${e.response}");
      return ArticleDetailsResponse.withError(e.message);
    }
  }

  Future<ArticleDetailsResponse> getCategoryArticleDetails(
      categ_name, slug) async {
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
    // var url = "${homeUrl}/${categ_name}/${slug}";
    var url = "${homeUrl}/topic/${categ_name}/${slug}";
    dio = Dio(option);
    debugPrint(url.toString());
    debugPrint('${categ_name}');

    try {
      Response? response = await dio?.get(
        url,
      );
      debugPrint("topic/${categ_name}/${slug} Details response: ");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return ArticleDetailsResponse.fromJson(response?.data);
      } else {
        debugPrint("topic/${categ_name}/${slug} error: ${response?.data}");
        return ArticleDetailsResponse.withError("Something Went Wrong");
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 420) {
        Storage.instance.logout();
        Navigation.instance.navigateAndRemoveUntil('/login');
        showError("Oops! Your session expired. Please Login Again");
      }
      debugPrint("topic/${categ_name}/${slug} Details response: ${e.response}");
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
      // debugPrint("Article response: ${response?.data}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return OpinionResponse.fromJson(response?.data);
      } else {
        debugPrint("Article error: ${response?.data}");
        return OpinionResponse.withError("Something Went Wrong");
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 420) {
        Storage.instance.logout();
        Navigation.instance.navigateAndRemoveUntil('/login');
        showError("Oops! Your session expired. Please Login Again");
      }
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
      if (e.response?.statusCode == 420) {
        Storage.instance.logout();
        Navigation.instance.navigateAndRemoveUntil('/login');
        showError("Oops! Your session expired. Please Login Again");
      }
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
      debugPrint("HomeAlbum response: ${response?.data['data'][0]}",wrapWidth: 4024);
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return ArticleResponse.fromJson(response?.data);
      } else {
        debugPrint("HomeAlbum error: ${response?.data}");
        return ArticleResponse.withError("Something Went Wrong");
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 420) {
        Storage.instance.logout();
        Navigation.instance.navigateAndRemoveUntil('/login');
        showError("Oops! Your session expired. Please Login Again");
      }
      debugPrint("HomeAlbum response: ${e.response}");
      return ArticleResponse.withError(e.message);
    }
  }

  Future<StoryResponse> getStories() async {
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
    var url = "${homeUrl}/app/get-stories";
    dio = Dio(option);
    debugPrint(url.toString());
    // debugPrint(jsonEncode(data));

    try {
      Response? response = await dio?.get(
        url,
      );
      debugPrint("StoryResponse response: ${response?.data}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return StoryResponse.fromJson(response?.data);
      } else {
        debugPrint("StoryResponse error: ${response?.data}");
        return StoryResponse.withError("Something Went Wrong");
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 420) {
        Storage.instance.logout();
        Navigation.instance.navigateAndRemoveUntil('/login');
        showError("Oops! Your session expired. Please Login Again");
      }
      debugPrint("StoryResponse response: ${e.response}");
      return StoryResponse.withError(e.message);
    }
  }

  Future<NotificationInDeviceResponse> getNotifications() async {
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
    var url = "${homeUrl}/app/notifications/unread";
    dio = Dio(option);
    debugPrint(url.toString());
    // debugPrint(jsonEncode(data));

    try {
      Response? response = await dio?.get(
        url,
      );
      // debugPrint("getNotifications response: ${response?.data}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return NotificationInDeviceResponse.fromJson(response?.data);
      } else {
        debugPrint("getNotifications error: ${response?.data}");
        return NotificationInDeviceResponse.withError("Something Went Wrong");
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 420) {
        Storage.instance.logout();
        Navigation.instance.navigateAndRemoveUntil('/login');
        showError("Oops! Your session expired. Please Login Again");
      }
      debugPrint("StoryResponse response: ${e.response}");
      return NotificationInDeviceResponse.withError(e.message);
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
      // debugPrint("Weekly response: ${response?.data}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return VideoNewsResponse.fromJson(response?.data);
      } else {
        debugPrint("Weekly error: ${response?.data}");
        return VideoNewsResponse.withError("Something Went Wrong");
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 420) {
        Storage.instance.logout();
        Navigation.instance.navigateAndRemoveUntil('/login');
        showError("Oops! Your session expired. Please Login Again");
      }
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
      debugPrint("latest-opinions response: ${response?.data['data'][0]}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return LatestOpinionResponse.fromJson(response?.data);
      } else {
        debugPrint("latest-opinions error: ${response?.data}");
        return LatestOpinionResponse.withError("Something Went Wrong");
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 420) {
        Storage.instance.logout();
        Navigation.instance.navigateAndRemoveUntil('/login');
        showError("Oops! Your session expired. Please Login Again");
      }
      debugPrint("latest-opinions response: ${e.response}");
      return LatestOpinionResponse.withError(e.message);
    }
  }

  Future<OpinionDetailsResponse> getOpinionDetails(slug) async {
    // var data = {
    //   'category': 'opinion',
    //   'per_page': per_page,
    //   'page': page,
    // };
    debugPrint("URL SLUG ${slug}");
    BaseOptions option =
        BaseOptions(connectTimeout: 80000, receiveTimeout: 80000, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Storage.instance.token}'
      // 'APP-KEY': ConstanceData.app_key
    });
    var url =
        "${homeUrl}/opinion/${slug.toString().split(",")[1] == '4' ? 'editorials' : 'opinion'}/${slug.toString().split(",")[0]}";
    dio = Dio(option);
    debugPrint(url.toString());
    // debugPrint(jsonEncode(data));

    try {
      Response? response = await dio?.get(
        url,
        // queryParameters: data,
      );
      debugPrint("OpinionDetailsResponse response: ${response?.data}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return OpinionDetailsResponse.fromJson(response?.data);
      } else {
        debugPrint("OpinionDetailsResponse error: ${response?.data}");
        return OpinionDetailsResponse.withError("Something Went Wrong");
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 420) {
        Storage.instance.logout();
        Navigation.instance.navigateAndRemoveUntil('/login');
        showError("Oops! Your session expired. Please Login Again");
      }
      debugPrint("OpinionDetailsResponse response: ${e.response}");
      return OpinionDetailsResponse.withError(e.message);
    }
  }

  Future<ClassifiedDetailsResponse> getClassifiedDetails(id) async {
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
    var url = "${baseUrl}/app/get-classified/${id}";
    dio = Dio(option);
    debugPrint(url.toString());
    // debugPrint(jsonEncode(data));

    try {
      Response? response = await dio?.get(
        url,
        // queryParameters: data,
      );
      debugPrint("ClassifiedDetailsResponse response: ${response?.data}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return ClassifiedDetailsResponse.fromJson(response?.data);
      } else {
        debugPrint("ClassifiedDetailsResponse error: ${response?.data}");
        return ClassifiedDetailsResponse.withError("Something Went Wrong");
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 420) {
        Storage.instance.logout();
        Navigation.instance.navigateAndRemoveUntil('/login');
        showError("Oops! Your session expired. Please Login Again");
      }
      debugPrint("ClassifiedDetailsResponse response: ${e.response}");
      return ClassifiedDetailsResponse.withError(e.message);
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
      if (e.response?.statusCode == 420) {
        Storage.instance.logout();
        Navigation.instance.navigateAndRemoveUntil('/login');
        showError("Oops! Your session expired. Please Login Again");
      }
      debugPrint("E_paper response: ${e.response}");
      return E_paperRepsonse.withError(e.message);
    }
  }

  Future<VideoNewsResponse> getVideoNews(categ) async {
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
      if (e.response?.statusCode == 420) {
        Storage.instance.logout();
        Navigation.instance.navigateAndRemoveUntil('/login');
        showError("Oops! Your session expired. Please Login Again");
      }
      debugPrint("video-news response: ${e.response}");
      return VideoNewsResponse.withError(e.message);
    }
  }

  Future<MoreVideoNewsResponse> getVideoMoreNews(categ, per_page, page) async {
    var data = {
      'category': categ,
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
    var url = "${homeUrl}/video/${categ}";
    dio = Dio(option);
    debugPrint(url.toString());
    debugPrint(jsonEncode(data));

    try {
      Response? response = await dio?.get(url, queryParameters: data);
      debugPrint("video-news response: ${response?.data}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return MoreVideoNewsResponse.fromJson(response?.data);
      } else {
        debugPrint("video-news error: ${response?.data}");
        return MoreVideoNewsResponse.withError("Something Went Wrong");
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 420) {
        Storage.instance.logout();
        Navigation.instance.navigateAndRemoveUntil('/login');
        showError("Oops! Your session expired. Please Login Again");
      }
      debugPrint("video-news response: ${e.response}");
      return MoreVideoNewsResponse.withError(e.message);
    }
  }

  Future<MembershipResponse2> getMembership(String platform) async {
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
    var url = "${baseUrl}/app/subscriptions/$platform";
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
        return MembershipResponse2.fromJson(response?.data);
      } else {
        debugPrint("subscriptions error: ${response?.data}");
        return MembershipResponse2.withError("Something Went Wrong");
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 420) {
        Storage.instance.logout();
        Navigation.instance.navigateAndRemoveUntil('/login');
        showError("Oops! Your session expired. Please Login Again");
      }
      debugPrint("subscriptions response: ${e.response}");
      return MembershipResponse2.withError(e.message);
    }
  }

  Future<MembershipResponse> getActiveMembership() async {
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
    var url = "${baseUrl}/app/currently-active-plan";
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
      if (e.response?.statusCode == 420) {
        Storage.instance.logout();
        Navigation.instance.navigateAndRemoveUntil('/login');
        showError("Oops! Your session expired. Please Login Again");
      }
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
      if (e.response?.statusCode == 420) {
        Storage.instance.logout();
        Navigation.instance.navigateAndRemoveUntil('/login');
        showError("Oops! Your session expired. Please Login Again");
      }
      debugPrint("promoted-deal-list error: ${e.response}");
      return PromotedDealResponse.withError(e.message);
    }
  }

  Future<ShopResponse> getShopByCategory(id, locality_ids, order_by) async {
    var url = "${baseUrl}/app/deal-list/${id}";
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
      'locality_ids': locality_ids,
      'order_by': order_by,
      // “locality_ids”:”2,3,4”
      // “order_by”:”alphabet/timeline”
    };
    debugPrint(jsonEncode(data));

    try {
      Response? response = await dio?.get(
        url,
        queryParameters: data,
      );
      debugPrint("ShopResponse response: ${response?.data}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return ShopResponse.fromJson(response?.data);
      } else {
        debugPrint("ShopResponse error: ${response?.data}");
        return ShopResponse.withError("Something Went Wrong");
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 420) {
        Storage.instance.logout();
        Navigation.instance.navigateAndRemoveUntil('/login');
        showError("Oops! Your session expired. Please Login Again");
      }
      debugPrint("ShopResponse error: ${e.response}");
      return ShopResponse.withError(e.message);
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
      if (e.response?.statusCode == 420) {
        Storage.instance.logout();
        Navigation.instance.navigateAndRemoveUntil('/login');
        showError("Oops! Your session expired. Please Login Again");
      }
      debugPrint("DealDetailsResponse error: ${e.response}");
      return DealDetailsResponse.withError(e.message);
    }
  }

  Future<GenericBoolMsgResponse> getCitizenText() async {
    var url = "${baseUrl}/be-a-journalist-msg";
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
      debugPrint("GenericMsgResponse response: ${response?.data}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return GenericBoolMsgResponse.fromJson(response?.data);
      } else {
        debugPrint("DealDetailsResponse error: ${response?.data}");
        return GenericBoolMsgResponse.withError("Something Went Wrong");
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 420) {
        Storage.instance.logout();
        Navigation.instance.navigateAndRemoveUntil('/login');
        showError("Oops! Your session expired. Please Login Again");
      }
      debugPrint("GenericMsgResponse error: ${e.response}");
      return GenericBoolMsgResponse.withError(e.message);
    }
  }

  Future<GenericMsgResponse> getReferEarnText() async {
    var url = "${baseUrl}/refer-n-earn-msg";
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
      debugPrint("GenericMsgResponse response: ${response?.data}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return GenericMsgResponse.fromJson(response?.data);
      } else {
        debugPrint("DealDetailsResponse error: ${response?.data}");
        return GenericMsgResponse.withError("Something Went Wrong");
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 420) {
        Storage.instance.logout();
        Navigation.instance.navigateAndRemoveUntil('/login');
        showError("Oops! Your session expired. Please Login Again");
      }
      debugPrint("GenericMsgResponse error: ${e.response}");
      return GenericMsgResponse.withError(e.message);
    }
  }

  Future<GenericResponse> readAll() async {
    var url = "${baseUrl}/app/notifications/read-all";
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
      Response? response = await dio?.post(
        url,
        // queryParameters: data,
      );
      debugPrint("notifications response: ${response?.data}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return GenericResponse.fromJson(response?.data);
      } else {
        debugPrint("notifications error: ${response?.data}");
        return GenericResponse.withError("Something Went Wrong");
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 420) {
        Storage.instance.logout();
        Navigation.instance.navigateAndRemoveUntil('/login');
        showError("Oops! Your session expired. Please Login Again");
      }
      debugPrint("notifications error: ${e.response}");
      return GenericResponse.withError(e.message);
    }
  }

  Future<GenericMsgResponse> getRedeemText() async {
    var url = "${baseUrl}/redeem-confirmation-msg";
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
      // debugPrint("GenericMsgResponse response: ${response?.data}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return GenericMsgResponse.fromJson(response?.data);
      } else {
        debugPrint("DealDetailsResponse error: ${response?.data}");
        return GenericMsgResponse.withError("Something Went Wrong");
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 420) {
        Storage.instance.logout();
        Navigation.instance.navigateAndRemoveUntil('/login');
        showError("Oops! Your session expired. Please Login Again");
      }
      debugPrint("GenericMsgResponse error: ${e.response}");
      return GenericMsgResponse.withError(e.message);
    }
  }

  Future<ReportResponse> getReportMsg() async {
    var url = "${baseUrl}/user-report-list";
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
      debugPrint("user-report-list response: ${response?.data}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return ReportResponse.fromJson(response?.data);
      } else {
        debugPrint("user-report-list error: ${response?.data}");
        return ReportResponse.withError("Something Went Wrong");
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 420) {
        Storage.instance.logout();
        Navigation.instance.navigateAndRemoveUntil('/login');
        showError("Oops! Your session expired. Please Login Again");
      }
      debugPrint("user-report-list error: ${e.response}");
      return ReportResponse.withError(e.message);
    }
  }

  Future<GenericMsgResponse> getTerms() async {
    var url = "${baseUrl}/user-security-msg";
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
      debugPrint("user-security-msg response: ${response?.data}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return GenericMsgResponse.fromJson(response?.data);
      } else {
        debugPrint("user-security-msg error: ${response?.data}");
        return GenericMsgResponse.withError("Something Went Wrong");
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 420) {
        Storage.instance.logout();
        Navigation.instance.navigateAndRemoveUntil('/login');
        showError("Oops! Your session expired. Please Login Again");
      }
      debugPrint("user-security-msg error: ${e.response}");
      return GenericMsgResponse.withError(e.message);
    }
  }

  Future<GenericMsgResponse> getGuwahatiConnectText() async {
    var url = "${baseUrl}/guwahati-connect-msg";
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
      debugPrint("GuwahatiConnect response: ${response?.data}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return GenericMsgResponse.fromJson(response?.data);
      } else {
        debugPrint("GuwahatiConnect error: ${response?.data}");
        return GenericMsgResponse.withError("Something Went Wrong");
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 420) {
        Storage.instance.logout();
        Navigation.instance.navigateAndRemoveUntil('/login');
        showError("Oops! Your session expired. Please Login Again");
      }
      debugPrint("GuwahatiConnect error: ${e.response}");
      return GenericMsgResponse.withError(e.message);
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
      if (e.response?.statusCode == 420) {
        Storage.instance.logout();
        Navigation.instance.navigateAndRemoveUntil('/login');
        showError("Oops! Your session expired. Please Login Again");
      }
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
      if (e.response?.statusCode == 420) {
        Storage.instance.logout();
        Navigation.instance.navigateAndRemoveUntil('/login');
        showError("Oops! Your session expired. Please Login Again");
      }
      debugPrint("enterPreferences error: ${e.response}");
      return GenericResponse.withError(e.message);
    }
  }

  Future<BlockedUserResponse> getBlockedList() async {
    var url = "${baseUrl}/app/blocked-user-list";
    BaseOptions option =
        BaseOptions(connectTimeout: 80000, receiveTimeout: 80000, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Storage.instance.token}'
      // 'APP-KEY': ConstanceData.app_key
    });
    dio = Dio(option);
    debugPrint(url.toString());
    // var data = {
    //   'mobile': mobile,
    //   'topic_ids': topicks,
    //   'geo_ids': geotopicks,
    // };
    // debugPrint(jsonEncode(data));

    try {
      Response? response = await dio?.get(
        url,
        // data: data,
        // queryParameters: data,
      );
      debugPrint("BlockedUserResponse response: ${response?.data}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return BlockedUserResponse.fromJson(response?.data);
      } else {
        debugPrint("BlockedUserResponse error: ${response?.data}");
        return BlockedUserResponse.withError("Something Went Wrong");
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 420) {
        Storage.instance.logout();
        Navigation.instance.navigateAndRemoveUntil('/login');
        showError("Oops! Your session expired. Please Login Again");
      }
      debugPrint("BlockedUserResponse error: ${e.response}");
      return BlockedUserResponse.withError(e.message);
    }
  }

  Future<GenericResponse> updateDeviceToken(token) async {
    var url = "${baseUrl}/update-device-token";
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
      'device_token': token,
    };
    debugPrint(jsonEncode(data));

    try {
      Response? response = await dio?.post(
        url,
        data: data,
        // queryParameters: data,
      );
      debugPrint("device_token response: ${response?.data}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return GenericResponse.fromJson(response?.data);
      } else {
        debugPrint("device_token error: ${response?.data}");
        return GenericResponse.withError("Something Went Wrong");
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 420) {
        Storage.instance.logout();
        Navigation.instance.navigateAndRemoveUntil('/login');
        showError("Oops! Your session expired. Please Login Again");
      }
      debugPrint("device_token error: ${e.response}");
      return GenericResponse.withError(e.message);
    }
  }

  Future<GenericResponse> reportPost_Comment(id, report_type, type) async {
    var url = "${baseUrl}/app/user-report";
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
      'report_for_id': id,
      'report_type_id': report_type,
      'type': type,
    };
    debugPrint(jsonEncode(data));

    try {
      Response? response = await dio?.post(
        url,
        data: data,
        // queryParameters: data,
      );
      debugPrint("user-report response: ${response?.data}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return GenericResponse.fromJson(response?.data);
      } else {
        debugPrint("user-report error: ${response?.data}");
        return GenericResponse.withError("Something Went Wrong");
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 420) {
        Storage.instance.logout();
        Navigation.instance.navigateAndRemoveUntil('/login');
        showError("Oops! Your session expired. Please Login Again");
      }
      debugPrint("user-report error: ${e.response}");
      return GenericResponse.withError(e.message);
    }
  }

  Future<GenericResponse> blockUser(id, categ) async {
    var url = "${baseUrl}/app/block-user-by-user";
    BaseOptions option =
        BaseOptions(connectTimeout: 80000, receiveTimeout: 80000, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Storage.instance.token}'
      // 'APP-KEY': ConstanceData.app_key
    });
    dio = Dio(option);
    debugPrint(url.toString());
    var data = {'block_user_id': id, 'block_for': categ};
    debugPrint(jsonEncode(data));

    try {
      Response? response = await dio?.post(
        url,
        data: data,
        // queryParameters: data,
      );
      debugPrint("block-user-by-user response: ${response?.data}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return GenericResponse.fromJson(response?.data);
      } else {
        debugPrint("block-user-by-user error: ${response?.data}");
        return GenericResponse.withError("Something Went Wrong");
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 420) {
        Storage.instance.logout();
        Navigation.instance.navigateAndRemoveUntil('/login');
        showError("Oops! Your session expired. Please Login Again");
      }
      debugPrint("update-device-token error: ${e.response}");
      return GenericResponse.withError(e.message);
    }
  }

  Future<GenericResponse> unblockUser(id, categ) async {
    var url = "${baseUrl}/app/unblock-user-by-user";
    BaseOptions option =
        BaseOptions(connectTimeout: 80000, receiveTimeout: 80000, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Storage.instance.token}'
      // 'APP-KEY': ConstanceData.app_key
    });
    dio = Dio(option);
    debugPrint(url.toString());
    var data = {'block_user_id': id, 'block_for': categ};
    debugPrint(jsonEncode(data));

    try {
      Response? response = await dio?.post(
        url,
        data: data,
        // queryParameters: data,
      );
      debugPrint("unblock-user-by-user response: ${response?.data}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return GenericResponse.fromJson(response?.data);
      } else {
        debugPrint("unblock-user-by-user error: ${response?.data}");
        return GenericResponse.withError("Something Went Wrong");
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 420) {
        Storage.instance.logout();
        Navigation.instance.navigateAndRemoveUntil('/login');
        showError("Oops! Your session expired. Please Login Again");
      }
      debugPrint("unblock-user-by-user error: ${e.response}");
      return GenericResponse.withError(e.message);
    }
  }

  Future<BlockedUserResponse> blockedUsers() async {
    var url = "${baseUrl}/app/blocked-user-list";
    BaseOptions option =
        BaseOptions(connectTimeout: 80000, receiveTimeout: 80000, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Storage.instance.token}'
      // 'APP-KEY': ConstanceData.app_key
    });
    dio = Dio(option);
    debugPrint(url.toString());
    // var data = {'block_user_id': id, 'block_for': categ};
    // debugPrint(jsonEncode(data));

    try {
      Response? response = await dio?.get(
        url,
        // data: data,
        // queryParameters: data,
      );
      debugPrint("blocked-user-list response: ${response?.data}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return BlockedUserResponse.fromJson(response?.data);
      } else {
        debugPrint("blocked-user-list error: ${response?.data}");
        return BlockedUserResponse.withError("Something Went Wrong");
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 420) {
        Storage.instance.logout();
        Navigation.instance.navigateAndRemoveUntil('/login');
        showError("Oops! Your session expired. Please Login Again");
      }
      debugPrint("blocked-user-list error: ${e.response}");
      return BlockedUserResponse.withError(e.message);
    }
  }

  Future<GenericResponse> deleteComment(
    comment_id,
  ) async {
    var url = "${baseUrl}/app/comment-delete/${comment_id}";
    BaseOptions option =
        BaseOptions(connectTimeout: 80000, receiveTimeout: 80000, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Storage.instance.token}'
      // 'APP-KEY': ConstanceData.app_key
    });
    dio = Dio(option);
    debugPrint(url.toString());
    // var data = {
    //   'device_token': token,
    // };
    // debugPrint(jsonEncode(data));

    try {
      Response? response = await dio?.post(
        url,
        // data: data,
        // queryParameters: data,
      );
      debugPrint("comment-delete response: ${response?.data}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return GenericResponse.fromJson(response?.data);
      } else {
        debugPrint("comment-delete error: ${response?.data}");
        return GenericResponse.withError("Something Went Wrong");
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 420) {
        Storage.instance.logout();
        Navigation.instance.navigateAndRemoveUntil('/login');
        showError("Oops! Your session expired. Please Login Again");
      }
      debugPrint("comment-delete error: ${e.response}");
      return GenericResponse.withError(e.message);
    }
  }

  Future<GenericResponse> editComment(commentId, comment) async {
    var url = "$baseUrl/app/comment/$commentId";
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
      'comment': comment,
    };
    debugPrint(jsonEncode(data));

    try {
      Response? response = await dio?.post(
        url,
        data: data,
        // queryParameters: data,
      );
      debugPrint("comment-edit response: ${response?.data}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return GenericResponse.fromJson(response?.data);
      } else {
        debugPrint("comment-edit error: ${response?.data}");
        return GenericResponse.withError("Something Went Wrong");
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 420) {
        Storage.instance.logout();
        Navigation.instance.navigateAndRemoveUntil('/login');
        showError("Oops! Your session expired. Please Login Again");
      }
      debugPrint("comment-edit error: ${e.response}");
      return GenericResponse.withError(e.message);
    }
  }

  Future<GenericResponse> notificationRead(id) async {
    var url = "${baseUrl}/app/notifications/read";
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
      'id': id,
    };
    debugPrint(jsonEncode(data));

    try {
      Response? response = await dio?.post(
        url,
        data: data,
        // queryParameters: data,
      );
      // debugPrint("notifications/read response: ${response?.data}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return GenericResponse.fromJson(response?.data);
      } else {
        debugPrint("notifications/read error: ${response?.data}");
        return GenericResponse.withError("Something Went Wrong");
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 420) {
        Storage.instance.logout();
        Navigation.instance.navigateAndRemoveUntil('/login');
        showError("Oops! Your session expired. Please Login Again");
      }
      debugPrint("notifications/read error: ${e.response}");
      return GenericResponse.withError(e.message);
    }
  }

  Future<GenericResponse> setAsFavourite(id, type) async {
    var url = "${baseUrl}/app/favourite";
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
      'type': type,
      'favourite_for_id': id,
    };
    debugPrint(jsonEncode(data));

    try {
      Response? response = await dio?.post(
        url,
        data: data,
        // queryParameters: data,
      );
      debugPrint("setAsFavourite response: ${response?.data}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return GenericResponse.fromJson(response?.data);
      } else {
        debugPrint("setAsFavourite error: ${response?.data}");
        return GenericResponse.withError("Something Went Wrong");
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 420) {
        Storage.instance.logout();
        Navigation.instance.navigateAndRemoveUntil('/login');
        showError("Oops! Your session expired. Please Login Again");
      }
      debugPrint("setAsFavourite error: ${e.response}");
      return GenericResponse.withError(e.message);
    }
  }

  Future<GenericResponse> setSwitch(val, type) async {
    var url = "${baseUrl}/update-switch";
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
      'type': type,
      'value': val,
    };
    debugPrint(jsonEncode(data));

    try {
      Response? response = await dio?.post(
        url,
        data: data,
        // queryParameters: data,
      );
      debugPrint("Swtich set response: ${response?.data}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return GenericResponse.fromJson(response?.data);
      } else {
        debugPrint("Swtich set error: ${response?.data}");
        return GenericResponse.withError("Something Went Wrong");
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 420) {
        Storage.instance.logout();
        Navigation.instance.navigateAndRemoveUntil('/login');
        showError("Oops! Your session expired. Please Login Again");
      }
      debugPrint("Swtich set error: ${e.response}");
      return GenericResponse.withError(e.message);
    }
  }

  Future<SwitchStatusResponse> getSwitchStatus() async {
    var url = "${baseUrl}/get-switch";
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
        // queryParameters: data,
      );
      debugPrint("Switch get response: ${response?.data}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return SwitchStatusResponse.fromJson(response?.data);
      } else {
        debugPrint("Switch get error: ${response?.data}");
        return SwitchStatusResponse.withError("Something Went Wrong");
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 420) {
        Storage.instance.logout();
        Navigation.instance.navigateAndRemoveUntil('/login');
        showError("Oops! Your session expired. Please Login Again");
      }
      debugPrint("Switch get error: ${e.response}");
      return SwitchStatusResponse.withError(e.message);
    }
  }

  Future<RazorpayResponse> fetchRazorpay() async {
    var url = "${baseUrl}/payment-gateway";
    BaseOptions option =
        BaseOptions(connectTimeout: 80000, receiveTimeout: 80000, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Storage.instance.token}'
      // 'APP-KEY': ConstanceData.app_key
    });
    dio = Dio(option);
    debugPrint(url.toString());
    try {
      Response? response = await dio?.get(url.toString());
      debugPrint("Razorpay response: ${response?.data}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return RazorpayResponse.fromJson(response?.data);
      } else {
        debugPrint("Razorpay error: ${response?.data}");
        return RazorpayResponse.withError("Something Went Wrong");
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 420) {
        Storage.instance.logout();
        Navigation.instance.navigateAndRemoveUntil('/login');
        showError("Oops! Your session expired. Please Login Again");
      }
      debugPrint("Razorpay error: ${e.response}");
      return RazorpayResponse.withError(e.message);
    }
  }

  Future<GenericResponse> verifyPayment(order_code, razorpay_payment_id, amount,
      payment_data, type, transaction_id, purchase_date) async {
    var url = "${baseUrl}/app/order/verify-payment/${type}";
    BaseOptions option =
        BaseOptions(connectTimeout: 80000, receiveTimeout: 80000, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Storage.instance.token}'
      // 'APP-KEY': ConstanceData.app_key
    });
    dio = Dio(option);
    debugPrint(url.toString());
    var exactData = {
      'name_on_card': "${payment_data['name_on_card']}",
      'txnid': "${payment_data['txnid']}",
      'easepayid': "${payment_data['easepayid']}",
      'addedon': "${payment_data['addedon']}",
      'udf1': "${payment_data['udf1']}",
      'udf2': "${payment_data['udf2']}",
      'udf3': "${payment_data['udf3']}",
      'amount': "${payment_data['amount']}",
      'phone': "${payment_data['phone']}",
      'email': "${payment_data['email']}",
      'order_code': "${order_code}",
      'transaction_id': "${transaction_id}",
      'purchase_date': "${purchase_date}",
    };
    debugPrint(jsonEncode(exactData));
    var data = {
      'order_code': order_code,
      'razorpay_payment_id': razorpay_payment_id,
      'amount': amount,
      // 'payment_data':exactData,
      'name_on_card': "${payment_data['name_on_card']}",
      'txnid': "${payment_data['txnid']}",
      'easepayid': "${payment_data['easepayid']}",
      'addedon': "${payment_data['addedon']}",
      'udf1': "${payment_data['udf1']}",
      'udf2': "${payment_data['udf2']}",
      'udf3': "${payment_data['udf3']}",
      'amount': "${payment_data['amount']}",
      'phone': "${payment_data['phone']}",
      'email': "${payment_data['email']}",
    };
    debugPrint(jsonEncode(data));

    try {
      Response? response = await dio?.post(
        url,
        data: data,
        // queryParameters: data,
      );
      debugPrint("verifyPayment response: ${response?.data}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return GenericResponse.fromJson(response?.data);
      } else {
        debugPrint("verifyPayment error: ${response?.data}");
        return GenericResponse.withError("Something Went Wrong");
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 420) {
        Storage.instance.logout();
        Navigation.instance.navigateAndRemoveUntil('/login');
        showError("Oops! Your session expired. Please Login Again");
      }
      debugPrint("verifyPayment error: ${e.response}");
      return GenericResponse.withError(e.message);
    }
  }

  Future<GenericResponse> verifyPaymentInapp(
      order_code, transaction_id, purchase_date) async {
    var url = "${baseUrl}/app/order/verify-payment/inapp";
    BaseOptions option =
        BaseOptions(connectTimeout: 80000, receiveTimeout: 80000, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Storage.instance.token}'
      // 'APP-KEY': ConstanceData.app_key
    });
    dio = Dio(option);
    debugPrint(url.toString());
    var exactData = {
      // 'name_on_card': "${payment_data['name_on_card']}",
      // 'txnid': "${payment_data['txnid']}",
      // 'easepayid': "${payment_data['easepayid']}",
      // 'addedon': "${payment_data['addedon']}",
      // 'udf1': "${payment_data['udf1']}",
      // 'udf2': "${payment_data['udf2']}",
      // 'udf3': "${payment_data['udf3']}",
      // 'amount': "${payment_data['amount']}",
      // 'phone': "${payment_data['phone']}",
      // 'email': "${payment_data['email']}",
      'order_code': "${order_code}",
      'transaction_id': "${transaction_id}",
      'purchase_date': "${purchase_date}",
    };
    debugPrint(jsonEncode(exactData));
    var data = {
      'order_code': order_code,
      'transaction_id': "${transaction_id}",
      'purchase_date': "${purchase_date}",
      // 'razorpay_payment_id': razorpay_payment_id,
      // 'amount': amount,
      // 'payment_data':exactData,
      // 'name_on_card': "${payment_data['name_on_card']}",
      // 'txnid': "${payment_data['txnid']}",
      // 'easepayid': "${payment_data['easepayid']}",
      // 'addedon': "${payment_data['addedon']}",
      // 'udf1': "${payment_data['udf1']}",
      // 'udf2': "${payment_data['udf2']}",
      // 'udf3': "${payment_data['udf3']}",
      // 'amount': "${payment_data['amount']}",
      // 'phone': "${payment_data['phone']}",
      // 'email': "${payment_data['email']}",
    };
    debugPrint(jsonEncode(data));

    try {
      Response? response = await dio?.post(
        url,
        data: data,
        // queryParameters: data,
      );
      debugPrint("verifyPayment response: ${response?.data}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return GenericResponse.fromJson(response?.data);
      } else {
        debugPrint("verifyPayment error: ${response?.data}");
        return GenericResponse.withError("Something Went Wrong");
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 420) {
        Storage.instance.logout();
        Navigation.instance.navigateAndRemoveUntil('/login');
        showError("Oops! Your session expired. Please Login Again");
      }
      debugPrint("verifyPayment error: ${e.response}");
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
      if (e.response?.statusCode == 420) {
        Storage.instance.logout();
        Navigation.instance.navigateAndRemoveUntil('/login');
        showError("Oops! Your session expired. Please Login Again");
      }
      debugPrint("shop-categories response: ${e.response}");
      return ShopCategoryResponse.withError(e.message);
    }
  }

  Future<GrievenceRedressalResponse> getGrievences() async {
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
    var url = "${baseUrl}/status-grievance";
    dio = Dio(option);
    debugPrint(url.toString());
    var data = {'Authorization': 'Bearer ${Storage.instance.token}'};
    debugPrint(jsonEncode(data));

    try {
      Response? response = await dio?.get(
        url,
        // queryParameters: data,
      );
      debugPrint("GrievenceRedressalResponse  response: ${response?.data}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return GrievenceRedressalResponse.fromJson(response?.data);
      } else {
        debugPrint("GrievenceRedressalResponse  error: ${response?.data}");
        return GrievenceRedressalResponse.withError("Something Went Wrong");
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 420) {
        Storage.instance.logout();
        Navigation.instance.navigateAndRemoveUntil('/login');
        showError("Oops! Your session expired. Please Login Again");
      }
      debugPrint("GrievenceRedressalResponse  response: ${e.response}");
      return GrievenceRedressalResponse.withError(e.message);
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
      if (e.response?.statusCode == 420) {
        Storage.instance.logout();
        Navigation.instance.navigateAndRemoveUntil('/login');
        showError("Oops! Your session expired. Please Login Again");
      }
      debugPrint("RedeemHistoryResponse error 2: ${e.response}");
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
      // debugPrint("advertise response: ${response?.data}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return AdvertiseResponse.fromJson(response?.data);
      } else {
        debugPrint("advertise error: ${response?.data}");
        return AdvertiseResponse.withError("Something Went Wrong");
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 420) {
        Storage.instance.logout();
        Navigation.instance.navigateAndRemoveUntil('/login');
        showError("Oops! Your session expired. Please Login Again");
      }
      debugPrint("advertise error: ${e.response}");
      return AdvertiseResponse.withError(e.message);
    }
  }

  Future<TopPicksResponse> getTopPicks(page) async {
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
    var data = {
      'Authorization': 'Bearer ${Storage.instance.token}',
      'page': page,
    };
    debugPrint(jsonEncode(data));

    try {
      Response? response = await dio?.get(
        url,
        queryParameters: data,
      );
      // debugPrint("toppicks response: ${response?.data}");
      debugPrint("toppicks response: ${response?.statusCode}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return TopPicksResponse.fromJson(response?.data);
      } else {
        debugPrint("toppicks error: ${response?.data}");
        return TopPicksResponse.withError("Something Went Wrong");
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 420) {
        Storage.instance.logout();
        Navigation.instance.navigateAndRemoveUntil('/login');
        showError("Oops! Your session expired. Please Login Again");
      }
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
      if (e.response?.statusCode == 420) {
        Storage.instance.logout();
        Navigation.instance.navigateAndRemoveUntil('/login');
        showError("Oops! Your session expired. Please Login Again");
      }
      debugPrint("topicks response: ${e.response}");
      return TopickResponse.withError(e.message);
    }
  }

  Future<ClassifiedResponse> getClassified(categ, result, title) async {
    var url = "${baseUrl}/app/classified/${categ}";
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
      'locality_ids': result,
      'title': title,
    };
    debugPrint(jsonEncode(data));

    try {
      Response? response = await dio?.get(
        url,
        queryParameters: data,
      );
      debugPrint("ClassifiedResponse response: ${response?.data}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return ClassifiedResponse.fromJson(response?.data);
      } else {
        debugPrint("ClassifiedResponse error: ${response?.data}");
        return ClassifiedResponse.withError("Something Went Wrong");
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 420) {
        Storage.instance.logout();
        Navigation.instance.navigateAndRemoveUntil('/login');
        showError("Oops! Your session expired. Please Login Again");
      }
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
      if (e.response?.statusCode == 420) {
        Storage.instance.logout();
        Navigation.instance.navigateAndRemoveUntil('/login');
        showError("Oops! Your session expired. Please Login Again");
      }
      debugPrint("ClassifiedCategoryResponse response: ${e.response}");
      return ClassifiedCategoryResponse.withError(e.message);
    }
  }

  Future<ReferEarnResponse> getReferAndEarn() async {
    var url =
        "${baseUrl}/app/get-refer-n-earn/${Platform.isAndroid ? "android" : "ios"}";
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
      if (e.response?.statusCode == 420) {
        Storage.instance.logout();
        Navigation.instance.navigateAndRemoveUntil('/login');
        showError("Oops! Your session expired. Please Login Again");
      }
      debugPrint("AboutUsResponse response: ${e.response}");
      return AboutUsResponse.withError(e.message);
    }
  }

  Future<AboutUsResponse> getTermsConditions() async {
    var url = "${baseUrl}/app/pages/terms-n-conditions";
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
      if (e.response?.statusCode == 420) {
        Storage.instance.logout();
        Navigation.instance.navigateAndRemoveUntil('/login');
        showError("Oops! Your session expired. Please Login Again");
      }
      debugPrint("AboutUsResponse response: ${e.response}");
      return AboutUsResponse.withError(e.message);
    }
  }

  Future<AboutUsResponse> getRefundPolicy() async {
    var url = "${baseUrl}/app/pages/refund-policy";
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
      if (e.response?.statusCode == 420) {
        Storage.instance.logout();
        Navigation.instance.navigateAndRemoveUntil('/login');
        showError("Oops! Your session expired. Please Login Again");
      }
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
      if (e.response?.statusCode == 420) {
        Storage.instance.logout();
        Navigation.instance.navigateAndRemoveUntil('/login');
        showError("Oops! Your session expired. Please Login Again");
      }
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
      if (e.response?.statusCode == 420) {
        Storage.instance.logout();
        Navigation.instance.navigateAndRemoveUntil('/login');
        showError("Oops! Your session expired. Please Login Again");
      }
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
      if (e.response?.statusCode == 420) {
        Storage.instance.logout();
        Navigation.instance.navigateAndRemoveUntil('/login');
        showError("Oops! Your session expired. Please Login Again");
      }
      debugPrint("guwahati-connect error: ${e.response}");
      return GuwahatiConnectResponse.withError(e.message);
    }
  }

  Future<GuwahatiConnectSpecificResponse> getGuwahatiConnectSpecific(id) async {
    var url = "${baseUrl}/app/guwahati-connect-test/${id}";
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
        return GuwahatiConnectSpecificResponse.fromJson(response?.data);
      } else {
        debugPrint("guwahati-connect error: ${response?.data}");
        return GuwahatiConnectSpecificResponse.withError(
            "Something Went Wrong");
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 420) {
        Storage.instance.logout();
        Navigation.instance.navigateAndRemoveUntil('/login');
        showError("Oops! Your session expired. Please Login Again");
      }
      debugPrint("guwahati-connect error: ${e.response}");
      return GuwahatiConnectSpecificResponse.withError(e.message);
    }
  }

  Future<GuwahatiConnectResponse> getMyGuwahatiConnect() async {
    var url = "${baseUrl}/app/guwahati-connect/my-list";
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
      debugPrint("guwahati-connect my response: ");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return GuwahatiConnectResponse.fromJson(response?.data);
      } else {
        debugPrint("guwahati-connect my error: ${response?.data}");
        return GuwahatiConnectResponse.withError("Something Went Wrong");
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 420) {
        Storage.instance.logout();
        Navigation.instance.navigateAndRemoveUntil('/login');
        showError("Oops! Your session expired. Please Login Again");
      }
      debugPrint("guwahati-connect my error: ${e.response}");
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
      if (e.response?.statusCode == 420) {
        Storage.instance.logout();
        Navigation.instance.navigateAndRemoveUntil('/login');
        showError("Oops! Your session expired. Please Login Again");
      }
      debugPrint("citizen-journalist-list error: ${e.response}");
      return CitizenJournalistResponse.withError(e.message);
    }
  }

  Future<CitizenJournalistResponse> getCitizenJournalistApproved() async {
    var url = "${baseUrl}/app/citizen-journalist-list/submit";
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
      if (e.response?.statusCode == 420) {
        Storage.instance.logout();
        Navigation.instance.navigateAndRemoveUntil('/login');
        showError("Oops! Your session expired. Please Login Again");
      }
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
      // debugPrint("PollOfTheWeekResponse: ${response?.data}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return PollOfTheWeekResponse.fromJson(response?.data);
      } else {
        debugPrint("PollOfTheWeekResponse error: ${response?.data}");
        return PollOfTheWeekResponse.withError("Something Went Wrong");
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 420) {
        Storage.instance.logout();
        Navigation.instance.navigateAndRemoveUntil('/login');
        showError("Oops! Your session expired. Please Login Again");
      }
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
    debugPrint(jsonEncode(data));

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
      if (e.response?.statusCode == 420) {
        Storage.instance.logout();
        Navigation.instance.navigateAndRemoveUntil('/login');
        showError("Oops! Your session expired. Please Login Again");
      }
      debugPrint("postPollOfTheWeek error: ${e.response}");
      return GenericResponse.withError(e.message);
    }
  }

  Future<GenericResponse> advertiseWithUs(
      f_name, l_name, email, mobile, ad_type, feedback) async {
    var url = "${baseUrl}/app/post-advertise-feedback";
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
      'first_name': f_name,
      'last_name': l_name,
      'email': email,
      'mobile': mobile,
      'ad_type': ad_type,
      'feedback': feedback,
    };
    debugPrint(jsonEncode(data));

    try {
      Response? response = await dio?.post(
        url,
        data: data,
        // queryParameters: data,
      );
      debugPrint("advertiseWithUs response: ${response?.data}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return GenericResponse.fromJson(response?.data);
      } else {
        debugPrint("advertiseWithUs error: ${response?.data}");
        return GenericResponse.withError("Something Went Wrong");
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 420) {
        Storage.instance.logout();
        Navigation.instance.navigateAndRemoveUntil('/login');
        showError("Oops! Your session expired. Please Login Again");
      }
      debugPrint("advertiseWithUs error: ${e.response}");
      return GenericResponse.withError(e.message);
    }
  }

  Future<GenericResponse> postFeedback(feedback) async {
    var url = "${baseUrl}/app/post-feedback";
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
      'comment': feedback,
    };
    debugPrint(jsonEncode(data));

    try {
      Response? response = await dio?.post(
        url,
        data: data,
        // queryParameters: data,
      );
      debugPrint("feedback response: ${response?.data}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return GenericResponse.fromJson(response?.data);
      } else {
        debugPrint("feedback error: ${response?.data}");
        return GenericResponse.withError("Something Went Wrong");
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 420) {
        Storage.instance.logout();
        Navigation.instance.navigateAndRemoveUntil('/login');
        showError("Oops! Your session expired. Please Login Again");
      }
      debugPrint("feedback error: ${e.response}");
      return GenericResponse.withError(e.message);
    }
  }

  Future<GenericResponse> deactiveAccount() async {
    var url = "${baseUrl}/request-for-deactive";
    BaseOptions option =
        BaseOptions(connectTimeout: 80000, receiveTimeout: 80000, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Storage.instance.token}'
      // 'APP-KEY': ConstanceData.app_key
    });
    dio = Dio(option);
    debugPrint(url.toString());
    // var data = {
    //   'comment': feedback,
    // };
    // debugPrint(jsonEncode(data));

    try {
      Response? response = await dio?.post(
        url,
        // data: data,
        // queryParameters: data,
      );
      debugPrint("deactiveAccount response: ${response?.data}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return GenericResponse.fromJson(response?.data);
      } else {
        debugPrint("deactiveAccount error: ${response?.data}");
        return GenericResponse.withError("Something Went Wrong");
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 420) {
        Storage.instance.logout();
        Navigation.instance.navigateAndRemoveUntil('/login');
        showError("Oops! Your session expired. Please Login Again");
      }
      debugPrint("deactiveAccount error: ${e.response}");
      return GenericResponse.withError(e.message);
    }
  }

  Future<ReferEarnHistoryResponse> fetchReferEarnHistory() async {
    var url = "${baseUrl}/app/history-refer-n-earn";
    BaseOptions option =
        BaseOptions(connectTimeout: 80000, receiveTimeout: 80000, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Storage.instance.token}'
      // 'APP-KEY': ConstanceData.app_key
    });
    dio = Dio(option);
    debugPrint(url.toString());
    // var data = {
    //   'first_name': f_name,
    //   'last_name': l_name,
    //   'email': email,
    //   'mobile': mobile,
    //   'ad_type': ad_type,
    //   'feedback': feedback,
    // };
    // debugPrint(jsonEncode(data));

    try {
      Response? response = await dio?.get(
        url,
        // data: data,
        // queryParameters: data,
      );
      debugPrint("ReferEarnHistoryResponse response: ${response?.data}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return ReferEarnHistoryResponse.withJson(response?.data);
      } else {
        debugPrint("ReferEarnHistoryResponse error: ${response?.data}");
        return ReferEarnHistoryResponse.withError("Something Went Wrong");
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 420) {
        Storage.instance.logout();
        Navigation.instance.navigateAndRemoveUntil('/login');
        showError("Oops! Your session expired. Please Login Again");
      }
      debugPrint("ReferEarnHistoryResponse error: ${e.response}");
      return ReferEarnHistoryResponse.withError(e.message);
    }
  }

  Future<GenericResponse> postCommentLike(comment_id, is_liked) async {
    var url = "${baseUrl}/app/comment/like";
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
    debugPrint(jsonEncode(data));

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
      if (e.response?.statusCode == 420) {
        Storage.instance.logout();
        Navigation.instance.navigateAndRemoveUntil('/login');
        showError("Oops! Your session expired. Please Login Again");
      }
      debugPrint("postLike error: ${e.response}");
      return GenericResponse.withError(e.message);
    }
  }

  Future<GenericResponse> addBookmark(bookmark_for_id, type) async {
    var url = "${baseUrl}/app/bookmark";
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
      'bookmark_for_id': bookmark_for_id,
      'type': type,
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
      debugPrint("addBookmark response: ${response?.data}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return GenericResponse.fromJson(response?.data);
      } else {
        debugPrint("addBookmark error: ${response?.data}");
        return GenericResponse.withError("Something Went Wrong");
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 420) {
        Storage.instance.logout();
        Navigation.instance.navigateAndRemoveUntil('/login');
        showError("Oops! Your session expired. Please Login Again");
      }
      debugPrint("addBookmark error: ${e.response}");
      return GenericResponse.withError(e.message);
    }
  }

  Future<BookmarkItemsResponse> fetchBookmarks() async {
    var url = "${baseUrl}/app/bookmark";
    BaseOptions option =
        BaseOptions(connectTimeout: 80000, receiveTimeout: 80000, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Storage.instance.token}'
      // 'APP-KEY': ConstanceData.app_key
    });
    dio = Dio(option);
    debugPrint(url.toString());
    // var data = {
    //   'bookmark_for_id': bookmark_for_id,
    //   'type': type,
    // };
    //attachment_list[0][file_data]
    //attachment_list[0][file_type]
    // debugPrint(jsonEncode(data));

    try {
      Response? response = await dio?.get(
        url,
        // data: data,
        // queryParameters: data,
      );
      debugPrint("BookmarkItems response: ${response?.data}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return BookmarkItemsResponse.fromJson(response?.data);
      } else {
        debugPrint("BookmarkItems error: ${response?.data}");
        return BookmarkItemsResponse.withError("Something Went Wrong");
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 420) {
        Storage.instance.logout();
        Navigation.instance.navigateAndRemoveUntil('/login');
        showError("Oops! Your session expired. Please Login Again");
      }
      debugPrint("BookmarkItems error: ${e.response}");
      return BookmarkItemsResponse.withError(e.message);
    }
  }

  Future<MessageResponse> fetchMessages() async {
    var url = "${baseUrl}/messages";
    BaseOptions option =
        BaseOptions(connectTimeout: 80000, receiveTimeout: 80000, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Storage.instance.token}'
      // 'APP-KEY': ConstanceData.app_key
    });
    dio = Dio(option);
    debugPrint(url.toString());
    // var data = {
    //   'bookmark_for_id': bookmark_for_id,
    //   'type': type,
    // };
    //attachment_list[0][file_data]
    //attachment_list[0][file_type]
    // debugPrint(jsonEncode(data));

    try {
      Response? response = await dio?.get(
        url,
        // data: data,
        // queryParameters: data,
      );
      debugPrint("MessageResponse  response: ${response?.data}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return MessageResponse.fromJson(response?.data);
      } else {
        debugPrint("MessageResponse  error: ${response?.data}");
        return MessageResponse.withError("Something Went Wrong");
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 420) {
        Storage.instance.logout();
        Navigation.instance.navigateAndRemoveUntil('/login');
        showError("Oops! Your session expired. Please Login Again");
      }
      debugPrint("MessageResponse  error: ${e.response}");
      return MessageResponse.withError(e.message);
    }
  }

  Future<GenericResponse> postLike(like_for_id, is_liked, like_for) async {
    var url = "${baseUrl}/app/post/like";
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
      'like_for_id': like_for_id,
      'like_for': like_for,
      'is_liked': is_liked,
    };
    //attachment_list[0][file_data]
    //attachment_list[0][file_type]
    debugPrint(jsonEncode(data));

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
      if (e.response?.statusCode == 420) {
        Storage.instance.logout();
        Navigation.instance.navigateAndRemoveUntil('/login');
        showError("Oops! Your session expired. Please Login Again");
      }
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
    debugPrint(jsonEncode(data));

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
      if (e.response?.statusCode == 420) {
        Storage.instance.logout();
        Navigation.instance.navigateAndRemoveUntil('/login');
        showError("Oops! Your session expired. Please Login Again");
      }
      debugPrint("postComment error: ${e.response}");
      return GenericResponse.withError(e.message);
    }
  }

  Future<CreateOrderResponse> createOrder(subscription_id, use_referral_point,
      name, email, phone, device_type) async {
    var url = "${baseUrl}/app/order/subscription";
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
      'subscription_id': subscription_id,
      'use_referral_point': use_referral_point,
      'payment_name': name,
      'payment_email': email,
      'payment_mobile': phone,
      'device_type': device_type
    };
    //attachment_list[0][file_data]
    //attachment_list[0][file_type]
    debugPrint(jsonEncode(data));

    try {
      Response? response = await dio?.post(
        url,
        data: data,
        // queryParameters: data,
      );
      debugPrint("CreateOrderResponse response: ${response?.data}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return CreateOrderResponse.fromJson(response?.data);
      } else {
        debugPrint("CreateOrderResponse1 error: ${response?.data}");
        return CreateOrderResponse.withError("Something Went Wrong");
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 420) {
        Storage.instance.logout();
        Navigation.instance.navigateAndRemoveUntil('/login');
        showError("Oops! Your session expired. Please Login Again");
      }
      debugPrint("CreateOrderResponse2 error: ${e.response} ${e.message}");
      return CreateOrderResponse.withError(e.message);
    }
  }

  Future<GenericResponse> deleteCitizenJournalist(id) async {
    var url = "${baseUrl}/app/citizen-journalist-delete/${id}";
    BaseOptions option =
        BaseOptions(connectTimeout: 80000, receiveTimeout: 80000, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Storage.instance.token}'
      // 'APP-KEY': ConstanceData.app_key
    });
    dio = Dio(option);
    debugPrint(url.toString());
    // var data = {
    //   'comment_for_id': comment_for_id,
    //   'comment_for': comment_for,
    //   'comment': comment,
    // };
    //attachment_list[0][file_data]
    //attachment_list[0][file_type]
    // debugPrint(jsonEncode(data));

    try {
      Response? response = await dio?.post(
        url,
        // data: data,
        // queryParameters: data,
      );
      debugPrint("citizen-journalist-delete response: ${response?.data}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return GenericResponse.fromJson(response?.data);
      } else {
        debugPrint("citizen-journalist-delete error: ${response?.data}");
        return GenericResponse.withError("Something Went Wrong");
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 420) {
        Storage.instance.logout();
        Navigation.instance.navigateAndRemoveUntil('/login');
        showError("Oops! Your session expired. Please Login Again");
      }
      debugPrint("citizen-journalist-delete error: ${e.response}");
      return GenericResponse.withError(e.message);
    }
  }

  Future<GenericResponse> deleteClassified(id) async {
    var url = "${baseUrl}/app/classified-delete/${id}";
    BaseOptions option =
        BaseOptions(connectTimeout: 80000, receiveTimeout: 80000, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Storage.instance.token}'
      // 'APP-KEY': ConstanceData.app_key
    });
    dio = Dio(option);
    debugPrint(url.toString());
    // var data = {
    //   'comment_for_id': comment_for_id,
    //   'comment_for': comment_for,
    //   'comment': comment,
    // };
    //attachment_list[0][file_data]
    //attachment_list[0][file_type]
    // debugPrint(jsonEncode(data));

    try {
      Response? response = await dio?.post(
        url,
        // data: data,
        // queryParameters: data,
      );
      debugPrint("deleteClassified response: ${response?.data}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return GenericResponse.fromJson(response?.data);
      } else {
        debugPrint("deleteClassified error: ${response?.data}");
        return GenericResponse.withError("Something Went Wrong");
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 420) {
        Storage.instance.logout();
        Navigation.instance.navigateAndRemoveUntil('/login');
        showError("Oops! Your session expired. Please Login Again");
      }
      debugPrint("deleteClassified error: ${e.response}");
      return GenericResponse.withError(e.message);
    }
  }

  Future<GenericResponse> versionCheck(
      String version, String buildNumber) async {
    var url = "${baseUrl}/verify-version";
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
      'version_code': version,
      'build_no': buildNumber,
    };
    //attachment_list[0][file_data]
    //attachment_list[0][file_type]
    // debugPrint(jsonEncode(data));

    try {
      Response? response = await dio?.get(
        url,
        // data: data,
        queryParameters: data,
      );
      debugPrint("verify-version response: ${response?.data}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return GenericResponse.fromJson(response?.data);
      } else {
        debugPrint("verify-version error: ${response?.data}");
        return GenericResponse.withError("Something Went Wrong");
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 420) {
        Storage.instance.logout();
        Navigation.instance.navigateAndRemoveUntil('/login');
        showError("Oops! Your session expired. Please Login Again");
      }
      debugPrint("verify-version error: ${e.response}");
      return GenericResponse.withError(e.message);
    }
  }

  Future<GenericDataResponse> getAdImage() async {
    var url = "${baseUrl}/free-subscriber";
    BaseOptions option =
        BaseOptions(connectTimeout: 80000, receiveTimeout: 80000, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Storage.instance.token}'
      // 'APP-KEY': ConstanceData.app_key
    });
    dio = Dio(option);
    debugPrint(url.toString());

    //attachment_list[0][file_data]
    //attachment_list[0][file_type]
    // debugPrint(jsonEncode(data));

    try {
      Response? response = await dio?.get(
        url,
        // data: data,
        // queryParameters: data,
      );
      debugPrint("free-subscriber response: ${response?.data}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return GenericDataResponse.fromJson(response?.data);
      } else {
        debugPrint("free-subscriber error: ${response?.data}");
        return GenericDataResponse.withError("Something Went Wrong");
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 420) {
        Storage.instance.logout();
        Navigation.instance.navigateAndRemoveUntil('/login');
        showError("Oops! Your session expired. Please Login Again");
      }
      debugPrint("free-subscriber error: ${e.response}");
      return GenericDataResponse.withError(e.message);
    }
  }

  Future<GenericResponse> deleteGuwhatiConnect(id) async {
    var url = "${baseUrl}/app/guwahati-connect-delete/${id}";
    BaseOptions option =
        BaseOptions(connectTimeout: 80000, receiveTimeout: 80000, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Storage.instance.token}'
      // 'APP-KEY': ConstanceData.app_key
    });
    dio = Dio(option);
    debugPrint(url.toString());
    // var data = {
    //   'comment_for_id': comment_for_id,
    //   'comment_for': comment_for,
    //   'comment': comment,
    // };
    //attachment_list[0][file_data]
    //attachment_list[0][file_type]
    // debugPrint(jsonEncode(data));

    try {
      Response? response = await dio?.post(
        url,
        // data: data,
        // queryParameters: data,
      );
      debugPrint("guwahati-connect-delete response: ${response?.data}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return GenericResponse.fromJson(response?.data);
      } else {
        debugPrint("guwahati-connect-delete error: ${response?.data}");
        return GenericResponse.withError("Something Went Wrong");
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 420) {
        Storage.instance.logout();
        Navigation.instance.navigateAndRemoveUntil('/login');
        showError("Oops! Your session expired. Please Login Again");
      }
      debugPrint("guwahati-connect-delete error: ${e.response}");
      return GenericResponse.withError(e.message);
    }
  }

  Future<GenericResponse> postGrievance(fname, lname, mobile, email, address,
      pincode, link, dop, details, summary, name, date) async {
    var url = "${baseUrl}/submit-grievance-form";
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
      "first_name": fname,
      "last_name": lname,
      "phone_number": mobile,
      "email": email,
      "full_address": address,
      "pincode": pincode,
      "complain_link": link,
      "date_of_publication": dop,
      "exact_details": details,
      "summery_details": summary,
      "name": name,
      "date": date,
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
      debugPrint("postGrievance response: ${response?.data}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return GenericResponse.fromJson(response?.data);
      } else {
        debugPrint("postGrievance error: ${response?.data}");
        return GenericResponse.withError("Something Went Wrong");
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 420) {
        Storage.instance.logout();
        Navigation.instance.navigateAndRemoveUntil('/login');
        showError("Oops! Your session expired. Please Login Again");
      }
      debugPrint("postGrievance error: ${e.response}");
      return GenericResponse.withError(e.message);
    }
  }

  Future<GenericResponse> postClassified(classified_category_id, locality_name,
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
      'locality_name': locality_name,
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
    debugPrint(data.fields.toString());

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
      if (e.response?.statusCode == 420) {
        Storage.instance.logout();
        Navigation.instance.navigateAndRemoveUntil('/login');
        showError("Oops! Your session expired. Please Login Again");
      }
      debugPrint("postClassified error: ${e.response}");
      return GenericResponse.withError(e.message);
    }
  }

  Future<GenericResponse> updateClassified(
      classified_category_id,
      locality_id,
      title,
      description,
      price,
      List<File> files,
      prev_attachment_ids,
      id) async {
    var url = "${baseUrl}/app/classified/${id}";
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
      'prev_attachment_ids': prev_attachment_ids,
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
    debugPrint(data.fields.toString());
    debugPrint(data.files.toString());

    try {
      Response? response = await dio?.post(
        url,
        data: data,
        // queryParameters: data,
      );
      debugPrint("update Classified response: ${response?.data}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return GenericResponse.fromJson(response?.data);
      } else {
        debugPrint("update Classified error: ${response?.data}");
        return GenericResponse.withError("Something Went Wrong");
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 420) {
        Storage.instance.logout();
        Navigation.instance.navigateAndRemoveUntil('/login');
        showError("Oops! Your session expired. Please Login Again");
      }
      debugPrint("update Classified error: ${e.response}");
      return GenericResponse.withError(e.message);
    }
  }

  Future<GenericResponse> postCitizenJournalist(
      title, story, List<File> files, is_story_submit) async {
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
      'is_story_submit': is_story_submit,
    });
    for (int i = 0; i < files.length; i++) {
      var type = lookupMimeType(
        files[i].path,
      )!;
      print(type);
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
    debugPrint(data.fields.toString());

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
      if (e.response?.statusCode == 420) {
        Storage.instance.logout();
        Navigation.instance.navigateAndRemoveUntil('/login');
        showError("Oops! Your session expired. Please Login Again");
      }
      debugPrint("postCitizenJournalist error: ${e.response}");
      return GenericResponse.withError(e.message);
    }
  }

  Future<GenericResponse> editCitizenJournalist(
      id, title, story, List<File> files, is_story_submit) async {
    var url = "${baseUrl}/app/citizen-journalist/${id}";
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
      'is_story_submit': is_story_submit,
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
    debugPrint(data.fields.toString());
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
      if (e.response?.statusCode == 420) {
        Storage.instance.logout();
        Navigation.instance.navigateAndRemoveUntil('/login');
        showError("Oops! Your session expired. Please Login Again");
      }
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
    // debugPrint(jsonEncode(data.fields));
    print(data.fields);
    // debugPrint(jsonEncode(data.files));

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
      if (e.response?.statusCode == 420) {
        Storage.instance.logout();
        Navigation.instance.navigateAndRemoveUntil('/login');
        showError("Oops! Your session expired. Please Login Again");
      }
      debugPrint("postguwahati-connect error: ${e.response}");
      return GenericResponse.withError(e.message);
    }
  }

  Future<GenericResponse> updateGuwahatiConnect(
      id, question, List<File> files, prev_attachments) async {
    var url = "${baseUrl}/app/guwahati-connect/${id}";
    BaseOptions option =
        BaseOptions(connectTimeout: 80000, receiveTimeout: 80000, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Storage.instance.token}'
      // 'APP-KEY': ConstanceData.app_key
    });
    print(Storage.instance.token);
    dio = Dio(option);
    debugPrint(url.toString());
    FormData data = FormData.fromMap({
      'question': question,
      'prev_attachment_ids': prev_attachments,
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
    // debugPrint(jsonEncode(data.fields));
    print(data.fields);
    print(data.files);
    // debugPrint(jsonEncode(data.files));

    try {
      Response? response = await dio?.post(
        url,
        data: data,
        // queryParameters: data,
      );
      debugPrint("update guwahati-connect response: ${response?.data}");
      if (response?.statusCode == 200 || response?.statusCode == 201) {
        return GenericResponse.fromJson(response?.data);
      } else {
        debugPrint("update guwahati-connect error: ${response?.data}");
        return GenericResponse.withError("Something Went Wrong");
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 420) {
        Storage.instance.logout();
        Navigation.instance.navigateAndRemoveUntil('/login');
        showError("Oops! Your session expired. Please Login Again");
      }
      debugPrint("update guwahati-connect error: ${e.response}");
      return GenericResponse.withError(e.message);
    }
  }

  Future download2(String url,String title) async {
    Navigation.instance.goBack();
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var tempDir = "/storage/emulated/0/Download";
    DateTime now = DateTime.now();
    DateTime date = DateTime(
        now.year, now.month, now.day, now.hour, now.minute, now.second);
    String fullPath = tempDir +
        "/" +
        "gplus_edition_"
            "${date.toString().split(" ")[0].replaceAll("-", "").replaceAll(".", "")}" +
        "_${date.toString().split(" ")[1].replaceAll(":", "").replaceAll(".", "")}.pdf";
    String actualPath = "$tempDir/$title.pdf";
    print('full path ${fullPath} ${actualPath}');
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
      debugPrint(response?.headers.toString());
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

  void showError(String msg) {
    AlertX.instance.showAlert(
        title: "Error",
        msg: msg,
        positiveButtonText: "Done",
        positiveButtonPressed: () {
          Navigation.instance.goBack();
        });
  }
}
