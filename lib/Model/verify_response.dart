class VerifyResponse {
  bool success = false;
  int is_new = 0;
  String? access_token,message;

  VerifyResponse.fromJson(json){
    success = json['success']??false;
    is_new = json['data']['is_new']??0;
    access_token = json['access_token']??"";
  }

  VerifyResponse.withError(msg){
    success = false;
    message = msg;
  }


}
