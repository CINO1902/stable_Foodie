// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_launcher_icons/ios.dart';
import 'package:flutter_native_splash/cli_commands.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart' as Svg;
import 'package:foodie_ios/linkfile/customesnackbar.dart';
import 'package:foodie_ios/linkfile/enum/connectivity_status.dart';
import 'package:foodie_ios/linkfile/provider/checkcart.dart';
import 'package:foodie_ios/linkfile/provider/internetchecker.dart';
import 'package:foodie_ios/linkfile/provider/onboarding.dart';
import 'package:foodie_ios/linkfile/provider/subscribed.dart';
import 'package:foodie_ios/page/addperaddress.dart';
import 'package:foodie_ios/page/landingpage.dart';
import 'package:foodie_ios/page/overlay.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;
import 'package:url_launcher/url_launcher.dart';
import 'package:foodie_ios/linkfile/networkhandler.dart';

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
        body: context.watch<checkstate>().checkregisteredlogg()
            ? SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: Svg.Svg('images/svg/Pattern-7.svg',
                                size: Size(400, 200)),
                            colorFilter: ColorFilter.mode(
                              Theme.of(context).primaryColorLight,
                              BlendMode.difference,
                            ),
                          ),
                        ),
                        padding: EdgeInsets.only(bottom: 20),
                        child: SafeArea(
                          top: true,
                          bottom: false,
                          maintainBottomViewPadding: false,
                          child: Center(
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: CircleAvatar(
                                    radius: MediaQuery.of(context).size.height *
                                        0.052,
                                    child: SvgPicture.asset(
                                        "images/svg/Vector-4.svg",
                                        height: 45,
                                        width: 45,
                                        color: Theme.of(context)
                                            .primaryColorLight),
                                  ),
                                ),
                                Container(
                                    // color: Colors.red,
                                    margin: EdgeInsets.only(
                                      // horizontal: MediaQuery.of(context).size.height * 0.01,
                                      top: MediaQuery.of(context).size.width *
                                          0.03,
                                    ),
                                    height: MediaQuery.of(context).size.height *
                                        0.029,
                                    width: MediaQuery.of(context).size.width *
                                        0.95,
                                    child: Text(
                                      context.watch<checkstate>().firstname !=
                                              ''
                                          ? '${context.watch<checkstate>().firstname.capitalize()} ${context.watch<checkstate>().lastname.capitalize()}'
                                          : '',
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 19),
                                    )),
                                context.watch<checkstate>().verified
                                    ? Container(
                                        height: 30,
                                        width: 140,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        decoration: BoxDecoration(
                                            color:
                                                Theme.of(context).primaryColor,
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              SvgPicture.asset(
                                                  'images/svg/Vector-5.svg'),
                                              const Text('Verified User',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white)),
                                            ],
                                          ),
                                        ),
                                      )
                                    : Container(
                                        height: 30,
                                        width: 120,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        decoration: BoxDecoration(
                                            color: Colors.yellow,
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: const Text('Not Verified',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white)),
                                        ),
                                      )
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
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => addAddressper()));
                          },
                          child: buttonprofile(
                            title: 'Delivery Details',
                            icon: SizedBox(
                                child: SvgPicture.asset(
                                    'images/svg/carbon_delivery.svg')),
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
                            icon: SizedBox(
                                child: SvgPicture.asset(
                                    'images/svg/Vector-7.svg')),
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
                            icon: SizedBox(
                                child: SvgPicture.asset(
                                    'images/svg/arcticons_nightmode.svg')),
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
                            icon: SizedBox(
                                child: SvgPicture.asset(
                                    'images/svg/Vector-8.svg')),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.015,
                      ),
                      Center(
                        child: InkWell(
                          onTap: () async {
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.warning,
                              headerAnimationLoop: false,
                              animType: AnimType.topSlide,
                              title: 'Warning',
                              desc:
                                  'This action would Log you out of your account',
                              btnCancelOnPress: () {},
                              onDismissCallback: (type) {},
                              btnOkOnPress: () async {
                                SmartDialog.showLoading();
                                await deleteaccount();

                                SmartDialog.showLoading();
                                context.read<checkstate>().logout();
                                context.read<checkcart>().loggout();
                                context.read<subscribed>().getsubscribed();

                                Navigator.pushNamedAndRemoveUntil(
                                    context, '/landingpage', (route) => false);
                                SmartDialog.dismiss();
                              },
                            ).show();
                          },
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.05,
                            width: MediaQuery.of(context).size.width * 0.85,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                                borderRadius: BorderRadius.circular(25)),
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
                                      child: SvgPicture.asset(
                                          'images/svg/Vector-6.svg')),
                                ]),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.025,
                      ),
                      Center(
                        child: InkWell(
                          onTap: () async {
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.warning,
                              headerAnimationLoop: false,
                              animType: AnimType.topSlide,
                              title: 'Warning',
                              desc:
                                  'This action would delete all your record with Foodie',
                              btnCancelOnPress: () {},
                              onDismissCallback: (type) {},
                              btnOkOnPress: () async {
                                SmartDialog.showLoading();
                                await deleteaccount();

                                if (success == 'fail') {
                                  SmartDialog.dismiss();
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
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
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
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

                                  Navigator.pushNamedAndRemoveUntil(context,
                                      '/landingpage', (route) => false);
                                }
                              },
                            ).show();
                          },
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.05,
                            width: MediaQuery.of(context).size.width * 0.85,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                                borderRadius: BorderRadius.circular(25)),
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
                                              'images/svg/cancel1.svg',
                                              color: Colors.red,
                                            )),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Container(
                                        child: const Text(
                                          'Close Account',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.red),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                      child: SvgPicture.asset(
                                          'images/svg/Vector-6.svg')),
                                ]),
                          ),
                        ),
                      ),
                    ]),
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
                          Navigator.pushNamed(context, '/login');
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: Svg.Svg('images/svg/Pattern-7.svg',
                                  size: Size(400, 200)),
                              colorFilter: ColorFilter.mode(
                                Theme.of(context).primaryColorLight,
                                BlendMode.difference,
                              ),
                            ),
                          ),
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.05),
                          child: Center(
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: CircleAvatar(
                                    radius: MediaQuery.of(context).size.height *
                                        0.052,
                                    child: SvgPicture.asset(
                                        "images/svg/Vector-4.svg",
                                        height: 45,
                                        width: 45,
                                        color: Theme.of(context)
                                            .primaryColorLight
                                            .withOpacity(.6)),
                                  ),
                                ),
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
    var iosUrl = "https://wa.me/$contact?text=Hi, I need some help";

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
  final Widget icon;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.055,
      width: MediaQuery.of(context).size.width * 0.85,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(25)),
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
        SizedBox(child: SvgPicture.asset('images/svg/Vector-6.svg')),
      ]),
    );
  }
}
