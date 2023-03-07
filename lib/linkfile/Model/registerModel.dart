// To parse this JSON data, do
//
//     final register = registerFromJson(jsonString);

import 'dart:convert';

Register registerFromJson(String str) => Register.fromJson(json.decode(str));

String registerToJson(Register data) => json.encode(data.toJson());

class Register {
  Register({
    this.firstname,
    this.lastname,
    this.email,
    this.phone,
    this.password,
  });

  String? firstname;
  String? lastname;
  String? email;
  String? phone;
  String? password;

  factory Register.fromJson(Map<String, dynamic> json) => Register(
        firstname: json["firstname"],
        lastname: json["lastname"],
        email: json["email"],
        phone: json['phone'],
        password: json["password"],
      );

  Map<String, dynamic> toJson() => {
        "firstname": firstname,
        "lastname": lastname,
        "email": email,
        "phone":phone,
        "password": password,
      };
}
