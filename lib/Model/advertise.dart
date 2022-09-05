class Advertise {
  int? id,
      status,
      default_ad,
      display_count,
      hit_count,
      type,
      assamese,
      is_app,
      is_web;
  String? title,
      page_type,
      ad_type,
      image_file_name,
      publish_date,
      link,
      mobile_image_file_name;

  Advertise.fromJson(json) {
    id = json['id'] ?? 0;
    status = json['status'] ?? 0;
    default_ad = json['default_ad'] ?? 0;
    display_count = json['display_count'] ?? 0;
    hit_count = json['hit_count'] ?? 0;
    type = json['type'] ?? 0;
    assamese = json['assamese'] ?? 0;
    is_app = json['is_app'] ?? 0;
    is_web = json['is_web'] ?? 0;

    //String
    title = json['title'] ?? "";
    link = json['link'] ?? "";
    page_type = json['page_type'] ?? "";
    ad_type = json['ad_type'] ?? "";
    publish_date = json['publish_date'] ?? "";
    image_file_name = json['image_file_name'] ?? "";
    mobile_image_file_name = json['mobile_image_file_name'] ?? "";
  }
}

class AdvertiseResponse {
  bool? success;
  String? message;
  List<Advertise>? ads;

  AdvertiseResponse.fromJson(json) {
    success = json['success'].toString() == 'true' ? true : false;
    message = json['message'] ?? "Something Went Wrong";
    ads = json['data'] == null
        ? []
        : (json['data'] as List).map((e) => Advertise.fromJson(e)).toList();
  }

  AdvertiseResponse.withError(msg) {
    success = false;
    message = msg ?? "Something Went Wrong";
  }
}
