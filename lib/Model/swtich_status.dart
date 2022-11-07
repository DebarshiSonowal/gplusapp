class SwitchStatus {
  bool deal = false, connect = false, classified = false, dark = false;

  SwitchStatus.fromJson(json) {
    deal = json['has_deal_notify_perm'] == null
        ? false
        : (json['has_deal_notify_perm'] == "0" ? false : true);
    connect = json['has_ghy_connect_notify_perm'] == null
        ? false
        : (json['has_ghy_connect_notify_perm'] == "0" ? false : true);
    classified = json['has_deal_notify_perm'] == null
        ? false
        : (json['has_classified_notify_perm'] == "0" ? false : true);
    dark = json['has_dark_mode_perm'] == null
        ? false
        : (json['has_dark_mode_perm'] == "0" ? false : true);
  }
}

class SwitchStatusResponse {
  bool? success;
  String? msg;
  SwitchStatus? status;

  SwitchStatusResponse.fromJson(json) {
    success = json['success'] ?? false;
    msg = json['message'] ?? "Something went wrong";
    status = SwitchStatus.fromJson(json['result']);
  }
  SwitchStatusResponse.withError(message){
    success = false;
    msg = message;
  }
}
