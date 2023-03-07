// To parse this JSON data, do
//
//     final fetchcartModel = fetchcartModelFromJson(jsonString);

import 'dart:convert';

FetchcartModel fetchcartModelFromJson(String str) =>
    FetchcartModel.fromJson(json.decode(str));

String fetchcartModelToJson(FetchcartModel data) => json.encode(data.toJson());

class FetchcartModel {
  FetchcartModel({required this.id, required this.email, this.ref});

  String id;
  String email;
  String? ref;

  factory FetchcartModel.fromJson(Map<String, dynamic> json) => FetchcartModel(
        id: json["Id"],
        email: json["email"],
        ref: json["ref"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "email": email,
        "ref": ref,
      };
}
