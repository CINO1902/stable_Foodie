import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:foodie_ios/linkfile/Model/calculateplan.dart';
import 'package:foodie_ios/linkfile/Model/checkoutsub.dart';
import 'package:foodie_ios/linkfile/Model/fetchpackage.dart';
import 'package:foodie_ios/linkfile/Model/sendcoupon.dart';
import 'package:foodie_ios/linkfile/Model/subscription.dart';
import 'package:foodie_ios/linkfile/Model/verifycoupon.dart';
import 'package:foodie_ios/linkfile/provider/subscribed.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:foodie_ios/linkfile/networkhandler.dart';

class sellectbucket extends ChangeNotifier {
  List ID = [];
  int frequency = 0;
  List allID = [];
  List allsecond = [];

  int amount = 0;
  int? coupon_amount;
  int? coupon_discount;
  String success_coupon = '';
  String coupon_type = '';
  String coupon_msg = '';
  int discount = 0;
  bool loadingcoupon = false;
  String stringmoney = '';
  bool verified = false;
  List allthird = [];
  List sellectID = [];

  List sellectID1 = [];
  List sellectID2 = [];
  List sellecteddrink = [];
  List sellecteddrink1 = [];
  List sellecteddrink2 = [];
  List<Item> sapa = [];
  List secondid = [];
  List secondselectedid = [];
  List secondselectedid1 = [];
  List secondselectedid2 = [];
  List seconddrinkid = [];
  List seconddrinkid1 = [];
  List seconddrinkid2 = [];
  List thirdid = [];
  int days = 0;
  List thirdselectedid = [];
  List thirdselectedid1 = [];
  List thirdselectedid2 = [];
  List thirddrinkid = [];
  List thirddrinkid1 = [];
  List thirddrinkid2 = [];
  bool error = false;
  bool success = false;
  List<String> firstbuckepage = [];
  List<String> secondbuckepage = [];
  List<String> thirdbuckepage = [];
  String drinkpackage1 = '';
  String drinkpackage2 = '';
  String drinkpackage3 = '';
  bool loadpackage = false;
  List totalpriceeach = [];
  List totaldrinkseeach = [];
  List totalfoodeach = [];
  int outstanddrink = 0;
  int outstandfood = 0;
  int outstandtotal = 0;
  String status = '';
  List<List> index1 = [
    [5],
    [5],
    [5]
  ];
  List index2 = [
    [5],
    [5],
    [5]
  ];
  int pageid = 0;
  bool a = false;
  bool data = false;
  String drink1 = '';
  String drink2 = '';
  String drink3 = '';
  void getbucket(List allid, sapa, idpage) {
    //ID.add(id);
    if (idpage == 0) {
      allID = allid;
    } else if (idpage == 1) {
      allsecond = allid;
    } else if (idpage == 2) {
      allthird = allid;
    }

    sapa = sapa;
  }

  String calculated = '0.00';
  String rollover = '0.00';
  void getfrequency(_freqency) {
    frequency = _freqency;
    notifyListeners();
  }

  void clearlist() {
    sellectID.clear();
    sellectID1.clear();
    sellectID2.clear();
    index1 = [
      [5],
      [5],
      [5]
    ];
    index2 = [
      [5],
      [5],
      [5]
    ];
    sellecteddrink.clear();
    sellecteddrink1.clear();
    sellecteddrink2.clear();
    thirdselectedid.clear();
    thirdselectedid1.clear();
    thirdselectedid2.clear();
    secondselectedid.clear();
    secondselectedid1.clear();
    secondselectedid2.clear();
    drink1 = '';
    drink2 = '';
    drink3 = '';
    seconddrinkid.clear();
    seconddrinkid1.clear();
    seconddrinkid2.clear();
    thirddrinkid.clear();
    thirddrinkid1.clear();
    thirddrinkid2.clear();
  }

  String msg = '';

  void savelistfinal(int inf, int page) {
  
    ID.clear();
    ID.add(inf);

    pageid = page;
    // index1.add(page);
    index1.contains(index1[page])
        ? index1[index1.indexWhere((v) => v == index1[page])] = [inf]
        : index1;
    index2.contains(index2[page])
        ? index2[index2.indexWhere((v) => v == index2[page])] = [page]
        : index2;
    //index = Set.of(index1).toList();

    notifyListeners();
  }

