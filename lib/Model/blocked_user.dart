// "id": 3,
//             "user_id": 6,
//             "blocked_by_id": 97693,
//             "block_for": "guwahati-connect",
import 'package:flutter/material.dart';
import 'package:gplusapp/Model/profile.dart';

class BlockedUser {
  int? id, user_id, blocked_by_id;
  String? block_for, created_by, updated_by;
  Profile? user,blocked_by;

  BlockedUser() {
    id = 0;
    user_id = 0;
    blocked_by_id = 0;
    block_for = "asd";
    created_by="2020-12-01";
    updated_by="2020-12-01";
  }

  BlockedUser.fromJson(json) {
    debugPrint((json['created_by'] ?? "").toString().split("T").toString());
    id = json['id'] ?? 0;
    user_id = json['user_id'] ?? 0;
    blocked_by_id = json['blocked_by_id'] ?? 0;
    block_for = json['block_for'] ?? "";
    created_by =
        "${(json['created_by'] ?? "").toString().split("T")[0]}";
    updated_by =
        "${(json['updated_by'] ?? "").toString().split("T")[0]}";
    if (json['user']!=null) {
      user = Profile.fromJson(json['user']);
    }
    if (json['blocked_by']!=null) {
      blocked_by = Profile.fromJson(json['blocked_by']);
    }
  }
}

class BlockedUserResponse {
  bool? success;
  String? message;
  List<BlockedUser>? blocked;

  BlockedUserResponse.fromJson(json) {
    success = json['success'] ?? false;
    message = json['message'] ?? "";
    blocked = json['data'] == null
        ? []
        : (json['data'] as List).map((e) => BlockedUser.fromJson(e)).toList();
  }

  BlockedUserResponse.withError(msg) {
    success = false;
    message = msg;
  }
}
