// To parse this JSON data, do
//
//     final imageslider = imagesliderFromJson(jsonString);

import 'dart:convert';

Imageslider imagesliderFromJson(String str) => Imageslider.fromJson(json.decode(str));

String imagesliderToJson(Imageslider data) => json.encode(data.toJson());

class Imageslider {
    Imageslider({
        required this.success,
        required this.item,
        required this.linkios,
        required this.linkandroid,
    });

    String success;
    List<String> item;
    List<String> linkios;
    List<String> linkandroid;

    factory Imageslider.fromJson(Map<String, dynamic> json) => Imageslider(
        success: json["success"],
        item: List<String>.from(json["item"].map((x) => x)),
        linkios: List<String>.from(json["linkios"].map((x) => x)),
        linkandroid: List<String>.from(json["linkandroid"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "item": List<dynamic>.from(item.map((x) => x)),
        "linkios": List<dynamic>.from(linkios.map((x) => x)),
        "linkandroid": List<dynamic>.from(linkandroid.map((x) => x)),
    };
}
