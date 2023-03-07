import 'package:flutter/material.dart';

class checkme extends ChangeNotifier {
  bool _value = false;

  bool get value => _value;
  void action(isChecked) {
    _value = isChecked;
    notifyListeners();
  }
}
