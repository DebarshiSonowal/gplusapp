import 'category_name.dart';

class Article {
  int? id, is_app, status, view_count, share_count;
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

  Article.fromJson(json) {
    print(json);

    //int
    id = json['id'] == null ? 0 : int.parse(json['id'].toString());
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
    // author = json['author'] ?? "";
  }
}

class ArticleResponse {
  bool? success;
  String? message;
  List<Article>? articles;

  ArticleResponse.fromJson(json) {
    success = json['success'].toString() == 'true' ? true : false;
    message = json['message'] ?? "Something Went Wrong";
    articles = json['data'] == null
        ? []
        : (json['data'] as List).map((e) => Article.fromJson(e)).toList();
  }

  ArticleResponse.withError(msg) {
    success = false;
    message = msg ?? "Something Went Wrong";
  }
}
