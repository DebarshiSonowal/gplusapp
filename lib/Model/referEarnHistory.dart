import 'dart:convert';

class ReferEarnHistory {
  int? id,
      user_id,
      earn_from_user_id,
      points,
      is_subscription,
      plan_id,
      is_credit,
      status;
  String? created_at, updated_at;

  ReferEarnHistory.fromJson(json) {
    id = json['id'] ?? 0;
    user_id = int.parse((json['user_id'] ?? 0).toString());
    earn_from_user_id = int.parse((json['earn_from_user_id'] ?? 0).toString());
    points = int.parse((json['points'] ?? 0).toString());
    is_subscription = int.parse((json['is_subscription'] ?? 0).toString());
    plan_id = int.parse((json['plan_id'] ?? 0).toString());
    is_credit = int.parse((json['is_credit'] ?? 0).toString());
    status = int.parse((json['status'] ?? 0).toString());

    //String
    updated_at = json['updated_at'] == null
        ? ""
        : '${json['updated_at'].toString().split("T")[0]}';
    created_at = json['created_at'] == null
        ? ""
        : json['created_at'].toString().split("T")[0];
  }
}

class ReferEarnHistoryResponse {
  bool? success;
  String? message,empty,invite;
  List<ReferEarnHistory> history = [];


  ReferEarnHistoryResponse.withJson(json) {
    success = json['success'] ?? false;
    message = json['message'] ?? "";
    empty = json['data']['history_empty_msg'] ?? "";
    invite = json['data']['invite_msg'] ?? "";
    history = json['data']['history'] == null
        ? []
        : (json['data']['history'] as List)
            .map((e) => ReferEarnHistory.fromJson(e))
            .toList();
  }

  ReferEarnHistoryResponse.withError(msg) {
    success = false;
    message = msg ?? "Something went wrong";
  }
}
