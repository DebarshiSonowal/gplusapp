import 'package:gplusapp/Model/comment.dart';
import 'package:gplusapp/Model/profile.dart';

class GuwahatiConnect {
  int? id, user_id, total_liked, total_disliked, total_comment, status;
  String? question, updated_at, created_at;
  List<GCAttachment>? attachment;
  Profile? user;
  bool? is_post_by_me;
  List<Comment> comments = [];

  GuwahatiConnect.fromJson(json) {
    id = json['id'] ?? 0;
    user_id =
        json['user_id'] == null ? 0 : int.parse(json['user_id'].toString());
    total_liked = json['total_liked'] == null
        ? 0
        : int.parse(json['total_liked'].toString());
    total_disliked = json['total_disliked'] == null
        ? 0
        : int.parse(json['total_disliked'].toString());
    total_comment = json['total_comment'] == null
        ? 0
        : int.parse(json['total_comment'].toString());
    status = json['status'] == null ? 0 : int.parse(json['status'].toString());
    updated_at = json['updated_at'] == null
        ? ""
        : '${json['updated_at'].toString().split("T")[0]} ${json['updated_at'].toString().split("T")[1].split('.')[0]}';
    created_at = json['created_at'] == null
        ? ""
        : json['created_at'].toString().split("T")[0];
    //String
    question = json['question'] ?? "";
    attachment = json['attached_files'] == null
        ? []
        : (json['attached_files'] as List)
            .map((e) => GCAttachment.fromJson(e))
            .toList();
    comments = json['comments'] == null
        ? []
        : (json['comments'] as List).map((e) => Comment.fromJson(e)).toList();
    //other
    is_post_by_me = json['is_post_by_me'] ?? false;
    try {
      user = Profile.fromJson(json['user']);
    } catch (e) {
      print(e);
    }
  }
}

class GCAttachment {
  int? id, guwahati_connect_id, status;
  String? file_name, file_type;

  GCAttachment.fromJson(json) {
    id = json['id'] ?? 0;
    guwahati_connect_id = json['guwahati_connect_id'] == null
        ? 0
        : int.parse(json['guwahati_connect_id'].toString());
    status = json['status'] == null ? 0 : int.parse(json['status'].toString());

    file_name = json['file_name'] ?? "";
    file_type = json['file_type'] ?? "";
  }
}

class GuwahatiConnectResponse {
  bool? success;
  String? message;
  List<GuwahatiConnect> posts = [];

  GuwahatiConnectResponse.fromJson(json) {
    success = json['success'] ?? false;
    message = json['message'] ?? "";
    posts = json['data'] == null
        ? []
        : (json['data'] as List)
            .map((e) => GuwahatiConnect.fromJson(e))
            .toList();
  }

  GuwahatiConnectResponse.withError(msg) {
    success = false;
    message = msg ?? "Something went wrong";
  }
}
