// To parse this JSON data, do
//
//     final fetchPackage = fetchPackageFromJson(jsonString);

import 'dart:convert';

FetchPackage fetchPackageFromJson(String str) => FetchPackage.fromJson(json.decode(str));

String fetchPackageToJson(FetchPackage data) => json.encode(data.toJson());

class FetchPackage {
    FetchPackage({
        this.item,
    });

    List<Item>? item;

    factory FetchPackage.fromJson(Map<String, dynamic> json) => FetchPackage(
        item: List<Item>.from(json["item"].map((x) => Item.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "item": List<dynamic>.from(item!.map((x) => x.toJson())),
    };
}

class Item {
    Item({
        this.id,
        this.packageName,
        this.amount,
        this.extras,
        this.image,
        this.v,
        this.category,
        this.itemId,
    });

    String? id;
    String? packageName;
    String? amount;
    List<Extra>? extras;
    String? image;
    int? v;
    String? category;
    String? itemId;

    factory Item.fromJson(Map<String, dynamic> json) => Item(
        id: json["_id"],
        packageName: json["package_name"],
        amount: json["amount"],
        extras: List<Extra>.from(json["extras"].map((x) => Extra.fromJson(x))),
        image: json["image"],
        v: json["__v"],
        category: json["category"],
        itemId: json["id"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "package_name": packageName,
        "amount": amount,
        "extras": List<dynamic>.from(extras!.map((x) => x.toJson())),
        "image": image,
        "__v": v,
        "category": category,
        "id": itemId,
    };
}

class Extra {
    Extra({
        this.the0,
        this.id,
    });

    String? the0;
    String? id;

    factory Extra.fromJson(Map<String, dynamic> json) => Extra(
        the0: json["0"],
        id: json["_id"],
    );

    Map<String, dynamic> toJson() => {
        "0": the0,
        "_id": id,
    };
}
