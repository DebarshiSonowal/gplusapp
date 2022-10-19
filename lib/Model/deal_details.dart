import 'coupon.dart';

class DealDetails {
  int? id,
      city_id,
      mobile,
      status,
      pin_code,
      locality_id,
      alt_mobile,
      shop_type_id;
  String? code,
      shop_name,
      contact_name,
      email,
      image_file_name,
      address,
      opening_time,
      closing_time;
  double? latitude, longitude;
  List<Coupon>? coupons;


  DealDetails.fromJson(json) {
    //int
    id = json['id'] ?? 0;
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
    status = json['status'] == null ? 0 : int.parse(json['status'].toString());

    //double
    latitude = json['latitude'] == null
        ? 0
        : double.parse(json['latitude'].toString());
    longitude = json['longitude'] == null
        ? 0
        : double.parse(json['longitude'].toString());

    //String
    image_file_name = json['image_file_name'] ?? "";
    code = json['code'] ?? "";
    shop_name = json['shop_name'] ?? "";
    contact_name = json['contact_name'] ?? "";
    email = json['email'] ?? "";
    address = json['address'] ?? "";
    opening_time = json['opening_time'] ?? "";
    closing_time = json['closing_time'] ?? "";
    // address = json['address']??"";

    coupons = json['coupons'] == null
        ? []
        : (json['coupons'] as List).map((e) => Coupon.fromJson(e)).toList();


  }
}

class DealDetailsResponse {
  bool? success;
  String? message;
  DealDetails? details;

  DealDetailsResponse.fromJson(json) {
    success = json['success'].toString() == 'true' ? true : false;
    message = json['message'] ?? "Something Went Wrong";
    details = DealDetails.fromJson(json['result']);
  }

  DealDetailsResponse.withError(msg) {
    success = false;
    message = msg ?? "Something Went Wrong";
  }
}
