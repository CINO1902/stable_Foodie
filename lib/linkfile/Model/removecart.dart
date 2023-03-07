// To parse this JSON data, do
//
//     final removeCart = removeCartFromJson(jsonString);

import 'dart:convert';

RemoveCart removeCartFromJson(String str) => RemoveCart.fromJson(json.decode(str));

String removeCartToJson(RemoveCart data) => json.encode(data.toJson());

class RemoveCart {
    RemoveCart({
        this.packageid,
    });

    String? packageid;

    factory RemoveCart.fromJson(Map<String, dynamic> json) => RemoveCart(
        packageid: json["packageid"],
    );

    Map<String, dynamic> toJson() => {
        "packageid": packageid,
    };
}
