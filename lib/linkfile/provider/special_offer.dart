import 'package:flutter/material.dart';
import 'package:foodie_ios/linkfile/Model/special_offer.dart';
import 'package:foodie_ios/linkfile/networkhandler.dart';

class special_offer extends ChangeNotifier {
  List<Msg> data = [];
  bool loading = false;
  bool error = false;
  Future<void> calloffer() async {
    loading = true;
    error = false;
    try {
      var response = await networkHandler.client.post(
          networkHandler.builderUrl('/call_offer'),
          headers: {'content-Type': 'application/json; charset=UTF-8'});

      final value = specialofferFromJson(response.body);
      data = value.msg;

      notifyListeners();
    } catch (e) {
      print(e);
      error = true;
    } finally {
      loading = false;
    }
    notifyListeners();
  }
}
