class ShopCategory {
  //"id": 1,
  //             "name": "Movies",
  //             "status": "1",
  int? id, status;

  // mobile,
  // city_id,
  // pin_code,
  // locality_id,
  // alt_mobile,
  // shop_type_id,
  // status;
  // double? latitude, longitude;
  // String? code, shop_name, contact_name, email, address;
  String? name, image_file_name;

  ShopCategory.fromJson(json) {
    //int
    id = json['id'] ?? 0;
    status = json['status'] == null ? 0 : int.parse(json['status'].toString());
    // city_id =
    //     json['city_id'] == null ? 0 : int.parse(json['city_id'].toString());
    // pin_code =
    //     json['pin_code'] == null ? 0 : int.parse(json['pin_code'].toString());
    // locality_id = json['locality_id'] == null
    //     ? 0
    //     : int.parse(json['locality_id'].toString());
    // alt_mobile = json['alt_mobile'] == null
    //     ? 0
    //     : int.parse(json['alt_mobile'].toString());
    // shop_type_id = json['shop_type_id'] == null
    //     ? 0
    //     : int.parse(json['shop_type_id'].toString());
    // status = json['status'] == null ? 0 : int.parse(json['status'].toString());
    // status = json['status'] == null ? 0 : int.parse(json['status'].toString());

    // //double
    // latitude = json['latitude'] == null
    //     ? 0
    //     : double.parse(json['latitude'].toString());
    // longitude = json['longitude'] == null
    //     ? 0
    //     : double.parse(json['longitude'].toString());

    //String
    name = json['name'] ?? "";
    image_file_name = json['image_file_name'] ?? "";
    // shop_name = json['shop_name'] ?? "";
    // contact_name = json['contact_name'] ?? "";
    // email = json['email'] ?? "";
    // address = json['address'] ?? "";
  }
}

class ShopCategoryResponse {
  bool? success;
  String? message;
  List<ShopCategory>? categories;

  ShopCategoryResponse.fromJson(json) {
    success = json['success'].toString() == 'true' ? true : false;
    message = json['message'] ?? "Something Went Wrong";
    categories = json['result'] == null
        ? []
        : (json['result'] as List).map((e) => ShopCategory.fromJson(e)).toList();
  }

  ShopCategoryResponse.withError(msg) {
    success = false;
    message = msg ?? "Something Went Wrong";
  }
}
