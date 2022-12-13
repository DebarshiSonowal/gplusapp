class Story {
//     "id": 1,
//             "user_id": 97379,
//             "title": "Lorem Ipsum is simply dummy text of the printing and typesetting industry",
//             "image_file_name": "https://www.guwahatiplus.com/storage/app/public/stories/1/large/11dd2f4d54ba926720cd257690261aae.jpeg",
//             "status": 1,
//             "created_at": "2022-11-17T05:08:19.000000Z",
//             "updated_at": "2022-11-17T05:08:19.000000Z"
  int? id, user_id, status;
  String? title, image_file_name, web_url, btn_text, btn_color;

  Story.fromJson(json) {
    id = json['id'] ?? 0;
    user_id = json['user_id'] ?? 0;
    status = json['status'] ?? 0;
    title = json['title'] ?? "";
    btn_text = json['btn_text'] ?? "";
    btn_color = json['btn_color'] ?? "";
    web_url = json['web_url'] ?? "https://guwahatiplus.com/";
    image_file_name = json['image_file_name'] ?? "";
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
