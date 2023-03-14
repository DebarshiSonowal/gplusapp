class GrievenceRedresalSend {
  String? month;
  int? received, resolved;

  GrievenceRedresalSend.fromJson(json) {
    month = json['month'] ?? "";
    received = int.parse("${json['received'] ?? "0"}");
    resolved = int.parse("${json['resolved'] ?? "0"}");
  }

//  "first_name": 1,
//   "last_name": "B220610115232",
//   "phone_number": "Book 1ee",
//   "email": 1,
//   "full_address": 1,
//   "pincode": 3,
//   "complain_link": 0,
//   "date_of_publication": null,
//   "exact_details": "e-book",
//   "summery_details": "e-book",
//  "name": "e-book",
//  "date": "e-book",
}

class GrievenceRedressalResponse {
  bool? success;
  String? message;
  List<GrievenceRedresalSend> grievences = [];

  GrievenceRedressalResponse.fromJson(json) {
    success = json['success'].toString() == 'true' ? true : false;
    message = json['message'] ?? "Something Went Wrong";
    grievences = json['data'] != null
        ? (json['data'] as List)
            .map((e) => GrievenceRedresalSend.fromJson(e))
            .toList()
        : [];
  }

  GrievenceRedressalResponse.withError(msg) {
    success = false;
    message = msg ?? "Something went wrong";
  }
}
