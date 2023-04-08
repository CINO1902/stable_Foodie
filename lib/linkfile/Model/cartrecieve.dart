// To parse this JSON data, do
//
//     final cartRecieveModel = cartRecieveModelFromJson(jsonString);

import 'dart:convert';

CartRecieveModel cartRecieveModelFromJson(String str) =>
    CartRecieveModel.fromJson(json.decode(str));

String cartRecieveModelToJson(CartRecieveModel data) =>
    json.encode(data.toJson());

class CartRecieveModel {
  CartRecieveModel({
    required this.status,
    required this.result,
  });

  String status;
  Result result;

  factory CartRecieveModel.fromJson(Map<String, dynamic> json) =>
      CartRecieveModel(
        status: json["status"],
        result: Result.fromJson(json["result"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "result": result.toJson(),
      };
}

class Result {
  Result({
    required this.pagnited,
    required this.next,
    required this.previous,
  });

  List<Pagnited> pagnited;
  Next next;
  Next previous;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        pagnited: List<Pagnited>.from(
            json["pagnited"].map((x) => Pagnited.fromJson(x))),
        next: Next.fromJson(json["next"]),
        previous: Next.fromJson(json["previous"]),
      );

  Map<String, dynamic> toJson() => {
        "pagnited": List<dynamic>.from(pagnited.map((x) => x.toJson())),
        "next": next.toJson(),
        "previous": previous.toJson(),
      };
}

class Next {
  Next({
    required this.page,
    required this.limit,
  });

  int page;
  int limit;

  factory Next.fromJson(Map<String, dynamic> json) => Next(
        page: json["page"],
        limit: json["limit"],
      );

  Map<String, dynamic> toJson() => {
        "page": page,
        "limit": limit,
      };
}

class Pagnited {
  Pagnited({
    required this.id,
    required this.pagnitedId,
    this.specialName,
    this.specialNameId,
    this.sides,
    this.foods,
    this.drinks,
    required this.status,
    required this.multiple,
    required this.amount,
    required this.image,
    required this.packageid,
    required this.order,
    required this.date,
    required this.v,
    this.address,
    required this.discounted,
    required this.discountedAmount,
    this.email,
    this.location,
    this.name,
    this.number,
    required this.ordernum,
    this.ref,
    this.food,
    this.extras,
    this.total,
    this.packageGroup,
  });

  String id;
  String pagnitedId;
  String? specialName;
  String? specialNameId;
  List<dynamic>? sides;
  List<Map<String, dynamic>>? foods;
  List<Map<String, dynamic>>? drinks;
  int status;
  dynamic multiple;
  dynamic amount;
  String image;
  String packageid;
  bool order;
  DateTime date;
  int v;
  String? address;
  bool? discounted;
  String? discountedAmount;
  String? email;
  String? location;
  String? name;
  String? number;
  String? ordernum;
  String? ref;
  String? food;
  List<Extra>? extras;
  String? total;
  String? packageGroup;

  factory Pagnited.fromJson(Map<String, dynamic> json) => Pagnited(
        id: json["_id"],
        pagnitedId: json["id"],
        specialName: json["specialName"],
        specialNameId: json["specialNameID"],
        sides: json["sides"] == null
            ? []
            : List<dynamic>.from(json["sides"]!.map((x) => x)),
        foods: json["foods"] == null
            ? []
            : List<Map<String, dynamic>>.from(json["foods"]!.map((x) =>
                Map.from(x).map((k, v) => MapEntry<String, dynamic>(k, v)))),
        drinks: json["drinks"] == null
            ? []
            : List<Map<String, dynamic>>.from(json["drinks"]!.map((x) =>
                Map.from(x).map((k, v) => MapEntry<String, dynamic>(k, v)))),
        status: json["status"],
        multiple: json["multiple"],
        amount: json["amount"],
        image: json["image"],
        packageid: json["packageid"],
        order: json["order"],
        date: DateTime.parse(json["date"]),
        v: json["__v"],
        address: json["address"],
        discounted: json["discounted"],
        discountedAmount: json["discounted_amount"],
        email: json["email"],
        location: json["location"],
        name: json["name"],
        number: json["number"],
        ordernum: json["ordernum"],
        ref: json["ref"],
        food: json["food"],
        extras: json["extras"] == null
            ? []
            : List<Extra>.from(json["extras"]!.map((x) => Extra.fromJson(x))),
        total: json["total"],
        packageGroup: json["package_group"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "id": pagnitedId,
        "specialName": specialName,
        "specialNameID": specialNameId,
        "sides": sides == null ? [] : List<dynamic>.from(sides!.map((x) => x)),
        "foods": foods == null
            ? []
            : List<dynamic>.from(foods!.map((x) =>
                Map.from(x).map((k, v) => MapEntry<String, dynamic>(k, v)))),
        "drinks": drinks == null
            ? []
            : List<dynamic>.from(drinks!.map((x) =>
                Map.from(x).map((k, v) => MapEntry<String, dynamic>(k, v)))),
        "status": status,
        "multiple": multiple,
        "amount": amount,
        "image": image,
        "packageid": packageid,
        "order": order,
        "date": date.toIso8601String(),
        "__v": v,
        "address": address,
        "discounted": discounted,
        "discounted_amount": discountedAmount,
        "email": email,
        "location": location,
        "name": name,
        "number": number,
        "ordernum": ordernum,
        "ref": ref,
        "food": food,
        "extras": extras == null
            ? []
            : List<dynamic>.from(extras!.map((x) => x.toJson())),
        "total": total,
        "package_group": packageGroup,
      };
}

class Extra {
  Extra({
    required this.the0,
    required this.the1,
    required this.the2,
    required this.the3,
    required this.the4,
    required this.the5,
    required this.id,
  });

  String the0;
  String the1;
  String the2;
  String the3;
  bool? the4;
  String the5;
  String id;

  factory Extra.fromJson(Map<String, dynamic> json) => Extra(
        the0: json["0"],
        the1: json["1"],
        the2: json["2"],
        the3: json["3"],
        the4: json["4"],
        the5: json["5"],
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "0": the0,
        "1": the1,
        "2": the2,
        "3": the3,
        "4": the4,
        "5": the5,
        "_id": id,
      };
}
