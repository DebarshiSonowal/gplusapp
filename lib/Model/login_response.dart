//
// class LoginResponse {
//   String? mobile,message;
//   int? otp;
//   bool? is_new, status;
//
//   LoginResponse.fromJson(json) {
//     status = true;
//     mobile = json['mobile'] ?? "";
//     otp = json['otp'] ?? 0;
//     is_new = (json['is_new'] == 0 ? false : true) ?? true;
//     message="OTP sent successfully";
//   }
//
//   LoginResponse.withError(msg){
//     status = false;
//     message = msg;
//   }
//
// }
