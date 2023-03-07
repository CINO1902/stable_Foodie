import 'dart:async';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foodie_ios/linkfile/Model/cartrecieve.dart';
import 'package:foodie_ios/linkfile/Model/sendNotificationModel.dart';
import 'package:foodie_ios/linkfile/enum/connectivity_status.dart';
import 'package:foodie_ios/linkfile/provider/checkcart.dart';
import 'package:foodie_ios/linkfile/provider/greetings.dart';
import 'package:foodie_ios/linkfile/provider/internetchecker.dart';
import 'package:foodie_ios/linkfile/provider/onboarding.dart';
import 'package:foodie_ios/linkfile/refresh.dart';
import 'package:foodie_ios/onboarding.dart';
import 'package:foodie_ios/page/overlay.dart';
import 'package:grouped_list/grouped_list.dart';

import 'package:provider/provider.dart';
import 'package:animated_custom_dropdown/custom_dropdown.dart';

class Order extends StatefulWidget {
  const Order({super.key});

  @override
  State<Order> createState() => _OrderState();
}

class _OrderState extends State<Order> {
  List<Pagnited> orderresults = [];

  List months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];
  bool hasInternet = false;
  bool network = false;
  late StreamSubscription subscription;
  late ScrollController _controller;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<checkcart>().checkcarts();
    _controller = ScrollController()
      ..addListener(() {
        if (_controller.position.maxScrollExtent ==
            _controller.position.pixels) {
          context.read<checkcart>().loadmore();
        }
      });
  }

  Future loadList() async {
    await context.read<checkcart>().checkcarts();
  }

  List dropdowntext = ['Both', 'When Logged In', 'When Not logged In'];

  bool _visible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('Order History'),
        actions: <Widget>[
          context.watch<checkstate>().checkregisteredlogg()
              ? InkWell(
                  onTap: () {
                    setState(() {
                      _visible = !_visible;
                    });
                  },
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.black,
                      ),
                      margin: EdgeInsets.only(right: 10),
                      height: 30,
                      width: 60,
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Sort',
                          style: TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                )
              : Container()
        ],
      ),
      body: Stack(
        children: [
          Container(
            child: Consumer<checkcart>(builder: (context, value, child) {
              if (value.loading == true) {
                return Center(
                  child: CircularProgressIndicator(
                    color: Theme.of(context).primaryColor,
                  ),
                );
              } else {
                if (value.orderempty == false) {
                  return Column(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                            margin: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height * 0.15),
                            height: 200,
                            width: 200,
                            child: SvgPicture.asset(
                              'images/empty.svg',
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
                  );
                } else {
                  orderresults = value.orderesult;
                  return Column(
                    children: [
                      Expanded(
                        child: GroupedListView<Pagnited, DateTime>(
                            shrinkWrap: true,
                            elements: orderresults,
                            controller: _controller,
                            groupBy: (Pagnited element) => DateTime(
                                  element.date.year,
                                  element.date.month,
                                  element.date.day,
                                ),
                            groupComparator:
                                (DateTime value1, DateTime value2) =>
                                    value1.compareTo(value2),
                            order: GroupedListOrder.DESC,
                            floatingHeader: true,
                            itemComparator:
                                (Pagnited element1, Pagnited element2) =>
                                    element1.date.compareTo(element2.date),
                            groupSeparatorBuilder: (DateTime date) {
                              DateTime currentdate =
                                  context.watch<greetings>().time;

                              String date1 = '';
                              final difference =
                                  currentdate.difference(date).inDays;
                              if (difference == 0) {
                                date1 = 'Today';
                              } else if (difference == 1) {
                                date1 = 'Yesterday';
                              } else if (difference > 1) {
                                date1 =
                                    '${date.day}, ${months[date.month - 1]} ${date.year}';
                              } else {
                                date1 =
                                    '${date.day}, ${months[date.month - 1]} ${date.year}';
                              }
                              return Padding(
                                padding: const EdgeInsets.all(8),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    date1,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              );
                            },
                            itemBuilder: (BuildContext context, index) {
                              return Cartbox(
                                context,
                                value,
                                index,
                              );
                            }),
                      ),
                      context.watch<checkcart>().isloadmore == true
                          ? Padding(
                              padding:
                                  const EdgeInsets.only(top: 10, bottom: 30),
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: Theme.of(context).primaryColor,
                                ),
                              ))
                          : Container(),
                      context.watch<checkcart>().hasnextpage == false
                          ? Padding(
                              padding:
                                  const EdgeInsets.only(top: 10, bottom: 0),
                              child: Container(
                                height: 50,
                                width: double.infinity,
                                decoration: BoxDecoration(color: Colors.amber),
                                child: Center(
                                    child: Text(
                                  'You have fetched all content',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSecondary),
                                )),
                              ),
                            )
                          : Container()
                    ],
                  );
                }
              }
            }),
          ),
          Visibility(
            visible: _visible,
            child: AnimatedOpacity(
              onEnd: () {},
              opacity: _visible ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 500),
              child: Container(
                height: 98,
                width: double.infinity,
                decoration: BoxDecoration(color: Colors.black.withOpacity(.6)),
                child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: dropdowntext.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          context.read<checkcart>().getindex(index);
                          setState(() {
                            _visible = false;
                          });
                          orderresults.clear();

                          loadList();
                        },
                        child: context
                                .watch<checkcart>()
                                .selected
                                .contains(index)
                            ? Container(
                                margin: EdgeInsets.only(bottom: 3),
                                color: Colors.black,
                                height: 30,
                                width: MediaQuery.of(context).size.width * 0.9,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        dropdowntext[index],
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: SvgPicture.asset(
                                          'images/tick.svg',
                                          color: Colors.greenAccent,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            : Container(
                                margin: EdgeInsets.only(bottom: 3),
                                color: Colors.black,
                                height: 30,
                                width: double.infinity,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    dropdowntext[index],
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                ),
                              ),
                      );
                    }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget Cartbox(BuildContext context, checkcart value, indexx) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: SizedBox(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.13,
        child: InkWell(
          onTap: () {
            modalpopup(
                context,
                indexx.image,
                indexx.multiple,
                indexx.food,
                indexx.extras,
                indexx.amount,
                indexx.total,
                indexx.packageid,
                indexx.date,
                indexx.ordernum,
                indexx.email,
                indexx.name,
                indexx.number,
                indexx.address,
                indexx.location);
          },
          child: Stack(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.215,
                width: MediaQuery.of(context).size.width * 1,
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
                          imageUrl: indexx.image ?? '',
                          fit: BoxFit.cover,
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                          width: MediaQuery.of(context).size.width * 0.4,
                          height: MediaQuery.of(context).size.width * 0.35,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.17,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              child: Text(
                                '${indexx.multiple} X',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 19),
                              ),
                            ),
                            const SizedBox(
                              child: Text(
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
                              '${indexx.food}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 17),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.07,
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: indexx.extras!.length,
                                  itemBuilder: (context, index) {
                                    return Text(
                                      '${indexx.extras![index].the5}',
                                      // overflow-: TextOverflow.ellipsis,
                                      style: const TextStyle(fontSize: 17),
                                    );
                                  }),
                            ),
                          ]),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.10,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              child: Text(
                                '${indexx.amount}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 17),
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.07,
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: indexx.extras!.length,
                                  itemBuilder: (context, index) {
                                    return Text(
                                      '${indexx.extras![index].the1}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 16),
                                    );
                                  }),
                            ),
                          ]),
                    ),
                    Container(
                      width: 70,
                      color: Colors.yellowAccent,
                      child: Text(
                        'Order In progress',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  height: 20,
                  margin: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.22),
                  width: MediaQuery.of(context).size.width * 0.52,
                  color: Colors.black.withOpacity(.3),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total:',
                          style: TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 17)),
                      Text('${indexx.total}',
                          style: const TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 17))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<dynamic> modalpopup(
      BuildContext context,
      image,
      multiple,
      food,
      extra,
      amount,
      total,
      package_id,
      date,
      ordernum,
      email,
      name,
      number,
      address,
      location) {
    return showModalBottomSheet(
        context: context,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        builder: (BuildContext context) {
          DateTime? currentdate = context.watch<greetings>().time;

          final day = date.day;
          final currentday = currentdate.day;

          String time1 = '';
          if ((currentday - day) == 0) {
            time1 = 'Today';
          } else if ((currentday - day) == 1) {
            time1 = 'Yesterday';
          } else if ((currentday - day) > 1) {
            time1 = '${date.day}, ${months[date.month - 1]} ${date.year}';
          } else {
            time1 = '${date.day}, ${months[date.month - 1]} ${date.year}';
          }

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
                    Column(
                      children: [
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
                      ],
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
                                    //color: Colors.black,
                                    height: MediaQuery.of(context).size.height *
                                        0.5,
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
              Container(
                margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.17,
                ),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(5),
                        color: Colors.yellowAccent,
                        child: Text(
                          'Order In progress',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                              color: Colors.black),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.45,
                        height: MediaQuery.of(context).size.height * 0.15,
                        child: ListView(
                          //   crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFormField(
                              maxLines: 2,
                              initialValue: '#$package_id',
                              readOnly: true,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                suffixIcon: InkWell(
                                  onTap: () async {
                                    await Clipboard.setData(
                                        ClipboardData(text: package_id));
                                    _showToast();
                                    HapticFeedback.mediumImpact();
                                  },
                                  child: Icon(
                                    Icons.copy,
                                    size: 15,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Placed On: $time1',
                              style: TextStyle(fontSize: 18),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Order Number: $ordernum',
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: EdgeInsets.only(
                    left: 10,
                    top: MediaQuery.of(context).size.height * 0.01,
                  ),
                  height: MediaQuery.of(context).size.height * 0.17,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Color.fromARGB(255, 216, 216, 216).withOpacity(.7),
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(10.0))),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FittedBox(
                          child: Container(
                            // color: Colors.black,
                            width: MediaQuery.of(context).size.width * 0.5,
                            height: MediaQuery.of(context).size.height * 0.02,
                            child: Text(
                              'Billing Details:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.008,
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.03,
                          child: Row(
                            children: [
                              Text('Name:  ',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Text(
                                name ?? '',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.03,
                          child: Row(
                            children: [
                              Text('Number:  ',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Text(
                                number ?? '',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.03,
                          child: Row(
                            children: [
                              Text(
                                'Email:  ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                email ?? '',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.03,
                          child: Row(
                            children: [
                              Text('Address:  ',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Text(
                                '${address ?? ''}, ${location ?? ''}',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(),
                              ),
                            ],
                          ),
                        ),
                      ]),
                ),
              ),
            ],
          );
        });
  }

  void _showToast() async {
    SmartDialog.showToast('Coppied to Clipboard',
        displayType: SmartToastType.onlyRefresh);
    await Future.delayed(Duration(milliseconds: 500));
  }
}
