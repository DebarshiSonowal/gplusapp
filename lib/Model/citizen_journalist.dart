import 'attach_file.dart';

class CitizenJournalist {
  int? id, user_id, status;
  String? title, story, created_at, remarks;
  List<CJAttachment>? attach_files;

  CitizenJournalist.fromJson(json) {
    id = json['id'] ?? 0;
    user_id =
        json['user_id'] == null ? 0 : int.parse(json['user_id'].toString());
    status = json['status'] == null ? 0 : int.parse(json['status'].toString());

    title = json['title'] ?? "";
    story = json['story'] ?? "";
    remarks = json['remarks'] ?? "";
    created_at = json['created_at'] == null
        ? ""
        : json['created_at'].toString().split("T")[0];
    attach_files = json['attached_files'] == null
        ? []
        : (json['attached_files'] as List)
            .map((e) => CJAttachment.fromJson(e))
            .toList();
  }
}

class CJAttachment {
  int? id, citizen_journalist_id, status;
  String? file_name, file_type;

  CJAttachment.fromJson(json) {
    id = json['id'] ?? 0;
    citizen_journalist_id = json['citizen_journalist_id'] == null
        ? 0
        : int.parse(json['citizen_journalist_id'].toString());
    status = json['status'] == null ? 0 : int.parse(json['status'].toString());

    file_name = json['file_name'] ?? "";
    file_type = json['file_type'] ?? "";
  }
}

class CitizenJournalistResponse {
  bool? success;
  String? message;
  List<CitizenJournalist> posts = [];

  CitizenJournalistResponse.fromJson(json) {
    success = json['success'] ?? false;
    message = json['message'] ?? "";
    posts = json['data'] == null
        ? []
        : (json['data'] as List)
            .map((e) => CitizenJournalist.fromJson(e))
            .toList();
  }

  CitizenJournalistResponse.withError(msg) {
    success = false;
    message = msg ?? "Something went wrong";
  }
}
