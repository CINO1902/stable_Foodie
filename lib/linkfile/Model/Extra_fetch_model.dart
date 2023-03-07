// To parse this JSON data, do
//
//     final extrasModelFetch = extrasModelFetchFromJson(jsonString);

import 'dart:convert';

ExtrasModelFetch extrasModelFetchFromJson(String str) => ExtrasModelFetch.fromJson(json.decode(str));

String extrasModelFetchToJson(ExtrasModelFetch data) => json.encode(data.toJson());

class ExtrasModelFetch {
    ExtrasModelFetch({
        this.id,
    });

    String? id;

    factory ExtrasModelFetch.fromJson(Map<String, dynamic> json) => ExtrasModelFetch(
        id: json["id"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
    };
}
