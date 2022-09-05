class Coupon {
  int? id,
      vendor_id,
      total,
      total_used,
      total_blocked,
      balance,
      plan_id,
      status;
  String? code, title, description;

  Coupon.fromJson(json) {
    id = json['id'] ?? 0;
    vendor_id =
        json['vendor_id'] == null ? 0 : int.parse(json['vendor_id'].toString());
    total = json['total'] == null ? 0 : int.parse(json['total'].toString());
    total_used = json['total_used'] == null
        ? 0
        : int.parse(json['total_used'].toString());
    total_blocked = json['total_blocked'] == null
        ? 0
        : int.parse(json['total_blocked'].toString());
    balance =
        json['balance'] == null ? 0 : int.parse(json['balance'].toString());
    plan_id =
        json['plan_id'] == null ? 0 : int.parse(json['plan_id'].toString());
    status = json['status'] == null ? 0 : int.parse(json['status'].toString());

    //String
    code = json['code'] ?? "";
    title = json['title'] ?? "";
    description = json['description'] ?? "";
  }
}
