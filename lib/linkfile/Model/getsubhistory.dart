// To parse this JSON data, do
//
//     final getsubhistory = getsubhistoryFromJson(jsonString);

import 'dart:convert';

Getsubhistory getsubhistoryFromJson(String str) => Getsubhistory.fromJson(json.decode(str));

String getsubhistoryToJson(Getsubhistory data) => json.encode(data.toJson());

class Getsubhistory {
    Getsubhistory({
        required this.status,
        required this.result,
        required this.date,
        required this.rollover,
        required this.totalordered,
    });

    String status;
    Result result;
    DateTime date;
    int rollover;
    int totalordered;

    factory Getsubhistory.fromJson(Map<String, dynamic> json) => Getsubhistory(
        status: json["status"],
        result: Result.fromJson(json["result"]),
        date: DateTime.parse(json["date"]),
        rollover: json["rollover"],
        totalordered: json["totalordered"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "result": result.toJson(),
        "date": date.toIso8601String(),
        "rollover": rollover,
        "totalordered": totalordered,
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
        pagnited: List<Pagnited>.from(json["pagnited"].map((x) => Pagnited.fromJson(x))),
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
        required this.email,
        required this.pagnitedId,
        this.order,
        required this.generatedid,
        required this.category,
        required this.packagename,
        required this.status,
        required this.image,
        required this.day,
        required this.month,
        required this.year,
        required this.date,
        required this.createdAt,
        required this.expire,
        required this.v,
        this.address,
        this.location,
        this.name,
        this.ordernum,
        this.phone,
    });

    String id;
    String email;
    String pagnitedId;
    bool? order;
    String generatedid;
    String category;
    String packagename;
    int status;
    String image;
    String day;
    String month;
    String year;
    DateTime date;
    DateTime createdAt;
    DateTime expire;
    int v;
    String? address;
    String? location;
    String? name;
    String? ordernum;
    String? phone;

    factory Pagnited.fromJson(Map<String, dynamic> json) => Pagnited(
        id: json["_id"],
        email: json["email"],
        pagnitedId: json["id"],
        order: json["order"],
        generatedid: json["generatedid"],
        category: json["category"],
        packagename: json["packagename"],
        status: json["status"],
        image: json["image"],
        day: json["day"],
        month: json["month"],
        year: json["year"],
        date: DateTime.parse(json["date"]),
        createdAt: DateTime.parse(json["createdAt"]),
        expire: DateTime.parse(json["expire"]),
        v: json["__v"],
        address: json["address"],
        location: json["location"],
        name: json["name"],
        ordernum: json["ordernum"],
        phone: json["phone"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "email": email,
        "id": pagnitedId,
        "order": order,
        "generatedid": generatedid,
        "category": category,
        "packagename": packagename,
        "status": status,
        "image": image,
        "day": day,
        "month": month,
        "year": year,
        "date": date.toIso8601String(),
        "createdAt": createdAt.toIso8601String(),
        "expire": expire.toIso8601String(),
        "__v": v,
        "address": address,
        "location": location,
        "name": name,
        "ordernum": ordernum,
        "phone": phone,
    };
}

