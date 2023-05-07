// To parse this JSON data, do
//
//     final sendextraSpecialoffer = sendextraSpecialofferFromJson(jsonString);

import 'dart:convert';

SendextraSpecialoffer sendextraSpecialofferFromJson(String str) =>
    SendextraSpecialoffer.fromJson(json.decode(str));

String sendextraSpecialofferToJson(SendextraSpecialoffer data) =>
    json.encode(data.toJson());

class SendextraSpecialoffer {
  SendextraSpecialoffer(
      {required this.id,
      required this.specialName,
      required this.specialNameId,
      required this.multiple,
      required this.amount,
      required this.image,
      required this.foods,
      required this.drinks,
      required this.sides,
      required this.version});

  String id;
  String specialName;
  String specialNameId;
  int multiple;
  int amount;
  int version;
  String image;
  List<Map<String, dynamic>> foods;
  List<Map<String, dynamic>> drinks;
  List<Map<String, dynamic>> sides;

  factory SendextraSpecialoffer.fromJson(Map<String, dynamic> json) =>
      SendextraSpecialoffer(
        id: json["id"],
        specialName: json["specialName"],
        specialNameId: json["specialNameID"],
        multiple: json["multiple"],
        amount: json["amount"],
        image: json["image"],
        version: json["version"],
        foods: List<Map<String, dynamic>>.from(json["foods"].map(
            (x) => Map.from(x).map((k, v) => MapEntry<String, dynamic>(k, v)))),
        drinks: List<Map<String, dynamic>>.from(json["drinks"].map(
            (x) => Map.from(x).map((k, v) => MapEntry<String, dynamic>(k, v)))),
        sides: List<Map<String, dynamic>>.from(json["sides"].map(
            (x) => Map.from(x).map((k, v) => MapEntry<String, dynamic>(k, v)))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "specialName": specialName,
        "specialNameID": specialNameId,
        "multiple": multiple,
        "amount": amount,
        "image": image,
        "version": version,
        "foods": List<dynamic>.from(foods.map(
            (x) => Map.from(x).map((k, v) => MapEntry<String, dynamic>(k, v)))),
        "drinks": List<dynamic>.from(drinks.map(
            (x) => Map.from(x).map((k, v) => MapEntry<String, dynamic>(k, v)))),
        "sides": List<dynamic>.from(sides.map(
            (x) => Map.from(x).map((k, v) => MapEntry<String, dynamic>(k, v)))),
      };
}
