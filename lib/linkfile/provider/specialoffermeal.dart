import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:foodie_ios/linkfile/Model/extra_specialoffer.dart';
import 'package:foodie_ios/linkfile/Model/send_offer.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

class meal_calculate extends ChangeNotifier {
  List item_clicked = [];
  bool loading_extra = false;
  List sidecollect = [];
  bool sendload = false;
  bool available1 = false;
  List drinkcollect = [];
  List foodcollect = [];
  int remains = 0;
  String report = '';
  String status = '';
  List<Map<String, dynamic>> mapside = [];
  List<Map<String, dynamic>> mapdrink = [];
  List<Map<String, dynamic>> mapfood = [];
  List<Drink> side = [];
  List<Drink> drink = [];
  List<Drink> food = [];

  void itemclick(name, image, desc, time, value, side, food, drink, extra,
      foodtras, drinktras, id, available, remaingamount, seg) {
    item_clicked.addAll([
      name,
      image,
      desc,
      time,
      value,
      1,
      side,
      food,
      drink,
      extra,
      foodtras,
      drinktras,
      id,
      seg
    ]);
    print(extra);
    available1 = available;
    remains = remaingamount;
    //print(item_clicked[11][0]);
  }

  addside(id, name) {
    sidecollect.add([id, name]);
    mapside.clear();
    for (var i = 0; i < sidecollect.length; i++) {
      Map<int, dynamic> map = sidecollect[i].asMap();
      Map<String, dynamic> newMap = new Map<String, dynamic>(); //keys as String

      map.forEach((key, value) {
        newMap.putIfAbsent(key.toString(), () => value);
      });

      mapside.add(newMap);
    }

    notifyListeners();
  }

  adddrink(id, name) {
    drinkcollect.add([id, name]);
    mapdrink.clear();
    for (var i = 0; i < drinkcollect.length; i++) {
      Map<int, dynamic> map = drinkcollect[i].asMap();
      Map<String, dynamic> newMap = new Map<String, dynamic>(); //keys as String

      map.forEach((key, value) {
        newMap.putIfAbsent(key.toString(), () => value);
      });

      mapdrink.add(newMap);
    }
    notifyListeners();
  }

  addfood(id, name) {
    foodcollect.add([id, name]);
    mapfood.clear();
    for (var i = 0; i < foodcollect.length; i++) {
      Map<int, dynamic> map = foodcollect[i].asMap();
      Map<String, dynamic> newMap = new Map<String, dynamic>(); //keys as String

      map.forEach((key, value) {
        newMap.putIfAbsent(key.toString(), () => value);
      });

      mapfood.add(newMap);
    }
    notifyListeners();
  }

  removeside(index) {
    sidecollect.removeAt(index);
    mapside.clear();
    for (var i = 0; i < sidecollect.length; i++) {
      Map<int, dynamic> map = sidecollect[i].asMap();
      Map<String, dynamic> newMap = new Map<String, dynamic>(); //keys as String

      map.forEach((key, value) {
        newMap.putIfAbsent(key.toString(), () => value);
      });

      mapside.add(newMap);
    }
    notifyListeners();
  }

  removedrink(index) {
    drinkcollect.removeAt(index);
    mapdrink.clear();
    for (var i = 0; i < drinkcollect.length; i++) {
      Map<int, dynamic> map = drinkcollect[i].asMap();
      Map<String, dynamic> newMap = new Map<String, dynamic>(); //keys as String

      map.forEach((key, value) {
        newMap.putIfAbsent(key.toString(), () => value);
      });

      mapdrink.add(newMap);
    }
    notifyListeners();
  }

  removefood(index) {
    foodcollect.removeAt(index);
    mapfood.clear();
    for (var i = 0; i < foodcollect.length; i++) {
      Map<int, dynamic> map = foodcollect[i].asMap();
      Map<String, dynamic> newMap = new Map<String, dynamic>(); //keys as String

      map.forEach((key, value) {
        newMap.putIfAbsent(key.toString(), () => value);
      });

      mapfood.add(newMap);
    }
    notifyListeners();
  }

  clearclick() {
    item_clicked.clear();
    sidecollect.clear();
    foodcollect.clear();
    mapdrink.clear();
    mapfood.clear();
    mapside.clear();
    drinkcollect.clear();
  }

  addlist() {
    item_clicked.contains(item_clicked[5])
        ? item_clicked[item_clicked.indexWhere((v) => v == item_clicked[5])] =
            item_clicked[5] + 1
        : item_clicked;
    notifyListeners();
  }

  removelist() {
    if (item_clicked[5] != 1) {
      item_clicked.contains(item_clicked[5])
          ? item_clicked[item_clicked.indexWhere((v) => v == item_clicked[5])] =
              item_clicked[5] - 1
          : item_clicked;
    }
    notifyListeners();
  }

  CancelToken cancelToken1 = CancelToken();
  Future<void> extracall() async {
    String seg = item_clicked[13];

    loading_extra = true;
    cancelToken1 = CancelToken();
    try {
      final dio = Dio();
      var response = await dio.post(
          'https://foodie1902.herokuapp.com/route/call_extra_offer',
          data: jsonEncode(<String, String>{'seg': seg}),
          options: Options(
              headers: {'content-Type': 'application/json; charset=UTF-8'}),
          cancelToken: cancelToken1);
      var msg = extraSpecialofferFromJson(response.toString());

      side = msg.side
          .where((element) =>
              element.availability == true || element.remaining == true)
          .toList();
      drink = msg.drink
          .where((element) =>
              element.availability == true || element.remaining == true)
          .toList();

      food = msg.food
          .where((element) =>
              element.availability == true || element.remaining == true)
          .toList();
    } catch (e) {
      print(e);
    } finally {
      loading_extra = false;
    }
    notifyListeners();
  }

  CancelToken cancelToken = CancelToken();
  Future<void> sendtocart() async {
    final prefs = await SharedPreferences.getInstance();

    sendload = true;
    String? token1 = prefs.getString("tokenregistered");
    String getid() {
      String id = '';
      if (token1 == null) {
        final intid = prefs.getInt('ID') ?? 0;
        id = intid.toString();
      } else {
        id = prefs.getString("email") ?? '';
      }
      return id;
    }

    cancelToken = CancelToken();
    SendextraSpecialoffer send = SendextraSpecialoffer(
        id: getid(),
        specialName: item_clicked[0],
        specialNameId: item_clicked[12].toString(),
        multiple: item_clicked[5],
        amount: item_clicked[4] * item_clicked[5],
        image: item_clicked[1],
        foods: mapfood,
        drinks: mapdrink,
        version: 2,
        sides: mapside);

    notifyListeners();

    try {
      final dio = Dio();
      var response = await dio.post(
          'https://foodie1902.herokuapp.com/route/addTocart_offer',
          data: sendextraSpecialofferToJson(send),
          options: Options(
              headers: {'content-Type': 'application/json; charset=UTF-8'}),
          cancelToken: cancelToken);
      var msg = jsonDecode(response.toString());
      status = msg["status"];
      report = msg["msg"];
      print(msg);
    } catch (e) {
      print(e);
    } finally {
      sidecollect.clear();
      foodcollect.clear();
      mapdrink.clear();
      mapfood.clear();
      mapside.clear();
      drinkcollect.clear();
      sendload = false;
    }
    notifyListeners();
  }

  cancelresquest() {
    cancelToken.cancel();
    cancelToken1.cancel();
  }
}
