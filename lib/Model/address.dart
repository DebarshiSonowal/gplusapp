class Address {
  int? id, user_id, is_primary;
  String? title, landmark, zip_code, address;
  double? longitude, latitude;

  Address.fromJson(json) {
    id = json['id'] ?? 0;
    user_id = json['user_id']==null? 0:int.parse(json['user_id'].toString());
    is_primary = json['is_primary']==null? 0:int.parse(json['is_primary'].toString());

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

class AddressResponse {
  bool? success;
  String? message;
  List<Address> addresses = [];

  AddressResponse.fromJson(json) {
    success = json['success'] ?? false;
    message = json['message'] ?? "Something went wrong";
    addresses = json['result'] == null
        ? []
        : (json['result'] as List).map((e) => Address.fromJson(e)).toList();
  }

  AddressResponse.withError(msg) {
    success = false;
    message = msg ?? "Something went wrong";
  }
}
