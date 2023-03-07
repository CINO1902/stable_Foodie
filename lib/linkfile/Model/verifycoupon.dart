// To parse this JSON data, do
//
//     final verifyCoupon = verifyCouponFromJson(jsonString);

import 'dart:convert';

VerifyCoupon? verifyCouponFromJson(String str) =>
    VerifyCoupon.fromJson(json.decode(str));

String verifyCouponToJson(VerifyCoupon? data) => json.encode(data!.toJson());

class VerifyCoupon {
  VerifyCoupon({
   required  this.status,
    required this.msg,
    this.amount,
    required this.type,
    this.discount,
  });

  String status;
  String msg;
  int? amount;
  String type;
  int? discount;

  factory VerifyCoupon.fromJson(Map<String, dynamic> json) => VerifyCoupon(
        status: json["status"],
        msg: json["msg"],
        amount: json["amount"],
        type: json["type"],
        discount: json["discount"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "msg": msg,
        "amount": amount,
        "type": type,
        "discount": discount,
      };
}
