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
        iconTheme: IconThemeData(color: Theme.of(context).primaryColorDark),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          'Cart',
          style: TextStyle(
              color: Theme.of(context).primaryColorDark,
              fontSize: 27,
              fontWeight: FontWeight.bold),
        ),
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                          height: 100,
                          width: 100,
                          child: SvgPicture.asset(
                            'images/shopping-cart-svgrepo-com.svg',
                            color: Theme.of(context).primaryColorDark,
                          )),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      'No order found',
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColorDark,
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
    return Container(
      margin: const EdgeInsets.all(10),
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.13,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: SvgPicture.asset(
              'images/svg/Pattern-7.svg',
              fit: BoxFit.cover,
              height: MediaQuery.of(context).size.height * 0.45,
              color: Theme.of(context).primaryColorLight,
              colorBlendMode: BlendMode.difference,
            ),
          ),
          Row(
            children: [
              InkWell(
                onTap: () {
                  modalpopup(context, image, multiple, food, extra, amount,
                      total, cartresults);
                },
                child: Stack(
                  children: [
                    SizedBox(
                      height: double.infinity,
                      //  color: Colors.black,
                      width: MediaQuery.of(context).size.width * 0.85,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: CachedNetworkImage(
                                imageUrl: cartresults[indexx].image ?? '',
                                fit: BoxFit.cover,
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                                width: 90,
                                height:
                                    MediaQuery.of(context).size.width * 0.23,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.15,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 5,
                                  ),
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
                            width: MediaQuery.of(context).size.width * 0.22,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    '${cartresults[indexx].food}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17),
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.07,
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
                                            style:
                                                const TextStyle(fontSize: 17),
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
                                    height: 5,
                                  ),
                                  SizedBox(
                                    child: Text(
                                      '₦ ${cartresults[indexx].amount}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17),
                                    ),
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.07,
                                    child: ListView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount:
                                            cartresults[indexx].extras!.length,
                                        itemBuilder: (context, index) {
                                          return Text(
                                            '₦ ${cartresults[indexx].extras![index].the1}',
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
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 20,
                        margin: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.27),
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Total:',
                                style: TextStyle(
                                    fontWeight: FontWeight.w400, fontSize: 17)),
                            Text('₦ ${cartresults[indexx].total}',
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
        ],
      ),
    );
  }

  Future<dynamic> modalpopup(BuildContext context, image, multiple, food, extra,
      amount, total, cartresults) {
    return showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(35), topRight: Radius.circular(35))),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        builder: (BuildContext context) {
          return Stack(
            children: [
              SizedBox(
                width: double.infinity,
                height: 100,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(35),
                  child: SvgPicture.asset(
                    'images/svg/Pattern-3.svg',
                    fit: BoxFit.cover,
                    color: Theme.of(context).scaffoldBackgroundColor,
                    colorBlendMode: BlendMode.difference,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 40),
                child: ListView(
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Text(
                        'Order Detail',
                        style: TextStyle(
                            fontSize: 23, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: SvgPicture.asset(
                            'images/svg/Pattern-7.svg',
                            fit: BoxFit.cover,
                            height: MediaQuery.of(context).size.height * 0.45,
                            color: Theme.of(context).primaryColorLight,
                            colorBlendMode: BlendMode.difference,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Align(
                                  alignment: Alignment.topCenter,
                                  child: Align(
                                    alignment: Alignment.topCenter,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: CachedNetworkImage(
                                        imageUrl: image ?? '',
                                        fit: BoxFit.cover,
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error),
                                        width: 110,
                                        height:
                                            MediaQuery.of(context).size.width *
                                                0.27,
                                      ),
                                    ),
                                  ),
                                ),
                                Row(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.17,
                                        child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10),
                                                child: Text(
                                                  '$multiple X',
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18),
                                                ),
                                              ),
                                              Container(
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10),
                                                child: const Text(
                                                  'Extras:',
                                                  style:
                                                      TextStyle(fontSize: 16),
                                                ),
                                              ),
                                            ]),
                                      ),
                                      Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.44,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Container(
                                                    child: Text(
                                                      '$food',
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 19),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 60,
                                                    child: Text(
                                                      '₦ $amount',
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontSize: 17),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                                // color: Colors.black,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.6,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.44,
                                                padding: EdgeInsets.only(
                                                  bottom: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.2,
                                                ),
                                                child: ListView.builder(
                                                    shrinkWrap: true,
                                                    itemCount: extra.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return Container(
                                                        margin: const EdgeInsets
                                                            .only(
                                                          bottom: 5,
                                                        ),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            SizedBox(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.21,
                                                              child: Text(
                                                                '${extra![index].the5}',
                                                                // overflow-: TextOverflow.ellipsis,
                                                                style:
                                                                    const TextStyle(
                                                                        fontSize:
                                                                            19),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 60,
                                                              child: Text(
                                                                '₦ ${extra![index].the1}',
                                                                style: const TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    fontSize:
                                                                        17),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    })),
                                          ]),
                                    ]),
                              ]),
                        ),
                        Positioned(
                          top: MediaQuery.of(context).size.height * 0.4,
                          left: MediaQuery.of(context).size.width * 0.30,
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: SizedBox(
                              height: 20,
                              width: MediaQuery.of(context).size.width * 0.6,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Total:',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 17)),
                                  Text('₦ $total',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 17))
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }
}
