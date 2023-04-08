import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:foodie_ios/linkfile/Model/mostcommon.dart';
import 'package:foodie_ios/linkfile/Model/subcart.dart';
import 'package:foodie_ios/linkfile/Model/submitsuborder.dart';
import 'package:foodie_ios/linkfile/customesnackbar.dart';
import 'package:foodie_ios/linkfile/enum/connectivity_status.dart';
import 'package:foodie_ios/linkfile/networkhandler.dart';
import 'package:foodie_ios/linkfile/cartbox.dart';
import 'package:foodie_ios/linkfile/provider/checkcart.dart';
import 'package:foodie_ios/linkfile/provider/internetchecker.dart';
import 'package:foodie_ios/linkfile/provider/mostcommon.dart';
import 'package:foodie_ios/linkfile/provider/onboarding.dart';
import 'package:foodie_ios/page/addnewaddress.dart';
import 'package:foodie_ios/page/landingpage.dart';
import 'package:foodie_ios/page/overlay.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class confirmsuborder extends StatefulWidget {
  const confirmsuborder({
    super.key,
  });

  @override
  State<confirmsuborder> createState() => _confirmsuborderState();
}

class _confirmsuborderState extends State<confirmsuborder> {
  String getclass(catergory) {
    switch (catergory) {
      case "1":
        return 'Sapa';
      case "2":
        return 'Long Throat';
      case '3':
        return 'Odogwu';
      case '4':
        return 'Drinks';
      default:
        return '';
    }
  }

  List<Detail> subcart = [];
  String msg = '';
  String success = '';
  Future<void> sendsuborder() async {
    final pref = await SharedPreferences.getInstance();
    String email = pref.getString('email') ?? '';

    String addressget() {
      String add = '';
      if (Provider.of<checkcart>(context, listen: false).usedefault == true) {
        setState(() {
          add = Provider.of<checkstate>(context, listen: false).address;
        });
      } else if (Provider.of<checkcart>(context, listen: false).usedefault ==
          false) {
        setState(() {
          add = Provider.of<checkcart>(context, listen: false).address;
        });
      }
      return add;
    }

    String number() {
      String add = '';
      if (Provider.of<checkcart>(context, listen: false).usedefault == true) {
        setState(() {
          add = Provider.of<checkstate>(context, listen: false).phone;
        });
      } else if (Provider.of<checkcart>(context, listen: false).usedefault ==
          false) {
        setState(() {
          add = Provider.of<checkcart>(context, listen: false).number;
        });
      }
      return add;
    }

    String name() {
      String add = '';
      if (Provider.of<checkcart>(context, listen: false).usedefault == true) {
        setState(() {
          add = Provider.of<checkstate>(context, listen: false).firstname;
        });
      } else if (Provider.of<checkcart>(context, listen: false).usedefault ==
          false) {
        setState(() {
          add = Provider.of<checkcart>(context, listen: false).fullname;
        });
      }
      return add;
    }

    String getlocation() {
      String add = '';
      if (Provider.of<checkcart>(context, listen: false).usedefault == true) {
        setState(() {
          add = Provider.of<checkstate>(context, listen: false).location;
        });
      } else if (Provider.of<checkcart>(context, listen: false).usedefault ==
          false) {
        setState(() {
          add = Provider.of<checkcart>(context, listen: false).location;
        });
      }
      return add;
    }

    SmartDialog.showLoading();

    try {
      Submitsuborder fetch = Submitsuborder(
        email: email,
        phone: number(),
        name: name(),
        location: getlocation(),
        address: addressget(),
      );
      var response = await networkHandler.client.post(
          networkHandler.builderUrl('/ordersub'),
          body: submitsuborderToJson(fetch),
          headers: {'content-Type': 'application/json; charset=UTF-8'});

      final decodedresponse = jsonDecode(response.body);
      if (response.statusCode == 200) {
        print(decodedresponse);

        setState(() {
          success = decodedresponse['success'];
          msg = decodedresponse['msg'];
        });
      } else {
        print('error');
        setState(() {
          success = 'fail';
          msg = 'Something Went wrong';
        });
      }
    } catch (e) {
      print(e);
      setState(() {
        success = 'fail';
        msg = 'Something Went wrong';
      });
    } finally {
      SmartDialog.dismiss();
    }
  }

