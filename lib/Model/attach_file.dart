class AttachFile {
  int? id, classified_id, status;
  String? file_name, file_type;

  AttachFile.fromJson(json) {
    id = json['id'] ?? 0;
    classified_id = json['classified_id'] == null
        ? 0
        : int.parse(json['classified_id'].toString());
    status = json['status'] == null ? 0 : int.parse(json['status'].toString());
    file_name = json['file_name'] ?? "";
    file_type = json['file_type'] ?? "";
  }
}
