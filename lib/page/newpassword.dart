import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:foodie_ios/linkfile/Model/requestotp.dart';
import 'package:foodie_ios/linkfile/Model/verifyotp.dart';
import 'package:foodie_ios/linkfile/customesnackbar.dart';
import 'package:foodie_ios/linkfile/enum/connectivity_status.dart';
import 'package:foodie_ios/linkfile/provider/internetchecker.dart';
import 'package:foodie_ios/page/overlay.dart';
import 'package:provider/provider.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';
import 'package:foodie_ios/linkfile/networkhandler.dart';

class newpassword extends StatefulWidget {
  newpassword({super.key, required this.email});

  String email;
  @override
  State<newpassword> createState() => _newpasswordState();
}

class _newpasswordState extends State<newpassword> {
  bool finish = false;
  String msg = '';
  bool _absorb = false;
  bool passobscure = true;
  bool cpassobscure = true;
  String otp = '';
  String password = '';
  String success = '';
  String confirmPass = '';
  Future<void> resendo() async {
    Requestotp requestotp = Requestotp(
      email: widget.email,
    );

    try {
      SmartDialog.showLoading();
      var response = await networkHandler.client.post(
          networkHandler.builderUrl('/resendrecoverOTP'),
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

  Future<void> confirmpassword() async {
    VerifyOtp requestotp = VerifyOtp(
      email: widget.email,
      otp: otp,
      password: password,
    );

    try {
      SmartDialog.showLoading();
      var response = await networkHandler.client.post(
          networkHandler.builderUrl('/verifynewpassword'),
          body: verifyOtpToJson(requestotp),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          });

      final decodedresponse = jsonDecode(response.body);
      setState(() {
        success = decodedresponse['success'];
        msg = decodedresponse['msg'];
      });
    } catch (e) {
      SmartDialog.showToast('Something Went wrong',
          displayType: SmartToastType.onlyRefresh);
      await Future.delayed(Duration(milliseconds: 500));
    } finally {
      SmartDialog.dismiss();
    }
  }

  bool network = false;
  final GlobalKey<FormState> _key1 = GlobalKey<FormState>();
  final CountdownController _controller =
      new CountdownController(autoStart: true);
  @override
  Widget build(BuildContext context) {
      if (Provider.of<ConnectivityStatus>(context) ==
        ConnectivityStatus.Offline) {
      showoverlay();
    } else {
      SmartDialog.dismiss(tag: 'network');
    }
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).primaryColorDark),
        title: Text('Set New Password'),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: ListView(
          children: [
            Form(
                key: _key1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Enter the OTP sent to your email, and create a new password',
                      style:
                          TextStyle(fontSize: 19, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'One Time Password:',
                      style:
                          TextStyle(fontSize: 19, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      onChanged: (value) {
                        setState(() {
                          otp = value;
                        });
                      },
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        errorBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 1.0),
                        ),
                        focusedErrorBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 1.7),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 70, 70, 70),
                              width: 1.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 70, 70, 70),
                              width: 1.7),
                        ),
                        hintText: 'Enter Your OTP',
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'New Password:',
                      style:
                          TextStyle(fontSize: 19, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      onChanged: (value) {
                        setState(() {
                          password = value;
                        });
                      },
                      obscureText: passobscure,
                      validator: _validatePassword,
                      decoration: InputDecoration(
                        errorBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 1.0),
                        ),
                        focusedErrorBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 1.7),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 70, 70, 70),
                              width: 1.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 70, 70, 70),
                              width: 1.7),
                        ),
                        hintText: 'Enter new password',
                        suffixIcon: InkWell(
                          onTap: () {
                            setState(() {
                              passobscure = !passobscure;
                            });
                          },
                          child: passobscure
                              ? Icon(Icons.visibility_off)
                              : Icon(Icons.visibility),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Confirm new pasword:',
                      style:
                          TextStyle(fontSize: 19, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      onChanged: (value) {
                        setState(() {
                          confirmPass = value;
                        });
                      },
                      validator: _validateCPassword,
                      obscureText: cpassobscure,
                      decoration: InputDecoration(
                        errorBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 1.0),
                        ),
                        focusedErrorBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 1.7),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 70, 70, 70),
                              width: 1.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 70, 70, 70),
                              width: 1.7),
                        ),
                        hintText: 'Enter new password',
                        suffixIcon: InkWell(
                          onTap: () {
                            setState(() {
                              cpassobscure = !cpassobscure;
                            });
                          },
                          child: cpassobscure
                              ? Icon(Icons.visibility_off)
                              : Icon(Icons.visibility),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                )),
            SizedBox(
              height: 20,
            ),
            Text(
              "Didn't you receive any code?",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
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
                        textAlign: TextAlign.center,
                      );
                    },
                    onFinished: () {
                      setState(() {
                        finish = true;
                      });
                    },
                  ),
            SizedBox(
              height: 18,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              height: 50,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Theme.of(context).primaryColor.withOpacity(.7)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  )),
                ),
                onPressed: () {
                  recoverpassword();
                },
                child: Text(
                  'Change Password',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String? _validatePassword(String? value) {
    if (value!.length == 0) {
      return "Please Input a Password";
    } else if (value.length < 8) {
      return "Password Must be more that 7 Characters";
    } else {
      return null;
    }
  }

  String? _validateCPassword(String? value) {
    if (value!.length == 0) {
      return "Please Input a Password";
    } else if (password != confirmPass) {
      return "Password Does not match";
    } else {
      return null;
    }
  }

  void recoverpassword() async {
    if (_key1.currentState!.validate()) {
      await confirmpassword();
      if (success == 'false') {
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
      } else if (success == 'true') {
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
