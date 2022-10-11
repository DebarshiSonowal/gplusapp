class GenericResponse {
  bool? success;
  String? message;

  GenericResponse.fromJson(json) {
    success = json['success'].toString() == 'true' ? true : false;
    message = json['message'] ?? "Something Went Wrong";
  }

  GenericResponse.withError(msg) {
    success = false;
    message = msg ?? "Something Went Wrong";
  }
}

class GenericMsgResponse {
  bool? success;
  String? message, desc;

  GenericMsgResponse.fromJson(json) {
    success = json['success'].toString() == 'true' ? true : false;
    message = json['message'] ?? "Something Went Wrong";
    desc = json['result'] ?? "";
  }

  GenericMsgResponse.withError(msg) {
    success = false;
    message = msg ?? "Something Went Wrong";
  }
}
