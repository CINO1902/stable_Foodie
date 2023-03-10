import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_svg/svg.dart';
import 'package:foodie_ios/linkfile/Model/fetchcart.dart';
import 'package:foodie_ios/linkfile/customesnackbar.dart';
import 'package:foodie_ios/linkfile/enum/connectivity_status.dart';
import 'package:foodie_ios/linkfile/provider/checkcart.dart';
import 'package:foodie_ios/linkfile/provider/internetchecker.dart';
import 'package:foodie_ios/linkfile/provider/onboarding.dart';
import 'package:foodie_ios/linkfile/provider/sellectbucket.dart';
import 'package:foodie_ios/linkfile/provider/subscribed.dart';
import 'package:foodie_ios/page/overlay.dart';
import 'package:foodie_ios/linkfile/networkhandler.dart';
import 'package:foodie_ios/page/webpage.dart';
import 'package:provider/provider.dart';

class checkoutsub extends StatefulWidget {
  const checkoutsub({super.key});

  @override
  State<checkoutsub> createState() => _checkoutsubState();
}

class _checkoutsubState extends State<checkoutsub> {
  bool network = false;

  String getcetegory(bucked) {
    String cat = '';
    List arr1 = ['1000', '1001', '1002', '1003', '1004', '1005', '1006'];
    List arr2 = ['1011', '1012', '1013', '1014', '1015', '1016', '1017'];
    List arr3 = ['1018', '1019', '1020', '1021', '1022', '1023', '1024'];

    List lists = [
      bucked,
      arr1,
    ];
    List listtwo = [
      bucked,
      arr2,
    ];
    List listthree = [
      bucked,
      arr3,
    ];
    List commonElements = lists
        .fold<Set>(lists.first.toSet(), (a, b) => a.intersection(b.toSet()))
        .toList();
    List commonElementstwo = listtwo
        .fold<Set>(listtwo.first.toSet(), (a, b) => a.intersection(b.toSet()))
        .toList();
    List commonElementsthree = listthree
        .fold<Set>(listthree.first.toSet(), (a, b) => a.intersection(b.toSet()))
        .toList();

    if (commonElements.isNotEmpty) {
      cat = 'Smallie';
    } else if (commonElementstwo.isNotEmpty) {
      cat = 'longthroat';
    } else if (commonElementsthree.isNotEmpty) {
      cat = 'Biggie';
    }

    return cat;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<sellectbucket>().getidpackage();
  }

  bool loading = false;

