import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../Model/login_response.dart';

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


}
