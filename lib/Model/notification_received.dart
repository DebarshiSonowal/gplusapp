class NotificationReceived {
  String? category_name,
      seo_name,
      seo_name_category,
      notification_id,
      type,
      title,time,post_id,vendor_id,category_id;

  NotificationReceived(this.category_name, this.seo_name,
      this.seo_name_category, this.notification_id, this.type, this.title);

  NotificationReceived.fromJson(json) {
    category_name = (json['category_name']??"") as String;
    seo_name = (json['seo_name']??"") as String;
    seo_name_category = (json['seo_name_category']??"") as String;
    post_id = (json['id']??"") as String;
    category_id = (json['category_id']??"") as String;
    time = (json['time']??"") as String;
    vendor_id = (json['vendor_id']??"") as String;
    notification_id = json['notification_id'] as String;
    type = json['type'] as String;
    title = json['title'] as String;
  }
}