  void onCategorySelected2(bool selected, idpage, int page) {
    if (idpage == 0) {
      if (selected == true) {
        if (page == 0) {
          sellectID.clear();

          sellectID.addAll(allID);
        } else if (page == 1) {
          sellectID1.clear();

          sellectID1.addAll(allID);
        } else {
          sellectID2.clear();

          sellectID2.addAll(allID);
        }
      } else {
        if (page == 0) {
          sellectID.clear();
        } else if (page == 2) {
          sellectID1.clear();
        } else {
          sellectID2.clear();
        }
      }
    } else if (idpage == 1) {
      if (selected == true) {
        if (page == 0) {
          secondselectedid.clear();
          secondselectedid.addAll(allsecond);
        } else if (page == 1) {
          secondselectedid1.clear();
          secondselectedid1.addAll(allsecond);
        } else {
          secondselectedid2.clear();
          secondselectedid2.addAll(allsecond);
        }
      } else {
        if (page == 0) {
          secondselectedid.clear();
        } else if (page == 1) {
          secondselectedid1.clear();
        } else {
          secondselectedid2.clear();
        }
      }
    } else if (idpage == 2) {
      if (selected == true) {
        if (page == 0) {
          thirdselectedid.clear();
          thirdselectedid.addAll(allthird);
        } else if (page == 1) {
          thirdselectedid1.clear();
          thirdselectedid1.addAll(allthird);
        } else {
          thirdselectedid2.clear();
          thirdselectedid2.addAll(allthird);
        }
      } else {
        if (page == 0) {
          thirdselectedid.clear();
        } else if (page == 1) {
          thirdselectedid1.clear();
        } else {
          thirdselectedid2.clear();
        }
      }
    }

    notifyListeners();
  }

  void onCategorySelected(bool selected, categoryId, idpage, int page1) {
    if (idpage == 0) {
      if (selected == true) {
        if (page1 == 0) {
          sellectID.add(categoryId);
        } else if (page1 == 1) {
          sellectID1.add(categoryId);
        } else {
          sellectID2.add(categoryId);
        }
      } else {
        if (page1 == 0) {
          sellectID.remove(categoryId);
        } else if (page1 == 1) {
          sellectID1.remove(categoryId);
        } else {
          sellectID2.remove(categoryId);
        }
      }
    } else if (idpage == 1) {
      if (selected == true) {
        if (page1 == 0) {
          secondselectedid.add(categoryId);
        } else if (page1 == 1) {
          secondselectedid1.add(categoryId);
        } else {
          secondselectedid2.add(categoryId);
        }
      } else {
        if (page1 == 0) {
          secondselectedid.remove(categoryId);
        } else if (page1 == 1) {
          secondselectedid1.remove(categoryId);
        } else {
          secondselectedid2.remove(categoryId);
        }
      }
    } else {
      if (selected == true) {
        if (page1 == 0) {
          thirdselectedid.add(categoryId);
        } else if (page1 == 1) {
          thirdselectedid1.add(categoryId);
        } else {
          thirdselectedid2.add(categoryId);
        }
      } else {
        if (page1 == 0) {
          thirdselectedid.remove(categoryId);
        } else if (page1 == 1) {
          thirdselectedid1.remove(categoryId);
        } else {
          thirdselectedid2.remove(categoryId);
        }
      }
    }

    notifyListeners();
  }

  void onCategorySelectedDrinks(bool selected, categoryId, idpage, int page) {
    if (idpage == 0) {
      if (selected == true) {
        if (page == 0) {
          sellecteddrink.clear();
          sellecteddrink.add(
            categoryId,
          );
        } else if (page == 1) {
          sellecteddrink1.clear();
          sellecteddrink1.add(categoryId);
        } else {
          sellecteddrink2.clear();
          sellecteddrink2.add(categoryId);
        }
      } else {
        if (page == 0) {
          sellecteddrink.remove(categoryId);
        } else if (page == 1) {
          sellecteddrink1.remove(categoryId);
        } else {
          sellecteddrink2.remove(categoryId);
        }
      }
    } else if (idpage == 1) {
      if (selected == true) {
        if (page == 0) {
          seconddrinkid.clear();
          seconddrinkid.add(categoryId);
        } else if (page == 1) {
          seconddrinkid1.clear();
          seconddrinkid1.add(categoryId);
        } else {
          seconddrinkid2.clear();
          seconddrinkid2.add(categoryId);
        }
      } else {
        if (page == 0) {
          seconddrinkid.remove(categoryId);
        } else if (page == 1) {
          seconddrinkid1.remove(categoryId);
        } else {
          seconddrinkid2.remove(categoryId);
        }
      }
    } else if (idpage == 2) {
      if (selected == true) {
        if (page == 0) {
          thirddrinkid.clear();
          thirddrinkid.add(categoryId);
        } else if (page == 1) {
          thirddrinkid1.clear();
          thirddrinkid1.add(categoryId);
        } else {
          thirddrinkid2.clear();
          thirddrinkid2.add(categoryId);
        }
      } else {
        if (page == 0) {
          thirddrinkid.remove(categoryId);
        } else if (page == 1) {
          thirddrinkid1.remove(categoryId);
        } else {
          thirddrinkid2.remove(categoryId);
        }
      }
    }
    notifyListeners();
  }

