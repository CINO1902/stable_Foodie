// To parse this JSON data, do
//
//     final confirmmodel = confirmmodelFromJson(jsonString);

import 'dart:convert';

Confirmmodel confirmmodelFromJson(String str) =>
    Confirmmodel.fromJson(json.decode(str));

String confirmmodelToJson(Confirmmodel data) => json.encode(data.toJson());

class Confirmmodel {
  Confirmmodel(
      {required this.packageGroup,
      required this.amount,
      required this.verified,
      required this.email,
      required this.name,
      required this.number,
      required this.address,
      required this.location,
      required this.ref});

  String packageGroup;
  int amount;
  bool verified;
  String email;
  String name;
  String number;
  String address;
  String location;
  String ref;

  factory Confirmmodel.fromJson(Map<dynamic, dynamic> json) => Confirmmodel(
      packageGroup: json["package_group"],
      amount: json["amount"],
      verified: json["verified"],
      email: json["email"],
      name: json["name"],
      number: json["number"],
      address: json["address"],
      location: json["location"],
      ref: json["ref"]);

  Map<dynamic, dynamic> toJson() => {
        "package_group": packageGroup,
        "amount": amount,
        "verified": verified,
        "email": email,
        "name": name,
        "number": number,
        "address": address,
        "location": location,
        "ref": ref
      };
}
