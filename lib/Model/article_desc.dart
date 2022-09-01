import 'package:gplusapp/Model/comment.dart';

import 'category_daily_page.dart';
import 'category_name.dart';

class ArticleDesc {
  int? id, is_app, status, view_count, share_count, is_live;
  String? title,
      author_name,
      seo_name,
      publish_date,
      description,
      short_description,
      image_file_name,
      as_title,
      as_author_name,
      as_description,
      as_short_description,
      author;
  CategoryName? first_cat_name;
  List<String>? tags, tags_arr;
  List<Comment>? comments;
  CategoryDailyPage? category_daily_page;

  ArticleDesc.fromJson(json) {
    //int
    id = json['id'] ?? 0;
    is_app = json['is_app'] == null ? 0 : int.parse(json['is_app'].toString());
    status = json['status'] == null ? 1 : int.parse(json['status'].toString());
    view_count = json['view_count'] == null
        ? 1
        : int.parse(json['view_count'].toString());
    share_count = json['share_count'] == null
        ? 1
        : int.parse(json['share_count'].toString());

    //Others
    first_cat_name = CategoryName.fromJson(json['first_cat_name']);
    category_daily_page =
        CategoryDailyPage.fromJson(json['category_daily_page']);

    //String
    title = json['title'] ?? "";
    author_name = json['author_name'] ?? "";
    seo_name = json['seo_name'] ?? "";
    publish_date = json['publish_date'] ?? "";
    description = json['description'] ?? "";
    short_description = json['short_description'] ?? "";
    image_file_name = json['image_file_name'] ?? "";
    as_title = json['as_title'] ?? "";
    as_author_name = json['as_author_name'] ?? "";
    as_description = json['as_description'] ?? "";
    as_short_description = json['as_short_description'] ?? "";
    author = json['author'] ?? "";
    comments = json['comments'] == null
        ? []
        : (json['comments'] as List).map((e) => Comment.fromJson(e)).toList();
  }
}

class ArticleDescResponse {
  bool? success;
  String? message;
  ArticleDesc? articleDesc;

  ArticleDescResponse.fromJson(json) {
    success = json['success'] ?? false;
    message = json['message'] ?? "Something Went Wrong";
    articleDesc = ArticleDesc.fromJson(json['data']);
  }

  ArticleDescResponse.withError(msg) {
    success = false;
    message = msg ?? "Something Went Wrong";
  }
}