  bool checkempty(pageid, page) {
    if (page == 0) {
      if (pageid == 0) {
        if (sellectID.isEmpty) {
          a = true;
        } else {
          a = false;
        }
      } else if (pageid == 1) {
        if (sellectID1.isEmpty) {
          a = true;
        } else {
          a = false;
        }
      } else {
        if (sellectID2.isEmpty) {
          a = true;
        } else {
          a = false;
        }
      }
    } else if (page == 1) {
      if (pageid == 0) {
        if (secondselectedid.isEmpty) {
          a = true;
        } else {
          a = false;
        }
      } else if (pageid == 1) {
        if (secondselectedid1.isEmpty) {
          a = true;
        } else {
          a = false;
        }
      } else {
        if (secondselectedid2.isEmpty) {
          a = true;
        } else {
          a = false;
        }
      }
    } else {
      if (pageid == 0) {
        if (thirdselectedid.isEmpty) {
          a = true;
        } else {
          a = false;
        }
      } else if (pageid == 1) {
        if (thirdselectedid1.isEmpty) {
          a = true;
        } else {
          a = false;
        }
      } else {
        if (thirdselectedid2.isEmpty) {
          a = true;
        } else {
          a = false;
        }
      }
    }
    return a;
  }

  bool checkbucket(index_1, index_2, index_3, page1, page2, page3) {
    if (index2[index_1].contains(page1) &&
        index2[index_2].contains(page2) &&
        index2[index_3].contains(page3)) {
      return true;
    } else {
      return false;
    }
  }

  void getsellected() {
    firstbucket();
    secondbucket();
    thirdbucket();
  }

  List<Map<String, String>> firstbucket() {
    List<Map<String, String>> firstbucket1 = [];
    if (index1[0].contains(0)) {
      Map bucket = {};
      Map<String, String> newMap = new Map<String, String>();
      bucket = sellectID.asMap();
      bucket.forEach((key, value) {
        newMap.putIfAbsent(key.toString(), () => value);
      });
      if (sellecteddrink.isNotEmpty) {
        drink1 = sellecteddrink[0];
      } else {
        drink1 = '';
      }

      firstbucket1.add(newMap);
    } else if (index1[0].contains(1)) {
      Map bucket = {};
      Map<String, String> newMap = new Map<String, String>();
      bucket = secondselectedid.asMap();
      bucket.forEach((key, value) {
        newMap.putIfAbsent(key.toString(), () => value);
      });
      if (seconddrinkid.isNotEmpty) {
        drink1 = seconddrinkid[0];
      } else {
        drink1 = '';
      }

      firstbucket1.add(newMap);
    } else if (index1[0].contains(2)) {
      Map bucket = {};
      Map<String, String> newMap = new Map<String, String>();
      bucket = thirdselectedid.asMap();
      bucket.forEach((key, value) {
        newMap.putIfAbsent(key.toString(), () => value);
      });
      if (thirddrinkid.isNotEmpty) {
        drink1 = thirddrinkid[0];
      } else {
        drink1 = '';
      }

      firstbucket1.add(newMap);
    }

    return firstbucket1;
  }

