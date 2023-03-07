// To parse this JSON data, do
//
//     final getsubdetails = getsubdetailsFromJson(jsonString);

import 'dart:convert';

Getsubdetails getsubdetailsFromJson(String str) =>
    Getsubdetails.fromJson(json.decode(str));

String getsubdetailsToJson(Getsubdetails data) => json.encode(data.toJson());

class Getsubdetails {
  Getsubdetails({
    required this.startdate,
    required this.expiredate,
    required this.currentdate,
    required this.newplan,
    required this.frequency,
    required this.dayuse,
    
  });

  DateTime startdate;
  DateTime expiredate;
  DateTime currentdate;
  bool newplan;
  int frequency;
  int dayuse;


  factory Getsubdetails.fromJson(Map<String, dynamic> json) => Getsubdetails(
      startdate: DateTime.parse(json["startdate"]),
      expiredate: DateTime.parse(json["expiredate"]),
      currentdate: DateTime.parse(json["currentdate"]),
      newplan: json["newplan"],
      frequency: json["frequency"],
      dayuse: json['dayuse'],
     
      );
    

  Map<String, dynamic> toJson() => {
        "startdate": startdate.toIso8601String(),
        "expiredate": expiredate.toIso8601String(),
        "currentdate": currentdate.toIso8601String(),
        "newplan": newplan,
        "frequency": frequency,
        "dayuse": dayuse,
      
      };
}
