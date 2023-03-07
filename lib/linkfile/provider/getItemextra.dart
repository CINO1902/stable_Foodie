import 'package:foodie_ios/linkfile/networkhandler.dart';
import 'package:flutter/material.dart';

import 'package:foodie_ios/linkfile/Model/Extra_fetch_model.dart';
import 'package:foodie_ios/linkfile/Model/Extra_model.dart';
import 'package:foodie_ios/linkfile/provider/addTocart.dart';

class getiItemExtra extends ChangeNotifier {
  List<List<ItemExtra>> _items = [];
  List<List<ItemExtra>> souplist = [];
  bool _data = false;
  List<String> soupid = [];
  String _id = '';
  List<List<dynamic>> itemsquote = [];
  List soupadded = [];
  bool error = false;
  List foodquote = [];
  bool loading = false;
  bool get data => _data;
  String id = '';
  List<List<ItemExtra>> get items => _items;

  void getId(_id) {
    id = _id;
    notifyListeners();
  }

  void addsoup(id) {
    soupadded.clear();
    soupadded.add(id);
    checkempty();
  }

  bool checkempty() {
    bool checksoupempty = true;
    if (soupadded.isEmpty) {
      checksoupempty = true;
    } else {
      checksoupempty = false;
    }
    return checksoupempty;
  }

  Future<void> getItemExtra(id) async {
    try {
      error = false;
      _data = false;
      loading = true;
      _items.clear();
      soupid.clear();
      souplist.clear();

      ExtrasModelFetch fetch = ExtrasModelFetch(id: id);
      var response = await networkHandler.client.post(
          networkHandler.builderUrl('/getItemsExtra'),
          body: extrasModelFetchToJson(fetch),
          headers: {'content-Type': 'application/json; charset=UTF-8'});

      final decodedresponse = extrasModelFromJson(response.body);
      if (response.statusCode == 200) {
        _items = decodedresponse.itemExtra ?? [];

        _data = true;
        _items = _items
            .where((element) =>
                element[0].availability == true || element[0].remaining == true)
            .toList();
        for (var i = 0; i < _items.length; i++) {
          var productMap = [
            items[i][0].itemExtraId,
            int.parse(items[i][0].mincost),
            1,
            int.parse(items[i][0].mincost),
            false,
            items[i][0].item,
            items[i][0].maxspoon
          ];

          itemsquote.add(productMap);
        }
        souplist =
            _items.where((element) => element[0].segment == 'soup').toList();
        for (var i = 0; i < souplist.length; i++) {
          soupid.add(souplist[i][0].itemExtraId);
        }
      
      } else {
        error = true;
        print('error');
      }
    } catch (e) {
      print(e);
      error = true;
    } finally {
      loading = false;
    }
    notifyListeners();
  }
}