  List<Map<String, String>> secondbucket() {
    List<Map<String, String>> firstbucket3 = [];
    if (index1[1].contains(0)) {
      Map bucket = {};
      Map<String, String> newMap = new Map<String, String>();
      bucket = sellectID1.asMap();
      bucket.forEach((key, value) {
        newMap.putIfAbsent(key.toString(), () => value);
      });
      if (sellecteddrink1.isNotEmpty) {
        drink2 = sellecteddrink1[0];
      } else {
        drink2 = '';
      }

      firstbucket3.add(newMap);
    } else if (index1[1].contains(1)) {
      Map bucket = {};
      Map<String, String> newMap = new Map<String, String>();
      bucket = secondselectedid1.asMap();
      bucket.forEach((key, value) {
        newMap.putIfAbsent(key.toString(), () => value);
      });
      if (seconddrinkid1.isNotEmpty) {
        drink2 = seconddrinkid1[0];
      } else {
        drink2 = '';
      }

      firstbucket3.add(newMap);
    } else if (index1[1].contains(2)) {
      Map bucket = {};
      Map<String, String> newMap = new Map<String, String>();
      bucket = thirdselectedid1.asMap();
      bucket.forEach((key, value) {
        newMap.putIfAbsent(key.toString(), () => value);
      });
      if (thirddrinkid1.isNotEmpty) {
        drink2 = thirddrinkid1[0];
      } else {
        drink2 = '';
      }

      firstbucket3.add(newMap);
    }

    return firstbucket3;
  }

  List<Map<String, String>> thirdbucket() {
    List<Map<String, String>> firstbucket2 = [];
    if (index1[2].contains(0)) {
      Map bucket = {};
      Map<String, String> newMap = new Map<String, String>();
      bucket = sellectID2.asMap();
      bucket.forEach((key, value) {
        newMap.putIfAbsent(key.toString(), () => value);
      });
      if (sellecteddrink2.isNotEmpty) {
        drink3 = sellecteddrink2[0];
      } else {
        drink3 = '';
      }

      firstbucket2.add(newMap);
    } else if (index1[2].contains(1)) {
      Map bucket = {};
      Map<String, String> newMap = new Map<String, String>();
      bucket = secondselectedid2.asMap();
      bucket.forEach((key, value) {
        newMap.putIfAbsent(key.toString(), () => value);
      });
      if (seconddrinkid2.isNotEmpty) {
        drink3 = seconddrinkid2[0];
      } else {
        drink3 = '';
      }

      firstbucket2.add(newMap);
    } else if (index1[2].contains(2)) {
      Map bucket = {};
      Map<String, String> newMap = new Map<String, String>();
      bucket = thirdselectedid2.asMap();
      bucket.forEach((key, value) {
        newMap.putIfAbsent(key.toString(), () => value);
      });
      if (thirddrinkid2.isNotEmpty) {
        drink3 = thirddrinkid2[0];
      } else {
        drink3 = '';
      }

      firstbucket2.add(newMap);
    }

    return firstbucket2;
  }

  Future<void> sendsubscription() async {
    data = false;

    final prefs = await SharedPreferences.getInstance();
    String email = prefs.getString('email') ?? '';
    List<String> firstbuck = firstbucket()[0].values.toList();

    List<String> getsecondbuc() {
      List<String> bucket = [];

      if (secondbucket().isNotEmpty) {
        bucket = secondbucket()[0].values.toList();
      }
      return bucket;
    }

    List<String> getthirdbuck() {
      List<String> bucket = [];
      if (thirdbucket().isNotEmpty) {
        bucket = thirdbucket()[0].values.toList();
      }
      return bucket;
    }

    String getcetegory(bucked) {
      String cat = '';
      List arr1 = ['1000', '1001', '1002', '1003', '1004', '1005', '1006'];
      List arr2 = ['1011', '1012', '1013', '1014', '1015', '1016', '1017'];
      List arr3 = ['1018', '1019', '1020', '1021', '1022', '1023', '1024'];

      List lists = [
        bucked,
        arr1,
      ];
      List listtwo = [
        bucked,
        arr2,
      ];
      List listthree = [
        bucked,
        arr3,
      ];
      List commonElements = lists
          .fold<Set>(lists.first.toSet(), (a, b) => a.intersection(b.toSet()))
          .toList();
      List commonElementstwo = listtwo
          .fold<Set>(listtwo.first.toSet(), (a, b) => a.intersection(b.toSet()))
          .toList();
      List commonElementsthree = listthree
          .fold<Set>(
              listthree.first.toSet(), (a, b) => a.intersection(b.toSet()))
          .toList();

      if (commonElements.isNotEmpty) {
        cat = 'sapa';
      } else if (commonElementstwo.isNotEmpty) {
        cat = 'longthroat';
      } else if (commonElementsthree.isNotEmpty) {
        cat = 'odogwu';
      }

      return cat;
    }

    try {
      Subscription fetch = Subscription(
          email: email,
          frequency: frequency,
          day1: firstbucket(),
          day2: secondbucket(),
          day3: thirdbucket(),
          drink1: drink1,
          drink2: drink2,
          drink3: drink3,
          category1: getcetegory(firstbuck),
          category2: getcetegory(getsecondbuc()),
          category3: getcetegory(getthirdbuck()));
      var response = await networkHandler.client.post(
          networkHandler.builderUrl('/sendsubscription'),
          body: subscriptionToJson(fetch),
          headers: {'content-Type': 'application/json; charset=UTF-8'});

      notifyListeners();
      final decodedresponse = jsonDecode(response.body);
      data = true;
      final success1 = decodedresponse['status'];
      if (success1 == 'success') {
        success = true;
        prefs.setBool('subscribed', true);
      } else {
        success = false;
      }
    } catch (e) {
      print(e);
    } finally {}
  }

