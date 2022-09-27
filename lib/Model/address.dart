class Address {
  int? id, user_id, is_primary;
  String? title, landmark, zip_code, address;
  double? longitude, latitude;

  Address.fromJson(json) {
    id = json['id'] ?? 0;
    user_id = json['user_id'] ?? 0;
    is_primary = json['is_primary'] ?? 0;

    //String
    title = json['title'] ?? "";
    landmark = json['landmark'] ?? "";
    zip_code = json['zip_code'] ?? "";
    address = json['address'] ?? "";

    //double
    longitude = json['longitude'] == null
        ? 0
        : double.parse(json['longitude'].toString());
    latitude = json['latitude'] == null
        ? 0
        : double.parse(json['latitude'].toString());
  }
}
