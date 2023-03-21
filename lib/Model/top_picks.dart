import 'category_new.dart';

class TopPicks {
  int? id, sequence, status, show_on_slider, author_id, assamese, only_assamese;
  String? title,
      seo_name,
      as_title,
      meta_title,
      meta_description,
      meta_keywords,
      date,
      image_file_name,
      tags,
      author_name,
      image_caption;
  bool has_permission = false;
  List<CategoryNew>? categories = [];
  List<DailyBanner> banner = [];

  TopPicks.fromJson(json) {
    //int
    id = json['id'] ?? 0;
    sequence =
        json['sequence'] == null ? 0 : int.parse(json['sequence'].toString());
    status = json['status'] == null ? 0 : int.parse(json['status'].toString());
    show_on_slider = json['show_on_slider'] == null
        ? 0
        : int.parse(json['show_on_slider'].toString());
    author_id =
        json['author_id'] == null ? 0 : int.parse(json['author_id'].toString());
    assamese =
        json['assamese'] == null ? 0 : int.parse(json['assamese'].toString());
    only_assamese = json['only_assamese'] == null
        ? 0
        : int.parse(json['only_assamese'].toString());

    has_permission = json['has_permission'] ?? false;

    //String
    title = json['title'] ?? "";
    seo_name = json['seo_name'] ?? "";
    as_title = json['as_title'] ?? "";
    meta_title = json['meta_title'] ?? "";
    meta_description = json['meta_description'] ?? "";
    meta_keywords = json['meta_keywords'] ?? "";
    date = json['publish_date'].toString().split(' ')[0] ?? "";
    tags = json['tags'] ?? "";
    author_name = json['author_name'] ?? "";
    image_caption = json['image_caption'] ?? "";
    image_file_name = json['image_file_name'] ??
        "https://www.guwahatiplus.com/storage/app/public/video_images/500/large/6845fdb31f2ad42bcf19585c94ae619d.png";

    //model
    banner = json['daily_banners'] == null
        ? []
        : (json['daily_banners'] as List)
            .map((e) => DailyBanner.fromJson(e))
            .toList();
    categories = json['categories'] == null
        ? []
        : (json['categories'] as List)
            .map((e) => CategoryNew.fromJson(e))
            .toList();
  }
}

class DailyBanner {
  int? id, sequence, status, daily_page_id;
  String? caption, image_file_name, alt_name;

  DailyBanner.fromJson(json) {
    id = json['id'] ?? 0;
    sequence =
        json['sequence'] == null ? 0 : int.parse(json['sequence'].toString());
    status = json['status'] == null ? 0 : int.parse(json['status'].toString());
    daily_page_id = json['daily_page_id'] == null
        ? 0
        : int.parse(json['daily_page_id'].toString());

    //String
    caption = json['caption'] ?? "";
    alt_name = json['alt_name'] ?? "";
    image_file_name = json['image_file_name'] ??
        "https://www.guwahatiplus.com/storage/app/public/video_images/500/large/6845fdb31f2ad42bcf19585c94ae619d.png";
  }
}

class TopPicksResponse {
  bool? success;
  String? message;
  List<TopPicks>? toppicks;

  TopPicksResponse.fromJson(json) {
    success = json['success'].toString() == 'true' ? true : false;
    message = json['message'] ?? "Something Went Wrong";
    toppicks = json['data']['data'] == null
        ? []
        : (json['data']['data'] as List)
            .map((e) => TopPicks.fromJson(e))
            .toList();
  }

  TopPicksResponse.withError(msg) {
    success = false;
    message = msg ?? "Something Went Wrong";
  }
}
