// To parse this JSON data, do
//
//     final extrasModel = extrasModelFromJson(jsonString);

import 'dart:convert';

ExtrasModel extrasModelFromJson(String str) =>
    ExtrasModel.fromJson(json.decode(str));

String extrasModelToJson(ExtrasModel data) => json.encode(data.toJson());

class ExtrasModel {
  ExtrasModel({
    this.itemExtra,
  });

  List<List<ItemExtra>>? itemExtra;

  factory ExtrasModel.fromJson(Map<String, dynamic> json) => ExtrasModel(
        itemExtra: List<List<ItemExtra>>.from(json["itemExtra"].map(
            (x) => List<ItemExtra>.from(x.map((x) => ItemExtra.fromJson(x))))),
      );

  Map<String, dynamic> toJson() => {
        "itemExtra": List<dynamic>.from(itemExtra!
            .map((x) => List<dynamic>.from(x.map((x) => x.toJson())))),
      };
}

class ItemExtra {
  ItemExtra({
    this.id,
    required this.itemExtraId,
    this.item,
    this.availability,
    required this.remaining,
    this.remainingInt,
    this.imageUrl,
    this.extras,
    this.v,
    required this.mincost,
    this.extraable,
    this.maxspoon,
    this.segment,
  });

  String? id;
  String itemExtraId;
  String? item;
  bool? availability;
  bool remaining;
  String? remainingInt;
  String? imageUrl;
  List<dynamic>? extras;
  int? v;
  String mincost;
  bool? extraable;
  int? maxspoon;
  String? segment;

  factory ItemExtra.fromJson(Map<String, dynamic> json) => ItemExtra(
      id: json["_id"],
      itemExtraId: json["id"],
      item: json["item"],
      availability: json["availability"],
      remaining: json["remaining"],
      remainingInt: json["remainingINT"],
      imageUrl: json["image_url"],
      extras: List<dynamic>.from(json["extras"].map((x) => x)),
      v: json["__v"],
      mincost: json["mincost"],
      extraable: json["extraable"],
      maxspoon: json['maxspoon'],
      segment: json['segment']
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "id": itemExtraId,
        "item": item,
        "availability": availability,
        "remaining": remaining,
        "remainingINT": remainingInt,
        "image_url": imageUrl,
        "extras": List<dynamic>.from(extras!.map((x) => x)),
        "__v": v,
        "mincost": mincost,
        "extraable": extraable,
        "maxspoon": maxspoon,
        "segment":segment
      };
}
