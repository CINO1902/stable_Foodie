// To parse this JSON data, do
//
//     final changeAddress = changeAddressFromJson(jsonString);

import 'dart:convert';

ChangeAddress? changeAddressFromJson(String str) =>
    ChangeAddress.fromJson(json.decode(str));

String changeAddressToJson(ChangeAddress? data) => json.encode(data!.toJson());

class ChangeAddress {
  ChangeAddress({this.email, this.address, this.phone, this.location});

  String? email;
  String? address;
  String? phone;
  String? location;

  factory ChangeAddress.fromJson(Map<String, dynamic> json) => ChangeAddress(
      email: json["email"],
      address: json["address"],
      phone: json['phone'],
      location: json['location']);

  Map<String, dynamic> toJson() => {
        "email": email,
        "address": address,
        "location": location,
        "phone": phone
      };
}
