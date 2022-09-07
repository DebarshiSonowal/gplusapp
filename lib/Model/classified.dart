import 'package:gplusapp/Model/category_name.dart';

import 'attach_file.dart';
import 'locality.dart';

class Classified {
  int? id, user_id, classified_category_id, locality_id, status;
  double? price;
  CategoryName? categoryName;
  String? title, description;
  Locality? locality;
  List<AttachFile>? attach_files;

  Classified.fromJson(json) {
    id = json['id'] ?? 0;
    user_id =
        json['user_id'] == null ? 0 : int.parse(json['user_id'].toString());
    status = json['status'] == null ? 0 : int.parse(json['status'].toString());
    locality_id = json['locality_id'] == null
        ? 0
        : int.parse(json['locality_id'].toString());
    classified_category_id = json['classified_category_id'] == null
        ? 0
        : int.parse(json['classified_category_id'].toString());

    //double
    price = json['price'] == null ? 0 : double.parse(json['price'].toString());

    //Category
    categoryName = CategoryName.fromJson(json['category']);

    locality = Locality.fromJson(json['locality']);

    attach_files = json['attached_files'] == null
        ? []
        : (json['attached_files'] as List)
            .map((e) => AttachFile.fromJson(e))
            .toList();

    title = json['title']??"";
    description = json['description']??"";
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
