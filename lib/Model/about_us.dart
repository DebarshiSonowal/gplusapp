class AboutUs {
  String? slug, title, content;

  AboutUs.fromJson(json) {
    slug = json['slug'] ?? "";
    title = json['title'] ?? "";
    content = json['content'] ?? "";
  }
}

class AboutUsResponse {
  bool? success;
  String? message;
  AboutUs? aboutUs;

  AboutUsResponse.fromJson(json) {
    success = json['success'] ?? false;
    message = json['message'] ?? "";
    aboutUs = AboutUs.fromJson(json['result']['data']);
  }

  AboutUsResponse.withError(msg) {
    success = false;
    message = msg;
  }
}
