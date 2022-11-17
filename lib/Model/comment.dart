import 'package:gplusapp/Model/user.dart';

class Comment {
  int? id,
      user_id,
      commentable_id,
      status,
      share_count,
      like_count,
      dislike_count;
  String? commentable_type, comment,name;
  User? user;
  bool is_liked=false;

  Comment.fromJson(json) {
    id = json['id'] ?? 0;
    user_id =
        json['user_id'] == null ? 0 : int.parse(json['user_id'].toString());
    status = json['status'] == null ? 0 : int.parse(json['status'].toString());
    share_count = json['share_count'] == null
        ? 0
        : int.parse(json['share_count'].toString());
    dislike_count = json['dislike_count'] == null
        ? 0
        : int.parse(json['dislike_count'].toString());
    like_count = json['like_count'] == null
        ? 0
        : int.parse(json['like_count'].toString());
    commentable_id = json['commentable_id'] == null
        ? 0
        : int.parse(json['commentable_id'].toString());
    comment = json['comment']??"";
    name = json['name']??"";
    is_liked = json['is_liked']??false;
    try {
      user = User.fromJson(json['user']);
    } catch (e) {
      print(e);
    }
  }
}

class CommentResponse {
  bool? success;
  String? message;
  List<Comment> comments = [];

  CommentResponse.fromJson(json) {
    success = json['success'].toString() == 'true' ? true : false;
    message = json['message'] ?? "Something Went Wrong";
    comments = json['data'] == null
        ? []
        : (json['data'] as List).map((e) => Comment.fromJson(e)).toList();
  }

  CommentResponse.withError(msg) {
    success = false;
    message = msg ?? "Something Went Wrong";
  }
}
