import 'package:gplusapp/Model/vendor.dart';

class RedeemHistory {
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
  String? plan_active_date, plan_expiry_date, title, description, code, date;
  Vendor? vendor;

  RedeemHistory.fromJson(json) {
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
    date = json['updated_at'] ?? "";
    title = json['title'] ?? "";
    description = json['description'] ?? "";
    code = json['code'] ?? "";

    vendor = Vendor.fromJson(json['vendor']);
  }
}

class RedeemHistoryResponse {
  bool? success;
  String? message;
  List<RedeemHistory>? data;

  RedeemHistoryResponse.fromJson(json) {
    success = json['success'] ?? false;
    message = json['message'] ?? "Something went wrong";
    data = json['result'] == null
        ? []
        : (json['result'] as List)
            .map((e) => RedeemHistory.fromJson(e))
            .toList();
  }

  RedeemHistoryResponse.withError(msg) {
    success = false;
    message = msg ?? "Something went wrong";
  }
}
