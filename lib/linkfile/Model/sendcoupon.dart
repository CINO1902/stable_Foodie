// To parse this JSON data, do
//
//     final sendcoupon = sendcouponFromJson(jsonString);

import 'dart:convert';

Sendcoupon? sendcouponFromJson(String str) => Sendcoupon.fromJson(json.decode(str));

String sendcouponToJson(Sendcoupon? data) => json.encode(data!.toJson());

class Sendcoupon {
    Sendcoupon({
        this.code,
    });

    String? code;

    factory Sendcoupon.fromJson(Map<String, dynamic> json) => Sendcoupon(
        code: json["code"],
    );

    Map<String, dynamic> toJson() => {
        "code": code,
    };
}
