import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:foodie_ios/linkfile/networkhandler.dart';

class greetings extends ChangeNotifier {
  String getTime = DateTime.now().toString();
  String _greeting = 'hvdfv';
  DateTime time = DateTime.now();
  String greetingss = '';

  String get greeting => _greeting;
  //String strTime = getTime.toString();

  void gettime() {
    var time1 = time.toString().split(' ')[1];
    var hour = time1.split(':')[0];
    var minute = time1.split(':')[1];

    var inthour = int.parse(hour);

    if (inthour >= 0 && inthour <= 11) {
      _greeting = 'Good Morning';
    } else if (inthour >= 12 && inthour <= 15) {
      _greeting = 'Good Afternoon';
    } else if (inthour >= 16 && inthour <= 20) {
      _greeting = 'Good Evening';
    } else {
      _greeting = 'Good Night';
    }

    greetingss = _greeting;
  }

  Future<void> gettim() async {
    try {
      var response = await networkHandler.client.post(
          networkHandler.builderUrl('/gettime'),
          headers: {'content-Type': 'application/json; charset=UTF-8'});
      final time1 = jsonDecode(response.body);
      time = DateTime.parse(time1["date"]);
      print(time);
      gettime();
    } catch (e) {}

    notifyListeners();
  }
}