  Future<void> verifycoupon(code) async {
    stringmoney = calculated;
    try {
      loadingcoupon = true;
      Sendcoupon send = Sendcoupon(code: code);
      var response = await networkHandler.client.post(
          networkHandler.builderUrl('/verifycoupon'),
          body: sendcouponToJson(send),
          headers: {
            'content-Type': 'application/json; charset=UTF-8',
          });

      final coupondetails = verifyCouponFromJson(response.body);

      coupon_type = coupondetails!.type;

      coupon_msg = coupondetails.msg;
      success_coupon = coupondetails.status;
      final intmoney = int.parse(stringmoney);

      if (success_coupon == 'success') {
        verified = true;
        coupon_amount = coupondetails.amount;
        coupon_discount = coupondetails.discount;
        if (coupon_type == 'discount') {
          final dis = (coupon_discount! / 100) * intmoney;
          final discountmoney = intmoney.toDouble() - dis;
          stringmoney = discountmoney.round().toString();
        } else if (coupon_type == 'money') {
          final discountmoney = (intmoney - coupon_amount!);
          stringmoney = discountmoney.toString();
        }
      } else {
        verified = false;
      }
    } catch (e) {
      print(e);
    } finally {
      loadingcoupon = false;
    }
    notifyListeners();
  }

  void disposediscount() {
    verified = false;
    discount = 0;
    amount = 0;
  }

  Future<void> getidpackage() async {
    loadpackage = true;
    try {
      Subscription fetch = Subscription(
        email: '',
        frequency: 1,
        day1: firstbucket(),
        day2: secondbucket(),
        day3: thirdbucket(),
        drink1: drink1,
        drink2: drink2,
        drink3: drink3,
      );
      var response = await networkHandler.client.post(
          networkHandler.builderUrl('/getpackageid'),
          body: subscriptionToJson(fetch),
          headers: {'content-Type': 'application/json; charset=UTF-8'});

      notifyListeners();
      final decodedresponse = checkoutListFromJson(response.body);
      firstbuckepage = decodedresponse.food1;
      secondbuckepage = decodedresponse.food2;
      thirdbuckepage = decodedresponse.food3;
      drinkpackage1 = decodedresponse.drink1;
      drinkpackage2 = decodedresponse.drink2;
      drinkpackage3 = decodedresponse.drink3;
      data = true;
    } catch (e) {
      print(e);
    } finally {
      loadpackage = false;
    }
  }

