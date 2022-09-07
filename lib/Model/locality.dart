class Locality {
  int? id, city_id, status;
  String? name;

  Locality.fromJson(json) {
    id = json['id'] ?? 0;
    city_id =
        json['city_id'] == null ? 0 : int.parse(json['city_id'].toString());
    status = json['status'] == null ? 0 : int.parse(json['status'].toString());
    name = json['name'] ?? "";
  }
}
