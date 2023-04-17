import 'package:foodie_ios/linkfile/networkhandler.dart';
import 'package:flutter/material.dart';

import 'package:foodie_ios/linkfile/Model/Extra_fetch_model.dart';
import 'package:foodie_ios/linkfile/Model/Extra_model.dart';
import 'package:foodie_ios/linkfile/provider/addTocart.dart';
import 'package:dio/dio.dart';

class getiItemExtra extends ChangeNotifier {
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
  List<List<ItemExtra>> items = [];

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

  CancelToken cancelToken = CancelToken();
  Future<void> getItemExtra(id) async {
    cancelToken = CancelToken();

    try {
      error = false;
      _data = false;
      loading = true;
      items.clear();
      soupid.clear();
      souplist.clear();
      itemsquote.clear();
      final dio = Dio();
      notifyListeners();
      ExtrasModelFetch fetch = ExtrasModelFetch(id: id);
      var response = await dio.post(
          'https://foodie1902.herokuapp.com/route/getItemsExtra',
          data: extrasModelFetchToJson(fetch),
          options: Options(
              headers: {'content-Type': 'application/json; charset=UTF-8'}),
          cancelToken: cancelToken);
      final decodedresponse = extrasModelFromJson(response.toString());
      if (response.statusCode == 200) {
        items = decodedresponse.itemExtra ?? [];

        _data = true;
        items = items
            .where((element) =>
                element[0].availability == true || element[0].remaining == true)
            .toList();
        for (var i = 0; i < items.length; i++) {
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
            items.where((element) => element[0].segment == 'soup').toList();
        for (var i = 0; i < souplist.length; i++) {
          soupid.add(souplist[i][0].itemExtraId);
        }
        print(items[0][0].item);
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

  cancelresquest() {
    cancelToken.cancel();
  }
}
