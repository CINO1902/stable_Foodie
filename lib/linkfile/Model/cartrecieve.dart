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
    this.pagnited,
    this.next,
    this.previous,
  });

  List<Pagnited>? pagnited;
  Next? next;
  Next? previous;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        pagnited: List<Pagnited>.from(
            json["pagnited"].map((x) => Pagnited.fromJson(x))),
        next: Next.fromJson(json["next"]),
        previous: Next.fromJson(json["previous"]),
      );

  Map<String, dynamic> toJson() => {
        "pagnited": List<dynamic>.from(pagnited!.map((x) => x.toJson())),
        "next": next!.toJson(),
        "previous": previous!.toJson(),
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
  Pagnited(
      {required this.id,
      required this.pagnitedId,
      required this.food,
      required this.amount,
      required this.extras,
      required this.order,
      required this.status,
      required this.multiple,
      required this.total,
      required this.image,
      required this.packageid,
      required this.packageGroup,
      required this.date,
      required this.v,
      this.discounted,
      this.discountedAmount,
      this.ordernum,
      this.name,
      this.number,
      this.email,
      this.address,
      this.location});

  String id;
  String pagnitedId;
  String food;
  String amount;
  List<Extra> extras;
  bool order;
  int status;
  String multiple;
  String total;
  String image;
  String packageid;
  String packageGroup;
  DateTime date;
  int v;
  bool? discounted;
  String? discountedAmount;
  String? ordernum;
  String? name;
  String? number;
  String? address;
  String? location;
  String? email;

  factory Pagnited.fromJson(Map<String, dynamic> json) => Pagnited(
        id: json["_id"],
        pagnitedId: json["id"],
        food: json["food"],
        amount: json["amount"],
        extras: List<Extra>.from(json["extras"].map((x) => Extra.fromJson(x))),
        order: json["order"],
        status: json["status"],
        multiple: json["multiple"],
        total: json["total"],
        image: json["image"],
        packageid: json["packageid"],
        packageGroup: json["package_group"],
        date: DateTime.parse(json["date"]),
        v: json["__v"],
        discounted: json["discounted"],
        discountedAmount: json["discounted_amount"],
        ordernum: json["ordernum"],
        name: json["name"],
        number: json["number"],
        address: json["address"],
        location: json["location"],
        email: json["email"]
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "id": pagnitedId,
        "food": food,
        "amount": amount,
        "extras": List<dynamic>.from(extras.map((x) => x.toJson())),
        "order": order,
        "status": status,
        "multiple": multiple,
        "total": total,
        "image": image,
        "packageid": packageid,
        "package_group": packageGroup,
        "date": date.toIso8601String(),
        "__v": v,
        "discounted": discounted,
        "discounted_amount": discountedAmount,
        "ordernum": ordernum,
         "name": name,
        "number": number,
        "address": address,
        "location": location,
        "email":email
      };
}

class Extra {
  Extra({
    required this.the0,
    required this.the1,
    required this.the2,
    required this.the3,
    this.the4,
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
