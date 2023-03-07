// To parse this JSON data, do
//
//     final calculateplan = calculateplanFromJson(jsonString);

import 'dart:convert';

Calculateplan? calculateplanFromJson(String str) =>
    Calculateplan.fromJson(json.decode(str));

String calculateplanToJson(Calculateplan? data) => json.encode(data!.toJson());

class Calculateplan {
  Calculateplan({
    this.email,
    this.category1,
    this.category2,
    this.category3,
    this.drinks1,
    this.drinks2,
    this.drinks3,
  });

  String? email;
  String? category1;
  String? category2;
  String? category3;
  String? drinks1;
  String? drinks2;
  String? drinks3;

  factory Calculateplan.fromJson(Map<String, dynamic> json) => Calculateplan(
        email: json["email"],
        category1: json["category1"],
        category2: json["category2"],
        category3: json["category3"],
        drinks1: json["drinks1"],
        drinks2: json["drinks2"],
        drinks3: json["drinks3"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "category1": category1,
        "category2": category2,
        "category3": category3,
         "drinks1": drinks1,
          "drinks2": drinks2,
           "drinks3": drinks3,
      };
}
