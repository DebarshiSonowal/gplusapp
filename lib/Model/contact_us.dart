class ContactUs {
  String? slug, title, editor, phone, email, address1, address2, address3;

  ContactUs.fromJson(json) {
    slug = json['slug'] ?? "";
    title = json['title'] ?? "";
    editor = json['editor'] ?? "";
    phone = json['phone'] ?? "";
    email = json['email'] ?? "";
    address1 = json['address1'] ?? "";
    address2 = json['address2'] ?? "";
    address3 = json['address3'] ?? "";
  }
}

class ContactUsResponse {
  bool? success;
  String? message;
  ContactUs? contactUs;

  ContactUsResponse.fromJson(json) {
    success = json['success'] ?? false;
    message = json['message'] ?? "";
    contactUs = ContactUs.fromJson(json['result']['data']);
  }

  ContactUsResponse.withError(msg) {
    success = false;
    message = msg;
  }
}
