class PhonepeResponse {
  // {success: true,
  // result: ppesim://mandate?pa=PGTESTPAYUAT@ybl&pn=SUBSCRIBEMID&am=100&mam=100&tr=TX1710931255&utm_campaign=SUBSCRIBE_AUTH&utm_medium=PGTESTPAYUAT&utm_source=TX1710931255,
  // message: Promoted deal list, code: 200}
  bool? success;
  String? message;
  PhonepeData? result;
  int? code;

  PhonepeResponse.fromJson(json) {
    success = json['success'] ?? false;
    result = PhonepeData.fromJson(json['result']);
    message = json['message'] ?? "Something went wrong";
    code = int.parse((json['code'] ?? '0').toString());
  }

  PhonepeResponse.withError(msg) {
    success = false;
    message = msg;
  }
}

// "result": {
//         "order_code": "ORD1710998643",
//         "redirect_url": "upi://mandate?mn=Autopay&ver=01&rev=Y&purpose=14&validityend=21032034&QRts=2024-03-21T10:54:04.823747522+05:30&QRexpire=2024-03-21T10:59:04.823747522+05:30&txnType=CREATE&am=2.00&validitystart=21032024&mode=04&pa=M22BLAIFV1B13@ybl&cu=INR&amrule=MAX&mc=4816&qrMedium=00&recur=ASPRESENTED&mg=ONLINE&share=Y&block=N&tr=ORD1710998643&pn=NSIGHT%20BRANDCOM%20PRIVATE%20LIMITED&orgid=180001&sign=MEQCIHVPXm1yLw17LpLv2wb+kO8HdK7hCFObYjn2qSazJndHAiBRNTI4gdlr2/d7gxwjaiHt40v0Hj/xcwRi0tI7qmXKEA=="
//     },
class PhonepeData {
  String? order_code, merchant_subscription_id,redirect_url,merchant_user_id;
//order_code,merchant_subscription_id,merchant_user_id
  PhonepeData.fromJson(json) {
    order_code = json["order_code"] ?? "";
    merchant_subscription_id = json["merchant_subscription_id"] ?? "";
    merchant_user_id = json["merchant_user_id"] ?? "";
    redirect_url = json["redirect_url"] ?? "";
  }
}
