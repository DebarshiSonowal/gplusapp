import 'package:gplusapp/Model/profile.dart';

import 'category_name.dart';
import 'news_catergory.dart';

class Article {
  int? id, is_app, status, view_count, share_count, author, is_liked;
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
      web_url,
      tags,image_caption;
  bool is_bookmark = false,has_permission=false;
  CategoryName? first_cat_name;
  List<NewsCategories> categories=[];
  // AuthorProfile? author_profile;

  Article.fromJson(json) {
    // print(json);

    //int
    id = json['id'] == null ? 0 : int.parse(json['id'].toString());
    is_liked =
        json['is_liked'] == null ? -1 : int.parse(json['is_liked'].toString());
    is_app = json['is_app'] == null ? 0 : int.parse(json['is_app'].toString());
    status = json['status'] == null ? 1 : int.parse(json['status'].toString());
    author =
        json['author_id'] == null ? 1 : int.parse(json['author_id'].toString());
    view_count = json['view_count'] == null
        ? 1
        : int.parse(json['view_count'].toString());
    share_count = json['share_count'] == null
        ? 1
        : int.parse(json['share_count'].toString());

    is_bookmark = json['Is_bookmarked'] ?? false;
    has_permission = json['has_permission'] ?? false;
    //Others
    try {
      first_cat_name = CategoryName.fromJson(json['first_cat_name']);
    } catch (e) {
      print(e);
    }

    //String
    title = json['title'] ?? "";
    image_caption = json['image_caption'] ?? "";
    author_name = json['author_name'] ?? "";
    tags = json['tags'] ?? "";
    seo_name = json['seo_name'] ?? "";
    publish_date = json['publish_date'] ?? "";
    description = json['description'] ?? "";
    short_description = json['short_description'] ?? "";
    image_file_name = json['image_file_name'] ?? "";
    as_title = json['as_title'] ?? "";
    as_author_name = json['as_author_name'] ?? "";
    as_description = json['as_description'] ?? "";
    as_short_description = json['as_short_description'] ?? "";
    web_url = json['web_url'] ?? "";
    categories = json['category_list']==null?[]:(json['category_list'] as List).map((e) => NewsCategories.fromJson(e)).toList();
    // author = json['author'] ?? "";
    // author_profile = AuthorProfile.fromJson(json['author_detail']);
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

class CategoryArticleResponse {
  bool? success;
  String? message;
  List<Article>? articles;

  CategoryArticleResponse.fromJson(json) {
    success = json['success'].toString() == 'true' ? true : false;
    message = json['message'] ?? "Something Went Wrong";
    articles = json['data']['data'] == null
        ? []
        : (json['data']['data'] as List)
            .map((e) => Article.fromJson(e))
            .toList();
  }

  CategoryArticleResponse.withError(msg) {
    success = false;
    message = msg ?? "Something Went Wrong";
  }
}

class ArticleDetailsResponse {
  bool? success;
  String? message;
  Article? article;

  ArticleDetailsResponse.fromJson(json) {
    success = json['success'].toString() == 'true' ? true : false;
    message = json['message'] ?? "Something Went Wrong";
    article = Article.fromJson(json['data']);
  }

  ArticleDetailsResponse.withError(msg) {
    success = false;
    message = msg ?? "Something Went Wrong";
  }
}