  bool network = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<getmostcommon>().getsubcart();
  }

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
        title: Text('Order Confirmation'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Consumer<getmostcommon>(builder: (context, value, child) {
        if (value.loading == true) {
          return Center(
              child: CircularProgressIndicator(
            color: Theme.of(context).primaryColor,
          ));
        } else if (value.error == true) {
          return Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                "images/5_Something.png",
                fit: BoxFit.cover,
                width: double.infinity,
              ),
              Positioned(
                bottom: MediaQuery.of(context).size.height * 0.15,
                left: MediaQuery.of(context).size.width * 0.3,
                right: MediaQuery.of(context).size.width * 0.3,
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 5),
                        blurRadius: 25,
                        color: Colors.black.withOpacity(0.17),
                      ),
                    ],
                  ),
                  child: InkWell(
                    onTap: () {
                      context.read<getmostcommon>().getsubcart();
                    },
                    child: Container(
                      height: 40,
                      width: 80,
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(50)),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Retry",
                          style: TextStyle(
                              color: Color.fromARGB(255, 234, 234, 234),
                              fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          );
        } else if (value.sucartdata == true) {
          subcart = value.subcart;
          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 10.0,
                  right: 10,
                ),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        if (Provider.of<checkstate>(context, listen: false)
                                .address ==
                            '') {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => addAddress(
                                        save: true,
                                      )));
                        } else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => addAddress(
                                        save: false,
                                      )));
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(7),
                        height: 120,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color:
                                Theme.of(context).colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              child: Expanded(
                                child: ListView(
                                  //crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      Provider.of<checkcart>(context,
                                                  listen: false)
                                              .usedefault
                                          ? '${context.watch<checkstate>().firstname} ${context.watch<checkstate>().lastname}'
                                          : context.watch<checkcart>().fullname,
                                      style: TextStyle(
                                          fontSize: 19,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      Provider.of<checkcart>(context,
                                                  listen: false)
                                              .usedefault
                                          ? context.watch<checkstate>().phone
                                          : context.watch<checkcart>().number,
                                      style: TextStyle(
                                        fontSize: 17,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      Provider.of<checkcart>(context,
                                                  listen: false)
                                              .usedefault
                                          ? context.watch<checkstate>().address
                                          : context.watch<checkcart>().address,
                                      style: TextStyle(
                                        fontSize: 17,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      Provider.of<checkcart>(context,
                                                  listen: false)
                                              .usedefault
                                          ? context.watch<checkstate>().location
                                          : context.watch<checkcart>().location,
                                      style: TextStyle(
                                        fontSize: 17,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.7,
                      child: ListView.builder(
                          itemCount: subcart.length,
                          itemBuilder: (context, index) {
                            return Container(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              height: 80,
                              margin: EdgeInsets.only(bottom: 10),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primaryContainer),
                              child: Row(
                                children: [
                                  SizedBox(
                                    height: 50,
                                    width: 50,
                                    child: CachedNetworkImage(
                                      imageUrl: subcart[index].image,
                                      errorWidget: (context, url, error) =>
                                          Icon(Icons.error),
                                      width: MediaQuery.of(context).size.width *
                                          0.4,
                                      height:
                                          MediaQuery.of(context).size.width *
                                              0.35,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.6,
                                              child: Text(
                                                subcart[index].packagename,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                    fontSize: 17,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.only(left: 5),
                                              child: Text(
                                                getclass(
                                                    subcart[index].category),
                                                style: TextStyle(
                                                  fontSize: 17,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        InkWell(
                                          onTap: () async {
                                            print(subcart[index].generatedid);
                                            SmartDialog.showLoading();
                                            await context
                                                .read<getmostcommon>()
                                                .deletesubcart(
                                                    subcart[index].generatedid);

                                            if (value.loadingdelete == false) {
                                              SmartDialog.dismiss();
                                            }
                                            if (value.success == 'success') {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                content: CustomeSnackbar(
                                                  topic: 'Great!',
                                                  msg: value.msg,
                                                  color1: const Color.fromARGB(
                                                      255, 25, 107, 52),
                                                  color2: const Color.fromARGB(
                                                      255, 19, 95, 40),
                                                ),
                                                behavior:
                                                    SnackBarBehavior.floating,
                                                backgroundColor:
                                                    Colors.transparent,
                                                elevation: 0,
                                              ));
                                            }
                                            if (value.success == 'fail') {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                content: CustomeSnackbar(
                                                  topic: 'Oh Snap!',
                                                  msg: value.msg,
                                                  color1: const Color.fromARGB(
                                                      255, 171, 51, 42),
                                                  color2: const Color.fromARGB(
                                                      255, 127, 39, 33),
                                                ),
                                                behavior:
                                                    SnackBarBehavior.floating,
                                                backgroundColor:
                                                    Colors.transparent,
                                                elevation: 0,
                                              ));
                                            }
                                          },
                                          child: const Align(
                                            alignment: Alignment.center,
                                            child: Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                    padding: EdgeInsets.all(10),
                    height: MediaQuery.of(context).size.height * 0.14,
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(20.0))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () async {
                            if (Provider.of<checkstate>(context, listen: false)
                                    .address ==
                                '') {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: CustomeSnackbar(
                                  topic: 'Oh Snap!',
                                  msg: "You haven't set a location",
                                  color1: Color.fromARGB(255, 171, 51, 42),
                                  color2: Color.fromARGB(255, 127, 39, 33),
                                ),
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: Colors.transparent,
                                elevation: 0,
                              ));
                            } else {
                              await sendsuborder();
                              if (success == 'fail') {
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
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute<void>(
                                      builder: (BuildContext context) =>
                                          const homelanding(),
                                    ),
                                    (Route<dynamic> route) => false);
                              }
                            }
                          },
                          child: Container(
                            margin: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).size.height * 0.02),
                            width: double.infinity,
                            height: 40,
                            decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(20)),
                            child: const Align(
                                alignment: Alignment.center,
                                child: Text('Place Order')),
                          ),
                        )
                      ],
                    )),
              )
            ],
          );
        } else {
          return Container();
        }
      }),
    );
  }
}
