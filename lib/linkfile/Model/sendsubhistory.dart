// To parse this JSON data, do
//
//     final sendSubhistory = sendSubhistoryFromJson(jsonString);

import 'dart:convert';

SendSubhistory sendSubhistoryFromJson(String str) => SendSubhistory.fromJson(json.decode(str));

String sendSubhistoryToJson(SendSubhistory data) => json.encode(data.toJson());

class SendSubhistory {
    SendSubhistory({
        this.email,
    });

    String? email;

    factory SendSubhistory.fromJson(Map<String, dynamic> json) => SendSubhistory(
        email: json["email"],
    );

    Map<String, dynamic> toJson() => {
        "email": email,
    };
}
