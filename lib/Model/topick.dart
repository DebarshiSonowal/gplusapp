class Topick {
  int? id, sequence, status;
  String? title,
      seo_name,
      as_title,
      meta_title,
      meta_description,
      meta_keywords;

  Topick.fromJson(json) {
    id = json['id'] ?? 0;
    sequence =
        json['sequence'] == null ? 0 : int.parse(json['sequence'].toString());
    status = json['status'] == null ? 0 : int.parse(json['status'].toString());

    //String
    title = json['title'] ?? "";
    seo_name = json['seo_name'] ?? "";
    as_title = json['as_title'] ?? "";
    meta_title = json['meta_title'] ?? "";
    meta_description = json['meta_description'] ?? "";
    meta_keywords = json['meta_keywords'] ?? "";
  }
}

class GeoTopick {
  int? id, sequence, status, opinion_count, cat_type;
  String? title,
      seo_name,
      as_title,
      meta_title,
      meta_description,
      meta_keywords,
      color_code;

  GeoTopick.fromJson(json) {
    id = json['id'] ?? 0;
    sequence =
        json['sequence'] == null ? 0 : int.parse(json['sequence'].toString());
    status = json['status'] == null ? 0 : int.parse(json['status'].toString());
    opinion_count = json['opinion_count'] == null
        ? 0
        : int.parse(json['opinion_count'].toString());
    cat_type =
        json['cat_type'] == null ? 0 : int.parse(json['cat_type'].toString());

    //String
    title = json['title'] ?? "";
    seo_name = json['seo_name'] ?? "";
    as_title = json['as_title'] ?? "";
    meta_title = json['meta_title'] ?? "";
    meta_description = json['meta_description'] ?? "";
    meta_keywords = json['meta_keywords'] ?? "";
    color_code = json['color_code'] ?? "#ff0000";
  }
}

class TopickResponse {
  bool? success;
  String? message;
  List<Topick> topicks = [];
  List<GeoTopick> geoTopicks = [];

  TopickResponse.fromJson(json) {
    success = json['success'].toString() == 'true' ? true : false;
    message = json['message'] ?? "Something Went Wrong";
    topicks = json['result'] == null
        ? []
        : json['result']['topic_list'] == null
            ? []
            : (json['result']['topic_list'] as List)
                .map((e) => Topick.fromJson(e))
                .toList();
    geoTopicks = json['result'] == null
        ? []
        : json['result']['geo_list'] == null
            ? []
            : (json['result']['geo_list'] as List)
                .map((e) => GeoTopick.fromJson(e))
                .toList();
  }

  TopickResponse.withError(msg) {
    success = false;
    message = msg ?? "Something Went Wrong";
  }
}
