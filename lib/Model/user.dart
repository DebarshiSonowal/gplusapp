class User {
  int? id;
  String? name, as_name, seo_name, image_file_name;

  User.fromJson(json) {
    id = json['id'] ?? 0;
    name = json['name'] ?? "";
    as_name = json['as_name'] ?? "";
    seo_name = json['seo_name'] ?? "";
    image_file_name = json['image_file_name'] ?? "";
  }
}
