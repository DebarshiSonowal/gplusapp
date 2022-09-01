class Profile {
  String? email, enc_password, name, mobile, city, sign_in_count,image_file_name;
  int?  super_admin, role_id, status;


  Profile.fromJson(json) {
    email = json['email'] ?? "";
    enc_password = json['encrypted_password'] ?? "";
    name = json['name'] ?? "";
    mobile = json['mobile'] ?? "";
    city = json['city'] ?? "";
    image_file_name = json['image_file_name'] ?? "";
    sign_in_count = json['sign_in_count'] ?? "";
    super_admin = int.parse(json['super_admin'].toString()) ?? 0;
    role_id = int.parse(json['role_id'].toString()) ?? 0;
    status = int.parse(json['status'].toString()) ?? 0;
  }
}

class ProfileResponse {
  bool? status;
  String? access_token;
  Profile? profile;

  ProfileResponse.fromJson(json){
    status = true;
    access_token = json['access_token']??"";
    profile = Profile.fromJson(json['data']);
  }
  ProfileResponse.withError(){
    status = false;
  }


}
