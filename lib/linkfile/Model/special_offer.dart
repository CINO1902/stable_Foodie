// To parse this JSON data, do
//
//     final specialoffer = specialofferFromJson(jsonString);

import 'dart:convert';

Specialoffer specialofferFromJson(String str) => Specialoffer.fromJson(json.decode(str));

String specialofferToJson(Specialoffer data) => json.encode(data.toJson());

class Specialoffer {
    Specialoffer({
        required this.status,
        required this.msg,
    });

    String status;
    List<Msg> msg;

    factory Specialoffer.fromJson(Map<String, dynamic> json) => Specialoffer(
        status: json["status"],
        msg: List<Msg>.from(json["msg"].map((x) => Msg.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "msg": List<dynamic>.from(msg.map((x) => x.toJson())),
    };
}

class Msg {
    Msg({
        required this.extras,
        required this.id,
        required this.offerId,
        required this.offerName,
        required this.image,
        required this.description,
        required this.value,
        required this.time,
        required this.availability,
        required this.remaining,
        required this.remainingvalue,
        required this.date,
        required this.v,
        required this.side,
        required this.drink,
        required this.food,
        required this.drinksTras,
        required this.foodTras,
        required this.drinktype,
    });

    List<Map<String, dynamic>> extras;
    String id;
    int offerId;
    String offerName;
    String image;
    String description;
    int value;
    String time;
    bool availability;
    bool remaining;
    int remainingvalue;
    DateTime date;
    int v;
    bool side;
    bool drink;
    bool food;
    List<Map<String, dynamic>> drinksTras;
    List<Map<String, dynamic>> foodTras;
    String drinktype;

    factory Msg.fromJson(Map<String, dynamic> json) => Msg(
        extras: List<Map<String, dynamic>>.from(json["extras"].map((x) => Map.from(x).map((k, v) => MapEntry<String, dynamic>(k, v)))),
        id: json["_id"],
        offerId: json["offer_id"],
        offerName: json["offer_name"],
        image: json["image"],
        description: json["description"],
        value: json["value"],
        time: json["time"],
        availability: json["availability"],
        remaining: json["remaining"],
        remainingvalue: json["remainingvalue"],
        date: DateTime.parse(json["date"]),
        v: json["__v"],
        side: json["side"],
        drink: json["drink"],
        food: json["food"],
        drinksTras: List<Map<String, dynamic>>.from(json["drinks_tras"].map((x) => Map.from(x).map((k, v) => MapEntry<String, dynamic>(k, v)))),
        foodTras: List<Map<String, dynamic>>.from(json["food_tras"].map((x) => Map.from(x).map((k, v) => MapEntry<String, dynamic>(k, v)))),
        drinktype: json["drinktype"],
    );

    Map<String, dynamic> toJson() => {
        "extras": List<dynamic>.from(extras.map((x) => Map.from(x).map((k, v) => MapEntry<String, dynamic>(k, v)))),
        "_id": id,
        "offer_id": offerId,
        "offer_name": offerName,
        "image": image,
        "description": description,
        "value": value,
        "time": time,
        "availability": availability,
        "remaining": remaining,
        "remainingvalue": remainingvalue,
        "date": date.toIso8601String(),
        "__v": v,
        "side": side,
        "drink": drink,
        "food": food,
        "drinks_tras": List<dynamic>.from(drinksTras.map((x) => Map.from(x).map((k, v) => MapEntry<String, dynamic>(k, v)))),
        "food_tras": List<dynamic>.from(foodTras.map((x) => Map.from(x).map((k, v) => MapEntry<String, dynamic>(k, v)))),
        "drinktype": drinktype,
    };
}
