class Story {
  int? id, user_id, status;
  String? title, image_file_name, web_url, btn_text, btn_color;
  bool? has_permission = false;

  Story.fromJson(json) {
    id = json['id'] ?? 0;
    user_id = json['user_id'] ?? 0;
    status = json['status'] ?? 0;
    title = json['title'] ?? "";
    btn_text = json['btn_text'] ?? "";
    btn_color = json['btn_color'] ?? "";
    web_url = json['web_url'] ?? "https://guwahatiplus.com/";
    image_file_name = json['image_file_name'] ?? "";
    has_permission = json['has_permission'] ?? false;
  }
}

class StoryResponse {
  bool? success;
  String? msg;
  List<Story> stories = [];

  StoryResponse.fromJson(json) {
    success = json['success'] ?? false;
    msg = json['message'] ?? "Something went wrong";

    stories = json['data'] == null
        ? []
        : (json['data'] as List).map((e) => Story.fromJson(e)).toList();
  }

  StoryResponse.withError(String s) {
    success = false;
    msg = s;
  }
}
