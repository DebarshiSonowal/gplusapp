class PollOfTheWeek {
//         "poll_answer": []
  int? id, vote_count, status, article_id, daily_page_id;
  String? title,
      option1,
      option2,
      option3,
      as_title,
      as_option1,
      as_option2,
      as_option3,
      is_polled;
  double? percent1, percent2, percent3;
  bool has_permission=false;
  PollOfTheWeek.fromJson(json) {
    id = json['id'] ?? 0;
    vote_count = json['vote_count'] == null
        ? 0
        : int.parse(json['vote_count'].toString());
    status = json['status'] == null ? 0 : int.parse(json['status'].toString());
    article_id = json['article_id'] == null
        ? 0
        : int.parse(json['article_id'].toString());
    daily_page_id = json['daily_page_id'] == null
        ? 0
        : int.parse(json['daily_page_id'].toString());

    //String
    title = json['title'] ?? "";
    option1 = json['option1'] ?? "";
    option2 = json['option2'] ?? "";
    option3 = json['option3'] ?? "";
    as_title = json['as_title'] ?? "";
    as_option1 = json['as_option1'] ?? "";
    as_option2 = json['as_option2'] ?? "";
    as_option3 = json['as_option3'] ?? "";
    is_polled = json['is_polled'].toString() ?? "";


    has_permission = json['has_permission'] ?? false;
    //double
    percent1 = json['percent1'] == null
        ? 0
        : double.parse(json['percent1'].toString());
    percent2 = json['percent2'] == null
        ? 0
        : double.parse(json['percent2'].toString());
    percent3 = json['percent3'] == null
        ? 0
        : double.parse(json['percent3'].toString());
  }
}

class PollOfTheWeekResponse {
  bool? success;
  String? message;
  PollOfTheWeek? pollOfTheWeek;

  PollOfTheWeekResponse.fromJson(json) {
    success = json['success'] ?? false;
    message = json['message'] ?? "Something went wrong";
    pollOfTheWeek = PollOfTheWeek.fromJson(json['data']);
  }

  PollOfTheWeekResponse.withError(msg) {
    success = false;
    message = msg;
  }
}
