import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:foodie_ios/linkfile/Model/cartrecieve.dart';
import 'package:foodie_ios/linkfile/Model/fetchcart.dart';
import 'package:foodie_ios/linkfile/Model/sendcoupon.dart';
import 'package:foodie_ios/linkfile/Model/sendlocation.dart';
import 'package:foodie_ios/linkfile/Model/verifycoupon.dart';
import 'package:foodie_ios/linkfile/provider/onboarding.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:foodie_ios/linkfile/networkhandler.dart';

class checkcart extends ChangeNotifier {
  List sumadd = [];
  bool loaded = false;
  List getTotal = [];
  Timer? t;
  int sumget = 0;
  double moneytopay = 0.00;
  String stringmoney = '';
  String msg = '';
  bool empty = false;
  bool orderempty = false;
  bool loading = false;
  List<Pagnited> cartresult = [];
  List<Pagnited> fetchresult = [];
  List<Pagnited> orderesult = [];
  List selected = [0];
  List<List<dynamic>> itemsquote = [];
  String fullname = '';
  String number = '';
  String address = '';
  String location = '';
  int delivery = 0;
  bool error = false;
  String perfullname = '';
  String pernumber = '';
  String peraddress = '';
  String perlocation = '';
  bool usedefault = true;
  String type = '';
  int? amount = 0;
  String? success = '';
  int? discount = 0;
  bool verified = false;
  bool isloadmore = false;
  bool hasnextpage = true;
  int limit = 10;
  int page = 1;
  void getindex(index) {
    selected.clear();
    selected.add(index);
    notifyListeners();
  }

  Future<void> loadmore() async {
    final prefs = await SharedPreferences.getInstance();
    int? ID = prefs.getInt("ID");
    String id = ID.toString();
    String email = prefs.getString("email") ?? '';

    if (hasnextpage == true && isloadmore == false && loading == false) {
      isloadmore = true;
      notifyListeners();
      page += 1;
      try {
        FetchcartModel getfetchmodel() {
          FetchcartModel fetchmodel = FetchcartModel(id: id, email: email);

          if (selected.contains(0)) {
            fetchmodel = FetchcartModel(id: id, email: email);
          } else if (selected.contains(1)) {
            fetchmodel = FetchcartModel(id: '', email: email);
          } else if (selected.contains(2)) {
            fetchmodel = FetchcartModel(id: id, email: '');
          }
          return fetchmodel;
        }

        var response = await networkHandler.client.post(
            networkHandler.builderUrl('/getCart?page=$page&limit=$limit'),
            body: fetchcartModelToJson(getfetchmodel()),
            headers: {
              'content-Type': 'application/json; charset=UTF-8',
            });

        final data = cartRecieveModelFromJson(response.body);

        fetchresult = data.result.pagnited;

        fetchresult.sort((a, b) => b.date.compareTo(a.date));

        orderesult.addAll(
            fetchresult.where((element) => element.order == true).toList());
        final loadmore = data.result.next;
        if (loadmore.page == page) {
          hasnextpage = false;
        } else {
          hasnextpage = true;
        }
        checkempty();
        totalcart();
        checkorderempty();
      } catch (e) {
        print(e);
      } finally {
        isloadmore = false;
      }
    }

    notifyListeners();
  }