  String success = '';
  String code = '';
  int subtotal = 0;
  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();
    context.read<sellectbucket>().disposediscount();
  }

  RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
  String Function(Match) mathFunc = (Match match) => '${match[1]},';

  @override
  Widget build(BuildContext context) {
    print(Provider.of<subscribed>(context, listen: false).rolloverclick);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text('Overview'),
      ),
      body: Consumer<sellectbucket>(builder: (context, value, child) {
        return Stack(
          children: [
            Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.05,
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  child: const Text(
                    'The subscription plan you selected, offers you two times a day meal with the menu below.',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ),
                Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.47,
                      child: ListView.builder(
                          shrinkWrap: true,
                          // physics: NeverScrollableScrollPhysics(),
                          itemCount: value.frequency + 1,
                          itemBuilder: (context, index) {
                            List<List<String>> subresults = [];
                            List<List<String>> subpakage = [];
                            List<String> subdrink = [];
                            List<String> firstbuck =
                                value.firstbucket()[0].values.toList();

                            List<String> getsecondbuc() {
                              List<String> bucket = [];

                              if (value.secondbucket().isNotEmpty) {
                                bucket =
                                    value.secondbucket()[0].values.toList();
                              }
                              return bucket;
                            }

                            List<String> getthirdbuck() {
                              List<String> bucket = [];
                              if (value.thirdbucket().isNotEmpty) {
                                bucket = value.thirdbucket()[0].values.toList();
                              }
                              return bucket;
                            }

                            subresults.add(firstbuck);
                            subresults.add(getsecondbuc());
                            subresults.add(getthirdbuck());
                            subpakage.add(value.firstbuckepage);
                            subpakage.add(value.secondbuckepage);
                            subpakage.add(value.thirdbuckepage);
                            subdrink.add(value.drinkpackage1);
                            subdrink.add(value.drinkpackage2);
                            subdrink.add(value.drinkpackage3);

                            // List<int> dataListAsInt = value.totalpriceeach
                            //     .map((data) => int.parse(data))
                            //     .toList();
                            //  print(dataListAsInt);

                            subtotal = value.totalpriceeach.fold<int>(
                                0,
                                (sum, item) =>
                                    sum + int.parse(item.toString()));
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Cartbox(
                                    context,
                                    index,
                                    getcetegory(subresults[index]),
                                    subpakage[index],
                                    subdrink[index]),
                                Container(
                                  margin: EdgeInsets.only(left: 10),
                                  child: Text(
                                    'Meal Selected: ${value.totalfoodeach[index].toString().replaceAllMapped(reg, mathFunc)}',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                value.totaldrinkseeach[index] != 0
                                    ? Container(
                                        margin: EdgeInsets.only(left: 10),
                                        child: Text(
                                          'Drinks Selected: ${value.totaldrinkseeach[index].toString().replaceAllMapped(reg, mathFunc)}',
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      )
                                    : SizedBox(),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 10),
                                  child: Text(
                                    'Total: ${value.totalpriceeach[index].toString().replaceAllMapped(reg, mathFunc)}',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                )
                              ],
                            );
                          }),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.15,
                      margin: EdgeInsets.only(
                          left: 10,
                          right: 10,
                          top: 0,
                          bottom: MediaQuery.of(context).size.height * 0.14),
                      padding: EdgeInsets.all(15),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(15)),
                      child: ListView(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Provider.of<subscribed>(context, listen: false)
                                  .upgradeclick
                              ? Container(
                                  margin: EdgeInsets.only(bottom: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Total subscription cost:',
                                        style: TextStyle(fontSize: 19),
                                      ),
                                      Text(
                                          '₦ ${subtotal.toString().replaceAllMapped(reg, mathFunc)}',
                                          style: TextStyle(fontSize: 19))
                                    ],
                                  ),
                                )
                              : Container(),
                          Provider.of<subscribed>(context, listen: false)
                                  .upgradeclick
                              ? Container(
                                  margin: EdgeInsets.only(bottom: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Outstanding meal cost:',
                                        style: TextStyle(fontSize: 19),
                                      ),
                                      Text(
                                          '₦ ${context.watch<sellectbucket>().outstandfood.toString().replaceAllMapped(reg, mathFunc)}',
                                          style: TextStyle(fontSize: 19))
                                    ],
                                  ),
                                )
                              : Container(),
                          Provider.of<subscribed>(context, listen: false)
                                  .upgradeclick
                              ? Container(
                                  margin: EdgeInsets.only(bottom: 10),
                                  child: context
                                              .watch<sellectbucket>()
                                              .outstanddrink >
                                          31
                                      ? Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'Outstanding Drink cost:',
                                                  style:
                                                      TextStyle(fontSize: 19),
                                                ),
                                                Text(
                                                    '₦ ${context.watch<sellectbucket>().outstanddrink.toString().replaceAllMapped(reg, mathFunc)}',
                                                    style:
                                                        TextStyle(fontSize: 19))
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'Total Outstanding:',
                                                  style:
                                                      TextStyle(fontSize: 19),
                                                ),
                                                Text(
                                                    '₦ ${context.watch<sellectbucket>().outstandtotal.toString().replaceAllMapped(reg, mathFunc)}',
                                                    style:
                                                        TextStyle(fontSize: 19))
                                              ],
                                            ),
                                          ],
                                        )
                                      : Container(),
                                )
                              : Container(),
                          Provider.of<subscribed>(context, listen: false)
                                  .upgradeclick
                              ? Container(
                                  margin: EdgeInsets.only(bottom: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Total Upgrading cost:',
                                        style: TextStyle(fontSize: 19),
                                      ),
                                      Text(
                                          '₦ ${context.watch<sellectbucket>().calculated.replaceAllMapped(reg, mathFunc)}',
                                          style: TextStyle(fontSize: 19))
                                    ],
                                  ),
                                )
                              : Container(
                                  margin: EdgeInsets.only(bottom: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Total subscription cost:',
                                        style: TextStyle(fontSize: 19),
                                      ),
                                      Text(
                                          '₦ ${context.watch<sellectbucket>().calculated.replaceAllMapped(reg, mathFunc)}',
                                          style: TextStyle(fontSize: 19))
                                    ],
                                  ),
                                ),
                          Consumer<sellectbucket>(
                              builder: (context, value, child) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Promo code',
                                  style: TextStyle(fontSize: 19),
                                ),
                                InkWell(
                                  onTap: () {
                                    modalbox(context);
                                  },
                                  child: value.verified
                                      ? value.coupon_type == 'discount'
                                          ? Text(
                                              '${value.coupon_discount.toString()}% off',
                                              style: TextStyle(fontSize: 19))
                                          : value.coupon_type == 'money'
                                              ? Text(
                                                  '- ₦ ${value.coupon_amount.toString().replaceAllMapped(reg, mathFunc)}',
                                                  style:
                                                      TextStyle(fontSize: 19))
                                              : Text('Enter coupon code')
                                      : Text('Enter coupon code',
                                          style: TextStyle(fontSize: 19)),
                                )
                              ],
                            );
                          }),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total:',
                            style: TextStyle(
                                fontSize: 21,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          context.watch<subscribed>().rolloverclick
                              ? int.parse(context
                                          .watch<sellectbucket>()
                                          .stringmoney) <
                                      0
                                  ? Text('₦ 0.00',
                                      style: TextStyle(
                                          fontSize: 21,
                                          fontWeight: FontWeight.bold))
                                  : Column(
                                      children: [
                                        Text(
                                          'Rollover discount price: ₦ ${context.watch<sellectbucket>().stringmoney.replaceAllMapped(reg, mathFunc)}',
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Opacity(
                                                opacity: 0.8,
                                                child: RichText(
                                                  text: TextSpan(
                                                    text: 'Normal price: ₦ ',
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    children: <TextSpan>[
                                                      TextSpan(
                                                        text:
                                                            '${context.watch<sellectbucket>().rollover.replaceAllMapped(reg, mathFunc)}',
                                                        style: TextStyle(
                                                            decoration:
                                                                TextDecoration
                                                                    .lineThrough,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ],
                                                  ),
                                                )),
                                            SizedBox(width: 10),
                                            Opacity(
                                              opacity: 0.7,
                                              child: Container(
                                                height: 20,
                                                width: 40,
                                                decoration: BoxDecoration(
                                                    color: Colors.black,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5)),
                                                child: Text(
                                                  '-10%',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    )
                              : int.parse(context
                                          .watch<sellectbucket>()
                                          .stringmoney) <
                                      0
                                  ? Text('₦ 0.00',
                                      style: TextStyle(
                                          fontSize: 21,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white))
                                  : Text(
                                      '₦ ${context.watch<sellectbucket>().stringmoney.replaceAllMapped(reg, mathFunc)}',
                                      style: TextStyle(
                                          fontSize: 21,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                        ],
                      ),
                      InkWell(
                        onTap: () {
                          if (Provider.of<checkcart>(context, listen: false)
                                  .error ==
                              true) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: CustomeSnackbar(
                                topic: 'Oh Snap!',
                                msg: 'Payment cannot proceed',
                                color1: const Color.fromARGB(255, 171, 51, 42),
                                color2: const Color.fromARGB(255, 127, 39, 33),
                              ),
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Colors.transparent,
                              elevation: 0,
                            ));
                          } else if (Provider.of<checkcart>(context,
                                      listen: false)
                                  .error !=
                              true) {
                            //checkpayment();
                            taketoweb();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: CustomeSnackbar(
                                topic: 'Oh Snap!',
                                msg: 'Something Went wrong',
                                color1: const Color.fromARGB(255, 171, 51, 42),
                                color2: const Color.fromARGB(255, 127, 39, 33),
                              ),
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Colors.transparent,
                              elevation: 0,
                            ));
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
                              child: Text(
                                'Place Order',
                                style: TextStyle(color: Colors.white),
                              )),
                        ),
                      )
                    ],
                  )),
            ),
          ],
        );
      }),
    );
  }

  void modalbox(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).size.width * 0.5,
            child: Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                child:
                    Consumer<sellectbucket>(builder: (context, value, child) {
                  return Form(
                    //key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          child: const Text(
                            'Apply Coupon Code',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                'A coupon code is a combination if letters(case sensitive) and numbers without spaces',
                                style: TextStyle(fontSize: 19),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              SizedBox(
                                height: 75,
                                width: MediaQuery.of(context).size.width * 0.6,
                                child: TextFormField(
                                  autocorrect: false,
                                  onChanged: (value) {
                                    code = value;
                                  },
                                  autofocus: true,
                                  initialValue: code,
                                  decoration: const InputDecoration(
                                      hintText: 'Enter code',
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
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Theme.of(context)
                                      .primaryColor
                                      .withOpacity(.7)),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              )),
                            ),
                            onPressed: () async {
                              SmartDialog.showLoading();
                              await context
                                  .read<sellectbucket>()
                                  .verifycoupon(code);

                              if (value.success_coupon == 'success') {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: CustomeSnackbar(
                                    topic: 'Great!',
                                    msg: value.coupon_msg,
                                    color1:
                                        const Color.fromARGB(255, 25, 107, 52),
                                    color2:
                                        const Color.fromARGB(255, 19, 95, 40),
                                  ),
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: Colors.transparent,
                                  elevation: 0,
                                ));
                              } else if (value.success_coupon == 'fail') {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: CustomeSnackbar(
                                    topic: 'Oh Snap!',
                                    msg: value.coupon_msg,
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
                  );
                }),
              ),
            ),
          );
        });
  }

  taketoweb() async {
    String _getReference() {
      String platform;
      if (Platform.isIOS) {
        platform = 'iOS';
      } else {
        platform = 'Android';
      }

      return 'ChargedFrom${platform}_${DateTime.now().millisecondsSinceEpoch}';
    }

    SmartDialog.showLoading();
    await createref(
        Provider.of<checkstate>(context, listen: false).email, _getReference());
    SmartDialog.dismiss();
    if (success == 'success') {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => webpage(
                    email:
                        Provider.of<checkstate>(context, listen: false).email,
                    price: (Provider.of<sellectbucket>(context, listen: false)
                        .stringmoney),
                    ID: Provider.of<checkstate>(context, listen: false).email,
                    ref: _getReference(),
                    type: 'subcheckout',
                  )),
          (Route<dynamic> route) => false);
    } else if (success == 'fail') {
      SmartDialog.dismiss();
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

  Future<void> createref(email, ref) async {
    SmartDialog.showLoading();
    setState(() {
      loading = true;
    });

    try {
      FetchcartModel send = FetchcartModel(id: email, ref: ref, email: '');
      var response = await networkHandler.client.post(
          networkHandler.builderUrl('/insertingref'),
          body: fetchcartModelToJson(send),
          headers: {
            'content-Type': 'application/json; charset=UTF-8',
          });
      print(send.id);
      final decodedres = jsonDecode(response.body);
      setState(() {
        success = decodedres['success'];
      });
      print(decodedres);
    } catch (e) {
      print(e);
      setState(() {
        success = 'fail';
      });
    } finally {
      setState(() {
        loading = false;
      });
      SmartDialog.dismiss();
    }
  }
}

