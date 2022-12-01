class ReferEarnResponse {
  bool? success;
  String? message;
  ReferEarn? data;

  ReferEarnResponse.fromJson(json) {
    success = json['success'] ?? false;
    message = json['message'] ?? "Something went wrong";
    data = ReferEarn.fromJson(json['data']);
  }

  ReferEarnResponse.withError(msg) {
    success = false;
    message = msg ?? "Something went wrong";
  }
}

class ReferEarn {
  int? subscriber_added_point, coin_balance,buying_points;
  String? referral_link;
  List<ReferEarnPlan> plans = [];

  ReferEarn.fromJson(json) {
    subscriber_added_point = json['subscriber_added_point'] == null
        ? 0
        : int.parse(json['subscriber_added_point'].toString());
    coin_balance = json['coin_balance'] == null
        ? 0
        : int.parse(json['coin_balance'].toString());

    //string
    referral_link = json['referral_link'] ?? "";

    //list
    plans = json['plans'] == null
        ? []
        : (json['plans'] as List)
            .map((e) => ReferEarnPlan.fromJson(e))
            .toList();
  }
}

class ReferEarnPlan {
  int? id, referral_points, free_coupons, status, display_order,buying_points;
  double? base_price, discount_value, discount, price_after_discount;
  String? name, duration, plan_type, bg_color;

  ReferEarnPlan.fromJson(json) {
    id = json['id'] ?? 0;
    referral_points = json['referral_points'] == null
        ? 0
        : int.parse(json['referral_points'].toString());
    buying_points = json['buying_points'] == null
        ? 0
        : int.parse(json['buying_points'].toString());
    free_coupons = json['free_coupons'] == null
        ? 0
        : int.parse(json['free_coupons'].toString());
    status = json['status'] == null ? 0 : int.parse(json['status'].toString());
    display_order = json['display_order'] == null
        ? 0
        : int.parse(json['display_order'].toString());

    //double
    base_price = json['base_price'] == null
        ? 0
        : double.parse(json['base_price'].toString());
    discount_value = json['discount_value'] == null
        ? 0
        : double.parse(json['discount_value'].toString());
    discount = json['discount'] == null
        ? 0
        : double.parse(json['discount'].toString());
    price_after_discount = json['price_after_discount'] == null
        ? 0
        : double.parse(json['price_after_discount'].toString());

    //String
    name = json['name'] ?? "";
    duration = json['duration'] ?? "";
    plan_type = json['plan_type'] ?? "";
    bg_color = json['plan_type'] ?? "";
  }
}
