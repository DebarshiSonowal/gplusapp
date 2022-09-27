import 'package:gplusapp/Model/vendor.dart';

class PromotedDeal {
  int? id,
      vendor_id,
      total,
      active_total_days,
      total_used,
      total_blocked,
      balance,
      plan_id,
      status;
  bool? is_percent, is_one_time;
  String? plan_active_date, plan_expiry_date,title,description;
  Vendor? vendor;

  PromotedDeal.fromJson(json) {
    //int
    id = json['id'] ?? 0;
    vendor_id =
        json['vendor_id'] == null ? 0 : int.parse(json['vendor_id'].toString());
    total = json['total'] == null ? 0 : int.parse(json['total'].toString());
    active_total_days = json['active_total_days'] == null
        ? 0
        : int.parse(json['active_total_days'].toString());
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

    //bool
    is_percent = json['is_percent'] == null
        ? false
        : (json['is_percent'].toString() == '1' ? true : false);
    is_one_time = json['is_one_time'] == null
        ? false
        : (json['is_one_time'].toString() == '1' ? true : false);

    //String
    plan_active_date = json['plan_active_date'] ?? "";
    plan_expiry_date = json['plan_expiry_date'] ?? "";
    title = json['title'] ?? "";
    description = json['description'] ?? "";

    vendor = Vendor.fromJson(json['vendor']);
  }
}

class PromotedDealResponse {
  bool? success;
  String? message;
  List<PromotedDeal>? deals;

  PromotedDealResponse.fromJson(json) {
    success = json['success'].toString() == 'true' ? true : false;
    message = json['message'] ?? "Something Went Wrong";
    deals = json['result'] == null
        ? []
        : (json['result'] as List).map((e) => PromotedDeal.fromJson(e)).toList();
  }

  PromotedDealResponse.withError(msg) {
    success = false;
    message = msg ?? "Something Went Wrong";
  }
}
