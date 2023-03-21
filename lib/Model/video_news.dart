import 'package:gplusapp/Model/video_gallery.dart';

class VideoNews {
  int? id, video_gallery_id, is_app, status, share_count, view_count;
  String? title,
      publish_date,
      description,
      image_file_name,
      as_title,
      as_description,
      sequence,
      video_file_name,
      youtube_id;
  VideoGallery? videoGallery;
  bool has_permission = false;

  VideoNews.fromJson(json) {
    //int
    id = json['id'] == null ? 0 : int.parse(json['id'].toString());
    is_app = json['is_app'] == null ? 0 : int.parse(json['is_app'].toString());
    status = json['status'] == null ? 1 : int.parse(json['status'].toString());
    view_count = json['view_count'] == null
        ? 1
        : int.parse(json['view_count'].toString());
    share_count = json['share_count'] == null
        ? 1
        : int.parse(json['share_count'].toString());

    videoGallery = VideoGallery.fromJson(json['video_gallery']);

    has_permission = json['has_permission'] ?? false;

    title = json['title'] ?? "";
    publish_date = json['publish_date'] ?? "";
    description = json['description'] ?? "";
    image_file_name = json['image_file_name'] ?? "";
    as_title = json['as_title'] ?? "";
    // sequence = json['sequence'] ?? "";
    as_description = json['as_description'] ?? "";
    video_file_name = json['video_file_name'] ?? "";
    youtube_id = json['youtube_id'] ?? "";
  }
}

class VideoNewsResponse {
  bool? success;
  String? message;
  List<VideoNews>? videos;

  VideoNewsResponse.fromJson(json) {
    success = json['success'].toString() == 'true' ? true : false;
    message = json['message'] ?? "Something Went Wrong";
    videos = json['data'] == null
        ? []
        : (json['data'] as List).map((e) => VideoNews.fromJson(e)).toList();
  }

  VideoNewsResponse.withError(msg) {
    success = false;
    message = msg ?? "Something Went Wrong";
  }
}

class MoreVideoNewsResponse {
  bool? success;
  String? message;
  List<VideoNews>? videos;

  MoreVideoNewsResponse.fromJson(json) {
    success = json['success'].toString() == 'true' ? true : false;
    message = json['message'] ?? "Something Went Wrong";
    videos = json['data']['data'] == null
        ? []
        : (json['data']['data'] as List)
            .map((e) => VideoNews.fromJson(e))
            .toList();
  }

  MoreVideoNewsResponse.withError(msg) {
    success = false;
    message = msg ?? "Something Went Wrong";
  }
}
