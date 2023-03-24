import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:foodie_ios/linkfile/customesnackbar.dart';
import 'package:foodie_ios/linkfile/enum/connectivity_status.dart';
import 'package:foodie_ios/linkfile/provider/checkcart.dart';
import 'package:foodie_ios/linkfile/provider/internetchecker.dart';
import 'package:foodie_ios/linkfile/provider/onboarding.dart';
import 'package:foodie_ios/linkfile/provider/subscribed.dart';
import 'package:foodie_ios/page/addnewaddress.dart';
import 'package:foodie_ios/page/addperaddress.dart';
import 'package:foodie_ios/page/otpverify.dart';
import 'package:foodie_ios/page/overlay.dart';
import 'package:provider/provider.dart';
import 'package:foodie_ios/linkfile/networkhandler.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class myaccount extends StatefulWidget {
  const myaccount({super.key});

  @override
  State<myaccount> createState() => _myaccountState();
}

class _myaccountState extends State<myaccount> {
  String? address;
  bool network = false;
  String success = '';
  String msg = '';
  bool loading = true;
  Future<void> deleteaccount() async {
    print(Provider.of<checkstate>(context, listen: false).email);
    try {
      setState(() {
        loading = true;
      });

      var response = await networkHandler.client.post(
          networkHandler.builderUrl('/deleteaccount'),
          body: jsonEncode(<String, String>{
            'email': Provider.of<checkstate>(context, listen: false).email
          }),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          });

      final decodedresponse = jsonDecode(response.body);
      setState(() {
        msg = decodedresponse['msg'];
        success = decodedresponse['success'];
      });
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Account Details'),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            SizedBox(
              height: 20,
            ),
            Center(
              child: Container(
                child: CircleAvatar(
                  radius: MediaQuery.of(context).size.height * 0.06,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.03,
              width: MediaQuery.of(context).size.height * 0.5,
              child: FittedBox(
                child: Text(
                  '${context.watch<checkstate>().lastname.toUpperCase()}, ${context.watch<checkstate>().firstname.toUpperCase()}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.015,
            ),
            Center(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.09,
                width: MediaQuery.of(context).size.width * 0.9,
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.03,
                    vertical: MediaQuery.of(context).size.height * 0.01),
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.04,
                                width: MediaQuery.of(context).size.width * 0.4,
                                child: FittedBox(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    '${context.watch<checkstate>().lastname.toUpperCase()}, ${context.watch<checkstate>().firstname.toUpperCase()}',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w800),
                                  ),
                                ),
                              ),
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.02,
                                width: MediaQuery.of(context).size.width * 0.3,
                                child: FittedBox(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Account Name',
                                    style: TextStyle(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                          child: Icon(
                        Icons.forward,
                        size: 30,
                        color: Theme.of(context).primaryColor,
                      )),
                    ]),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Center(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.09,
                width: MediaQuery.of(context).size.width * 0.9,
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.03,
                    vertical: MediaQuery.of(context).size.height * 0.01),
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.04,
                                width: MediaQuery.of(context).size.width * 0.4,
                                child: FittedBox(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    '+234 ${context.watch<checkstate>().phone.substring(1)}',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w800),
                                  ),
                                ),
                              ),
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.02,
                                width: MediaQuery.of(context).size.width * 0.3,
                                child: FittedBox(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Phone Number',
                                    style: TextStyle(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                          child: Icon(
                        Icons.forward,
                        size: 30,
                        color: Theme.of(context).primaryColor,
                      )),
                    ]),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () {
                verifymail();
              },
              child: Center(
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.09,
                  width: MediaQuery.of(context).size.width * 0.9,
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.03,
                      vertical: MediaQuery.of(context).size.height * 0.01),
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.04,
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  child: FittedBox(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      '${context.watch<checkstate>().email}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w800),
                                    ),
                                  ),
                                ),
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.02,
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  child: context.watch<checkstate>().verified
                                      ? Text(
                                          'Email Address',
                                          style: TextStyle(),
                                        )
                                      : RichText(
                                          text: TextSpan(
                                            text: 'Email Address ',
                                            style: DefaultTextStyle.of(context)
                                                .style,
                                            children: const <TextSpan>[
                                              TextSpan(
                                                  text: '(Not verified)',
                                                  style: TextStyle(
                                                      color: Colors.red)),
                                            ],
                                          ),
                                        ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                            child: Icon(
                          Icons.forward,
                          size: 30,
                          color: Theme.of(context).primaryColor,
                        )),
                      ]),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => addAddressper()));
              },
              child: Center(
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.09,
                  width: MediaQuery.of(context).size.width * 0.9,
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.03,
                      vertical: MediaQuery.of(context).size.height * 0.01),
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.04,
                                  width:
                                      MediaQuery.of(context).size.width * 0.7,
                                  child: Text(
                                    context.watch<checkstate>().address,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 19),
                                  ),
                                ),
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.02,
                                  width:
                                      MediaQuery.of(context).size.width * 0.3,
                                  child: FittedBox(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Address',
                                      style: TextStyle(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                            child: Icon(
                          Icons.forward,
                          size: 30,
                          color: Theme.of(context).primaryColor,
                        )),
                      ]),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () async {
                AwesomeDialog(
                  context: context,
                  dialogType: DialogType.warning,
                  headerAnimationLoop: false,
                  animType: AnimType.topSlide,
                  title: 'Warning',
                  desc: 'This action would delete all your record with Foodie',
                  btnCancelOnPress: () {},
                  onDismissCallback: (type) {},
                  btnOkOnPress: () async {
                    SmartDialog.showLoading();
                    await deleteaccount();

                    if (success == 'fail') {
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
                    } else if (success == 'success') {
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
                      context.read<checkstate>().logout();
                      context.read<checkcart>().loggout();
                      context.read<subscribed>().getsubscribed();

                      Navigator.pushNamedAndRemoveUntil(
                          context, '/landingpage', (route) => false);
                    }
                  },
                ).show();
              },
              child: Center(
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.09,
                  width: MediaQuery.of(context).size.width * 0.9,
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.03,
                      vertical: MediaQuery.of(context).size.height * 0.01),
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height:
                                  MediaQuery.of(context).size.height * 0.04,
                              width:
                                  MediaQuery.of(context).size.width * 0.3,
                              child: FittedBox(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Close Account',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      color: Colors.red),
                                ),
                              ),
                            ),
                            Container(
                              height:
                                  MediaQuery.of(context).size.height * 0.02,
                              width:
                                  MediaQuery.of(context).size.width * 0.4,
                              child: FittedBox(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Delete your Foodie Account',
                                  style: TextStyle(),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                            child: Icon(
                          Icons.forward,
                          size: 30,
                          color: Theme.of(context).primaryColor,
                        )),
                      ]),
                ),
              ),
            ),
          ]),
        ));
  }

  void modalbox(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Consumer<checkstate>(builder: (context, value, child) {
            return AlertDialog(
              content: Stack(
                alignment: AlignmentDirectional.center,
                clipBehavior: Clip.none,
                children: <Widget>[
                  Positioned(
                    top: -MediaQuery.of(context).size.height * 0.07,
                    child: InkResponse(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: Colors.white, width: 3),
                          color: Colors.red,
                        ),
                        child: const Icon(Icons.location_on),
                      ),
                    ),
                  ),
                  Form(
                    //key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Enter Address:',
                                style: TextStyle(fontSize: 15),
                              ),
                              SizedBox(
                                height: 75,
                                width: MediaQuery.of(context).size.width * 0.6,
                                child: TextFormField(
                                  onChanged: (value) {
                                    setState(() {
                                      address = value;
                                    });
                                  },
                                  initialValue:
                                      context.watch<checkstate>().address,
                                  autocorrect: false,
                                  decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.black))),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            child: const Text("Submit"),
                            onPressed: () async {
                              // Navigator.of(context).pop();

                              SmartDialog.showLoading();
                              // await context
                              //     .read<checkstate>()
                              //     .changeadress(address);

                              if (value.success == true) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: CustomeSnackbar(
                                    topic: 'Great!',
                                    msg: value.msg,
                                    color1:
                                        const Color.fromARGB(255, 25, 107, 52),
                                    color2:
                                        const Color.fromARGB(255, 19, 95, 40),
                                  ),
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: Colors.transparent,
                                  elevation: 0,
                                ));
                              } else if (value.success == false) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: CustomeSnackbar(
                                    topic: 'Oh Snap!',
                                    msg: value.msg,
                                    color1:
                                        const Color.fromARGB(255, 171, 51, 42),
                                    color2:
                                        const Color.fromARGB(255, 127, 39, 33),
                                  ),
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: Colors.transparent,
                                  elevation: 0,
                                ));
                              }
                              SmartDialog.dismiss();
                              Navigator.of(context).pop();
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          });
        });
  }

  void verifymail() {
    if (Provider.of<checkstate>(context, listen: false).verified == true) {
      SmartDialog.showToast('Account already Verified');
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Otp(
                    email: context.watch<checkstate>().email,
                  )));
    }
  }
}