  Future<void> checkcarts() async {
    hasnextpage = true;
    final prefs = await SharedPreferences.getInstance();
    int id1 = prefs.getInt("ID") ?? 0;
    String id = id1.toString();

    String email = prefs.getString("email") ?? '';

    try {
      loading = true;
      notifyListeners();
      FetchcartModel getfetchmodel() {
        FetchcartModel fetchmodel = FetchcartModel(id: id, email: email);

        if (selected.contains(0)) {
          fetchmodel = FetchcartModel(id: id, email: email);
        } else if (selected.contains(1)) {
          fetchmodel = FetchcartModel(id: '', email: email);
        } else if (selected.contains(2)) {
          fetchmodel = FetchcartModel(id: id, email: '');
        }
        return fetchmodel;
      }

      var response = await networkHandler.client.post(
          networkHandler.builderUrl('/getCart?page=$page&limit=$limit'),
          body: fetchcartModelToJson(getfetchmodel()),
          headers: {
            'content-Type': 'application/json; charset=UTF-8',
          });

      final data = cartRecieveModelFromJson(response.body);

      fetchresult = data.result.pagnited;

      fetchresult.sort((a, b) => b.date.compareTo(a.date));

      orderesult =
          fetchresult.where((element) => element.order == true).toList();
      for (var i = 0; i < orderesult.length; i++) {
        var productMap = [orderesult[i].status, orderesult[i].ordernum];
        itemsquote.add(productMap);
      }

      checkempty();
      totalcart();
      checkorderempty();
    } catch (e) {
      print(e);
    } finally {
      loading = false;

      if (loaded == false) {
        refreshcheckcarts();
        loaded = true;
      }
    }
    notifyListeners();
  }

  runcode() {
    t = Timer(Duration(seconds: 5), () {
      refreshcheckcarts();
    });
  }

  Future<void> refreshcheckcarts() async {
    hasnextpage = true;
    final prefs = await SharedPreferences.getInstance();
    int id1 = prefs.getInt("ID") ?? 0;
    String id = id1.toString();

    String email = prefs.getString("email") ?? '';

    try {
      notifyListeners();
      FetchcartModel getfetchmodel() {
        FetchcartModel fetchmodel = FetchcartModel(id: id, email: email);

        if (selected.contains(0)) {
          fetchmodel = FetchcartModel(id: id, email: email);
        } else if (selected.contains(1)) {
          fetchmodel = FetchcartModel(id: '', email: email);
        } else if (selected.contains(2)) {
          fetchmodel = FetchcartModel(id: id, email: '');
        }
        return fetchmodel;
      }

      var response = await networkHandler.client.post(
          networkHandler.builderUrl('/getCart?page=1&limit=20'),
          body: fetchcartModelToJson(getfetchmodel()),
          headers: {
            'content-Type': 'application/json; charset=UTF-8',
          });

      final data = cartRecieveModelFromJson(response.body);

      final fetchstatus = data.result.pagnited;
      fetchstatus.sort((a, b) => b.date.compareTo(a.date));
      final statusresult =
          fetchstatus.where((element) => element.order == true).toList();
      itemsquote.clear();
      for (var i = 0; i < statusresult.length; i++) {
        var productMap = [statusresult[i].status, statusresult[i].ordernum];
        itemsquote.add(productMap);
      }
    } catch (e) {
      print(e);
    } finally {
      // loading = false;

      runcode();
    }
    notifyListeners();
  }

  Future<void> checkcartforcart() async {
    hasnextpage = true;
    final prefs = await SharedPreferences.getInstance();
    int id1 = prefs.getInt("ID") ?? 0;
    String id = id1.toString();

    String email = prefs.getString("email") ?? '';
    String token1 = prefs.getString("tokenregistered") ?? '';

    try {
      loading = true;
      notifyListeners();
      FetchcartModel getfetchmodel() {
        FetchcartModel fetchmodel = FetchcartModel(id: id, email: email);

        if (token1 != '') {
          fetchmodel = FetchcartModel(id: '', email: email);
        } else {
          fetchmodel = FetchcartModel(id: id, email: '');
        }
        return fetchmodel;
      }

      var response = await networkHandler.client.post(
          networkHandler.builderUrl('/getCart?page=1&limit=10'),
          body: fetchcartModelToJson(getfetchmodel()),
          headers: {
            'content-Type': 'application/json; charset=UTF-8',
          });

      final data = cartRecieveModelFromJson(response.body);

      fetchresult = data.result.pagnited;

      fetchresult.sort((a, b) => a.date.compareTo(b.date));

      if (token1 != '') {
        cartresult = fetchresult
            .where((element) =>
                element.order == false && element.pagnitedId == email)
            .toList();
      } else {
        cartresult =
            fetchresult.where((element) => element.order == false).toList();
      }

      checkempty();
      totalcart();
      checkorderempty();
    } catch (e) {
      print(e);
    } finally {
      loading = false;
    }
    notifyListeners();
  }

