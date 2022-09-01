class CategoryNew{
  int? id, status, sequence, cat_type, opinion_count;
  String? title,
      seo_name,
      color_code,
      as_title,
      meta_title,
      meta_description,
      meta_keywords;

  CategoryNew.fromJson(json){
    //int
    id = json['id']??0;
    status = json['status']==null?0:int.parse(json['status'].toString());
    sequence = json['sequence']==null?0:int.parse(json['sequence'].toString());
    cat_type = json['cat_type']==null?0:int.parse(json['cat_type'].toString());
    opinion_count = json['opinion_count']==null?0:int.parse(json['opinion_count'].toString());

    //String
    title = json['title']??"";
    seo_name = json['seo_name']??"";
    color_code = json['color_code']??"";
    as_title = json['as_title']??"";
    meta_title = json['meta_title']??"";
    meta_description = json['meta_description']??"";
    meta_keywords = json['meta_keywords']??"";

  }

}
