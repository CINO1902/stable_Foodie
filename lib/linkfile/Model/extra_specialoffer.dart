// To parse this JSON data, do
//
//     final extraSpecialoffer = extraSpecialofferFromJson(jsonString);

import 'dart:convert';

ExtraSpecialoffer extraSpecialofferFromJson(String str) =>
    ExtraSpecialoffer.fromJson(json.decode(str));

String extraSpecialofferToJson(ExtraSpecialoffer data) =>
    json.encode(data.toJson());

class ExtraSpecialoffer {
  ExtraSpecialoffer({
    required this.status,
    required this.side,
    required this.drink,
    required this.food,
  });

  String status;
  List<Drink> side;
  List<Drink> drink;
  List<Drink> food;

  factory ExtraSpecialoffer.fromJson(Map<String, dynamic> json) =>
      ExtraSpecialoffer(
        status: json["status"],
        side: List<Drink>.from(json["side"].map((x) => Drink.fromJson(x))),
        drink: List<Drink>.from(json["drink"].map((x) => Drink.fromJson(x))),
        food: List<Drink>.from(json["food"].map((x) => Drink.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "side": List<dynamic>.from(side.map((x) => x.toJson())),
        "drink": List<dynamic>.from(drink.map((x) => x.toJson())),
        "food": List<dynamic>.from(food.map((x) => x.toJson())),
      };
}

class Drink {
  Drink({
    required this.id,
    required this.extraId,
    required this.extraName,
    required this.availability,
    required this.remaining,
    required this.value,
    required this.remainingvalue,
    required this.segment,
    required this.v,
  });

  String id;
  int extraId;
  String extraName;
  bool availability;
  bool remaining;
  int value;
  int remainingvalue;
  String segment;
  int v;

  factory Drink.fromJson(Map<String, dynamic> json) => Drink(
        id: json["_id"],
        extraId: json["extra_id"],
        extraName: json["extra_name"],
        availability: json["availability"],
        remaining: json["remaining"],
        value: json["value"],
        remainingvalue: json["remainingvalue"],
        segment: json["segment"],
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "extra_id": extraId,
        "extra_name": extraName,
        "availability": availability,
        "remaining": remaining,
        "value": value,
        "remainingvalue": remainingvalue,
        "segment": segment,
        "__v": v,
      };
}

enum Segment { DRINK, FOOD, SIDE }

final segmentValues = EnumValues(
    {"drink": Segment.DRINK, "food": Segment.FOOD, "side": Segment.SIDE});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
