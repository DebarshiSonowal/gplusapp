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
class GenericDataResponse {
  bool? success;
  String? message,data;

  GenericDataResponse.fromJson(json) {
    success = json['success'].toString() == 'true' ? true : false;
    message = json['message'] ?? "Something Went Wrong";
    data = json['data']??"";
  }

  GenericDataResponse.withError(msg) {
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
class GenericBoolMsgResponse {
  bool? success,has_permission;
  String? message, desc;

  GenericBoolMsgResponse.fromJson(json) {
    success = json['success'].toString() == 'true' ? true : false;
    message = json['message'] ?? "Something Went Wrong";
    desc = json['result'] ?? "";
    has_permission = json['has_permission']??false;
  }

  GenericBoolMsgResponse.withError(msg) {
    success = false;
    message = msg ?? "Something Went Wrong";
    has_permission=false;
  }
}