  Future<void> sendsubscriptionrollover() async {
    data = false;

    final prefs = await SharedPreferences.getInstance();
    String email = prefs.getString('email') ?? '';
    List<String> firstbuck = firstbucket()[0].values.toList();

    List<String> getsecondbuc() {
      List<String> bucket = [];

      if (secondbucket().isNotEmpty) {
        bucket = secondbucket()[0].values.toList();
      }
      return bucket;
    }

    List<String> getthirdbuck() {
      List<String> bucket = [];
      if (thirdbucket().isNotEmpty) {
        bucket = thirdbucket()[0].values.toList();
      }
      return bucket;
    }

    String getcetegory(bucked) {
      String cat = '';
      List arr1 = ['1000', '1001', '1002', '1003', '1004', '1005', '1006'];
      List arr2 = ['1011', '1012', '1013', '1014', '1015', '1016', '1017'];
      List arr3 = ['1018', '1019', '1020', '1021', '1022', '1023', '1024'];

      List lists = [
        bucked,
        arr1,
      ];
      List listtwo = [
        bucked,
        arr2,
      ];
      List listthree = [
        bucked,
        arr3,
      ];
      List commonElements = lists
          .fold<Set>(lists.first.toSet(), (a, b) => a.intersection(b.toSet()))
          .toList();
      List commonElementstwo = listtwo
          .fold<Set>(listtwo.first.toSet(), (a, b) => a.intersection(b.toSet()))
          .toList();
      List commonElementsthree = listthree
          .fold<Set>(
              listthree.first.toSet(), (a, b) => a.intersection(b.toSet()))
          .toList();

      if (commonElements.isNotEmpty) {
        cat = 'Smallie';
      } else if (commonElementstwo.isNotEmpty) {
        cat = 'longthroat';
      } else if (commonElementsthree.isNotEmpty) {
        cat = 'Biggie';
      }

      return cat;
    }

    try {
      Subscription fetch = Subscription(
          email: email,
          frequency: frequency,
          days: days,
          day1: firstbucket(),
          day2: secondbucket(),
          day3: thirdbucket(),
          drink1: drink1,
          drink2: drink2,
          drink3: drink3,
          category1: getcetegory(firstbuck),
          category2: getcetegory(getsecondbuc()),
          category3: getcetegory(getthirdbuck()));
      var response = await networkHandler.client.post(
          networkHandler.builderUrl('/ '),
          body: subscriptionToJson(fetch),
          headers: {'content-Type': 'application/json; charset=UTF-8'});
      var decoded_res = jsonDecode(response.body);
      msg = decoded_res['msg'];
      status = decoded_res['status'];
      data = true;
      prefs.setBool('subscribed', true);
    } catch (e) {
      print(e);
    } finally {}
    notifyListeners();
  }

  void update(subscribed checkstate) {
    days = checkstate.days;
  }

  Future<void> calculateammount() async {
    success = false;
    error = false;
    final prefs = await SharedPreferences.getInstance();
    String email = prefs.getString('email') ?? '';
    List<String> firstbuck = firstbucket()[0].values.toList();

    List<String> getsecondbuc() {
      List<String> bucket = [];

      if (secondbucket().isNotEmpty) {
        bucket = secondbucket()[0].values.toList();
      }
      return bucket;
    }

    List<String> getthirdbuck() {
      List<String> bucket = [];
      if (thirdbucket().isNotEmpty) {
        bucket = thirdbucket()[0].values.toList();
      }
      return bucket;
    }

    String getcetegory(bucked) {
      String cat = '';
      List arr1 = ['1000', '1001', '1002', '1003', '1004', '1005', '1006'];
      List arr2 = ['1011', '1012', '1013', '1014', '1015', '1016', '1017'];
      List arr3 = ['1018', '1019', '1020', '1021', '1022', '1023', '1024'];

      List lists = [
        bucked,
        arr1,
      ];
      List listtwo = [
        bucked,
        arr2,
      ];
      List listthree = [
        bucked,
        arr3,
      ];
      List commonElements = lists
          .fold<Set>(lists.first.toSet(), (a, b) => a.intersection(b.toSet()))
          .toList();
      List commonElementstwo = listtwo
          .fold<Set>(listtwo.first.toSet(), (a, b) => a.intersection(b.toSet()))
          .toList();
      List commonElementsthree = listthree
          .fold<Set>(
              listthree.first.toSet(), (a, b) => a.intersection(b.toSet()))
          .toList();

      if (commonElements.isNotEmpty) {
        cat = 'sapa';
      } else if (commonElementstwo.isNotEmpty) {
        cat = 'longthroat';
      } else if (commonElementsthree.isNotEmpty) {
        cat = 'odogwu';
      }

      return cat;
    }

    try {
      Calculateplan fetch = Calculateplan(
          email: email,
          category1: getcetegory(firstbuck),
          category2: getcetegory(getsecondbuc()),
          category3: getcetegory(getthirdbuck()),
          drinks1: drink1,
          drinks2: drink2,
          drinks3: drink3);

      var response = await networkHandler.client.post(
          networkHandler.builderUrl('/calculateamount'),
          body: calculateplanToJson(fetch),
          headers: {'content-Type': 'application/json; charset=UTF-8'});

      final thisresponse = jsonDecode(response.body);
      calculated = thisresponse['amount'].toString();
      totalpriceeach = thisresponse['total'];
      totaldrinkseeach = thisresponse['drinks'];
      totalfoodeach = thisresponse['food'];
      success = true;
      stringmoney = calculated;
      notifyListeners();
    } catch (e) {
      error = true;
      print(e);
    } finally {}
    notifyListeners();
  }

