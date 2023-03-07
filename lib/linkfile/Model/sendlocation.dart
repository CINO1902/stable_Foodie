// To parse this JSON data, do
//
//     final sendlocation = sendlocationFromJson(jsonString);

import 'dart:convert';

Sendlocation? sendlocationFromJson(String str) => Sendlocation.fromJson(json.decode(str));

String sendlocationToJson(Sendlocation? data) => json.encode(data!.toJson());

class Sendlocation {
    Sendlocation({
        this.location,
    });

    String? location;

    factory Sendlocation.fromJson(Map<String, dynamic> json) => Sendlocation(
        location: json["location"],
    );

    Map<String, dynamic> toJson() => {
        "location": location,
    };
}
