// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:js' as js;
import 'package:foodie_ios/linkfile/constant/key.dart';
import 'package:foodie_ios/linkfile/interlop.dart' as paystack;

class PaystackPopup {
  static Future<void> openPaystackPopup({
    required String email,
    required String amount,
    required String ref,
    required void Function() onClosed,
    required void Function() onSuccess,
  }) async {
    js.context.callMethod(
      paystack.paystackPopUp(
        constantKey.paystack_key,
        email,
        amount,
        ref,
        js.allowInterop(
          onClosed,
        ),
        js.allowInterop(
          onSuccess,
        ),
      ),
      [],
    );
  }
}