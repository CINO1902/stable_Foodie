// To parse this JSON data, do
//
//     final getsubhistory = getsubhistoryFromJson(jsonString);

import 'dart:convert';

Getsubhistory getsubhistoryFromJson(String str) =>
    Getsubhistory.fromJson(json.decode(str));

String getsubhistoryToJson(Getsubhistory data) => json.encode(data.toJson());

class Getsubhistory {
  Getsubhistory(
      {required this.status,
      this.result,
      required this.date,
      required this.rollover,
      required this.totalordered});

  String status;
  Result? result;
  DateTime date;
  int rollover;
  int totalordered;

  factory Getsubhistory.fromJson(Map<String, dynamic> json) => Getsubhistory(
        status: json["status"],
        result: Result.fromJson(json["result"]),
        date: DateTime.parse(json["date"]),
        rollover: json["rollover"],
        totalordered: json['totalordered'],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "result": result!.toJson(),
        "date": date.toIso8601String(),
        "rollover": rollover,
        "totalordered": totalordered
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
  Pagnited(
      {required this.id,
      required this.email,
      required this.pagnitedId,
      this.order,
      this.address,
      required this.generatedid,
      this.ordernum,
      required this.category,
      this.packagename,
      this.status,
      required this.image,
      required this.day,
      required this.month,
      required this.year,
      required this.date,
      required this.v,
      required this.expire,
      required this.createdAt,
      this.name,
      this.number,
      this.location});

  String id;
  String email;
  String pagnitedId;
  bool? order;
  String? address;
  String generatedid;
  String? ordernum;
  String category;
  String? packagename;
  String? status;
  String image;
  String day;
  String month;
  String year;
  DateTime date;
  int v;
  DateTime expire;
  DateTime createdAt;
  String? name;
  String? number;

  String? location;

  factory Pagnited.fromJson(Map<String, dynamic> json) => Pagnited(
        id: json["_id"],
        email: json["email"],
        pagnitedId: json["id"],
        order: json['order'],
        address: json["address"],
        generatedid: json["generatedid"],
        ordernum: json["ordernum"],
        category: json["category"],
        packagename: json["packagename"],
        status: json["status"],
        image: json["image"],
        day: json["day"],
        month: json["month"],
        year: json["year"],
        date: DateTime.parse(json["date"]),
        v: json["__v"],
        expire: DateTime.parse(json["expire"]),
        createdAt: DateTime.parse(json["createdAt"]),
        name: json["name"],
        number: json["phone"],
        location: json["location"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "email": email,
        "id": pagnitedId,
        "address": address,
        "order": order,
        "generatedid": generatedid,
        "ordernum": ordernum,
        "category": category,
        "packagename": packagename,
        "status": status,
        "image": image,
        "day": day,
        "month": month,
        "year": year,
        "date": date.toIso8601String(),
        "__v": v,
        "expire": expire.toIso8601String(),
        "createdAt": createdAt.toIso8601String(),
        "name": name,
        "phone": number,
        "location": location,
      };
}
