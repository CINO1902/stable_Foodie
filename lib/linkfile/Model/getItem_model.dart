// To parse this JSON data, do
//
//     final getItem = getItemFromJson(jsonString);

import 'dart:convert';

GetItem getItemFromJson(String str) => GetItem.fromJson(json.decode(str));

String getItemToJson(GetItem data) => json.encode(data.toJson());

class GetItem {
  GetItem({
    this.item,
  });

  List<Item>? item;

  factory GetItem.fromJson(Map<String, dynamic> json) => GetItem(
        item: List<Item>.from(json["item"].map((x) => Item.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "item": List<dynamic>.from(item!.map((x) => x.toJson())),
      };
}

class Item {
  Item({
    this.id,
    this.itemId,
    this.item,
    this.availability,
    this.remaining,
    this.remainingInt,
    this.imageUrl,
    this.extras,
    this.v,
    required this.mincost,
    this.extraable,
    this.maxspoon,
  });

  String? id;
  String? itemId;
  String? item;
  bool? availability;
  bool? remaining;
  String? remainingInt;
  String? imageUrl;
  List<String>? extras;
  int? v;
  String mincost;
  bool? extraable;
  int? maxspoon;

  factory Item.fromJson(Map<String, dynamic> json) => Item(
      id: json["_id"],
      itemId: json["id"],
      item: json["item"],
      availability: json["availability"],
      remaining: json["remaining"],
      remainingInt: json["remainingINT"],
      imageUrl: json["image_url"],
      extras: List<String>.from(json["extras"].map((x) => x)),
      v: json["__v"],
      mincost: json["mincost"],
      extraable: json["extraable"],
      maxspoon: json['maxspoon']);

  Map<String, dynamic> toJson() => {
        "_id": id,
        "id": itemId,
        "item": item,
        "availability": availability,
        "remaining": remaining,
        "remainingINT": remainingInt,
        "image_url": imageUrl,
        "extras": List<dynamic>.from(extras!.map((x) => x)),
        "__v": v,
        "mincost": mincost,
        "extraable": extraable,
        "maxspoon": maxspoon
      };
}
