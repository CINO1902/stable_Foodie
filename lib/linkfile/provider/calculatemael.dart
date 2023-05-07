import 'package:flutter/material.dart';


class calculatemeal extends ChangeNotifier {
  List clickedfood = [];
  List extrasquote = [];
  bool buynow = false;
  List sum = [];
  List Selected = [];
  List distinctList1 = [];
  List sumadd = [];
  int dupplicate = 1;
  var sumget;
  num totalvalue = 0;
  num total3 = 0;

  List<Map<String, dynamic>> sumMap = [];

  void itemclick(item, imageurl, ammount, fixedamount, id, max) {
    clickedfood.addAll([item, imageurl, ammount, fixedamount, id, max]);
  }

  void clearlist() {
    clickedfood.clear();
  }

  void addlist() {
    clickedfood.contains(clickedfood[2])
        ? clickedfood[clickedfood.indexWhere((v) => v == clickedfood[2])] =
            clickedfood[2] + clickedfood[3]
        : clickedfood;
    sum.clear();
    sumadd.clear();

    for (var i = 0; i < extrasquote.length; i++) {
      Map<int, dynamic> map = extrasquote[i].asMap();
      Map<String, dynamic> newMap = new Map<String, dynamic>(); //keys as String

      map.forEach((key, value) {
        newMap.putIfAbsent(key.toString(), () => value);
      });
      // int x = 0;
      // Map<String, dynamic> map = {for (var item in extrasquote[i]) 'x++': item};
      sum.add(newMap);
    }

    // var sumget = sum.reduce((a, b) => a + b);
    distinctList1 = sum.where((element) => element['4'] == true).toList();
    notifyListeners();
  }

  void substractlist() {
    clickedfood.contains(clickedfood[2])
        ? clickedfood[clickedfood.indexWhere((v) => v == clickedfood[2])] =
            clickedfood[2] - clickedfood[3]
        : clickedfood;
    sum.clear();
    sumadd.clear();

    for (var i = 0; i < extrasquote.length; i++) {
      Map<int, dynamic> map = extrasquote[i].asMap();
      Map<String, dynamic> newMap = new Map<String, dynamic>(); //keys as String

      map.forEach((key, value) {
        newMap.putIfAbsent(key.toString(), () => value);
      });
      // int x = 0;
      // Map<String, dynamic> map = {for (var item in extrasquote[i]) 'x++': item};
      sum.add(newMap);
    }

    // var sumget = sum.reduce((a, b) => a + b);
    distinctList1 = sum.where((element) => element['4'] == true).toList();
    notifyListeners();
  }

  void getselected(collectsellectr) {
    Selected = collectsellectr;

    sum.clear();
    sumadd.clear();

    for (var i = 0; i < extrasquote.length; i++) {
      Map<int, dynamic> map = extrasquote[i].asMap();
      Map<String, dynamic> newMap = new Map<String, dynamic>();
      map.forEach((key, value) {
        newMap.putIfAbsent(key.toString(), () => value);
      });

      sum.add(newMap);
    }
    distinctList1 = sum.where((element) => element['4'] == true).toList();
    notifyListeners();
  }

  void getExtras(extraq) {
    extrasquote = extraq;
  }

  void addduplicate() {
    dupplicate = dupplicate + 1;
    notifyListeners();
  }

  void substractdupplicate() {
    dupplicate = dupplicate - 1;
    notifyListeners();
  }

