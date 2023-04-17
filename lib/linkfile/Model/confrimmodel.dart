// To parse this JSON data, do
//
//     final confirmmodel = confirmmodelFromJson(jsonString);

import 'dart:convert';

Confirmmodel confirmmodelFromJson(String str) =>
    Confirmmodel.fromJson(json.decode(str));

String confirmmodelToJson(Confirmmodel data) => json.encode(data.toJson());

class Confirmmodel {
  Confirmmodel(
      {required this.amount,
      required this.id,
      required this.verified,
      required this.email,
      required this.name,
      required this.number,
      required this.address,
      required this.code,
      required this.location,
      required this.ref});

  int amount;
  String id;
  bool verified;
  String email;
  String name;
  String code;
  String number;
  String address;
  String location;
  String ref;

  factory Confirmmodel.fromJson(Map<dynamic, dynamic> json) => Confirmmodel(
      amount: json["amount"],
      id: json["id"],
      verified: json["verified"],
      email: json["email"],
      name: json["name"],
      code: json["code"],
      number: json["number"],
      address: json["address"],
      location: json["location"],
      ref: json["ref"]);

  Map<dynamic, dynamic> toJson() => {
        "amount": amount,
        "id": id,
        "verified": verified,
        "email": email,
        "name": name,
        "code":code,
        "number": number,
        "address": address,
        "location": location,
        "ref": ref
      };
}
