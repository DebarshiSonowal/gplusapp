class MessageResponse {
  bool? success;
  String? message,
      deal,
      classified,
      beajournalist,
      beamember,
      guwahatiConnect,
      redeem,
      refer,
      benifit,paywall;

  MessageResponse.fromJson(json) {
    success = json['success'] ?? false;
    message = json['message'] ?? "";
    deal = json['result']['deal-welcome-msg'] ?? "";
    classified = json['result']['classified-listing-msg'] ?? "";
    beajournalist = json['result']['be-a-journalist-msg'] ?? "";
    beamember = json['result']['be-a-member-msg'] ?? "";
    guwahatiConnect = json['result']['guwahati-connect-msg'] ?? "";
    redeem = json['result']['redeem-confirmation-msg'] ?? "";
    refer = json['result']['refer-n-earn-msg'] ?? "";
    benifit = json['result']['benifit-members-list'] ?? "";
    paywall = json['result']['paywall-msg'] ?? "";
  }

  MessageResponse.withError(msg) {
    success = false;
    message = msg;
  }
}
