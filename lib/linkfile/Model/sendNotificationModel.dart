// To parse this JSON data, do
//
//     final sendnotification = sendnotificationFromJson(jsonString);

import 'dart:convert';

Sendnotification sendnotificationFromJson(String str) =>
    Sendnotification.fromJson(json.decode(str));

String sendnotificationToJson(Sendnotification data) =>
    json.encode(data.toJson());

class Sendnotification {
  Sendnotification({
    required this.status,
    required this.notific,
  });

  String status;
  Notific notific;

  factory Sendnotification.fromJson(Map<String, dynamic> json) =>
      Sendnotification(
        status: json["status"],
        notific: Notific.fromJson(json["notific"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "notific": notific.toJson(),
      };
}

class Notific {
  Notific({
    this.pagnitednotify,
    required this.next,
    required this.previous,
  });

  List<Pagnitednotify>? pagnitednotify;
  Next next;
  Next previous;

  factory Notific.fromJson(Map<String, dynamic> json) => Notific(
        pagnitednotify: List<Pagnitednotify>.from(
            json["pagnitednotify"].map((x) => Pagnitednotify.fromJson(x))),
        next: Next.fromJson(json["next"]),
        previous: Next.fromJson(json["previous"]),
      );

  Map<String, dynamic> toJson() => {
        "pagnitednotify":
            List<dynamic>.from(pagnitednotify!.map((x) => x.toJson())),
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

class Pagnitednotify {
  Pagnitednotify(
      {required this.id,
      required this.pagnitednotifyId,
      required this.notificationType,
      this.discount,
      this.coupon,
      required this.date,
      required this.v,
      this.ordernum,
      this.paymentAmount,
      this.amountDaily,
      this.amountweekly});

  String id;
  String pagnitednotifyId;
  int notificationType;
  String? discount;
  String? coupon;
  DateTime date;
  int v;
  String? ordernum;
  String? paymentAmount;
  String? amountDaily;
  String? amountweekly;

  factory Pagnitednotify.fromJson(Map<String, dynamic> json) => Pagnitednotify(
      id: json["_id"],
      pagnitednotifyId: json["id"],
      notificationType: json["notification_type"],
      discount: json["discount"],
      coupon: json["coupon"],
      date: DateTime.parse(json["date"]),
      v: json["__v"],
      ordernum: json["ordernum"],
      paymentAmount: json["payment_amount"],
      amountDaily: json["amount_daily"],
      amountweekly: json["amount_weekly"]);

  Map<String, dynamic> toJson() => {
        "_id": id,
        "id": pagnitednotifyId,
        "notification_type": notificationType,
        "discount": discount,
        "coupon": coupon,
        "date": date.toIso8601String(),
        "__v": v,
        "ordernum": ordernum,
        "payment_amount": paymentAmount,
        "amount_daily": amountDaily,
        "amount_weekly": amountweekly
      };
}
