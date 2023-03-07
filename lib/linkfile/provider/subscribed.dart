import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:foodie_ios/linkfile/Model/getsubdetails.dart';
import 'package:foodie_ios/linkfile/Model/sendsubhistory.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:foodie_ios/linkfile/networkhandler.dart';

class subscribed extends ChangeNotifier {
  bool subscribe = false;
  bool showrollover = false;
  bool rolloverclick = false;
  bool shownewplan = false;
  int days = 0;
  int daysback = 0;
  int frequency = 0;
  bool upgradeclick = false;
  Future<void> getsubscribed() async {
    final prefs = await SharedPreferences.getInstance();
    subscribe = prefs.getBool('subscribed') ?? false;
    if (subscribe == true) {
      getsubdetails();
    }
    notifyListeners();
  }

  Future<void> getsubdetails() async {
    final pref = await SharedPreferences.getInstance();
    String email = pref.getString('email') ?? '';

    try {
      SendSubhistory send = SendSubhistory(email: email);

      var response = await networkHandler.client.post(
          networkHandler.builderUrl('/subsciption'),
          body: sendSubhistoryToJson(send),
          headers: {
            'content-Type': 'application/json; charset=UTF-8',
          });

      final data = getsubdetailsFromJson(response.body);
      final currentdate = data.currentdate;
      final date = DateTime.now();

      final expiredate = data.expiredate;
      final startdate = data.startdate;
      final newplan = data.newplan;

      int daysBetween(DateTime from, DateTime to) {
        from = DateTime(currentdate.year, currentdate.month, currentdate.day);
        to = DateTime(expiredate.year, expiredate.month, expiredate.day);
        return (to.difference(from).inHours / 24).round();
      }

      days = daysBetween(currentdate, expiredate);
      if (daysBetween(currentdate, expiredate) < 6) {
        if (newplan != true) {
          showrollover = true;
        } else {
          shownewplan = true;
        }
      }

      frequency = data.frequency;
      daysback = data.dayuse;
      print(daysback);
    } catch (e) {
      print(e);
    }
  }

  void cancel() {
    showrollover = false;
    shownewplan = false;
    notifyListeners();
  }

  void clickupgrade() {
    upgradeclick = true;
    rolloverclick = false;
    notifyListeners();
  }

  void clickrollover() {
    rolloverclick = true;
    upgradeclick = false;
    notifyListeners();
  }


}
