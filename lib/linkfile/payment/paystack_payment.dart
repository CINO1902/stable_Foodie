import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:foodie_ios/linkfile/Model/cartrecieve.dart';
import 'package:foodie_ios/linkfile/constant/key.dart';
import 'package:foodie_ios/linkfile/customesnackbar.dart';

import 'package:foodie_ios/page/verifyquickbuy.dart';

class MakePayment {
  MakePayment(
      {required this.context, required this.price, required this.email});
  BuildContext context;
  int price;
  String email;
  List<Result> cartresults = [];

  PaystackPlugin paystack = PaystackPlugin();
  Future initializeplugin() async {
    await paystack.initialize(publicKey: constantKey.paystack_key);
  }

  String _getReference() {
    String platform;
    if (Platform.isIOS) {
      platform = 'iOS';
    } else {
      platform = 'Android';
    }

    return 'ChargedFrom${platform}_${DateTime.now().millisecondsSinceEpoch}';
  }

  PaymentCard _getCardUI() {
    return PaymentCard(number: "", cvc: "", expiryMonth: 0, expiryYear: 0);
  }

  chargeCardAndMakePayment() {
    initializeplugin().then((_) async {
      Charge charge = Charge()
        ..amount =
            price * 100 //rounding the price to a whole naira and removing kobo
        ..email = email
        ..reference = _getReference()
        // ..accessCode = "Zenith bank"
        ..putCustomField("Charged from", "Foodie")
        ..card = _getCardUI();

      final response = await paystack.checkout(context,
          charge: charge,
          method: CheckoutMethod.card,
          fullscreen: true,
          logo: Image.asset(
            'images/logo.png',
            width: 30,
            height: 30,
          ));

      print('Response ${response}');

      if (response.status == true) {
        // Navigator.pushAndRemoveUntil(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => verifyquickbuy(price: price)),
        //     (Route<dynamic> route) => false);
        print('Transaction Successful');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: CustomeSnackbar(
            topic: 'Oh Snap!',
            msg: '${response.message}',
            color1: const Color.fromARGB(255, 171, 51, 42),
            color2: const Color.fromARGB(255, 127, 39, 33),
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ));
        print('Transaction Failed');
      }
    });
  }
}
