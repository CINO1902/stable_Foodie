import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:foodie_ios/linkfile/Model/changeaddress.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:foodie_ios/linkfile/networkhandler.dart';

class checkstate with ChangeNotifier {
  bool _value = true;
  int ID = 0;
  bool get value => _value;
  String email = '';
  String? tokenregistered;
  String firstname = '';
  bool verified = false;
  String lastname = '';
  String referal = '';
  String address = '';
  int numberrefer = 0;
  String phone = '';
  String location = '';
  String? token;
  String? token1;
  bool success = false;
  String msg = '';
  String notloggedaddress = '';
  String notloggedemail = '';
  String notloggednumber = '';
  String notloggedname = '';
  String? notloggedlocation;
  bool logoutout = true;

  checkstate() {
    _loadfrompref();
    getID();
    notifyListeners();
  }

  _loadfrompref() async {
    final _pref = await SharedPreferences.getInstance();
    _value = _pref.getBool('showhomeprovider') ?? true;
    token = _pref.getString('token') ?? '';
    notifyListeners();
  }

  gethome(token) async {
    final _pref = await SharedPreferences.getInstance();
    token = _pref.setString('token', token);
    _value = false;

    _savetopref();
    notifyListeners();
  }

  _savetopref() async {
    final _pref = await SharedPreferences.getInstance();

    _pref.setBool('showhomeprovider', _value);
  }