  num total() {
    sum.clear();
    sumadd.clear();

    for (var i = 0; i < extrasquote.length; i++) {
      Map<int, dynamic> map = extrasquote[i].asMap();
      Map<String, dynamic> newMap = new Map<String, dynamic>(); //keys as String

      map.forEach((key, value) {
        newMap.putIfAbsent(key.toString(), () => value);
      });
      // int x = 0;
      // Map<String, dynamic> map = {for (var item in extrasquote[i]) 'x++': item};
      sum.add(newMap);
    }

    // var sumget = sum.reduce((a, b) => a + b);
    distinctList1 = sum.where((element) => element['4'] == true).toList();

    for (var i = 0; i < distinctList1.length; i++) {
      sumadd.add(distinctList1[i]['1']);
    }
    if (sumadd.isNotEmpty) {
      sumget = sumadd.reduce((a, b) => a + b);
    } else {
      sumget = 0;
    }
    if (clickedfood.isEmpty) {
      return 0;
    } else {
      // print(dupplicate * (sumget + clickedfood[2]));
      return dupplicate * (sumget + clickedfood[2]);
    }
  }

  void total2() {
    sum.clear();
    sumadd.clear();

    for (var i = 0; i < extrasquote.length; i++) {
      Map<int, dynamic> map = extrasquote[i].asMap();
      Map<String, dynamic> newMap = new Map<String, dynamic>(); //keys as String

      map.forEach((key, value) {
        newMap.putIfAbsent(key.toString(), () => value);
      });
      // int x = 0;
      // Map<String, dynamic> map = {for (var item in extrasquote[i]) 'x++': item};
      sum.add(newMap);
    }

    distinctList1 = sum.where((element) => element['4'] == true).toList();

    for (var i = 0; i < distinctList1.length; i++) {
      sumadd.add(distinctList1[i]['1']);
    }
    if (sumadd.isNotEmpty) {
      sumget = sumadd.reduce((a, b) => a + b);
    } else {
      sumget = 0;
    }
    if (clickedfood.isEmpty) {
      total3 = 0;
    } else {
      total3 = dupplicate * (sumget + clickedfood[2]);
    }
    notifyListeners();
  }

  List<Map<String, dynamic>> total1() {
    sum.clear();
    sumadd.clear();

    sumMap.clear();

    for (var i = 0; i < extrasquote.length; i++) {
      Map<int, dynamic> map = extrasquote[i].asMap();
      Map<String, dynamic> newMap = new Map<String, dynamic>(); //keys as String

      map.forEach((key, value) {
        newMap.putIfAbsent(key.toString(), () => value);
      });
      // int x = 0;
      // Map<String, dynamic> map = {for (var item in extrasquote[i]) 'x++': item};
      sum.add(newMap);
    }

    distinctList1 = sum.where((element) => element['4'] == true).toList();
    for (var i = 0; i < distinctList1.length; i++) {
      sumMap.add(distinctList1[i]);
    }

    return sumMap;
  }

  num foodtotal() {
    sum.clear();
    sumadd.clear();

    for (var i = 0; i < extrasquote.length; i++) {
      Map<int, dynamic> map = extrasquote[i].asMap();
      Map<String, dynamic> newMap = new Map<String, dynamic>(); //keys as String

      map.forEach((key, value) {
        newMap.putIfAbsent(key.toString(), () => value);
      });
      // int x = 0;
      // Map<String, dynamic> map = {for (var item in extrasquote[i]) 'x++': item};
      sum.add(newMap);
    }
    distinctList1 = sum.where((element) => element['4'] == true).toList();
    //print(distinctList1);
    for (var i = 0; i < distinctList1.length; i++) {
      sumadd.add(distinctList1[i]['1']);
    }
    if (sumadd.isNotEmpty) {
      sumget = sumadd.reduce((a, b) => a + b);
    } else {
      sumget = 0;
    }

    return sumget + clickedfood[2];
  }

  void reset() {
    sum.clear();
    sumadd.clear();

    clickedfood.contains(clickedfood[2])
        ? clickedfood[clickedfood.indexWhere((v) => v == clickedfood[2])] =
            clickedfood[3]
        : clickedfood;
    for (var i = 0; i < extrasquote.length; i++) {
      final extraquoteindex = extrasquote[i];
      extraquoteindex.contains(extraquoteindex[4])
          ? extraquoteindex[extraquoteindex
              .indexWhere((v) => v == extraquoteindex[4])] = false
          : extraquoteindex;
    }

    notifyListeners();
  }
}
