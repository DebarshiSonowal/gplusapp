class Profile {
  String? email, enc_password, name, mobile, city, image_file_name;
  int? sign_in_count, super_admin, role_id, status;


  Profile.fromJson(json) {
    email = json['email'] ?? "";
    enc_password = json['encrypted_password'] ?? "";
    name = json['name'] ?? "";
    mobile = json['mobile'] ?? "";
    city = json['city'] ?? "";
    image_file_name = json['image_file_name'] ?? "";
    sign_in_count = json['sign_in_count'] ?? 0;
    super_admin = json['super_admin'] ?? 0;
    role_id = json['role_id'] ?? 0;
    status = json['status'] ?? 0;
  }
}

class ProfileResponse {
  bool? status;
  String? access_token;
  Profile? profile;

  ProfileResponse.fromJson(json){
    status = true;
    access_token = json['access_token']??"";
    // profile = json['']
  }


}
