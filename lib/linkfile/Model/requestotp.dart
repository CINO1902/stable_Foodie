// To parse this JSON data, do
//
//     final requestotp = requestotpFromJson(jsonString);

import 'dart:convert';

Requestotp requestotpFromJson(String str) => Requestotp.fromJson(json.decode(str));

String requestotpToJson(Requestotp data) => json.encode(data.toJson());

class Requestotp {
    Requestotp({
        this.email
    });

    String? email;

    factory Requestotp.fromJson(Map<String, dynamic> json) => Requestotp(
        email: json["email"],
    );

    Map<String, dynamic> toJson() => {
        "email": email,
    };
}
