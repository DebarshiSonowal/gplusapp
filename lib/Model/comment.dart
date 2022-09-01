import 'package:gplusapp/Model/user.dart';

class Comment {
  int? id, user_id, commentable_id, status, share_count;
  String? commentable_type, comment;
  User? user;

  Comment.fromJson(json) {
    id = json['id'] ?? 0;
    user_id =
        json['user_id'] == null ? 0 : int.parse(json['user_id'].toString());
    status = json['status'] == null ? 0 : int.parse(json['status'].toString());
    share_count = json['share_count'] == null
        ? 0
        : int.parse(json['share_count'].toString());
    commentable_id = json['commentable_id'] == null
        ? 0
        : int.parse(json['commentable_id'].toString());
    user = User.fromJson(json['user']);
  }
}
