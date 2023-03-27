class BookmarkItem {
  String? title,
      seo_name,
      author_name,
      publish_date,
      image_file_name,
      cat_name,
      cat_seo_name;
  int? category_id;
  bool has_permission = false;

  BookmarkItem.fromJson(json) {
    title = json['title'] ?? "";
    seo_name = json['seo_name'] ?? "";
    author_name = json['author_name'] ?? "G Plus Admin";
    publish_date = json['publish_date'] ?? "";
    image_file_name = json['image_file_name'] ?? "";
    cat_name = json['cat_name'] ?? "";
    cat_seo_name = json['cat_seo_name'] ?? "";

    has_permission = json['has_permission'] ?? false;

    category_id = json['category_id'] == null
        ? 0
        : int.parse(json['category_id'].toString());
  }
}

class BookmarkItemsResponse {
  bool? success;
  String? message;
  List<BookmarkItem> bookmarks = [];

  BookmarkItemsResponse.fromJson(json) {
    success = json['success'] ?? false;
    message = json['message'] ?? "Something went wrong";
    bookmarks = json['data'] == null
        ? []
        : (json['data'] as List).map((e) => BookmarkItem.fromJson(e)).toList();
  }

  BookmarkItemsResponse.withError(msg) {
    success = false;
    message = msg ?? "Something went wrong";
  }
}
