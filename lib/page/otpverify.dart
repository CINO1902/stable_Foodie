import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:foodie_ios/linkfile/Model/requestotp.dart';
import 'package:foodie_ios/linkfile/Model/verifyotp.dart';
import 'package:foodie_ios/linkfile/customesnackbar.dart';
import 'package:foodie_ios/linkfile/enum/connectivity_status.dart';
import 'package:foodie_ios/linkfile/provider/internetchecker.dart';
import 'package:foodie_ios/page/overlay.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';
import 'package:foodie_ios/linkfile/networkhandler.dart';

class Otp extends StatefulWidget {
  const Otp({Key? key, required this.email}) : super(key: key);

  final String? email;
  @override
  _OtpState createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  TextEditingController textEditingController = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  String currentText = "";

  bool finish = false;
  bool _absorb = false;
  String msg = '';
  String success = '';

  @override
  initState() {
    super.initState();
    requesto();
  }

  final CountdownController _controller =
      new CountdownController(autoStart: true);

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Future<void> requesto() async {
    Requestotp requestotp = Requestotp(
      email: widget.email,
    );

    try {
      var response = await networkHandler.client.post(
          networkHandler.builderUrl('/requestOTP'),
          body: requestotpToJson(requestotp),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          });

      final decodedresponse = jsonDecode(response.body);
      setState(() {
        success = decodedresponse['success'];
        msg = decodedresponse['msg'];
      });
      print(decodedresponse);
    } catch (e) {
      print(e);
    } finally {}
  }

  Future<void> resendo() async {
    Requestotp requestotp = Requestotp(
      email: widget.email,
    );

    try {
      SmartDialog.showLoading();
      var response = await networkHandler.client.post(
          networkHandler.builderUrl('/resendOTP'),
          body: requestotpToJson(requestotp),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          });

      final decodedresponse = jsonDecode(response.body);
      setState(() {
        success = decodedresponse['success'];
        msg = decodedresponse['msg'];
      });
      print(decodedresponse);
      SmartDialog.showToast(msg, displayType: SmartToastType.onlyRefresh);
      await Future.delayed(Duration(milliseconds: 500));
    } catch (e) {
      SmartDialog.showToast('Something Went wrong',
          displayType: SmartToastType.onlyRefresh);
      await Future.delayed(Duration(milliseconds: 500));
    } finally {
      SmartDialog.dismiss();
    }
  }

  Future<void> verify() async {
    print(widget.email);
    VerifyOtp verifyOtp = VerifyOtp(email: widget.email, otp: currentText);

    try {
      SmartDialog.showLoading();
      var response = await networkHandler.client.post(
          networkHandler.builderUrl('/verifyOTP'),
          body: verifyOtpToJson(verifyOtp),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          });

      final decodedresponse = jsonDecode(response.body);
      setState(() {
        success = decodedresponse['success'];
        msg = decodedresponse['msg'];
      });
    } catch (e) {
      print(e);
      setState(() {
        success = 'false';
        msg = 'Something went wrong';
      });
    } finally {
      SmartDialog.dismiss();
    }
  }

  bool network = false;
  @override
  Widget build(BuildContext context) {
    if (Provider.of<ConnectivityStatus>(context) ==
        ConnectivityStatus.Offline) {
      showoverlay();
    } else {
      SmartDialog.dismiss(tag: 'network');
    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: InkWell(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 24, horizontal: 32),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.arrow_back,
                      size: 32,
                      color: Colors.black54,
                    ),
                  ),
                ),
                SizedBox(
                  height: 18,
                ),
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset(
                    'images/illustration-3.png',
                  ),
                ),
                SizedBox(
                  height: 24,
                ),
                Text(
                  'Verification',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Enter your OTP code number",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black38,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 28,
                ),
                Container(
                  padding: EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Form(
                        key: _key,
                        child: PinCodeTextField(
                          appContext: context,
                          pastedTextStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                          length: 4,
                          animationType: AnimationType.fade,
                          validator: (v) {
                            if (v!.length < 3) {
                              return "OTP must be Four digit";
                            } else {
                              return null;
                            }
                          },
                          pinTheme: PinTheme(
                              shape: PinCodeFieldShape.box,
                              borderRadius: BorderRadius.circular(5),
                              fieldHeight: 50,
                              fieldWidth: 40,
                              disabledColor: Colors.white,
                              //inactiveColor: Colors.white,
                              errorBorderColor: Colors.red),

                          cursorColor: Colors.black,
                          animationDuration: const Duration(milliseconds: 300),
                          enableActiveFill: false,

                          controller: textEditingController,
                          keyboardType: TextInputType.number,
                          boxShadows: const [],

                          onCompleted: (v) {
                            debugPrint("Completed");
                          },
                          // onTap: () {
                          //   print("Pressed");
                          // },
                          onChanged: (value) {
                            debugPrint(value);
                            setState(() {
                              currentText = value;
                            });
                          },
                          beforeTextPaste: (text) {
                            debugPrint("Allowing to paste $text");
                            //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                            //but you can show anything you want here, like your pop up saying wrong paste format or etc
                            return true;
                          },
                        ),
                      ),
                      SizedBox(
                        height: 22,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                           
                            sendToserver();
                          },
                          style: ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Theme.of(context).primaryColor),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24.0),
                              ),
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(14.0),
                            child: Text(
                              'Verify',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 18,
                ),
                Text(
                  "Didn't you receive any code?",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black38,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 18,
                ),
                finish
                    ? AbsorbPointer(
                        absorbing: _absorb,
                        child: InkWell(
                          onTap: () async {
                            setState(() {
                              finish = false;
                            });
                            await resendo();
                          },
                          child: Text(
                            "Resend New Code",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    : Countdown(
                        controller: _controller,
                        seconds: 60,
                        build: (context, double time) {
                          return Text(
                            time.toString().padLeft(2),
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          );
                        },
                        onFinished: () {
                          setState(() {
                            finish = true;
                          });
                        },
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  sendToserver() async {
    if (_key.currentState!.validate()) {
      await verify();
      if (success == "false") {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: CustomeSnackbar(
              topic: 'Oh Snap!',
              msg: msg,
              color1: Color.fromARGB(255, 171, 51, 42),
              color2: Color.fromARGB(255, 127, 39, 33),
            ),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
        );
      }
      if (success == 'true') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: CustomeSnackbar(
            topic: 'Great!',
            msg: msg,
            color1: Color.fromARGB(255, 25, 107, 52),
            color2: Color.fromARGB(255, 19, 95, 40),
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ));
        Navigator.pushNamed(context, '/login');
      }
    }
  }
}
