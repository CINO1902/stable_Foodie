import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:foodie_ios/linkfile/Model/confrimmodel.dart';
import 'package:foodie_ios/linkfile/provider/checkcart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:foodie_ios/linkfile/networkhandler.dart';

class confirmcart extends ChangeNotifier {
  bool loading = false;
  String success = '';
  int amount = 0;
  String name1 = '';
  String number1 = '';
  String address1 = '';
  String code = '';
  String location1 = '';
  bool verified = false;
  bool error = false;
  double discount = 0.0;
  Future<void> checkcarts(amount, ref) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    String? token1 = prefs.getString("tokenregistered");

    String getmail() {
      String emailsent = '';
      if (token1 == null) {
        emailsent = prefs.getString('notloggedemail') ?? '';
      } else {
        emailsent = prefs.getString("email") ?? '';
      }
      return emailsent;
    }

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

    print(verified);
    String setcoupon() {
      String id = '';
      if (verified == false) {
        id = '';
      } else {
        id = code;
      }
      return id;
    }

    try {
      loading = true;
      error = false;
      Confirmmodel confirmmodel = Confirmmodel(
          email: getmail(),
          id: getid(),
          verified: verified,
          amount: amount,
          name: name1,
          number: number1,
          address: address1,
          code: setcoupon(),
          location: location1,
          ref: ref);
      var response = await networkHandler.client.post(
          networkHandler.builderUrl('/confirmorder'),
          body: confirmmodelToJson(confirmmodel),
          headers: {
            'content-Type': 'application/json; charset=UTF-8',
            'authorization': 'Bearer $token'
          });

      final data = jsonDecode(response.body);
      success = data['status'];
      print(success);
      notifyListeners();
    } catch (e) {
      print(e);
      error = true;
    } finally {
      loading = false;
    }
    notifyListeners();
  }

  collect(name, number, address, location) {
    name1 = name;
    number1 = number;
    address1 = address;
    location1 = location;
    //notifyListeners();
  }

  void update(checkcart checkcat) {
    verified = checkcat.verified;
    discount = checkcat.moneytopay;
    code = checkcat.coupon;
  }
}
