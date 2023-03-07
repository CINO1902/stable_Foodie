// To parse this JSON data, do
//
//     final getsoup = getsoupFromJson(jsonString);

import 'dart:convert';

Getsoup getsoupFromJson(String str) => Getsoup.fromJson(json.decode(str));

String getsoupToJson(Getsoup data) => json.encode(data.toJson());

class Getsoup {
    Getsoup({
        required this.soup,
    });

    List<Soup> soup;

    factory Getsoup.fromJson(Map<String, dynamic> json) => Getsoup(
        soup: List<Soup>.from(json["soup"].map((x) => Soup.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "soup": List<dynamic>.from(soup.map((x) => x.toJson())),
    };
}

class Soup {
    Soup({
        required this.id,
        required this.category,
        required this.packageName,
        required this.amount,
        required this.soupId,
        required this.v,
    });

    String id;
    String category;
    String packageName;
    String amount;
    String soupId;
    int v;

    factory Soup.fromJson(Map<String, dynamic> json) => Soup(
        id: json["_id"],
        category: json["category"],
        packageName: json["package_name"],
        amount: json["amount"],
        soupId: json["id"],
        v: json["__v"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "category": category,
        "package_name": packageName,
        "amount": amount,
        "id": soupId,
        "__v": v,
    };
}
