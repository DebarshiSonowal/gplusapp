import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gplusapp/Model/profile.dart';
import 'package:http/http.dart' as http;

import '../Model/article.dart';
import '../Model/article_desc.dart';
import '../Model/login_response.dart';
import '../Model/opinion.dart';

class ApiProvider {
  ApiProvider._();

  static final ApiProvider instance = ApiProvider._();
  final String baseUrl = "http://gplus.shecure.co.in/api/v1";
  final String path = "/books";

  Dio? dio;

  BaseOptions option =
      BaseOptions(connectTimeout: 80000, receiveTimeout: 80000, headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    // 'APP-KEY': ConstanceData.app_key
  });

  Future<LoginResponse> login(mobile) async {
    var data = {
      'mobile': mobile,
    };

    var url = "${baseUrl}/generate-login-otp";
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

  Future<ArticleResponse> getArticle(categ_name) async {
    // var data = {
    //   // 'mobile': mobile,
    // };

    var url = "${baseUrl}/${categ_name}";
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

  Future<OpinionResponse> getOpinion(category, per_page, page) async {
    var data = {
      'category': category,
      'per_page': per_page,
      'page': page,
    };

    var url = "${baseUrl}/opinion-list";
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
}
