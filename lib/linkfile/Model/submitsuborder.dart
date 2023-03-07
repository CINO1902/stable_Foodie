// To parse this JSON data, do
//
//     final submitsuborder = submitsuborderFromJson(jsonString);

import 'dart:convert';

Submitsuborder submitsuborderFromJson(String str) =>
    Submitsuborder.fromJson(json.decode(str));

String submitsuborderToJson(Submitsuborder data) => json.encode(data.toJson());

class Submitsuborder {
  Submitsuborder(
      {this.email,
      this.id,
      this.name,
      this.phone,
      this.address,
      this.category,
      this.location,
      this.packagename,
      this.image});

  String? email;
  String? id;
  String? name;
  String? phone;
  String? address;
  String? category;
String? location;
  String? packagename;
  String? image;

  factory Submitsuborder.fromJson(Map<String, dynamic> json) => Submitsuborder(
        email: json["email"],
        id: json["id"],
        name: json["name"],
        phone: json["phone"],
        address: json["address"],
        category: json["category"],
        location: json["location"],
        packagename: json["packagename"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "id": id,
        "name":name,
        "phone":phone,
        "address": address,
        "location": location,
        "category": category,
        "packagename": packagename,
        "image": image,
      };
}

class Extras {
  Extras({
    this.the0,
    this.id,
  });

  String? the0;
  String? id;

  factory Extras.fromJson(Map<String, dynamic> json) => Extras(
        the0: json["0"],
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "0": the0,
        "_id": id,
      };
}
