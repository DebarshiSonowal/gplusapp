class GuwahatiConnect {
  int? id, user_id, total_liked, total_disliked, total_comment, status;
  String? question;
  List<GCAttachment>? attachment;

  GuwahatiConnect.fromJson(json) {
    id = json['id'] ?? 0;
    user_id =
        json['user_id'] == null ? 0 : int.parse(json['user_id'].toString());
    total_liked = json['total_liked'] == null
        ? 0
        : int.parse(json['total_liked'].toString());
    total_disliked = json['total_disliked'] == null
        ? 0
        : int.parse(json['total_disliked'].toString());
    total_comment = json['total_comment'] == null
        ? 0
        : int.parse(json['total_comment'].toString());
    status = json['status'] == null ? 0 : int.parse(json['status'].toString());

    //String
    question = json['question'] ?? "";

    //other
    attachment = json['data'] == null
        ? []
        : (json['data'] as List).map((e) => GCAttachment.fromJson(e)).toList();
  }
}

class GCAttachment {
  int? id, guwahati_connect_id, status;
  String? file_name, file_type;

  GCAttachment.fromJson(json) {
    id = json['id'] ?? 0;
    guwahati_connect_id = json['guwahati_connect_id'] == null
        ? 0
        : int.parse(json['tguwahati_connect_id'].toString());
    status = json['status'] == null ? 0 : int.parse(json['status'].toString());

    file_name = json['file_name'] ?? "";
    file_type = json['file_type'] ?? "";
  }
}

class GuwahatiConnectResponse {
  bool? success;
  String? message;
  List<GuwahatiConnect> posts = [];

  GuwahatiConnectResponse.fromJson(json) {
    success = json['success'] ?? false;
    message = json['message'] ?? "";
    posts = json['data'] == null
        ? []
        : (json['data'] as List)
            .map((e) => GuwahatiConnect.fromJson(e))
            .toList();
  }
  GuwahatiConnectResponse.withError(msg){
    success = false;
    message = msg??"Something went wrong";
  }
}
