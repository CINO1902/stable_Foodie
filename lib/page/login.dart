import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

import 'package:foodie_ios/linkfile/Model/loginModel.dart';
import 'package:foodie_ios/linkfile/enum/connectivity_status.dart';
import 'package:foodie_ios/linkfile/provider/internetchecker.dart';
import 'package:foodie_ios/linkfile/provider/onboarding.dart';
import 'package:foodie_ios/page/overlay.dart';

import 'package:provider/provider.dart';
import 'package:foodie_ios/linkfile/networkhandler.dart';
import 'package:foodie_ios/linkfile/customesnackbar.dart';
import 'package:foodie_ios/linkfile/provider/subscribed.dart';
import 'package:foodie_ios/page/landingpage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  final GlobalKey<FormState> _key1 = GlobalKey<FormState>();
  bool passobscure = true;
  String email = '';
  String pass = '';
  String success = '';
  String msg = '';
  String token = '';
  bool subscribe = false;

  Future<void> login() async {
    LoginModel login = LoginModel(email: email, password: pass);

    try {
      SmartDialog.showLoading();
      var response = await networkHandler.client.post(
          networkHandler.builderUrl('/login'),
          body: loginModelToJson(login),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          });

      final decodedresponse = jsonDecode(response.body);
      setState(() {
        success = decodedresponse['success'];
        msg = decodedresponse['msg'];
      });

      final prefs = await SharedPreferences.getInstance();

      if (success == 'true') {
        token = decodedresponse['token'];
        subscribe = decodedresponse['subscribe'];
        final ref = decodedresponse['ref'];
        await prefs.setInt('loggedstamp', ref);
        await prefs.setString('tokenregistered', token);
        await prefs.setBool('subscribed', subscribe);
        await context.read<checkstate>().getregisterdID();
        await context.read<subscribed>().getsubscribed();
      }
    } catch (e) {
      print(e);
      setState(() {
        success = 'fail';
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
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).primaryColorDark),
        title: Text(
          'Login',
          style: TextStyle(color: Theme.of(context).primaryColorDark),
        ),
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
                      'Email Address:',
                      style:
                          TextStyle(fontSize: 19, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      onChanged: (value) {
                        setState(() {
                          email = value;
                        });
                      },
                      keyboardType: TextInputType.emailAddress,
                      validator: _validateEmail,
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
                        hintText: 'Enter Your Email Address',
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Password:',
                          style: TextStyle(
                              fontSize: 19, fontWeight: FontWeight.w500),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, '/forgotpassword');
                          },
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      onChanged: (value) {
                        setState(() {
                          pass = value;
                        });
                      },
                      validator: _validatePassword,
                      obscureText: passobscure,
                      decoration: InputDecoration(
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
                        hintText: 'Choose a password',
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                )),
            SizedBox(
              height: 20,
            ),
            Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'New to Foodie? ',
                  style: TextStyle(fontSize: 19),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, '/register');
                  },
                  child: Text(
                    'Create an account',
                    style: TextStyle(
                        fontSize: 19,
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            )),
            SizedBox(
              height: 20,
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
                  _sendToServer();
                },
                child: Text(
                  'Sign In',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String? _validateEmail(String? value) {
    RegExp regex = new RegExp('[a-z0-9]+@[a-z]+\.[a-z]{2,3}.com');
    if (value!.length == 0) {
      return "Please Input a Email";
    } else if (!regex.hasMatch(value)) {
      return "Must Be a valid email";
    } else {
      return null;
    }
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

  _sendToServer() async {
    if (_key1.currentState!.validate()) {
      _key1.currentState!.save();
      print(email);
      print(pass);
      await login();
      if (success == 'false') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: CustomeSnackbar(
            topic: 'Oh Snap!',
            msg: msg,
            color1: Color.fromARGB(255, 171, 51, 42),
            color2: Color.fromARGB(255, 127, 39, 33),
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ));
      } else if ((success == 'true')) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) => const homelanding(),
            ),
            (Route<dynamic> route) => false);
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
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: CustomeSnackbar(
            topic: 'Oh Snap!',
            msg: 'Something Went wrong',
            color1: Color.fromARGB(255, 171, 51, 42),
            color2: Color.fromARGB(255, 127, 39, 33),
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: CustomeSnackbar(
          topic: 'Oh Snap!',
          msg: 'Please Fill Out all fields',
          color1: Color.fromARGB(255, 171, 51, 42),
          color2: Color.fromARGB(255, 127, 39, 33),
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ));
    }
  }
}
