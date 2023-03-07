// To parse this JSON data, do
//
//     final verifyOtp = verifyOtpFromJson(jsonString);

import 'dart:convert';

VerifyOtp verifyOtpFromJson(String str) => VerifyOtp.fromJson(json.decode(str));

String verifyOtpToJson(VerifyOtp data) => json.encode(data.toJson());

class VerifyOtp {
  VerifyOtp({this.email, this.otp, this.password});

  String? email;
  String? otp;
  String? password;

  factory VerifyOtp.fromJson(Map<String, dynamic> json) => VerifyOtp(
        email: json["email"],
        otp: json["otp"],
        password: json['password']
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "otp": otp,
        "password": password
      };
}
