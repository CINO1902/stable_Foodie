// To parse this JSON data, do
//
//     final mostcommon = mostcommonFromJson(jsonString);

import 'dart:convert';

Mostcommon mostcommonFromJson(String str) =>
    Mostcommon.fromJson(json.decode(str));

String mostcommonToJson(Mostcommon data) => json.encode(data.toJson());

class Mostcommon {
  Mostcommon({
    this.suggestfood,
    this.frequency,
    required this.expire,
    required this.date,
    required this.currentdate,
    this.sapa,
    this.longthroat,
    this.odogwu,
    this.drinks,
    required this.swallow,
  });

  List<Drink>? suggestfood;
  int? frequency;
  DateTime expire;
  DateTime date;
  DateTime currentdate;
  bool? sapa;
  bool? longthroat;
  bool? odogwu;
  List<Drink>? drinks;
  List<String> swallow;

  factory Mostcommon.fromJson(Map<String, dynamic> json) => Mostcommon(
        suggestfood:
            List<Drink>.from(json["suggestfood"].map((x) => Drink.fromJson(x))),
        frequency: json["frequency"],
        expire: DateTime.parse(json["expire"]),
        date: DateTime.parse(json["date"]),
        currentdate: DateTime.parse(json["currentdate"]),
        sapa: json["sapa"],
        longthroat: json["longthroat"],
        odogwu: json["odogwu"],
        drinks: List<Drink>.from(json["drinks"].map((x) => Drink.fromJson(x))),
        swallow: List<String>.from(json["swallow"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "suggestfood": List<dynamic>.from(suggestfood!.map((x) => x.toJson())),
        "frequency": frequency,
        "expire": expire.toIso8601String(),
        "date": date.toIso8601String(),
        "currentdate": currentdate.toIso8601String(),
        "sapa": sapa,
        "longthroat": longthroat,
        "odogwu": odogwu,
        "drinks": List<dynamic>.from(drinks!.map((x) => x.toJson())),
        "swallow": List<dynamic>.from(swallow.map((x) => x)),
      };
}

class Drink {
  Drink({
    required this.id,
    required this.category,
    required this.packageName,
    required this.amount,
    required this.extras,
    required this.image,
    required this.v,
    required this.drinkId,
    required this.common,
  });

  String id;
  String category;
  String packageName;
  String amount;
  List<Extra> extras;
  String? image;
  int v;
  String drinkId;
  bool common;

  factory Drink.fromJson(Map<String, dynamic> json) => Drink(
        id: json["_id"],
        category: json["category"],
        packageName: json["package_name"],
        amount: json["amount"],
        extras: List<Extra>.from(json["extras"].map((x) => Extra.fromJson(x))),
        image: json["image"],
        v: json["__v"],
        drinkId: json["id"],
        common: json["common"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "category": category,
        "package_name": packageName,
        "amount": amount,
        "extras": List<dynamic>.from(extras.map((x) => x.toJson())),
        "image": image,
        "__v": v,
        "id": drinkId,
        "common": common,
      };
}

class Extra {
  Extra({
    required this.the0,
    this.the1,
    this.the2,
    required this.id,
  });

  String the0;
  String? the1;
  String? the2;
  String id;

  factory Extra.fromJson(Map<String, dynamic> json) => Extra(
        the0: json["0"],
        the1: json["1"],
        the2: json["2"],
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "0": the0,
        "1": the1,
        "2": the2,
        "_id": id,
      };
}
