class NewsCategories {
  int? id;
  String? title;
  String? seoName;
  int? status;
  int? sequence;
  Null? opinionCount;
  String? createdAt;
  String? updatedAt;
  String? colorCode;
  String? asTitle;
  int? catType;
  String? metaTitle;
  String? metaDescription;
  String? metaKeywords;
  int? isGeographical;

  NewsCategories(
      {this.id,
        this.title,
        this.seoName,
        this.status,
        this.sequence,
        this.opinionCount,
        this.createdAt,
        this.updatedAt,
        this.colorCode,
        this.asTitle,
        this.catType,
        this.metaTitle,
        this.metaDescription,
        this.metaKeywords,
        this.isGeographical});

  NewsCategories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    seoName = json['seo_name'];
    status = json['status'];
    sequence = json['sequence'];
    opinionCount = json['opinion_count'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    colorCode = json['color_code'];
    asTitle = json['as_title'];
    catType = json['cat_type'];
    metaTitle = json['meta_title'];
    metaDescription = json['meta_description'];
    metaKeywords = json['meta_keywords'];
    isGeographical = json['is_geographical'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['seo_name'] = this.seoName;
    data['status'] = this.status;
    data['sequence'] = this.sequence;
    data['opinion_count'] = this.opinionCount;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['color_code'] = this.colorCode;
    data['as_title'] = this.asTitle;
    data['cat_type'] = this.catType;
    data['meta_title'] = this.metaTitle;
    data['meta_description'] = this.metaDescription;
    data['meta_keywords'] = this.metaKeywords;
    data['is_geographical'] = this.isGeographical;
    return data;
  }
}