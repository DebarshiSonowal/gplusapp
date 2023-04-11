class Membership {
  int? id, status, free_coupons, discount_in, referral_points;
  double? base_price, discount, discount_value, price_after_discount,grand_total,gst;
  String? name,
      duration,
      description,
      plan_type,
      bg_color,
      plan_active_date,
      plan_expiry_date,
      inapp_identifier,plan_duration_type;
  bool? is_currently_active;

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
    base_price = double.parse(json['base_price']);
    grand_total = json['grand_total'] == null
        ? 0
        : double.parse(json['grand_total'].toString());
    gst  = json['gst'] == null
        ? 0
        : double.parse(json['gst'].toString());
    discount = json['discount'] == null
        ? 0
        : double.parse(json['discount'].toString());
    discount_value = json['discount_value'] == null
        ? 0
        : double.parse(json['discount_value'].toString());
    price_after_discount = json['price_after_discount'] == null
        ? 0
        : double.parse(json['price_after_discount'].toString());

    is_currently_active = json['is_currently_active'] ?? false;

    //String
    name = json['name'] ?? "";
    description = json['description'] ?? "";
    duration = json['duration'] ?? "";
    plan_duration_type = json['plan_duration_type'] ?? "";
    plan_type = json['plan_type'] ?? "";
    bg_color = json['bg_color'] ?? "";
    inapp_identifier =
        json['inapp_identifier'] ?? "gplus_subscription_one_month_non";
    plan_active_date = json['plan_active_date'] ?? "";
    plan_expiry_date = json['plan_expiry_date'] ?? "";
  }
}

class MembershipResponse {
  bool? success;
  String? message, be_a_member, benifit_members;
  List<Membership>? membership;

  MembershipResponse.fromJson(json) {
    success = json['success'].toString() == 'true' ? true : false;
    message = json['message'] ?? "Something Went Wrong";
    // benifit_members = json['content']['benifit_members'] ?? "";
    // be_a_member = json['content']['be_a_member'] ?? "";
    membership =
        (json['result'] as List).map((e) => Membership.fromJson(e)).toList();
  }

  MembershipResponse.withError(msg) {
    success = false;
    message = msg ?? "Something Went Wrong";
  }
}

class MembershipResponse2 {
  bool? success;
  String? message, be_a_member, benifit_members;
  List<Membership>? membership;

  MembershipResponse2.fromJson(json) {
    success = json['success'].toString() == 'true' ? true : false;
    message = json['message'] ?? "Something Went Wrong";
    benifit_members = json['content']['benifit_members'] ?? "";
    be_a_member = json['content']['be_a_member'] ?? "";
    membership =
        (json['result'] as List).map((e) => Membership.fromJson(e)).toList();
  }

  MembershipResponse2.withError(msg) {
    success = false;
    message = msg ?? "Something Went Wrong";
  }
}
