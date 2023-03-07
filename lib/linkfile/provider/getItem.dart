import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:foodie_ios/linkfile/Model/getItem_model.dart';
import 'package:foodie_ios/linkfile/networkhandler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class getiItem extends ChangeNotifier {
  List<Item> _items = [];
  bool error = false;
  bool _data = false;
  int ID = 0;

  bool get data => _data;
  List<Item> get items => _items;
  Future<void> getItem() async {
    try {
      error = false;
      _items.clear();
      _data = false;
      var response = await networkHandler.client
          .get(networkHandler.builderUrl('/getItems'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      });

      final decodedresponse = getItemFromJson(response.body);
      _items = decodedresponse.item ?? [];

      _data = true;

      notifyListeners();
    } catch (e) {
      error = true;
      print(e);
    } finally {}
    notifyListeners();
  }
}
