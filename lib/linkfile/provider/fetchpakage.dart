import 'package:flutter/material.dart';

import 'package:foodie_ios/linkfile/Model/fetchpackage.dart';
import 'package:foodie_ios/linkfile/networkhandler.dart';

class fetchprovider extends ChangeNotifier {
  List<Item> _items = [];
  List<Item> _Sapa = [];
  List<Item> _Drinks = [];
  List<Item> _longthroat = [];
  List<Item> _odogwu = [];
  bool _loading = true;

  List<Item> get item => _items;
  List<Item> get Sapa => _Sapa;
  List<Item> get drinks => _Drinks;
  List<Item> get longthroat => _longthroat;
  List<Item> get odogwu => _odogwu;
  bool get loading => _loading;

  Future<void> fetchprovide() async {
    try {
      var response = await networkHandler.client.get(
          networkHandler.builderUrl('/fetchpackage'),
          headers: {'content-Type': 'application/json; charset=UTF-8'});

      final decoderesponse = fetchPackageFromJson(response.body);

      _items = decoderesponse.item ?? [];

      _Sapa = _items.where((element) => element.category == '1').toList();
      _Drinks = _items.where((element) => element.category == '4').toList();
      _longthroat = _items.where((element) => element.category == '2').toList();

      _odogwu = _items.where((element) => element.category == '3').toList();
      _loading = false;
    
      notifyListeners();
    } catch (e) {
      print(e);
    } finally {}
    notifyListeners();
  }
}
