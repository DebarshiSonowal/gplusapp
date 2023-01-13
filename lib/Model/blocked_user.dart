// "id": 3,
//             "user_id": 6,
//             "blocked_by_id": 97693,
//             "block_for": "guwahati-connect",
import 'package:gplusapp/Model/profile.dart';

class BlockedUser {
  int? id, user_id, blocked_by_id;
  String? block_for, created_by, updated_by;
  Profile? user;

  BlockedUser() {
    id = 0;
    user_id = 0;
    blocked_by_id = 0;
    block_for = " ";
    created_by="";
    updated_by="";
  }

  BlockedUser.fromJson(json) {
    id = json['id'] ?? 0;
    user_id = json['user_id'] ?? 0;
    blocked_by_id = json['blocked_by_id'] ?? 0;
    block_for = json['block_for'] ?? "";
    created_by =
        "${(json['created_by'] ?? "").toString().split("T")[0]},${(json['created_by'] ?? "").toString().split("T")[1].split(".")[0]}";
    updated_by =
        "${(json['updated_by'] ?? "").toString().split("T")[0]},${(json['updated_by'] ?? "").toString().split("T")[1].split(".")[0]}";
    user = Profile.fromJson(json['user']);
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
