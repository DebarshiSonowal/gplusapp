import 'package:gplusapp/Model/vendor.dart';

class Shop {
  int? id,
      vendor_id,
      is_percent,
      is_one_time,
      total,
      active_total_days,
      total_used,
      total_blocked,
      balance,
      plan_id,
      mobile,
      city_id,
      pin_code,
      locality_id,
      alt_mobile,
      shop_type_id,
      status;
  String? code,
      title,
      valid_from,
      valid_to,
      description,
      plan_active_date,
      plan_expiry_date,
      created_by,
      image_file_name,
      shop_name,
      address;

  // Vendor? vendor;

  Shop.fromJson(json) {
    id = json['id'] ?? 0;
    status = json['status'] == null ? 0 : int.parse(json['status'].toString());
    vendor_id =
        json['vendor_id'] == null ? 0 : int.parse(json['vendor_id'].toString());
    is_percent = json['is_percent'] == null
        ? 0
        : int.parse(json['is_percent'].toString());
    is_one_time = json['is_one_time'] == null
        ? 0
        : int.parse(json['is_one_time'].toString());
    total = json['total'] == null ? 0 : int.parse(json['total'].toString());
    active_total_days = json['active_total_days'] == null
        ? 0
        : int.parse(json['active_total_days'].toString());
    total_used = json['total_used'] == null
        ? 0
        : int.parse(json['total_used'].toString());
    total_blocked = json['total_blocked'] == null
        ? 0
        : int.parse(json['total_blocked'].toString());
    balance =
        json['balance'] == null ? 0 : int.parse(json['balance'].toString());
    plan_id =
        json['plan_id'] == null ? 0 : int.parse(json['plan_id'].toString());
    mobile = json['mobile'] == null ? 0 : int.parse(json['mobile'].toString());
    city_id =
        json['city_id'] == null ? 0 : int.parse(json['city_id'].toString());
    pin_code =
        json['pin_code'] == null ? 0 : int.parse(json['pin_code'].toString());
    locality_id = json['locality_id'] == null
        ? 0
        : int.parse(json['locality_id'].toString());
    alt_mobile = json['alt_mobile'] == null
        ? 0
        : int.parse(json['alt_mobile'].toString());
    shop_type_id = json['shop_type_id'] == null
        ? 0
        : int.parse(json['shop_type_id'].toString());
    image_file_name = json['image_file_name'] ?? "";
    shop_name = json['shop_name'] ?? "";
    address = json['address'] ?? "";
    //String
    code = json['code'] ?? "";
    title = json['title'] ?? "";
    valid_from = json['valid_from'] ?? "";
    valid_to = json['valid_to'] ?? "";
    description = json['description'] ?? "";
    plan_active_date = json['plan_active_date'] ?? "";
    plan_expiry_date = json['plan_expiry_date'] ?? "";
    created_by = json['created_by'] ?? "";

    // vendor = Vendor.fromJson(json['vendor']);
  }
}

class ShopResponse {
  bool? success;
  String? message;
  List<Shop>? shops;

  ShopResponse.fromJson(json) {
    success = json['success'].toString() == 'true' ? true : false;
    message = json['message'] ?? "Something Went Wrong";
    shops = json['result'] == null
        ? []
        : (json['result'] as List).map((e) => Shop.fromJson(e)).toList();
  }

  ShopResponse.withError(msg) {
    success = false;
    message = msg ?? "Something Went Wrong";
  }
}
