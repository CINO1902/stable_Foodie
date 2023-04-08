import 'package:flutter/material.dart';
import 'package:foodie_ios/linkfile/Model/getsubhistory.dart';
import 'package:foodie_ios/linkfile/Model/sendsubhistory.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:foodie_ios/linkfile/networkhandler.dart';

class getsubhistory extends ChangeNotifier {
  bool loading = false;
  List<Pagnited> fetchresult = [];
  List<Pagnited> cappedresult = [];
  List<Pagnited> monthresult = [];
  double progress = 0;
  List<Pagnited> fullresult = [];

  int rollover = 0;
  List distinctList = [];
  String historylenght = '';
  int todorder = 0;
  bool isloadmore = false;
  bool hasnextpage = true;
  int limit = 15;
  int page = 1;
  int totalordered = 0;
  Future<void> loadmore() async {
    final prefs = await SharedPreferences.getInstance();
    String email = prefs.getString("email") ?? '';

    if (hasnextpage == true && isloadmore == false && loading == true) {
      isloadmore = true;
      notifyListeners();
      page += 1;
      try {
        SendSubhistory fetch = SendSubhistory(email: email);
        var response = await networkHandler.client.post(
            networkHandler.builderUrl('/subhistory?page=$page&limit=$limit'),
            body: sendSubhistoryToJson(fetch),
            headers: {
              'content-Type': 'application/json; charset=UTF-8',
            });

        final data = getsubhistoryFromJson(response.body);
       
        fetchresult = data.result.pagnited;
        final loadmore = data.result.next;
        if (loadmore.page == page) {
          hasnextpage = false;
        } else {
          hasnextpage = true;
        }

        fetchresult.sort((b, a) => a.date.compareTo(b.date));
        String day = DateFormat('d').format(data.date);

        fullresult.addAll(fetchresult);
        historylenght = fullresult.length.toString();

        rollover = data.rollover;
        if (loadmore.page == page) {
          hasnextpage = false;
        } else {
          hasnextpage = true;
        }
      } catch (e) {
        print(e);
      } finally {
        isloadmore = false;
      }
    }
    notifyListeners();
  }

  Future<void> getordersub() async {
    final prefs = await SharedPreferences.getInstance();

    String email = prefs.getString("email") ?? '';
    page = 1;
    try {
      loading = false;
      if (email != '') {
        SendSubhistory fetch = SendSubhistory(email: email);
        var response = await networkHandler.client.post(
            networkHandler.builderUrl('/subhistory?page=$page&limit=$limit'),
            body: sendSubhistoryToJson(fetch),
            headers: {
              'content-Type': 'application/json; charset=UTF-8',
            });

        final data = getsubhistoryFromJson(response.body);

        fetchresult = data.result.pagnited;

        final loadmore = data.result.next.page;
        if (loadmore == page) {
          hasnextpage = false;
        } else {
          hasnextpage = true;
        }

        fetchresult.sort((b, a) => a.date.compareTo(b.date));
        String day = DateFormat('d').format(data.date);
        String month = DateFormat('M').format(data.date);
        String year = DateFormat('y').format(data.date);
        cappedresult = fetchresult
            .where((element) =>
                element.date.day.toString() == day && element.order != false)
            .take(3)
            .toList();

        fullresult =
            fetchresult.where((element) => element.order != false).toList();
        historylenght = fullresult.length.toString();
        final daylenght = fullresult
            .where((element) =>
                element.category != '4' &&
                element.date.day.toString() == day &&
                element.date.month.toString() == month &&
                element.date.year.toString() == year &&
                element.order == true)
            .toList();

        todorder = daylenght.length;
        totalordered = data.totalordered;

        rollover = data.rollover;
        notifyListeners();
      }
    } catch (e) {
      print(e);
    } finally {
      loading = true;
    }
    notifyListeners();
  }
}
