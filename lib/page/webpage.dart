import 'dart:async';
import 'dart:convert';
import 'package:foodie_ios/linkfile/networkhandler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:foodie_ios/linkfile/Model/requestotp.dart';
import 'package:foodie_ios/page/verifyquickbuy.dart';
import 'package:webview_flutter/webview_flutter.dart';

class webpage extends StatefulWidget {
  webpage(
      {super.key,
      required this.email,
      required this.price,
      required this.ID,
      required this.ref,
      required this.type});

  String email;
  String price;
  String ID;
  String ref;
  String type;
  @override
  State<webpage> createState() => _webpageState();
}

class _webpageState extends State<webpage> {
  WebViewController controller = WebViewController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getcontroller();
    runcode();
  }

  Future<void> getcontroller() async {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..currentUrl()
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            print(int);
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {
            SmartDialog.showToast('Something went wrong');
            Navigator.pushNamedAndRemoveUntil(
                context, '/landingpage', (Route<dynamic> route) => false);
          },
          onNavigationRequest: (NavigationRequest request) {
            //print(request.url);
            if (request.url.startsWith('https://m.youtube.com/')) {
              Navigator.pushNamedAndRemoveUntil(
                  context, '/landingpage', (Route<dynamic> route) => false);
            } else if (request.url.startsWith(
                'https://neon-puffpuff-e88654.netlify.app/#/page5')) {
              Navigator.pop(context);
              // Navigator.pushNamedAndRemoveUntil(
              //     context, '/landingpage', (Route<dynamic> route) => false);
            } else if (request.url.startsWith(
                'https://neon-puffpuff-e88654.netlify.app/#/page24')) {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => verifyquickbuy(
                            price: int.parse(widget.price),
                            ref: widget.ref,
                          )),
                  (Route<dynamic> route) => false);
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(
          'https://neon-puffpuff-e88654.netlify.app/#/?email=${widget.email}&amount=${widget.price}&ID=${widget.ID}&ref=${widget.ref}'));
  }

  String success = '';
  String msg = '';
  Timer? t;
  runcode() {
//     Future.delayed(const Duration(milliseconds: 5000), () {
// // Here you can write your code

//     });
    t = Timer(Duration(seconds: 5), () {
      getnav();
    });
  }

  Future<void> getnav() async {
    try {
      Requestotp send = Requestotp(email: widget.ID);
      print(send.email);
      var response = await networkHandler.client.post(
          networkHandler.builderUrl('/verifyref'),
          body: requestotpToJson(send),
          headers: {
            'content-Type': 'application/json; charset=UTF-8',
          });
      final decodedres = jsonDecode(response.body);
      setState(() {
        success = decodedres['success'];
        msg = decodedres['msg'];
      });

      if (success == 'success') {
        print(msg);
        if (msg == 'paid') {
          if (widget.type == 'subcheckout') {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => verifysuborder(
                          price: int.parse(widget.price),
                          ref: widget.ref,
                        )),
                (Route<dynamic> route) => false);
          } else {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => verifyquickbuy(
                          price: int.parse(widget.price),
                          ref: widget.ref,
                        )),
                (Route<dynamic> route) => false);
          }
        } else if (msg == 'failed') {
          SmartDialog.showToast('Something went wrong');
          Navigator.pushNamedAndRemoveUntil(
              context, '/landingpage', (Route<dynamic> route) => false);
        }
      }
      // print(decodedres);
    } catch (e) {
      print(e);
      setState(() {
        success = 'fail';
      });
    } finally {
      runcode();
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    t!.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: WebViewWidget(
      controller: controller,
      //gestureRecognizers: GestureDetector,
    ));
  }
}
//https://neon-puffpuff-e88654.netlify.app/#/page2?email=${widget.email}&amount=${widget.price}00
//https://google.com