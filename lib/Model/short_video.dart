class ShortVideoResponse {
  bool? success;
  ShortVideoResult? result;
  String? message;
  int? code;

  ShortVideoResponse({this.success, this.result, this.message, this.code});

  ShortVideoResponse.fromJson(Map<String, dynamic> json) {
    success = json['success']??false;
    result =
    json['result'] != null ? new ShortVideoResult.fromJson(json['result']) : null;
    message = json['message'];
    code = json['code'];
  }
  ShortVideoResponse.withError(msg) {
    success =false;
    message = msg;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.result != null) {
      data['result'] = this.result!.toJson();
    }
    data['message'] = this.message;
    data['code'] = this.code;
    return data;
  }
}

class ShortVideoResult {
  int? currentPage;
  List<ShortVideo>? data;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  String? nextPageUrl;
  String? path;
  int? perPage;
  Null? prevPageUrl;
  int? to;
  int? total;

  ShortVideoResult(
      {this.currentPage,
        this.data,
        this.firstPageUrl,
        this.from,
        this.lastPage,
        this.lastPageUrl,
        this.nextPageUrl,
        this.path,
        this.perPage,
        this.prevPageUrl,
        this.to,
        this.total});

  ShortVideoResult.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      data = <ShortVideo>[];
      json['data'].forEach((v) {
        data!.add(new ShortVideo.fromJson(v));
      });
    }
    firstPageUrl = json['first_page_url'];
    from = json['from'];
    lastPage = json['last_page'];
    lastPageUrl = json['last_page_url'];
    nextPageUrl = json['next_page_url'];
    path = json['path'];
    perPage = json['per_page'];
    prevPageUrl = json['prev_page_url'];
    to = json['to'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['current_page'] = this.currentPage;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['first_page_url'] = this.firstPageUrl;
    data['from'] = this.from;
    data['last_page'] = this.lastPage;
    data['last_page_url'] = this.lastPageUrl;
    data['next_page_url'] = this.nextPageUrl;
    data['path'] = this.path;
    data['per_page'] = this.perPage;
    data['prev_page_url'] = this.prevPageUrl;
    data['to'] = this.to;
    data['total'] = this.total;
    return data;
  }
}

class ShortVideo {
  int? id;
  String? title;
  String? description;
  int? shareCount;
  int? viewCount;
  // Null? publishDate;
  String? videoUrl;
  String? videoUrlTemp;
  int? sequence;
  int? status;
  String? createdAt;
  String? updatedAt;
  String? videoPath;

  ShortVideo(
      {this.id,
        this.title,
        this.description,
        this.shareCount,
        this.viewCount,
        // this.publishDate,
        this.videoUrl,
        this.videoUrlTemp,
        this.sequence,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.videoPath});

  ShortVideo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    shareCount = json['share_count'];
    viewCount = json['view_count'];
    // publishDate = json['publish_date'];
    videoUrl = json['video_url'];
    videoUrlTemp = json['video_url_temp'];
    sequence = json['sequence'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    videoPath = json['video_path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['share_count'] = this.shareCount;
    data['view_count'] = this.viewCount;
    // data['publish_date'] = this.publishDate;
    data['video_url'] = this.videoUrl;
    data['video_url_temp'] = this.videoUrlTemp;
    data['sequence'] = this.sequence;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['video_path'] = this.videoPath;
    return data;
  }
}
