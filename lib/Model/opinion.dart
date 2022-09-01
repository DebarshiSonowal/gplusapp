import 'package:gplusapp/Model/user.dart';
import 'package:gplusapp/Model/video_gallery.dart';

class Opinion {
  int? id,
      is_app,
      status,
      share_count,
      view_count,
      user_id,
      category_id,
      home_page,
      tweet_image_file_size,
      assamese,
      only_assamese;
  String? title,
      author_name,
      publish_date,
      tags,
      seo_name,
      meta_title,
      meta_description,
      meta_keywords,
      fb_image,
      description,
      short_description,
      image_file_name,
      image_caption;

  User? user;
  VideoGallery? category_gallery;

  Opinion.fromJson(json) {
    //int
    id = json['id'] ?? 0;
    is_app = json['is_app'] == null ? 0 : int.parse(json['is_app'].toString());
    status = json['status'] == null ? 1 : int.parse(json['status'].toString());
    user_id =
        json['user_id'] == null ? 1 : int.parse(json['user_id'].toString());
    category_id = json['category_id'] == null
        ? 1
        : int.parse(json['category_id'].toString());
    home_page =
        json['home_page'] == null ? 0 : int.parse(json['home_page'].toString());
    assamese =
        json['assamese'] == null ? 0 : int.parse(json['assamese'].toString());
    only_assamese = json['only_assamese'] == null
        ? 0
        : int.parse(json['only_assamese'].toString());
    tweet_image_file_size = json['tweet_image_file_size'] == null
        ? 0
        : int.parse(json['tweet_image_file_size'].toString());
    view_count = json['view_count'] == null
        ? 1
        : int.parse(json['view_count'].toString());
    share_count = json['share_count'] == null
        ? 1
        : int.parse(json['share_count'].toString());

    //String
    title = json['title'] ?? "";
    author_name = json['author_name'] ?? "";
    publish_date = json['publish_date'] ?? "";
    tags = json['tags'] ?? "";
    seo_name = json['seo_name'] ?? "";
    meta_title = json['meta_title'] ?? "";
    meta_description = json['meta_description'] ?? "";
    meta_keywords = json['meta_keywords'] ?? "";
    fb_image = json['fb_image'] ?? "";
    description = json['description'] ?? "";
    short_description = json['short_description'] ?? "";
    image_file_name = json['image_file_name'] ?? "";
    image_caption = json['image_caption'] ?? "";
    user = User.fromJson(json['user']);
    category_gallery = VideoGallery.fromJson(json['category_gallery']);
  }
}

class OpinionResponse {
  bool? success;
  String? message;
  List<Opinion>? opinion;
  int? current_page, last_page;

  OpinionResponse.fromJson(json) {
    success = json['success'] ?? false;
    message = json['message'] ?? "Something Went Wrong";
    current_page = json['current_page'] ?? 0;
    last_page = json['last_page'] ?? 0;
    opinion = json['data'] == null
        ? []
        : json['data']['data'] == null
            ? []
            : (json['data']['data'] as List)
                .map((e) => Opinion.fromJson(e))
                .toList();
  }
  OpinionResponse.withError(msg){
    success = false;
    message = msg??"Something went wrong";
  }
}
