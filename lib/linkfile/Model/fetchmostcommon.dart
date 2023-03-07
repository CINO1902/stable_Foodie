// To parse this JSON data, do
//
//     final fetchmostcommon = fetchmostcommonFromJson(jsonString);

import 'dart:convert';

Fetchmostcommon fetchmostcommonFromJson(String str) =>
    Fetchmostcommon.fromJson(json.decode(str));

String fetchmostcommonToJson(Fetchmostcommon data) =>
    json.encode(data.toJson());

class Fetchmostcommon {
  Fetchmostcommon({this.email, this.generatedID});

  String? email;
  String? generatedID;

  factory Fetchmostcommon.fromJson(Map<String, dynamic> json) =>
      Fetchmostcommon(
        email: json["email"],
         generatedID: json["generatedID"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "generatedID":generatedID
      };
}