  void gettempaddress(fullname1, phone1, address1, location1) {
    fullname = fullname1;
    number = phone1;
    address = address1;
    usedefault = false;
    location = location1;
    notifyListeners();
  }

  void usedefaultaddress() {
    usedefault = true;
    notifyListeners();
  }

  Future<void> locationa() async {
    error = false;
    loading = true;
    String getlocation() {
      String locate = '';
      if (usedefault == true) {
        locate = perlocation;
      } else {
        locate = location;
      }
      return locate;
    }

    try {
      loading = true;
      Sendlocation send = Sendlocation(location: getlocation());
      var response = await networkHandler.client.post(
          networkHandler.builderUrl('/fetchlocation'),
          body: sendlocationToJson(send),
          headers: {
            'content-Type': 'application/json; charset=UTF-8',
          });

      final data = jsonDecode(response.body);
      delivery = data['msg'];
      moneytopay = (sumget + delivery).toDouble();
      stringmoney = moneytopay.toString();
    } catch (e) {
      print(e);
      error = true;
    } finally {
      loading = false;
    }
    notifyListeners();
  }

  void totalcart() {
    getTotal.clear();
    if (cartresult.isNotEmpty) {
      for (var i = 0; i < cartresult.length; i++) {
        if (cartresult[i].specialName == null) {
          getTotal.add(int.parse(cartresult[i].total!));
        } else {
          getTotal.add(int.parse(cartresult[i].amount.toString()));
        }
      }
    }
    if (getTotal.isNotEmpty) {
      sumget = getTotal.reduce((a, b) => a + b);
    }

    notifyListeners();
  }

  Future<void> verifycoupon(code) async {
    moneytopay = (sumget + delivery).toDouble();
    stringmoney = moneytopay.toString();
    try {
      loading = true;
      Sendcoupon send = Sendcoupon(code: code);
      var response = await networkHandler.client.post(
          networkHandler.builderUrl('/verifycoupon'),
          body: sendcouponToJson(send),
          headers: {
            'content-Type': 'application/json; charset=UTF-8',
          });

      final coupondetails = verifyCouponFromJson(response.body);

      type = coupondetails!.type;

      msg = coupondetails.msg;
      success = coupondetails.status;
      if (success == 'success') {
        verified = true;
        amount = coupondetails.amount;
        discount = coupondetails.discount;
        if (type == 'discount') {
          if (moneytopay > 5000) {
            final dis = (discount! / 100) * 5000;
            moneytopay = moneytopay - dis;
            stringmoney = moneytopay.toString();
          } else {
            final dis = (discount! / 100) * moneytopay;
            moneytopay = moneytopay - dis;
            stringmoney = moneytopay.toString();
          }
        } else if (type == 'money') {
          moneytopay = (moneytopay - amount!.toDouble());
          stringmoney = moneytopay.toString();
        }
      } else {
        verified = false;
      }
    } catch (e) {
      print(e);
    } finally {
      loading = false;
    }
    notifyListeners();
  }

  void disposediscount() {
    verified = false;
    discount = 0;
    amount = 0;
  }

  void checkempty() {
    if (cartresult.isEmpty) {
      empty = false;
    } else {
      empty = true;
    }
    notifyListeners();
  }

  void checkorderempty() {
    if (orderesult.isEmpty) {
      orderempty = false;
    } else {
      orderempty = true;
    }
    notifyListeners();
  }

  loggout() {
    selected = [0];
  }

  void update(checkstate checkstate) {
    perfullname = checkstate.namedecide();
    pernumber = checkstate.numberdecide();
    peraddress = checkstate.addressdecide();
    perlocation = checkstate.locationdecide();
  }
}
