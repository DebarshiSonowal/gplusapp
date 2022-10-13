class Order {
  int? id, taggable_id, plan_id, is_paid, status;
  double? base_price, referral_discount, cgst, sgst, igst, subtotal;
  String? voucher_no,
      order_date,
      taggable_type,
      plan_active_date,
      plan_expiry_date;

  Order.fromJson(json) {
    id = json['id'] ?? 0;
    taggable_id = json['taggable_id'] == null
        ? 0
        : int.parse(json['taggable_id'].toString());
    plan_id =
        json['plan_id'] == null ? 0 : int.parse(json['plan_id'].toString());
    is_paid =
        json['is_paid'] == null ? 0 : int.parse(json['is_paid'].toString());

    status = json['status'] == null ? 0 : int.parse(json['status'].toString());

    //double
    base_price = json['base_price'] == null
        ? 0
        : double.parse(json['base_price'].toString());
    referral_discount = json['referral_discount'] == null
        ? 0
        : double.parse(json['referral_discount'].toString());
    cgst = json['cgst'] == null ? 0 : double.parse(json['cgst'].toString());
    sgst = json['sgst'] == null ? 0 : double.parse(json['sgst'].toString());
    igst = json['igst'] == null ? 0 : double.parse(json['igst'].toString());
    subtotal = json['subtotal'] == null
        ? 0
        : double.parse(json['subtotal'].toString());

    //String
    voucher_no = json['voucher_no'] ?? "";
    order_date = json['order_date'] ?? "";
    taggable_type = json['taggable_type'] ?? "";
    plan_active_date = json['plan_active_date'] ?? "";
    plan_expiry_date = json['plan_expiry_date'] ?? "";
  }
}

class CreateOrderResponse {
  bool? success;
  String? message;
  Order? order;

  // int? current_page, last_page;

  CreateOrderResponse.fromJson(json) {
    success = json['success'] ?? false;
    message = json['message'] ?? "Something Went Wrong";
    order = Order.fromJson(json['result']['order']);
  }

  CreateOrderResponse.withError(msg) {
    success = false;
    message = msg ?? "Something went wrong";
  }
}
