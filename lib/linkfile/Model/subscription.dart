// To parse this JSON data, do
//
//     final subscription = subscriptionFromJson(jsonString);

import 'dart:convert';

Subscription subscriptionFromJson(String str) =>
    Subscription.fromJson(json.decode(str));

String subscriptionToJson(Subscription data) => json.encode(data.toJson());

class Subscription {
  Subscription({
    required this.email,
    required this.frequency,
    this.days,
    this.day1,
    this.day2,
    this.day3,
    this.drink1,
    this.drink2,
    this.drink3,
    this.category1,
    this.category2,
    this.category3
  });

  String email;
  int frequency;
  int? days;
  List<Map<String, String>>? day1;
  List<Map<String, String>>? day2;
  List<Map<String, String>>? day3;
  String? drink1;
  String? drink2;
  String? drink3;
  String? category1;
  String? category2;
  String? category3;

  factory Subscription.fromJson(Map<String, dynamic> json) => Subscription(
        email: json["email"],
        frequency: json["frequency"],
         days: json["days"],
        day1: List<Map<String, String>>.from(json["day1"].map(
            (x) => Map.from(x).map((k, v) => MapEntry<String, String>(k, v)))),
        day2: List<Map<String, String>>.from(json["day2"].map(
            (x) => Map.from(x).map((k, v) => MapEntry<String, String>(k, v)))),
        day3: List<Map<String, String>>.from(json["day3"].map(
            (x) => Map.from(x).map((k, v) => MapEntry<String, String>(k, v)))),
        drink1: json["drink1"],
        drink2: json["drink2"],
        drink3: json["drink3"],
        category1: json["category1"],
        category2: json["category2"],
        category3: json["category3"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "frequency": frequency,
        "days": days,
        "day1": List<dynamic>.from(day1!.map(
            (x) => Map.from(x).map((k, v) => MapEntry<String, dynamic>(k, v)))),
        "day2": List<dynamic>.from(day2!.map(
            (x) => Map.from(x).map((k, v) => MapEntry<String, dynamic>(k, v)))),
        "day3": List<dynamic>.from(day3!.map(
            (x) => Map.from(x).map((k, v) => MapEntry<String, dynamic>(k, v)))),
        "drink1": drink1,
        "drink2": drink2,
        "drink3": drink3,
        "category1": category1,
         "category2": category2,
          "category3": category3,
      };
}
