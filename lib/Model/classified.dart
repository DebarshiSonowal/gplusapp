import 'package:gplusapp/Model/category_name.dart';

import 'attach_file.dart';
import 'locality.dart';
import 'profile.dart';

class Classified {
  int? id, user_id, classified_category_id, locality_id, status, total_views;
  double? price;
  CategoryName? categoryName;
  String? title, description, disclaimer;
  Locality? locality;
  List<AttachFile>? attach_files;
  Profile? user;
  bool? is_post_by_me, is_favourite, has_permission;

  Classified.fromJson(json) {
    id = json['id'] ?? 0;
    user_id =
        json['user_id'] == null ? 0 : int.parse(json['user_id'].toString());
    status = json['status'] == null ? 0 : int.parse(json['status'].toString());
    locality_id = json['locality_id'] == null
        ? 0
        : int.parse(json['locality_id'].toString());
    total_views = json['total_views'] == null
        ? 0
        : int.parse(json['total_views'].toString());
    classified_category_id = json['classified_category_id'] == null
        ? 0
        : int.parse(json['classified_category_id'].toString());

    has_permission = json['has_permission'] ?? false;

    //double
    price = json['price'] == null ? 0 : double.parse(json['price'].toString());

    is_post_by_me = json['is_post_by_me'] ?? false;
    is_favourite = json['is_favourite'] == 1 ? true : false;
    //Category
    categoryName = CategoryName.fromJson(json['category']);

    locality = json['locality'] == null
        ? Locality(json['locality_id'], 0, 1, json['locality_name'])
        : Locality.fromJson(json['locality']);

    attach_files = json['attached_files'] == null
        ? []
        : (json['attached_files'] as List)
            .map((e) => AttachFile.fromJson(e))
            .toList();
    if (json['user'] != null) {
      user = Profile.fromJson(json['user']);
    }
    title = json['title'] ?? "";
    description = json['description'] ?? "";
    disclaimer = json['call_disclaimer'] ?? "";
  }
}

class ClassifiedResponse {
  bool? success;
  String? message;
  List<Classified>? classifieds;

  ClassifiedResponse.fromJson(json) {
    success = json['success'].toString() == 'true' ? true : false;
    message = json['message'] ?? "Something Went Wrong";
    classifieds = json['data'] == null
        ? []
        : (json['data'] as List).map((e) => Classified.fromJson(e)).toList();
  }

  ClassifiedResponse.withError(msg) {
    success = false;
    message = msg ?? "Something Went Wrong";
  }
}

class ClassifiedDetailsResponse {
  bool? success;
  String? message;
  Classified? classifieds;

  ClassifiedDetailsResponse.fromJson(json) {
    success = json['success'].toString() == 'true' ? true : false;
    message = json['message'] ?? "Something Went Wrong";
    try {
      classifieds = Classified.fromJson(json['data']);
    } catch (e) {
      print(e);
    }
  }

  ClassifiedDetailsResponse.withError(msg) {
    success = false;
    message = msg ?? "Something Went Wrong";
  }
}
