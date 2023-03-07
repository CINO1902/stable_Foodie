// ignore_for_file: depend_on_referenced_packages

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_launcher_icons/ios.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foodie_ios/linkfile/customesnackbar.dart';
import 'package:foodie_ios/linkfile/enum/connectivity_status.dart';
import 'package:foodie_ios/linkfile/provider/checkcart.dart';
import 'package:foodie_ios/linkfile/provider/internetchecker.dart';
import 'package:foodie_ios/linkfile/provider/onboarding.dart';
import 'package:foodie_ios/linkfile/provider/subscribed.dart';
import 'package:foodie_ios/page/landingpage.dart';
import 'package:foodie_ios/page/overlay.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;
import 'package:url_launcher/url_launcher.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  bool network = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Help'),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: context.watch<checkstate>().checkregisteredlogg()
            ? SingleChildScrollView(
                child: Container(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 15),
                        child: Card(
                          elevation: 2.5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          color: Theme.of(context).colorScheme.primaryContainer,
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.09,
                            width: double.infinity,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: CircleAvatar(
                                        radius:
                                            MediaQuery.of(context).size.height *
                                                0.032,
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                            margin: EdgeInsets.only(
                                              // horizontal: MediaQuery.of(context).size.height * 0.01,
                                              top: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.03,
                                            ),
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.029,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.2,
                                            child: FittedBox(
                                                child: Text(
                                              '${context.watch<checkstate>().firstname} ${context.watch<checkstate>().lastname}',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ))),
                                        Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.03,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.25,
                                            child: context
                                                    .watch<checkstate>()
                                                    .verified
                                                ? const Text('Verified',
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            Colors.greenAccent))
                                                : const Text('Not Verified',
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            Colors.yellowAccent,
                                                        shadows: [
                                                          Shadow(
                                                              // bottomLeft
                                                              offset: Offset(
                                                                  -0.5, -0.5),
                                                              color:
                                                                  Colors.black),
                                                          Shadow(
                                                              // bottomRight
                                                              offset: Offset(
                                                                  0.5, -0.5),
                                                              color:
                                                                  Colors.black),
                                                          Shadow(
                                                              // topRight
                                                              offset: Offset(
                                                                  0.5, 0.5),
                                                              color:
                                                                  Colors.black),
                                                          Shadow(
                                                              // topLeft
                                                              offset: Offset(
                                                                  -0.5, 0.5),
                                                              color:
                                                                  Colors.black),
                                                        ])))
                                      ],
                                    ),
                                  ],
                                ),
                                Container(
                                    margin: EdgeInsets.symmetric(
                                      // horizontal: MediaQuery.of(context).size.height * 0.01,
                                      vertical:
                                          MediaQuery.of(context).size.width *
                                              0.03,
                                    ),
                                    height: MediaQuery.of(context).size.height *
                                        0.023,
                                    width: MediaQuery.of(context).size.width *
                                        0.25,
                                    child: FittedBox(
                                        child: Text(
                                      '',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface),
                                    ))),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.03,
                      ),
                      Center(
                        child: InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, '/myaccount');
                          },
                          child: buttonprofile(
                            title: 'My Account',
                            icon: Icon(
                              Icons.person,
                              size: 30,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.015,
                      ),
                      Center(
                        child: InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, '/notifications');
                          },
                          child: buttonprofile(
                            title: 'Notifications',
                            icon: Icon(
                              Icons.notifications,
                              size: 30,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.015,
                      ),
                      Center(
                        child: InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, '/theme');
                          },
                          child: buttonprofile(
                            title: 'Theme',
                            icon: Icon(
                              Icons.settings,
                              size: 30,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.015,
                      ),
                      Center(
                        child: InkWell(
                          onTap: () => whatsapp(),
                          child: buttonprofile(
                            title: 'Help Center',
                            icon: Icon(
                              Icons.question_mark_outlined,
                              size: 30,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.015,
                      ),
                      Center(
                        child: InkWell(
                          onTap: () async {
                            SmartDialog.showLoading();
                            context.read<checkstate>().logout();
                            context.read<checkcart>().loggout();
                            context.read<subscribed>().getsubscribed();

                            Navigator.pushNamedAndRemoveUntil(
                                context, '/landingpage', (route) => false);
                            SmartDialog.dismiss();
                          },
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.09,
                            width: MediaQuery.of(context).size.width * 0.9,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                                borderRadius: BorderRadius.circular(10)),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.08,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.08,
                                        child: Transform.rotate(
                                            angle: 100 * math.pi / 100,
                                            child: SvgPicture.asset(
                                              'images/log-out.svg',
                                              color: Colors.red,
                                            )),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Container(
                                        child: const Text(
                                          'Log Out',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.red),
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
                      )
                    ])),
              )
            : SingleChildScrollView(
                child: Container(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.03,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, '/register');
                        },
                        child: Container(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.05),
                          child: Center(
                            child: Column(
                              children: [
                                SvgPicture.asset("images/profile.svg",
                                    height: 95,
                                    width: 95,
                                    color: Colors.black.withOpacity(.6)),
                                SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.06,
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
                                    child: const FittedBox(
                                        child: Text(
                                      'Log In / Register',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )))
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.015,
                      ),
                      Center(
                        child: InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, '/theme');
                          },
                          child: buttonprofile(
                            title: 'Theme',
                            icon: Icon(
                              Icons.settings,
                              size: 30,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.015,
                      ),
                      Center(
                        child: InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, '/notifications');
                          },
                          child: buttonprofile(
                            title: 'Notifications',
                            icon: Icon(
                              Icons.notifications,
                              size: 30,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.015,
                      ),
                      Center(
                        child: InkWell(
                          onTap: () => whatsapp(),
                          child: buttonprofile(
                            title: 'Help Center',
                            icon: Icon(
                              Icons.question_mark_outlined,
                              size: 30,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.015,
                      ),
                    ])),
              ));
  }

  whatsapp() async {
    var contact = "+2348075489359";
    var androidUrl = "whatsapp://send?phone=$contact&text=Hi, I need some help";
    var iosUrl =
        "https://wa.me/$contact?text=${Uri.parse('Hi, I need some help')}";

    try {
      if (Platform.isIOS) {
        if (await canLaunchUrl(Uri.parse(iosUrl))) {
          await launchUrl(Uri.parse(iosUrl));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: CustomeSnackbar(
              topic: 'Oh Snap!',
              msg: 'Something went wrong',
              color1: const Color.fromARGB(255, 171, 51, 42),
              color2: const Color.fromARGB(255, 127, 39, 33),
            ),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            elevation: 0,
          ));
        }
      } else {
        if (await canLaunchUrl(Uri.parse(androidUrl))) {
          await launchUrl(Uri.parse(androidUrl));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: CustomeSnackbar(
              topic: 'Oh Snap!',
              msg: 'Something went wrong',
              color1: const Color.fromARGB(255, 171, 51, 42),
              color2: const Color.fromARGB(255, 127, 39, 33),
            ),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            elevation: 0,
          ));
        }
      }
    } on Exception {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: CustomeSnackbar(
          topic: 'Oh Snap!',
          msg: 'Whatsapp is not installed',
          color1: const Color.fromARGB(255, 171, 51, 42),
          color2: const Color.fromARGB(255, 127, 39, 33),
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ));
    }
  }
}

class buttonprofile extends StatelessWidget {
  buttonprofile({
    Key? key,
    required this.title,
    required this.icon,
  }) : super(key: key);

  final String title;
  final Icon icon;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.09,
      width: MediaQuery.of(context).size.width * 0.9,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(10)),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Row(
          children: [
            SizedBox(child: icon),
            const SizedBox(
              width: 10,
            ),
            Container(
              child: Text(
                title,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
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
    );
  }
}
