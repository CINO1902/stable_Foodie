import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_svg/svg.dart';
import 'package:foodie_ios/linkfile/Model/registerModel.dart';
import 'package:foodie_ios/linkfile/enum/connectivity_status.dart';
import 'dart:math' as math;
import 'package:foodie_ios/linkfile/networkhandler.dart';
import 'package:foodie_ios/linkfile/customesnackbar.dart';
import 'package:foodie_ios/linkfile/provider/internetchecker.dart';
import 'package:foodie_ios/page/otpverify.dart';
import 'package:foodie_ios/page/overlay.dart';
import 'package:provider/provider.dart';

class register extends StatefulWidget {
  const register({super.key});

  @override
  State<register> createState() => _registerState();
}

class _registerState extends State<register> {
  String? pass;
  String referee = '';
  String? confirmPass;
  bool visible = false;
  String? firstname;
  String? lastname;
  String? success;
  String msg = '';
  String? email;
  String? phone;
  bool passobscure = true;
  bool cpassobscure = true;
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  Future<void> register() async {
    Register register = Register(
        firstname: firstname,
        lastname: lastname,
        email: email,
        phone: phone,
        referee: referee,
        password: pass);

    try {
      var response = await networkHandler.client.post(
          networkHandler.builderUrl('/register'),
          body: registerToJson(register),
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

  Future<void> checkreferal() async {
    try {
      var response = await networkHandler.client.post(
          networkHandler.builderUrl('/checkreferal'),
          body: jsonEncode(<String, String>{'referee': referee}),
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
          'Create an Account',
          style: TextStyle(color: Theme.of(context).primaryColorDark),
        ),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: ListView(
          children: [
            Form(
                key: _key,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'First Name:',
                      style:
                          TextStyle(fontSize: 19, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      onChanged: (value) {
                        setState(() {
                          firstname = value;
                        });
                      },
                      validator: _validateFName,
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
                        hintText: 'Enter Your first name here',
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Last Name:',
                      style:
                          TextStyle(fontSize: 19, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      onChanged: (value) {
                        setState(() {
                          lastname = value;
                        });
                      },
                      validator: _validateLName,
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
                        hintText: 'Enter Your last name here',
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Phone Number:',
                      style:
                          TextStyle(fontSize: 19, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      onChanged: (value) {
                        setState(() {
                          phone = value;
                        });
                      },
                      keyboardType: TextInputType.phone,
                      validator: _validatephone,
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
                        hintText: 'Enter Your Phone Number',
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
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
                    Text(
                      'Password:',
                      style:
                          TextStyle(fontSize: 19, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      validator: _validatePassword,
                      onChanged: (value) {
                        setState(() {
                          pass = value;
                        });
                      },
                      obscureText: passobscure,
                      decoration: InputDecoration(
                        suffixIcon: InkWell(
                          onTap: () {
                            setState(() {
                              passobscure = !passobscure;
                            });
                          },
                          child: passobscure
                              ? Icon(
                                  Icons.visibility_off,
                                  color: Theme.of(context).primaryColor,
                                )
                              : Icon(
                                  Icons.visibility,
                                  color: Theme.of(context).primaryColor,
                                ),
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
                      height: 20,
                    ),
                    Text(
                      'Confirm Password:',
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
                      obscureText: cpassobscure,
                      validator: _validateCPassword,
                      decoration: InputDecoration(
                        suffixIcon: InkWell(
                          onTap: () {
                            setState(() {
                              cpassobscure = !cpassobscure;
                            });
                          },
                          child: cpassobscure
                              ? Icon(
                                  Icons.visibility_off,
                                  color: Theme.of(context).primaryColor,
                                )
                              : Icon(
                                  Icons.visibility,
                                  color: Theme.of(context).primaryColor,
                                ),
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
                        hintText: 'Enter your password again',
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          visible = !visible;
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Referal ID(Optional):',
                            style: TextStyle(
                                fontSize: 19, fontWeight: FontWeight.w500),
                          ),
                          visible
                              ? Transform.rotate(
                                  angle: 180 * math.pi / 180,
                                  child: SvgPicture.asset(
                                    'images/arrow.svg',
                                    height: 15,
                                    width: 40,
                                  ),
                                )
                              : SvgPicture.asset(
                                  'images/arrow.svg',
                                  height: 15,
                                  width: 40,
                                )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Visibility(
                      visible: visible,
                      child: TextFormField(
                        onChanged: (value) {
                          setState(() {
                            referee = value;
                          });
                        },
                        decoration: InputDecoration(
                          errorBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.red, width: 1.0),
                          ),
                          focusedErrorBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.red, width: 1.7),
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
                          hintText: 'Enter Referal ID',
                        ),
                      ),
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
                  'Already have an account? ',
                  style: TextStyle(fontSize: 19),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  child: Text(
                    'Log In',
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
                  'Sign Up',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String? _validateFName(String? value) {
    if (value!.length == 0) {
      return "Please Input Your First Name";
    } else {
      return null;
    }
  }

  String? _validateLName(String? value) {
    if (value!.length == 0) {
      return "Please Input Your Last Name";
    } else {
      return null;
    }
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

  String? _validateCPassword(String? value) {
    if (value!.length == 0) {
      return "Please Input a Password";
    } else if (pass != confirmPass) {
      return "Password Does not match";
    } else {
      return null;
    }
  }

  String? _validatephone(String? value) {
    if (value!.length != 11) {
      return "Must be Eleven digits";
    } else {
      return null;
    }
  }

  _sendToServer() async {
    if (_key.currentState!.validate()) {
      _key.currentState!.save();
      SmartDialog.showLoading();
      if (referee != '') {
        await checkreferal();
        if (success == 'true') {
          await register();
        } else {
          SmartDialog.dismiss();
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
        }
      } else {
        await register();
      }

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
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Otp(
                      email: email,
                    )));
      }
      SmartDialog.dismiss();
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
