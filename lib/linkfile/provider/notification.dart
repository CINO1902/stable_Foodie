import 'package:flutter/material.dart';
import 'package:foodie_ios/linkfile/Model/requestotp.dart';
import 'package:foodie_ios/linkfile/Model/sendNotificationModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:foodie_ios/linkfile/networkhandler.dart';

class notifications extends ChangeNotifier {
  List<Pagnitednotify> notify = [];
  bool loading = false;
  int limit = 10;
  int page = 1;
  bool isloadmore = false;
  bool hasnextpage = true;
  Future<void> loadmorenotify() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    String email = prefs.getString("email") ?? '';
    if (hasnextpage == true && isloadmore == false && loading == false) {
      isloadmore = true;
      notifyListeners();
      page += 1;
      try {
        Requestotp send = Requestotp(email: email);
        var response = await networkHandler.client.post(
            networkHandler
                .builderUrl('/callnotification?page=$page&limit=$limit'),
            body: requestotpToJson(send),
            headers: {
              'content-Type': 'application/json; charset=UTF-8',
              'authorization': 'Bearer $token'
            });

        final decodedresponse = sendnotificationFromJson(response.body);

        notify.addAll(decodedresponse.notific.pagnitednotify!.toList());
        notify.sort((a, b) => b.date.compareTo(a.date));
        final loadmore = decodedresponse.notific.next;
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

  Future<void> getnotification() async {
    page = 1;
    hasnextpage = true;
    loading = true;
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    String email = prefs.getString("email") ?? '';
    try {
      Requestotp send = Requestotp(email: email);
      var response = await networkHandler.client.post(
          networkHandler
              .builderUrl('/callnotification?page=$page&limit=$limit'),
          body: requestotpToJson(send),
          headers: {
            'content-Type': 'application/json; charset=UTF-8',
            'authorization': 'Bearer $token'
          });

      final decodedresponse = sendnotificationFromJson(response.body);

      notify = decodedresponse.notific.pagnitednotify ?? [];
      notify.sort((a, b) => b.date.compareTo(a.date));
    } catch (e) {
      print(e);
    } finally {
      loading = false;
    }
    notifyListeners();
  }
}
