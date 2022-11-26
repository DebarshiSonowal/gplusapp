class MessageResponse {
  bool? success;
  String? message, deal, classified;

  MessageResponse.fromJson(json) {
    success = json['success'] ?? false;
    message = json['message'] ?? "";
    deal = json['result']['deal-welcome-msg'] ?? "";
    message = json['result']['classified-listing-msg'] ?? "";
  }

  MessageResponse.withError(msg) {
    success = false;
    message = msg;
  }
}
