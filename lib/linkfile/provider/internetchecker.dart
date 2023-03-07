import 'dart:async';

import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class internetcheck extends ChangeNotifier {
  bool hasInternet = true;

  late StreamSubscription subscription;
  void getinternet() {
    getsubscription();
    hasInternet = getsubscription();
  }

  bool getsubscription() {
    StreamSubscription subscription =
        InternetConnectionChecker().onStatusChange.listen((event) {
      hasInternet = event == InternetConnectionStatus.connected;
    });
    return hasInternet;
  }
}
