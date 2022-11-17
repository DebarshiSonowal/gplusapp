import 'category_name.dart';

class SearchResult {
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

  SearchResult.fromJson(json) {
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
    try {
      first_cat_name = CategoryName.fromJson(json['first_cat_name']);
    } catch (e) {
      print(e);
    }

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
  }
}

class SearchResultResponse {
  bool? success;
  String? message;
  List<SearchResult>? data;

  SearchResultResponse.fromJson(json) {
    success = json['success'] ?? false;
    message = json['message'] ?? "Something went wrong";
    data = json['result'] == null
        ? []
        : (json['result'] as List).map((e) => SearchResult.fromJson(e)).toList();
  }

  SearchResultResponse.withError(msg) {
    success = false;
    message = msg ?? "Something went wrong";
  }
}
