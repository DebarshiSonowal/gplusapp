import 'package:flutter/material.dart';
import 'package:gplusapp/Model/topick.dart';

import 'address.dart';

class Profile {
  String? email,
      gender,
      enc_password,
      name,
      mobile,
      city,
      sign_in_count,
      image_file_name,
      f_name,
      l_name,
      plan_active_date,
      plan_expiry_date,
      plan_reminder_date,
      referral_code,
      dob;
  int? super_admin, role_id, status, id, plan_id, referral_point_balance;
  bool? has_deal_notify_perm,
      has_ghy_connect_notify_perm,
      has_classified_notify_perm;
  List<Address> addresses = [];

  Profile.fromJson(json) {
    // debugPrint(json['name'].toString());
    email = json['email'] ?? "";
    id = json['id'] ?? 0;
    plan_id =
        json['plan_id'] == null ? 0 : int.parse(json['plan_id'].toString());
    enc_password = json['encrypted_password'] ?? "";
    name = json['name'] ?? "";
    f_name = json['f_name'] ?? "";
    l_name = json['l_name'] ?? "";
    dob = json['dob'] ?? "";
    mobile = json['mobile'] ?? "";
    city = json['city'] ?? "";
    gender = json['gender'] ?? "";
    referral_code = json['referral_code'] ?? "";
    image_file_name = json['image_file_name'] ?? "";
    plan_active_date = json['plan_active_date'] ?? "";
    plan_expiry_date = json['plan_expiry_date'] ?? "";
    sign_in_count = json['sign_in_count'] ?? "";
    plan_reminder_date = json['plan_reminder_date'] ?? "";
    super_admin = int.parse((json['super_admin'] ?? 0).toString());
    role_id = int.parse((json['role_id'] ?? 0).toString()) ?? 0;
    status = int.parse((json['status'] ?? 0).toString()) ?? 0;
    referral_point_balance =
        int.parse((json['referral_point_balance'] ?? 0).toString()) ?? 0;

    has_deal_notify_perm = json['has_deal_notify_perm'] == null
        ? false
        : (json['has_deal_notify_perm'].toString() == '0' ? false : true);
    has_ghy_connect_notify_perm = json['has_ghy_connect_notify_perm'] == null
        ? false
        : (json['has_ghy_connect_notify_perm'].toString() == '0'
            ? false
            : true);
    has_classified_notify_perm = json['has_classified_notify_perm'] == null
        ? false
        : (json['has_classified_notify_perm'].toString() == '0' ? false : true);

    addresses = json['addresses'] == null
        ? []
        : (json['addresses'] as List).map((e) => Address.fromJson(e)).toList();
  }
}

class LoginResponse {
  bool? status;
  String? access_token;
  Profile? profile;

  LoginResponse.fromJson(json) {
    status = true;
    access_token = json['access_token'] ?? "";
    profile = Profile.fromJson(json['data']);
  }

  LoginResponse.withError() {
    status = false;
  }
}

class ProfileResponse {
  bool? success;
  String? msg;
  Profile? profile;
  List<Topick> topicks = [];
  List<GeoTopick> geoTopicks = [];

  ProfileResponse.fromJson(json) {
    success = true;
    msg = json['message'] ?? "";
    profile = Profile.fromJson(json['result']['data']);
    topicks = json['result']['data']['topics'] == null
        ? []
        : (json['result']['data']['topics'] as List)
            .map((e) => Topick.fromJson(e))
            .toList();
    geoTopicks = json['result']['data']['geo'] == null
        ? []
        : (json['result']['data']['geo'] as List)
            .map((e) => GeoTopick.fromJson(e))
            .toList();
  }

  ProfileResponse.withError(msg) {
    success = false;
    this.msg = msg ?? "Something went wrong";
  }
}

class AuthorResponse {
  bool? success;
  String? msg;
  Profile? profile;

  // List<Topick> topicks = [];
  // List<GeoTopick> geoTopicks = [];

  AuthorResponse.fromJson(json) {
    success = true;
    msg = json['message'] ?? "";
    profile = Profile.fromJson(json['data']);
  }

  AuthorResponse.withError(msg) {
    success = false;
    this.msg = msg ?? "Something went wrong";
  }
}
