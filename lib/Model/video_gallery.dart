class VideoGallery {
  int? id;
  String? title, seo_name, as_title;

  VideoGallery.fromJson(json) {
    id = json['id'] ?? 0;
    title = json['title'] ?? "";
    seo_name = json['seo_name'] ?? "";
    as_title = json['as_title'] ?? "";
  }
}
