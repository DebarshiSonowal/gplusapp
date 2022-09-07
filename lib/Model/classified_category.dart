import 'locality.dart';

class ClassifiedCategory {
  int? id, status;
  String? title, seo_name, sequence;

  ClassifiedCategory.fromJson(json) {
    id = json['id'] ?? 0;
    status = json['status'] == null ? 0 : int.parse(json['status'].toString());
    title = json['title'] ?? "";
    seo_name = json['seo_name'] ?? "";
    sequence = json['seo_name'] ?? "";
  }
}

class ClassifiedCategoryResponse {
  bool? success;
  String? message;
  List<ClassifiedCategory>? categories;
  List<Locality>? localities;

  ClassifiedCategoryResponse.fromJson(json) {
    success = json['success'].toString() == 'true' ? true : false;
    message = json['message'] ?? "Something Went Wrong";
    categories = json['data'] == null
        ? []
        : json['data']['categories'] == null
            ? []
            : (json['data']['categories'] as List)
                .map((e) => ClassifiedCategory.fromJson(e))
                .toList();
    localities = json['data'] == null
        ? []
        : json['data']['localities'] == null
            ? []
            : (json['data']['localities'] as List)
                .map((e) => Locality.fromJson(e))
                .toList();
  }

  ClassifiedCategoryResponse.withError(msg) {
    success = false;
    message = msg ?? "Something Went Wrong";
  }
}