Widget Cartbox(BuildContext context, index, value, List package, drink) {
  String msg1 = '';
  String success = '';
  return Card(
    margin: const EdgeInsets.all(10),
    child: SizedBox(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.15,
      child: InkWell(
        onTap: () {
          modalpopup(context, value, package, drink);
        },
        child: Stack(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.9,
              //  color: Colors.black,
              width: MediaQuery.of(context).size.width * 0.95,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.12,
                        width: MediaQuery.of(context).size.width * 0.22,
                        child: SvgPicture.asset(
                          'images/fast-food.svg',
                          color: Theme.of(context).colorScheme.onBackground,
                        )),
                  ),
                  SizedBox(
                    //color: Colors.black,
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          FittedBox(
                            child: Text(
                              drink != ''
                                  ? ' $value Bucket with $drink'
                                  : '$value Bucket',
                              style: TextStyle(
                                  fontSize: 19, fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                child: const Text(
                                  'Bucket Include:',
                                  style: TextStyle(
                                    fontSize: 17,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.1,
                                width: MediaQuery.of(context).size.width * 0.3,
                                child: Consumer<sellectbucket>(
                                    builder: (context, value, child) {
                                  if (value.loadpackage == true) {
                                    return Center(
                                      child: CircularProgressIndicator(
                                          color:
                                              Theme.of(context).primaryColor),
                                    );
                                  } else {
                                    return ListView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: package.length,
                                        itemBuilder: (context, index) {
                                          return SizedBox(
                                            height: 20,
                                            child: Text(
                                              package[index],
                                              // overflow-: TextOverflow.ellipsis,
                                              style:
                                                  const TextStyle(fontSize: 17),
                                            ),
                                          );
                                        });
                                  }
                                }),
                              ),
                            ],
                          ),
                        ]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Future<dynamic> modalpopup(BuildContext context, value, List package, drink) {
  return showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      builder: (BuildContext context) {
        return Stack(
          children: [
            ListView(
              physics: const NeverScrollableScrollPhysics(),
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 5, left: 20, right: 10),
                  width: double.infinity,
                  height: 30,
                  color: Theme.of(context).primaryColor,
                  child: Center(
                    child: Text(
                      'Bucket Details',
                      style: TextStyle(
                        fontSize: 23,
                        letterSpacing: -0.4,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onTertiary,
                      ),
                    ),
                  ),
                ),
                Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.12,
                        width: 100,
                        child: SvgPicture.asset(
                          'images/fast-food.svg',
                          color: Theme.of(context).colorScheme.onBackground,
                        )),
                  ),
                  Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.4,
                          child: Text(
                            drink != ''
                                ? ' $value Bucket With $drink'
                                : '$value Bucket',
                            style: TextStyle(
                                fontSize: 19, fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Bucket Include:',
                                style: TextStyle(
                                    fontWeight: FontWeight.w400, fontSize: 17),
                              ),
                              Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.6,
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
                                  padding: EdgeInsets.only(
                                    bottom: MediaQuery.of(context).size.height *
                                        0.2,
                                  ),
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: package.length,
                                      itemBuilder: (context, index) {
                                        return Container(
                                          margin: const EdgeInsets.only(
                                            bottom: 5,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.3,
                                                child: Text(
                                                  '${package[index]}',
                                                  // overflow-: TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                      fontSize: 19),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      })),
                            ],
                          ),
                        ),
                      ]),
                ]),
              ],
            ),
          ],
        );
      });
}
