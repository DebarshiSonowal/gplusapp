class Vendor {

  int? id,
      mobile,
      city_id,
      pin_code,
      locality_id,
      alt_mobile,
      shop_type_id,
      status;
  double? latitude, longitude;
  String? image_file_name,code,shop_name,contact_name,email,address;

  Vendor.fromJson(json){
    //int
    id = json['id']??0;
    mobile = json['mobile']==null?0:int.parse(json['mobile'].toString());
    city_id = json['city_id']==null?0:int.parse(json['city_id'].toString());
    pin_code = json['pin_code']==null?0:int.parse(json['pin_code'].toString());
    locality_id = json['locality_id']==null?0:int.parse(json['locality_id'].toString());
    alt_mobile = json['alt_mobile']==null?0:int.parse(json['alt_mobile'].toString());
    shop_type_id = json['shop_type_id']==null?0:int.parse(json['shop_type_id'].toString());
    status = json['status']==null?0:int.parse(json['status'].toString());

    //double
    latitude = json['latitude']==null?0:double.parse(json['latitude'].toString());
    longitude = json['longitude']==null?0:double.parse(json['longitude'].toString());

    //String
    image_file_name = json['image_file_name']??"";
    code = json['code']??"";
    shop_name = json['shop_name']??"";
    contact_name = json['contact_name']??"";
    email = json['email']??"";
    address = json['address']??"";


  }
}
