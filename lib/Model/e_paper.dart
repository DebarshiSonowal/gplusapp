class E_paper {
//   "id": 125,
//         "title": "Vol 9 Issue 44",
//         "status": 1,
//         "news_pdf": "https://www.guwahatiplus.com/storage/app/public/e_papers/125/c0a662531f77f433ecfaf1d4a2ff0716.pdf",
//         "created_at": "2022-08-27T11:03:00.000000Z",
//         "updated_at": "2022-09-03T02:19:42.000000Z",
//         "view_count": "153",
//         "image_file_name": "https://www.guwahatiplus.com/storage/app/public/e_papers/125/large/0956d514eda00567a6c40b77a314257f.png"\
  int? id, status, view_count;
  String? title, news_pdf, image_file_name;

  E_paper.fromJson(json) {
    id = json['id'] ?? 0;
    status = json['status'] ?? 0;
    view_count = (json['view_count'] == null
            ? 0
            : int.parse(json['view_count'].toString())) ??
        0;

    title = json['title'] ?? "";
    news_pdf = json['news_pdf'] ?? "";
    image_file_name = json['image_file_name'] ?? "";
  }
}

class E_paperRepsonse {
  bool? success;
  String? message;
  E_paper? e_paper;

  E_paperRepsonse.fromJson(json) {
    success = json['success'].toString() == 'true' ? true : false;
    message = json['message'] ?? "Something Went Wrong";
    e_paper = E_paper.fromJson(json['data']);
  }

  E_paperRepsonse.withError(msg) {
    success = false;
    message = msg ?? "Something Went Wrong";
  }
}