  Future<void> rollovercalculateammount() async {
    success = false;
    error = false;
    final prefs = await SharedPreferences.getInstance();
    String email = prefs.getString('email') ?? '';
    List<String> firstbuck = firstbucket()[0].values.toList();

    List<String> getsecondbuc() {
      List<String> bucket = [];

      if (secondbucket().isNotEmpty) {
        bucket = secondbucket()[0].values.toList();
      }
      return bucket;
    }

    List<String> getthirdbuck() {
      List<String> bucket = [];
      if (thirdbucket().isNotEmpty) {
        bucket = thirdbucket()[0].values.toList();
      }
      return bucket;
    }

    String getcetegory(bucked) {
      String cat = '';
      List arr1 = ['1000', '1001', '1002', '1003', '1004', '1005', '1006'];
      List arr2 = ['1011', '1012', '1013', '1014', '1015', '1016', '1017'];
      List arr3 = ['1018', '1019', '1020', '1021', '1022', '1023', '1024'];

      List lists = [
        bucked,
        arr1,
      ];
      List listtwo = [
        bucked,
        arr2,
      ];
      List listthree = [
        bucked,
        arr3,
      ];
      List commonElements = lists
          .fold<Set>(lists.first.toSet(), (a, b) => a.intersection(b.toSet()))
          .toList();
      List commonElementstwo = listtwo
          .fold<Set>(listtwo.first.toSet(), (a, b) => a.intersection(b.toSet()))
          .toList();
      List commonElementsthree = listthree
          .fold<Set>(
              listthree.first.toSet(), (a, b) => a.intersection(b.toSet()))
          .toList();

      if (commonElements.isNotEmpty) {
        cat = 'sapa';
      } else if (commonElementstwo.isNotEmpty) {
        cat = 'longthroat';
      } else if (commonElementsthree.isNotEmpty) {
        cat = 'odogwu';
      }

      return cat;
    }

    try {
      Calculateplan fetch = Calculateplan(
          email: email,
          category1: getcetegory(firstbuck),
          category2: getcetegory(getsecondbuc()),
          category3: getcetegory(getthirdbuck()),
          drinks1: drink1,
          drinks2: drink2,
          drinks3: drink3);

      var response = await networkHandler.client.post(
          networkHandler.builderUrl('/rollovercalculateamount'),
          body: calculateplanToJson(fetch),
          headers: {'content-Type': 'application/json; charset=UTF-8'});

      final thisresponse = jsonDecode(response.body);
      calculated = thisresponse['amount'].toString();
      rollover = thisresponse['rollover'].toString();

      totalpriceeach = thisresponse['total'];
      totaldrinkseeach = thisresponse['drinks'];
      totalfoodeach = thisresponse['food'];
      success = true;
      stringmoney = calculated;
      notifyListeners();
    } catch (e) {
      error = true;
      print(e);
    } finally {}
    notifyListeners();
  }

  Future<void> checkupgrade() async {
    success = false;
    error = false;
    final prefs = await SharedPreferences.getInstance();
    String email = prefs.getString('email') ?? '';
    List<String> firstbuck = firstbucket()[0].values.toList();

    List<String> getsecondbuc() {
      List<String> bucket = [];

      if (secondbucket().isNotEmpty) {
        bucket = secondbucket()[0].values.toList();
      }
      return bucket;
    }

    List<String> getthirdbuck() {
      List<String> bucket = [];
      if (thirdbucket().isNotEmpty) {
        bucket = thirdbucket()[0].values.toList();
      }
      return bucket;
    }

    String getcetegory(bucked) {
      String cat = '';
      List arr1 = ['1000', '1001', '1002', '1003', '1004', '1005', '1006'];
      List arr2 = ['1011', '1012', '1013', '1014', '1015', '1016', '1017'];
      List arr3 = ['1018', '1019', '1020', '1021', '1022', '1023', '1024'];

      List lists = [
        bucked,
        arr1,
      ];
      List listtwo = [
        bucked,
        arr2,
      ];
      List listthree = [
        bucked,
        arr3,
      ];
      List commonElements = lists
          .fold<Set>(lists.first.toSet(), (a, b) => a.intersection(b.toSet()))
          .toList();
      List commonElementstwo = listtwo
          .fold<Set>(listtwo.first.toSet(), (a, b) => a.intersection(b.toSet()))
          .toList();
      List commonElementsthree = listthree
          .fold<Set>(
              listthree.first.toSet(), (a, b) => a.intersection(b.toSet()))
          .toList();

      if (commonElements.isNotEmpty) {
        cat = 'sapa';
      } else if (commonElementstwo.isNotEmpty) {
        cat = 'longthroat';
      } else if (commonElementsthree.isNotEmpty) {
        cat = 'odogwu';
      }

      return cat;
    }

    print(drink3);
    try {
      Calculateplan fetch = Calculateplan(
          email: email,
          category1: getcetegory(firstbuck),
          category2: getcetegory(getsecondbuc()),
          category3: getcetegory(getthirdbuck()),
          drinks1: drink1,
          drinks2: drink2,
          drinks3: drink3);
      var response = await networkHandler.client.post(
          networkHandler.builderUrl('/checkupgrade'),
          body: calculateplanToJson(fetch),
          headers: {'content-Type': 'application/json; charset=UTF-8'});

      final thisresponse = jsonDecode(response.body);

      if (thisresponse['status'] == 'success') {
        calculated = thisresponse['amount'].toString();
        totalpriceeach = thisresponse['priceseach'];
        totaldrinkseeach = thisresponse['drinkforeach'];
        totalfoodeach = thisresponse['foodforeach'];
        outstanddrink = thisresponse['outstandingdrink'];
        outstandfood = thisresponse['outstandingfood'];
        outstandtotal = thisresponse['outstandingtotal'];
     

        stringmoney = calculated;
        success = true;
      } else {
        success = false;
        msg = thisresponse['msg'];
      }

      notifyListeners();
    } catch (e) {
      error = true;
      print(e);
    } finally {}
    notifyListeners();
  }

