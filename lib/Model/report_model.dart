class ReportModel {
  String? id;
  String? name;

  ReportModel.fromJson(json) {
    id = json['id'] ?? "0";
    name = json['value'] ?? "";
  }
}

class ReportResponse {
  bool? success;
  String? message;
  List<ReportModel> reports = [];

  ReportResponse.fromJson(json) {
    success = json['success'] ?? false;
    message = json['message'] ?? "";
    reports = json['result'] == null
        ? []
        : (json['result'] as List).map((e) => ReportModel.fromJson(e)).toList();
  }

  ReportResponse.withError(msg) {
    success = false;
    message = msg ?? "";
  }
}
