// To parse this JSON data, do
//
//     final checkoutList = checkoutListFromJson(jsonString);

import 'dart:convert';

CheckoutList checkoutListFromJson(String str) => CheckoutList.fromJson(json.decode(str));

String checkoutListToJson(CheckoutList data) => json.encode(data.toJson());

class CheckoutList {
    CheckoutList({
        required this.food1,
        required this.food2,
        required this.food3,
        required this.drink1,
        required this.drink2,
        required this.drink3,
    });

    List<String> food1;
    List<String> food2;
    List<String> food3;
    String drink1;
    String drink2;
    String drink3;

    factory CheckoutList.fromJson(Map<String, dynamic> json) => CheckoutList(
        food1: List<String>.from(json["food1"].map((x) => x)),
        food2: List<String>.from(json["food2"].map((x) => x)),
        food3: List<String>.from(json["food3"].map((x) => x)),
        drink1: json["drink1"],
        drink2: json["drink2"],
        drink3: json["drink3"],
    );

    Map<String, dynamic> toJson() => {
        "food1": List<dynamic>.from(food1.map((x) => x)),
        "food2": List<dynamic>.from(food2.map((x) => x)),
        "food3": List<dynamic>.from(food3.map((x) => x)),
        "drink1": drink1,
        "drink2": drink2,
        "drink3": drink3,
    };
}