  Future<void> sendupgrade() async {
    success = false;

    final prefs = await SharedPreferences.getInstance();
    String email = prefs.getString('email') ?? '';
    List<String> firstbuck = firstbucket()[0].values.toList();

    List<String> getsecondbuc() {
      List<String> bucket = [];

      if (secondbucket().isNotEmpty) {
        bucket = secondbucket()[0].values.toList();
      }
      return bucket;
    }

    List<String> getthirdbuck() {
      List<String> bucket = [];
      if (thirdbucket().isNotEmpty) {
        bucket = thirdbucket()[0].values.toList();
      }
      return bucket;
    }

    String getcetegory(bucked) {
      String cat = '';
      List arr1 = ['1000', '1001', '1002', '1003', '1004', '1005', '1006'];
      List arr2 = ['1011', '1012', '1013', '1014', '1015', '1016', '1017'];
      List arr3 = ['1018', '1019', '1020', '1021', '1022', '1023', '1024'];

      List lists = [
        bucked,
        arr1,
      ];
      List listtwo = [
        bucked,
        arr2,
      ];
      List listthree = [
        bucked,
        arr3,
      ];
      List commonElements = lists
          .fold<Set>(lists.first.toSet(), (a, b) => a.intersection(b.toSet()))
          .toList();
      List commonElementstwo = listtwo
          .fold<Set>(listtwo.first.toSet(), (a, b) => a.intersection(b.toSet()))
          .toList();
      List commonElementsthree = listthree
          .fold<Set>(
              listthree.first.toSet(), (a, b) => a.intersection(b.toSet()))
          .toList();

      if (commonElements.isNotEmpty) {
        cat = 'sapa';
      } else if (commonElementstwo.isNotEmpty) {
        cat = 'longthroat';
      } else if (commonElementsthree.isNotEmpty) {
        cat = 'odogwu';
      }

      return cat;
    }

    try {
      Subscription fetch = Subscription(
          email: email,
          frequency: frequency,
          days: days,
          day1: firstbucket(),
          day2: secondbucket(),
          day3: thirdbucket(),
          drink1: drink1,
          drink2: drink2,
          drink3: drink3,
          category1: getcetegory(firstbuck),
          category2: getcetegory(getsecondbuc()),
          category3: getcetegory(getthirdbuck()));
      var response = await networkHandler.client.post(
          networkHandler.builderUrl('/upgradesub'),
          body: subscriptionToJson(fetch),
          headers: {'content-Type': 'application/json; charset=UTF-8'});

      final thisresponse = jsonDecode(response.body);
      if (thisresponse['status'] == 'success') {
        msg = thisresponse['msg'];
        success = true;
      } else {
        success = false;
        msg = thisresponse['msg'];
      }

      prefs.setBool('subscribed', true);
    } catch (e) {
      print(e);
    } finally {}
    notifyListeners();
  }

  // String total(){

  // }
}