  Future<void> getID() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token");
    if (token != null) {
      try {
        final response = await networkHandler.client
            .get(networkHandler.builderUrl('/fetchid'), headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'authorization': 'Bearer $token'
        });

        var data = jsonDecode(response.body);

        ID = data['msg']['ID'];

        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt("ID", ID);
      } catch (e) {
        print(e);
      } finally {
        if (tokenregistered == null) {
          getToken();
        }
      }
    }
    notifyListeners();
  }

  void getToken() async {
    await FirebaseMessaging.instance.getToken().then((token) {
      print(token);
      // getD();
      sendtoken(token);
      savetoken(token);
    });
  }

  String getD() {
    String token = '';
    if (tokenregistered == null) {
      token = ID.toString();
    } else {
      token = email;
    }
    print(email);
    return token;
  }

  void savetoken(String? token) async {
    await FirebaseFirestore.instance.collection("user token").doc(getD()).set({
      'token': token,
    });
  }

  Future<void> getregisterdID() async {
    final prefs = await SharedPreferences.getInstance();
    token1 = prefs.getString("tokenregistered");
    tokenregistered = token1;

    checkregisteredlogg();
    if (token1 != null) {
      try {
        final response = await networkHandler.client
            .get(networkHandler.builderUrl('/fetchidresgitered'), headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'authorization': 'Bearer $token1'
        });

        final data = jsonDecode(response.body);

        email = data['email'];

        firstname = data['firstname'];
        lastname = data['lastname'];
        verified = data['verified'];
        referal = data['referal'];
        address = data['address'];
        phone = data['phone'];
        location = data['location'];
        numberrefer = data['numberrefer'];

        final subscribe = data['subscribed'];

        prefs.setBool('subscribed', subscribe);
        prefs.setString('email', email);
      } catch (e) {
        //  print(e);
      } finally {
        //   runcode();
        getToken();
      }
    }
    notifyListeners();
  }

  Future<void> sendtoken(token) async {
    final prefs = await SharedPreferences.getInstance();
    token1 = prefs.getString("tokenregistered");
    tokenregistered = token1;

    if (token1 == null) {
      try {
        final response = await networkHandler.client.post(
            networkHandler.builderUrl('/addTokenunregisterd'),
            body: jsonEncode(
                <String, String>{'token': token, "id": ID.toString()}),
            headers: {
              'Content-Type': 'application/json; charset=UTF-8',
            });
      } catch (e) {
        //  print(e);
      } finally {
        //   runcode();
      }
    } else {
      try {
        final response = await networkHandler.client.post(
            networkHandler.builderUrl('/addTokenregisterd'),
            body: jsonEncode(<String, String>{'token': token, "id": email}),
            headers: {
              'Content-Type': 'application/json; charset=UTF-8',
            });
      } catch (e) {
        //  print(e);
      } finally {
        //   runcode();
      }
    }

    notifyListeners();
  }

  runcode() {
    Timer(const Duration(seconds: 5), () {
      getstat();
    });
  }

  getstat() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token1 = pref.getString("tokenregistered");
    int? storagestamp = pref.getInt("loggedstamp");
    if (token1 != null) {
      try {
        final response = await networkHandler.client
            .get(networkHandler.builderUrl('/fetchidresgitered'), headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'authorization': 'Bearer $token1'
        });

        final data = jsonDecode(response.body);

        final stamp = data['ref'];

        if (storagestamp != stamp) {
          logoutout = false;
        }
      } catch (e) {
        //  print(e);
      } finally {
        //  runcode();
      }
    }
    //notifyListeners();
  }

  Future<void> changeadress(phone1, location1, address1) async {
    success = false;

    ChangeAddress change = ChangeAddress(
        email: email, address: address1, phone: phone1, location: location1);
    if (token1 != null) {
      try {
        final response = await networkHandler.client.post(
            networkHandler.builderUrl('/updateaddress'),
            body: changeAddressToJson(change),
            headers: {
              'Content-Type': 'application/json; charset=UTF-8',
            });

        final data = jsonDecode(response.body);

        if (data['status'] == 'Success') {
          await getregisterdID();
          success = true;
          msg = data['msg'];
        } else if (data['status'] == 'fail') {
          success = false;
          msg = data['msg'];
        }
      } catch (e) {
        print(e);
      } finally {}
    }
    notifyListeners();
  }

  void saveaddress(address, email1, number, name, location1) async {
    final _pref = await SharedPreferences.getInstance();
    print(name);
    _pref.setString('address', address);
    _pref.setString('notloggedemail', email1);
    _pref.setString('notloggednumber', number);
    _pref.setString('notloggedname', name);
    _pref.setString('notloggedlocation', location1);
    getaddress();
    notifyListeners();
  }

  Future<String?> getaddress() async {
    final _pref = await SharedPreferences.getInstance();
    notloggedemail = _pref.getString('notloggedemail') ?? '';
    notloggednumber = _pref.getString('notloggednumber') ?? '';
    notloggedname = _pref.getString('notloggedname') ?? '';
    notloggedlocation = _pref.getString('notloggedlocation');
    notloggedaddress = _pref.getString('address') ?? '';

    return notloggedaddress;
  }

  bool checkregisteredlogg() {
    bool a = true;

    if (tokenregistered == null) {
      a = false;
    } else {
      a = true;
    }
    return a;
  }

  String addressdecide() {
    String getadd = '';
    if (tokenregistered != null) {
      getadd = address;
    } else {
      getadd = notloggedaddress;
    }
    return getadd;
  }

  String numberdecide() {
    String getnum = '';
    if (tokenregistered != null) {
      getnum = phone;
    } else {
      getnum = notloggednumber;
    }
    return getnum;
  }

  String emaildecide() {
    String getmail = '';
    if (tokenregistered != null) {
      getmail = email;
    } else {
      getmail = notloggedemail;
    }
    return getmail;
  }

  String namedecide() {
    String getname = '';
    if (tokenregistered != null) {
      getname = firstname;
    } else {
      getname = notloggedname;
    }
    return getname;
  }

  String locationdecide() {
    String getlocation = '';
    if (tokenregistered != null) {
      getlocation = location;
    } else {
      getlocation = notloggedlocation ?? '';
    }
    return getlocation;
  }

  bool checkaddress() {
    bool a = true;

    if (address == '') {
      a = false;
    } else {
      a = true;
    }
    return a;
  }

  void logout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("tokenregistered");
    prefs.remove('email');
    prefs.remove('subscribed');
    getregisterdID();
  }
}
