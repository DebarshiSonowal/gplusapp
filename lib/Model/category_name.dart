
class CategoryName{
  int? id;
  String? title,seo_name;

  CategoryName.fromJson(json){
    id = json['id']??0;
    title = json['title']??"";
    seo_name = json['seo_name']??"";
  }

}