class Membership {
  int? id, status, free_coupons, discount_in, referral_points;
  double? base_price, discount, discount_value, price_after_discount;
  String? name, duration, plan_type, bg_color;

  Membership.fromJson(json) {
    //int
    id = json['id'] ?? 0;
    status = json['status'] == null ? 0 : int.parse(json['status'].toString());
    free_coupons = json['free_coupons'] == null
        ? 0
        : int.parse(json['free_coupons'].toString());

    //double
    price_after_discount = json['price_after_discount'] == null
        ? 0
        : double.parse(json['price_after_discount'].toString());
    base_price = json['base_price'] == null
        ? 0
        : double.parse(json['base_price'].toString());
    discount = json['discount'] == null
        ? 0
        : double.parse(json['discount'].toString());
    discount_value = json['discount_value'] == null
        ? 0
        : double.parse(json['discount_value'].toString());
    price_after_discount = json['price_after_discount'] == null
        ? 0
        : double.parse(json['price_after_discount'].toString());

    //String
    name = json['name'] ?? "";
    duration = json['duration'] ?? "";
    plan_type = json['plan_type'] ?? "";
    bg_color = json['bg_color'] ?? "";
  }
}

class MembershipResponse {
  bool? success;
  String? message;
  List<Membership>? membership;

  MembershipResponse.fromJson(json) {
    success = json['success'].toString() == 'true' ? true : false;
    message = json['message'] ?? "Something Went Wrong";
    membership =
        (json['data'] as List).map((e) => Membership.fromJson(e)).toList();
  }

  MembershipResponse.withError(msg) {
    success = false;
    message = msg ?? "Something Went Wrong";
  }
}
