import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Themeprovider extends ChangeNotifier {
  String _theme = "system";
  String get theme => _theme;
  int group = 3;

  bool togg = true;

  ThemeMode getTheme() {
    switch (_theme) {
      case "light":
        return ThemeMode.light;
      case "dark":
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  Themeprovider() {
    _loadFromPrefs();
  }

  _loadFromPrefs() async {
    final pref = await SharedPreferences.getInstance();
    togg = pref.getBool('togg') ?? true;
    group = pref.getInt('group') ?? 3;
    _theme = pref.getString('theme') ?? 'system';
    notifyListeners();
  }

  _saveToPrefs() async {
    final _pref = await SharedPreferences.getInstance();
    _pref.setBool('togg', togg);
    _pref.setInt('group', group);
    _pref.setString('theme', _theme);
  }

  changetheme(value1) {
    group = value1;
    togg = false;
    if (group == 1) {
      _theme = 'light';
    } else if (group == 2) {
      _theme = 'dark';
    }
    _saveToPrefs();
    notifyListeners();
  }

  changetogg(togg1) {
    togg = togg1;
    checktogg();

    notifyListeners();
  }

  checktogg() {
    if (togg == true) {
      _theme = 'system';
      group = 3;
    }
    _saveToPrefs();
    notifyListeners();
  }
}

class myTheme {
  static final darktheme = ThemeData(
      scaffoldBackgroundColor: const Color.fromARGB(255, 54, 54, 54),
      primaryColor: Colors.red,
      primaryColorLight: Colors.black,
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: Colors.red,
        selectionColor: Colors.red,
      ),
      iconTheme: IconThemeData(
        color: Colors.red,
      ),
      appBarTheme: AppBarTheme(
          backgroundColor: Colors.black,
          systemOverlayStyle: SystemUiOverlayStyle(
              statusBarBrightness: Brightness.dark,
              systemNavigationBarColor: Colors.black)),
      primaryColorDark: Colors.white,
      colorScheme: const ColorScheme.dark(
        onBackground: Color.fromARGB(255, 229, 229, 229),
        onTertiary: Color.fromARGB(255, 231, 231, 231),
        onInverseSurface: Color.fromARGB(255, 199, 199, 199),
        primaryContainer: Color.fromARGB(255, 28, 28, 28),
      ));

  static final lighttheme = ThemeData(
      scaffoldBackgroundColor: const Color.fromARGB(255, 224, 224, 224),
      primaryColor: Colors.red,
      iconTheme: IconThemeData(
        color: Colors.red,
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: Colors.red,
        selectionColor: Colors.red,
      ),
      primaryColorLight: Colors.white,
      appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarBrightness: Brightness.light,
          )),
      primaryColorDark: Colors.black,
      colorScheme: const ColorScheme.light(
        onBackground: Color.fromARGB(255, 114, 114, 114),
        onInverseSurface: Color.fromARGB(255, 224, 224, 224),
        onTertiary: Color.fromARGB(255, 255, 255, 255),
        primaryContainer: Colors.white,
      ));
}
