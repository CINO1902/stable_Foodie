// To parse this JSON data, do
//
//     final cartModel = cartModelFromJson(jsonString);

import 'dart:convert';

CartModel cartModelFromJson(String str) => CartModel.fromJson(json.decode(str));

String cartModelToJson(CartModel data) => json.encode(data.toJson());

class CartModel {
  CartModel(
      {this.id,
      this.food,
      this.amount,
      this.extras,
      this.multiple,
      this.total,
      this.image,
      this.version});

  String? id;
  String? food;
  String? amount;
  List<Map<String, dynamic>>? extras;
  String? multiple;
  String? total;
  String? image;
  int? version;

  factory CartModel.fromJson(Map<String, dynamic> json) => CartModel(
        id: json["id"],
        food: json["food"],
        amount: json["amount"],
        extras: List<Map<String, dynamic>>.from(json["extras"].map(
            (x) => Map.from(x).map((k, v) => MapEntry<String, dynamic>(k, v)))),
        multiple: json["multiple"],
        total: json["total"],
        image: json["image"],
        version: json["version"],
      );

  Map<dynamic, dynamic> toJson() => {
        "id": id,
        "food": food,
        "amount": amount,
        "extras": List<dynamic>.from(extras!.map(
            (x) => Map.from(x).map((k, v) => MapEntry<String, dynamic>(k, v)))),
        "multiple": multiple,
        "total": total,
        "image": image,
        "version": version
      };
}
