class NotificationInDevice {
  String? id,
      notifiable_type,
      created_at,
      title,
      type,
      author_name,
      seo_name,
      category_name,
      seo_name_category,
      web_path,
      api_path,
      read_at,
      vendor_id,
      notification_id,
      category_id;

  NotificationInDevice.fromJson(json) {
    id = json['id'] ?? "";
    notifiable_type = json['notifiable_type'] ?? "";
    created_at = json['created_at'] ?? "";
    read_at = json['read_at'] ?? "";
    vendor_id = json['vendor_id'] ?? "";
    notification_id = json['notification_id']??"";
    title = json['data']['title'] ?? "";
    type = json['data']['type'] ?? "";
    author_name = json['data']['author_name'] ?? "G Plus";
    seo_name = json['data']['seo_name'] ?? "";
    category_name = json['data']['category_name'] ?? "";
    seo_name_category = json['data']['seo_name_category'] ?? "";
    web_path = json['data']['web_path'] ?? "";
    api_path = json['data']['api_path'] ?? "";
    category_id = (json['category_id'] ?? "") as String;
  }
}

class NotificationInDeviceResponse {
  bool? success;
  String? message;
  List<NotificationInDevice> notification = [];

  NotificationInDeviceResponse.fromJson(json) {
    success = json['success'] ?? false;
    message = json['message'] ?? "Something went wrong";
    notification = (json['result'] as List)
        .map((e) => NotificationInDevice.fromJson(e))
        .toList();
  }

  NotificationInDeviceResponse.withError(msg) {
    success = false;
    message = msg;
  }
}
