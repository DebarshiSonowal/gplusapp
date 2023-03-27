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
  bool has_permission=false;
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

    has_permission = json['has_permission']??false;
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

class OthersSearchResult {
  // "id": 1,
  // "title": "hello testing",
  // "image_file_name": "http://gplus.shecure.co.in/storage/app/public/guwahati_connect/1/32c53d80fc927c2c111cff53944d5f3b.jpg",
  // "type": "guwahati-connect"
  int? id;
  String? title, image_file_name, type;
  bool has_permission = false;

  OthersSearchResult.fromJson(json) {
    id = json['id'] == null ? 0 : int.parse(json['id'].toString());
    title = json['title'] ?? "";
    type = json['type'] ?? "";
    image_file_name = json['image_file_name'] ?? "";
    has_permission = json['has_permission']??false;
  }
}

class SearchResultResponse {
  bool? success;
  String? message;
  List<SearchResult>? data;

  SearchResultResponse.fromJson(json) {
    success = json['success'] ?? false;
    message = json['message'] ?? "Something went wrong";
    try {
      data = json['result']['data'] == null
          ? []
          : (json['result']['data'] as List)
              .map((e) => SearchResult.fromJson(e))
              .toList();
    } catch (e) {
      print(e);
      data = [];
    }
  }

  SearchResultResponse.withError(msg) {
    success = false;
    message = msg ?? "Something went wrong";
  }
}

class OthersSearchResultResponse {
  bool? success;
  String? message;
  List<OthersSearchResult>? data;

  OthersSearchResultResponse.fromJson(json) {
    success = json['success'] ?? false;
    message = json['message'] ?? "Something went wrong";
    data = json['result'] == null
        ? []
        : (json['result'] as List)
            .map((e) => OthersSearchResult.fromJson(e))
            .toList();
  }

  OthersSearchResultResponse.withError(msg) {
    success = false;
    message = msg ?? "Something went wrong";
  }
}
