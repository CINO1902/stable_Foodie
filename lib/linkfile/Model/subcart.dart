// To parse this JSON data, do
//
//     final getsubcart = getsubcartFromJson(jsonString);

import 'dart:convert';

Getsubcart getsubcartFromJson(String str) => Getsubcart.fromJson(json.decode(str));

String getsubcartToJson(Getsubcart data) => json.encode(data.toJson());

class Getsubcart {
    Getsubcart({
        required this.details,
    });

    List<Detail> details;

    factory Getsubcart.fromJson(Map<String, dynamic> json) => Getsubcart(
        details: List<Detail>.from(json["details"].map((x) => Detail.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "details": List<dynamic>.from(details.map((x) => x.toJson())),
    };
}

class Detail {
    Detail({
        required this.id,
        required this.email,
        this.detailId,
        required this.order,
        required this.generatedid,
        this.category,
        this.packagename,
        required this.status,
        this.image,
        required this.day,
        required this.month,
        required this.year,
        required this.date,
        required this.createdAt,
        required this.expire,
        required this.v,
    });

    String id;
    String email;
    String? detailId;
    bool order;
    String generatedid;
    String? category;
    String? packagename;
    String status;
    String? image;
    String day;
    String month;
    String year;
    DateTime date;
    DateTime createdAt;
    DateTime expire;
    int v;

    factory Detail.fromJson(Map<String, dynamic> json) => Detail(
        id: json["_id"],
        email: json["email"],
        detailId: json["id"],
        order: json["order"],
        generatedid: json["generatedid"],
        category: json["category"],
        packagename: json["packagename"],
        status: json["status"],
        image: json["image"],
        day: json["day"],
        month: json["month"],
        year: json["year"],
        date: DateTime.parse(json["date"]),
        createdAt: DateTime.parse(json["createdAt"]),
        expire: DateTime.parse(json["expire"]),
        v: json["__v"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "email": email,
        "id": detailId,
        "order": order,
        "generatedid": generatedid,
        "category": category,
        "packagename": packagename,
        "status": status,
        "image": image,
        "day": day,
        "month": month,
        "year": year,
        "date": date.toIso8601String(),
        "createdAt": createdAt.toIso8601String(),
        "expire": expire.toIso8601String(),
        "__v": v,
    };
}
