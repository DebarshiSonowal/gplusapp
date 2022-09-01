import 'category_new.dart';

class CategoryDailyPage {
  int? id, daily_pages_id, category_id;
  CategoryNew? category;

  CategoryDailyPage.fromJson(json){
    id = json['id']??0;
    daily_pages_id = json['daily_pages_id']==null?0:int.parse(json['daily_pages_id'].toString());
    category_id = json['category_id']==null?0:int.parse(json['category_id'].toString());
    category = CategoryNew.fromJson(json['category']);
  }

}
