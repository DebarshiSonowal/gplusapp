class TopPicks {
  int? id, sequence, status;
  String? title,
      seo_name,
      as_title,
      meta_title,
      meta_description,
      meta_keywords,
      date,
      image_file_name;

  TopPicks.fromJson(json) {
    //int
    id = json['id'] ?? 0;
    sequence =
        json['sequence'] == null ? 0 : int.parse(json['sequence'].toString());
    status = json['status'] == null ? 0 : int.parse(json['status'].toString());

    //String
    title = json['title'] ?? "";
    seo_name = json['seo_name'] ?? "";
    as_title = json['as_title'] ?? "";
    meta_title = json['meta_title'] ?? "";
    meta_description = json['meta_description'] ?? "";
    meta_keywords = json['meta_keywords'] ?? "";
    date = json['created_at_date'] ?? "";
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
    toppicks = json['data'] == null
        ? []
        : (json['data'] as List).map((e) => TopPicks.fromJson(e)).toList();
  }

  TopPicksResponse.withError(msg) {
    success = false;
    message = msg ?? "Something Went Wrong";
  }
}
