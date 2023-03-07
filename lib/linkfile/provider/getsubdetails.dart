import 'package:flutter/material.dart';

class getsubdetail extends ChangeNotifier {
  String _frequency = '';
  List _food = [];
  List _foodindex = [];
  bool oneday = false;
  bool twoday = false;
  bool threeday = false;
  List join = ['first', 'second', 'third'];

  String get frequency => _frequency;
  List get food => _food;
  List get foodindex => _foodindex;

  void getdetails(_freqency, _food, _foodindex) {
    _frequency = _freqency;
    _food = _food;
    _foodindex = _foodindex;
    boolcheck();

    notifyListeners();
  }

  void boolcheck() {
    if (int.parse(_frequency) < 1) {
      oneday = true;
      twoday = false;
      threeday = false;
    } else if (int.parse(_frequency) < 2) {
      twoday = true;
      oneday = false;
      threeday = false;
    } else if (int.parse(_frequency) < 3) {
      twoday = false;
      oneday = false;
      threeday = true;
    }
    notifyListeners();
  }
}
