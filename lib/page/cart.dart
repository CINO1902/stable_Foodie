import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:foodie_ios/linkfile/Model/cartrecieve.dart';
import 'package:foodie_ios/linkfile/Model/removecart.dart';
import 'package:foodie_ios/linkfile/customesnackbar.dart';
import 'package:foodie_ios/linkfile/enum/connectivity_status.dart';
import 'package:foodie_ios/linkfile/loading.dart';

import 'package:foodie_ios/linkfile/provider/checkcart.dart';
import 'package:foodie_ios/linkfile/provider/confirmcart.dart';
import 'package:foodie_ios/linkfile/provider/internetchecker.dart';
import 'package:foodie_ios/page/overlay.dart';

import 'package:provider/provider.dart';
import 'package:foodie_ios/linkfile/networkhandler.dart';

class cart extends StatefulWidget {
  const cart({super.key});

  @override
  State<cart> createState() => _cartState();
}

class _cartState extends State<cart> {
  List<Pagnited> cartresults = [];
  String msg1 = '';
  String success = '';
  bool network = false;

  late StreamSubscription subscription;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    context.read<checkcart>().checkcartforcart();
  }

  Future<void> removecart(id) async {
    RemoveCart remove = RemoveCart(packageid: id);

    try {
      Loadingwidget2.show(context);
      var response = await networkHandler.client.post(
          networkHandler.builderUrl('/removefromcart'),
          body: removeCartToJson(remove),
          headers: {
            'content-Type': 'application/json; charset=UTF-8',
          });

      var msg = jsonDecode(response.body);
      msg1 = msg['msg'];
      success = msg['status'];
    } catch (e) {
      print(e);
    } finally {
      Loadingwidget2.hide(context);
      context.read<checkcart>().checkcartforcart();
    }
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
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('Cart'),
      ),
      body: Stack(
        children: [
          Container(
            child: context.watch<checkcart>().loading
                ? Center(
                    child: CircularProgressIndicator(
                    color: Theme.of(context).primaryColor,
                  ))
                : context.watch<checkcart>().empty
                    ? Consumer<checkcart>(builder: (context, value, child) {
                        return SizedBox(
                          height: MediaQuery.of(context).size.height * 0.75,
                          child: ListView.builder(
                              itemCount: value.cartresult.length,
                              itemBuilder: (context, index) {
                                cartresults = value.cartresult;
                                final cart = cartresults[index];
                                final image = cartresults[index].image;
                                final multiple = cartresults[index].multiple;
                                final food = cartresults[index].food;
                                final amount = cartresults[index].amount;
                                final total = cartresults[index].total;
                                List<Extra>? extra = cartresults[index].extras;

                                return Cartbox(
                                    context,
                                    value,
                                    index,
                                    cart,
                                    image,
                                    multiple,
                                    food,
                                    extra,
                                    amount,
                                    total,
                                    cartresults);
                              }),
                        );
                      })
                    : Container(),
          ),
          context.watch<checkcart>().empty
              ? Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.15,
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(20.0))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          height: 40,
                          child: const Align(
                            alignment: Alignment.center,
                            child: Text(
                              'Check Out',
                              style: TextStyle(
                                  fontSize: 21,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              height: 40,
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  'Total: ${context.watch<checkcart>().sumget.toString()}',
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                if (Provider.of<checkcart>(context,
                                            listen: false)
                                        .loading !=
                                    true) {
                                  Navigator.pushNamed(context, '/confirmorder');
                                } else {
                                  SmartDialog.showToast('System is still busy');
                                }
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.4,
                                decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(.8),
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        bottomLeft: Radius.circular(10))),
                                height: 40,
                                child: const Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Proceed To payment',
                                      style: TextStyle(color: Colors.white),
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              : Column(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                          margin: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.15),
                          height: 200,
                          width: 200,
                          child: SvgPicture.asset(
                            'images/shopping-cart-svgrepo-com.svg',
                            color: Colors.black.withOpacity(.5),
                          )),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 50, bottom: 20),
                      child: Text(
                        'Opps!!!',
                        style: TextStyle(
                          fontSize: 29,
                          fontWeight: FontWeight.bold,
                          color: Colors.black.withOpacity(.5),
                        ),
                      ),
                    ),
                    Text(
                      'No order found',
                      style: TextStyle(
                        fontSize: 29,
                        fontWeight: FontWeight.bold,
                        color: Colors.black.withOpacity(.5),
                      ),
                    )
                  ],
                ),
        ],
      ),
    );
  }

  Widget Cartbox(BuildContext context, checkcart value, int indexx, cart, image,
      multiple, food, extra, amount, total, cartresults) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: SizedBox(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.13,
        child: Row(
          children: [
            InkWell(
              onTap: () {
                modalpopup(context, image, multiple, food, extra, amount, total,
                    cartresults);
              },
              child: Stack(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.width * 0.215,
                    //  color: Colors.black,
                    width: MediaQuery.of(context).size.width * 0.85,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.12,
                            width: MediaQuery.of(context).size.width * 0.22,
                            child: CachedNetworkImage(
                              imageUrl: cartresults[indexx].image ?? '',
                              fit: BoxFit.cover,
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                              width: MediaQuery.of(context).size.width * 0.4,
                              height: MediaQuery.of(context).size.width * 0.35,
                            ),
                          ),
                        ),
                        SizedBox(
                          //color: Colors.black,
                          width: MediaQuery.of(context).size.width * 0.17,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  child: Text(
                                    '${cartresults[indexx].multiple} X',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 19),
                                  ),
                                ),
                                SizedBox(
                                  child: const Text(
                                    'Extras:',
                                    style: TextStyle(
                                      fontSize: 17,
                                    ),
                                  ),
                                ),
                              ]),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.24,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${cartresults[indexx].food}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17),
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.07,
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount:
                                          cartresults[indexx].extras!.length,
                                      itemBuilder: (context, index) {
                                        return Text(
                                          '${cartresults[indexx].extras![index].the5}',
                                          // overflow-: TextOverflow.ellipsis,
                                          style: const TextStyle(fontSize: 17),
                                        );
                                      }),
                                ),
                              ]),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.18,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  child: Text(
                                    '${cartresults[indexx].amount}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17),
                                  ),
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.07,
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount:
                                          cartresults[indexx].extras!.length,
                                      itemBuilder: (context, index) {
                                        return Text(
                                          '${cartresults[indexx].extras![index].the1}',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 16),
                                        );
                                      }),
                                ),
                              ]),
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      height: 20,
                      margin: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.22),
                      width: MediaQuery.of(context).size.width * 0.55,
                      color: Colors.black.withOpacity(.3),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total:',
                              style: TextStyle(
                                  fontWeight: FontWeight.w400, fontSize: 17)),
                          Text('${cartresults[indexx].total}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w400, fontSize: 17))
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () async {
                await removecart(cartresults[indexx].packageid.toString());
                if (success == 'success') {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: CustomeSnackbar(
                      topic: 'Great!',
                      msg: msg1,
                      color1: const Color.fromARGB(255, 25, 107, 52),
                      color2: const Color.fromARGB(255, 19, 95, 40),
                    ),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                  ));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: CustomeSnackbar(
                      topic: 'Oh Snap!',
                      msg: msg1,
                      color1: const Color.fromARGB(255, 171, 51, 42),
                      color2: const Color.fromARGB(255, 127, 39, 33),
                    ),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Colors.transparent,
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
    );
  }

  Future<dynamic> modalpopup(BuildContext context, image, multiple, food, extra,
      amount, total, cartresults) {
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
                        'Order Details',
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
                        child: CachedNetworkImage(
                          imageUrl: image ?? '',
                          fit: BoxFit.cover,
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                          width: MediaQuery.of(context).size.width * 0.4,
                          height: MediaQuery.of(context).size.width * 0.35,
                        ),
                      ),
                    ),
                    Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.2,
                            child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Text(
                                      '$multiple X',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 19),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: const Text(
                                      'Extras:',
                                      style: TextStyle(fontSize: 17),
                                    ),
                                  ),
                                ]),
                          ),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.45,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(
                                          right: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.05,
                                        ),
                                        child: Text(
                                          '$food',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 19),
                                        ),
                                      ),
                                      Text(
                                        '$amount',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 17),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                    // color: Colors.black,
                                    height: MediaQuery.of(context).size.height *
                                        0.6,
                                    width: MediaQuery.of(context).size.width *
                                        0.45,
                                    padding: EdgeInsets.only(
                                      bottom:
                                          MediaQuery.of(context).size.height *
                                              0.2,
                                    ),
                                    child: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: extra.length,
                                        itemBuilder: (context, index) {
                                          return Container(
                                            margin: const EdgeInsets.only(
                                              bottom: 5,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.23,
                                                  child: Text(
                                                    '${extra![index].the5}',
                                                    // overflow-: TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                        fontSize: 19),
                                                  ),
                                                ),
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                      left: 30),
                                                  child: Text(
                                                    '${extra![index].the1}',
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 17),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        })),
                              ]),
                        ]),
                  ]),
                ],
              ),
              Positioned(
                  bottom: 0,
                  width: MediaQuery.of(context).size.width,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.09,
                      width: double.maxFinite,
                      // margin: EdgeInsets.only(
                      //   top: MediaQuery.of(context).size.height * 0.45,
                      // ),
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(10.0))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            height: 40,
                            child: const Align(
                              alignment: Alignment.center,
                              child: Text(
                                'Total:',
                                style: TextStyle(
                                    fontSize: 21,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {},
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                              decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(.8),
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      bottomLeft: Radius.circular(10))),
                              height: 40,
                              child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    '$total',
                                    style: const TextStyle(color: Colors.white),
                                  )),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ))
            ],
          );
        });
  }
}
