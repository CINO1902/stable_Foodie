import 'dart:convert';

import 'package:flutter_launcher_icons/logger.dart';
import 'package:foodie_ios/linkfile/Model/fetchmostcommon.dart';
import 'package:foodie_ios/linkfile/Model/getsoup.dart';
import 'package:foodie_ios/linkfile/Model/mostcommon.dart';
import 'package:foodie_ios/linkfile/Model/subcart.dart';
import 'package:foodie_ios/linkfile/Model/submitsuborder.dart';
import 'package:foodie_ios/linkfile/networkhandler.dart';
import 'package:flutter/material.dart';

import 'package:foodie_ios/linkfile/Model/Extra_fetch_model.dart';
import 'package:foodie_ios/linkfile/Model/Extra_model.dart';
import 'package:foodie_ios/linkfile/provider/addTocart.dart';
import 'package:foodie_ios/linkfile/provider/onboarding.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class getmostcommon extends ChangeNotifier {
  List<List<ItemExtra>> _items = [];
  List<Detail> subcart = [];
  List<String> swallow = [];
  List<Soup> soup = [];

  List sellectedsoup = [];
  bool _data = false;
  bool sucartdata = false;
  String _id = '';
  bool loadingdelete = false;
  bool errorsoup = false;
  bool error = false;
  List<Drink> mostcommon = [];
  List<Drink> notcommon = [];
  List<Drink> drinks = [];
  bool get data => _data;
  bool loadingsoup = false;
  int progress = 0;
  double percent = 0;
  bool loading = false;
  String id = '';
  num frequency = 0;
  DateTime? date;
  List sellected = [];
  bool emptysellect = false;
  String address = '';
  String success = '';
  String msg = '';

  bool subscribe = false;
  bool? sapacheck;
  bool? longthroatcheck;
  bool? odogwucheck;
  void getId(_id) {
    id = _id;
    notifyListeners();
  }

  Future<void> getcommon() async {
    mostcommon.clear();
    notcommon.clear();
    _data = false;
    error = false;
    final pref = await SharedPreferences.getInstance();
    String email = pref.getString('email') ?? '';
    //print(email);
    final prefs = await SharedPreferences.getInstance();
    subscribe = prefs.getBool('subscribed') ?? false;
    if (subscribe == true) {
      try {
        Fetchmostcommon fetch = Fetchmostcommon(email: email);
        var response = await networkHandler.client.post(
            networkHandler.builderUrl('/getmostcommon'),
            body: fetchmostcommonToJson(fetch),
            headers: {'content-Type': 'application/json; charset=UTF-8'});

        final decodedresponse = mostcommonFromJson(response.body);
        if (response.statusCode == 200) {
          final getr = decodedresponse.suggestfood ?? [];
          final getdrin = decodedresponse.drinks ?? [];
          sapacheck = decodedresponse.sapa;
          longthroatcheck = decodedresponse.longthroat;
          odogwucheck = decodedresponse.odogwu;
          swallow = decodedresponse.swallow;
          print(swallow);
          _data = true;
          mostcommon = getr.where((element) => element.common == true).toList();
          notcommon = getr.where((element) => element.common == false).toList();
          drinks = getdrin;

          int frequency1() {
            switch (decodedresponse.frequency) {
              case 0:
                return 1;
              case 1:
                return 2;
              case 2:
                return 3;

              default:
                return 0;
            }
          }

          date = decodedresponse.currentdate;

          int daysBetween(DateTime from, DateTime to) {
            from = DateTime(decodedresponse.date.year,
                decodedresponse.date.month, decodedresponse.date.day);
            to = DateTime(date!.year, date!.month, date!.day);
            return (to.difference(from).inHours / 24).round();
          }

          progress = daysBetween(decodedresponse.date, date!);
          percent = progress / 30;
          frequency = frequency1();
          notifyListeners();
        } else {
          print('error');
          error = true;
        }
      } catch (e) {
        print(e);
        error = true;
      } finally {}
    }
  }

  void getsellected(id) {
    sellected.clear();
    sellected.add(id);
    if (sellected.isEmpty) {
      emptysellect = false;
    } else {
      emptysellect = true;
    }
    notifyListeners();
  }

  void getsellectedsoup(id) {
    sellectedsoup.clear();
    sellectedsoup.add(id);
    emptysellectsoup();
    notifyListeners();
  }

  bool emptysellectsoup() {
    bool emptysellectsoup = true;
    if (sellectedsoup.isEmpty) {
      emptysellectsoup = true;
    } else {
      emptysellectsoup = false;
    }
    return emptysellectsoup;
  }

  void clearsellect() {
    sellected.clear();
    sellectedsoup.clear();
    if (sellected.isEmpty) {
      emptysellect = false;
    } else {
      emptysellect = true;
    }
    emptysellectsoup();
    notifyListeners();
  }

  Future<void> getsoup() async {
    loadingsoup = true;
    errorsoup = false;
    try {
      var response = await networkHandler.client.get(
          networkHandler.builderUrl('/callsoup'),
          headers: {'content-Type': 'application/json; charset=UTF-8'});

      final decodedresponse = getsoupFromJson(response.body);
      soup = decodedresponse.soup;
    } catch (e) {
      print(e);
      errorsoup = true;
    } finally {
      loadingsoup = false;
    }
    notifyListeners();
  }

  Future<void> sendsuborder() async {
    final pref = await SharedPreferences.getInstance();
    String email = pref.getString('email') ?? '';
    loading = true;
    try {
      Submitsuborder fetch =
          Submitsuborder(email: email, id: sellected[0], address: address);
      var response = await networkHandler.client.post(
          networkHandler.builderUrl('/ordersub'),
          body: submitsuborderToJson(fetch),
          headers: {'content-Type': 'application/json; charset=UTF-8'});

      final decodedresponse = response.body;
      if (response.statusCode == 200) {
        notifyListeners();
      } else {
        print('error');
      }
    } catch (e) {
      print(e);
    } finally {}
  }

  Future<void> addtosubcart(category, name, image, id) async {
    final pref = await SharedPreferences.getInstance();
    String email = pref.getString('email') ?? '';
    loading == true;
    error == false;
    try {
      Submitsuborder fetch = Submitsuborder(
          email: email,
          id: id,
          category: category,
          packagename: name,
          image: image);
      var response = await networkHandler.client.post(
          networkHandler.builderUrl('/cartsub'),
          body: submitsuborderToJson(fetch),
          headers: {'content-Type': 'application/json; charset=UTF-8'});

      final decodedresponse = jsonDecode(response.body);
      if (response.statusCode == 200) {
        success = decodedresponse['success'];
        msg = decodedresponse['msg'];
      } else {
        success = 'fail';
        msg = 'Something Went wrong';
      }
    } catch (e) {
      print(e);
      error = true;
      success = 'fail';
      msg = 'Something Went wrong';
    } finally {
      loading = false;
    }
    notifyListeners();
  }

  Future<void> getsubcart() async {
    final pref = await SharedPreferences.getInstance();
    String email = pref.getString('email') ?? '';
    loading = true;
    error = false;
    notifyListeners();
    try {
      Fetchmostcommon fetch = Fetchmostcommon(
        email: email,
      );
      print(fetch.email);
      Response response = await networkHandler.client.post(
          networkHandler.builderUrl('/getcartsub'),
          body: fetchmostcommonToJson(fetch),
          headers: {'content-Type': 'application/json; charset=UTF-8'});

      final decodedresponse = getsubcartFromJson(response.body);
      subcart = decodedresponse.details;

      sucartdata = true;
      notifyListeners();
    } catch (e) {
      print(e);
      error = true;
      success = 'fail';
      msg = 'Something Went wrong';
      notifyListeners();
    } finally {
      loading = false;
    }

    notifyListeners();
  }

  Future<void> deletesubcart(id) async {
    final pref = await SharedPreferences.getInstance();
    String email = pref.getString('email') ?? '';

    try {
      Fetchmostcommon fetch1 = Fetchmostcommon(email: email, generatedID: id);
      loadingdelete = true;
      Response response = await networkHandler.client.post(
          networkHandler.builderUrl('/deletesub'),
          body: fetchmostcommonToJson(fetch1),
          headers: {'content-Type': 'application/json; charset=UTF-8'});
      final body = jsonDecode(response.body);
      msg = body['msg'];
      success = body['success'];
      Fetchmostcommon fetch = Fetchmostcommon(
        email: email,
      );
      Response response1 = await networkHandler.client.post(
          networkHandler.builderUrl('/getcartsub'),
          body: fetchmostcommonToJson(fetch),
          headers: {'content-Type': 'application/json; charset=UTF-8'});
      final decodedresponse = getsubcartFromJson(response1.body);
      subcart = decodedresponse.details;

      sucartdata = true;
      print(success);
      notifyListeners();
    } catch (e) {
      print(e);

      success = 'fail';
      msg = 'Something Went wrong';
    } finally {
      loadingdelete = false;
    }
    notifyListeners();
  }

  void update(checkstate checkstate) {
    address = checkstate.address;
  }
}
