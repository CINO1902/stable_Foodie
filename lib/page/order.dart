import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foodie_ios/linkfile/Model/cartrecieve.dart';
import 'package:foodie_ios/linkfile/provider/checkcart.dart';
import 'package:foodie_ios/linkfile/provider/greetings.dart';

import 'package:foodie_ios/linkfile/provider/onboarding.dart';

import 'package:grouped_list/grouped_list.dart';

import 'package:provider/provider.dart';

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
    super.initState();
    //context.read<checkcart>().checkcarts();
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
        centerTitle: false,
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          'History of Order',
          style: TextStyle(
              color: Theme.of(context).primaryColorDark,
              fontSize: 27,
              fontWeight: FontWeight.bold),
        ),
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
                        color: Theme.of(context).primaryColor,
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                            height: 100,
                            width: 100,
                            child: SvgPicture.asset(
                              'images/empty.svg',
                              color: Theme.of(context).primaryColorDark,
                            )),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        'No record',
                        style: TextStyle(
                          fontSize: 29,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColorDark,
                        ),
                      )
                    ],
                  );
                } else {
                  orderresults = value.orderesult;
                  return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: Column(
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
                              indexedItemBuilder:
                                  (BuildContext context, index, indexed) {
                                return orderresults[indexed].specialName == null
                                    ? Cartbox(context, index, indexed)
                                    : Cartbox2(context, index, indexed);
                              }),
                        ),
                        context.watch<checkcart>().isloadmore == true
                            ? Padding(
                                padding: const EdgeInsets.only(bottom: 30),
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
                                  decoration:
                                      BoxDecoration(color: Colors.amber),
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
                    ),
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

  Widget Cartbox(BuildContext context, Pagnited indexx, int indexed) {
    return Container(
      margin: EdgeInsets.all(10),
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.13,
      child: InkWell(
        onTap: () {
          modalpopup(
              context,
              indexed,
              orderresults[indexed].image,
              orderresults[indexed].multiple,
              orderresults[indexed].food,
              orderresults[indexed].extras,
              orderresults[indexed].amount,
              orderresults[indexed].total,
              orderresults[indexed].packageid,
              orderresults[indexed].date,
              orderresults[indexed].ordernum,
              orderresults[indexed].email,
              orderresults[indexed].name,
              orderresults[indexed].number,
              orderresults[indexed].address,
              orderresults[indexed].location);
        },
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
            SizedBox(
              height: double.infinity,
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
                        imageUrl: orderresults[indexed].image,
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) => Icon(Icons.error),
                        width: 90,
                        height: MediaQuery.of(context).size.width * 0.25,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.17,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 5,
                          ),
                          SizedBox(
                            child: Text(
                              '${orderresults[indexed].multiple} X',
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
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            '${orderresults[indexed].food}',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 17),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.07,
                            child: ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: orderresults[indexed].extras!.length,
                                itemBuilder: (context, index) {
                                  return Text(
                                    '${orderresults[indexed].extras![index].the5}',
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
                            height: 5,
                          ),
                          SizedBox(
                            child: Text(
                              '${orderresults[indexed].amount}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 17),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.07,
                            child: ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: orderresults[indexed].extras!.length,
                                itemBuilder: (context, index) {
                                  return Text(
                                    '${orderresults[indexed].extras![index].the1}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16),
                                  );
                                }),
                          ),
                        ]),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      width: 60,
                      height: 30,
                      padding: EdgeInsets.symmetric(horizontal: 3),
                      decoration: BoxDecoration(
                          color: context
                                  .watch<checkcart>()
                                  .itemsquote[indexed]
                                  .contains(1)
                              ? Colors.yellow.withOpacity(.5)
                              : context
                                      .watch<checkcart>()
                                      .itemsquote[indexed]
                                      .contains(2)
                                  ? Color.fromARGB(255, 171, 122, 82)
                                      .withOpacity(.5)
                                  : context
                                          .watch<checkcart>()
                                          .itemsquote[indexed]
                                          .contains(3)
                                      ? Colors.green.withOpacity(.5)
                                      : context
                                              .watch<checkcart>()
                                              .itemsquote[indexed]
                                              .contains(4)
                                          ? Colors.red.withOpacity(.5)
                                          : Colors.black,
                          borderRadius: BorderRadius.circular(10)),
                      child: FittedBox(
                          child: context
                                  .watch<checkcart>()
                                  .itemsquote[indexed]
                                  .contains(1)
                              ? Text(
                                  'Processing',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.yellow.shade700,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              : context
                                      .watch<checkcart>()
                                      .itemsquote[indexed]
                                      .contains(2)
                                  ? const Text(
                                      'Packaged',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 251, 186, 45),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  : context
                                          .watch<checkcart>()
                                          .itemsquote[indexed]
                                          .contains(3)
                                      ? const Text(
                                          'Sent Out',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 120, 228, 92),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                      : context
                                              .watch<checkcart>()
                                              .itemsquote[indexed]
                                              .contains(4)
                                          ? const Text(
                                              'Returned',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 251, 45, 45),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            )
                                          : const Text('')),
                    ),
                  )
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 20,
                margin: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.11),
                width: MediaQuery.of(context).size.width * 0.5,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total:',
                        style: TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 17)),
                    Text('${orderresults[indexed].total}',
                        style: const TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 17))
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> modalpopup(
      BuildContext context,
      indexed,
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
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
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                      child: Text(
                        'Order Detail',
                        style: TextStyle(
                            fontSize: 23, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.30,
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: SvgPicture.asset(
                              'images/svg/Pattern-7.svg',
                              fit: BoxFit.cover,
                              height: MediaQuery.of(context).size.height * 0.30,
                              color: Theme.of(context).primaryColorLight,
                              colorBlendMode: BlendMode.difference,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      Align(
                                        alignment: Alignment.topCenter,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          child: CachedNetworkImage(
                                            imageUrl: image ?? '',
                                            fit: BoxFit.cover,
                                            errorWidget:
                                                (context, url, error) =>
                                                    Icon(Icons.error),
                                            width: 90,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.12,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  SizedBox(
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            child: Text(
                                              '$multiple X',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 19),
                                            ),
                                          ),
                                          SizedBox(
                                            child: const Text(
                                              'Extras:',
                                              style: TextStyle(fontSize: 17),
                                            ),
                                          ),
                                        ]),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.34,
                                    child: Column(
                                      children: [
                                        Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                '$food',
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 17),
                                              ),
                                              SizedBox(
                                                width: 50,
                                                child: Text(
                                                  '₦ $amount',
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 16),
                                                ),
                                              ),
                                            ]),
                                        SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.23,
                                          child: ListView.builder(
                                              shrinkWrap: true,
                                              itemCount: extra.length,
                                              itemBuilder: (context, index) {
                                                return Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    SizedBox(
                                                      width: 60,
                                                      child: Text(
                                                        '${extra![index].the5}',
                                                        // overflow-: TextOverflow.ellipsis,
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontSize: 16),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 50,
                                                      child: Text(
                                                        '₦ ${extra![index].the1}',
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontSize: 15),
                                                      ),
                                                    )
                                                  ],
                                                );
                                              }),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: Container(
                                      width: 60,
                                      height: 30,
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 3),
                                      decoration: BoxDecoration(
                                          color: context
                                                  .watch<checkcart>()
                                                  .itemsquote[indexed]
                                                  .contains(1)
                                              ? Colors.yellow.withOpacity(.5)
                                              : context
                                                      .watch<checkcart>()
                                                      .itemsquote[indexed]
                                                      .contains(2)
                                                  ? Color.fromARGB(
                                                          255, 171, 122, 82)
                                                      .withOpacity(.5)
                                                  : context
                                                          .watch<checkcart>()
                                                          .itemsquote[indexed]
                                                          .contains(3)
                                                      ? Colors.green
                                                          .withOpacity(.5)
                                                      : context
                                                              .watch<
                                                                  checkcart>()
                                                              .itemsquote[
                                                                  indexed]
                                                              .contains(4)
                                                          ? Colors.red
                                                              .withOpacity(.5)
                                                          : Colors.black,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: FittedBox(
                                          child: context
                                                  .watch<checkcart>()
                                                  .itemsquote[indexed]
                                                  .contains(1)
                                              ? Text(
                                                  'Processing',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color:
                                                        Colors.yellow.shade700,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                )
                                              : context
                                                      .watch<checkcart>()
                                                      .itemsquote[indexed]
                                                      .contains(2)
                                                  ? const Text(
                                                      'Packaged',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 251, 186, 45),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    )
                                                  : context
                                                          .watch<checkcart>()
                                                          .itemsquote[indexed]
                                                          .contains(3)
                                                      ? const Text(
                                                          'Sent Out',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    120,
                                                                    228,
                                                                    92),
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        )
                                                      : context
                                                              .watch<
                                                                  checkcart>()
                                                              .itemsquote[
                                                                  indexed]
                                                              .contains(4)
                                                          ? const Text(
                                                              'Returned',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        251,
                                                                        45,
                                                                        45),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            )
                                                          : const Text('')),
                                    ),
                                  )
                                ]),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height * 0.14,
                                left: 10),
                            width: 155,
                            height: MediaQuery.of(context).size.height * 0.15,
                            child: ListView(
                              children: [
                                Text(
                                  'Code:',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  height: 45,
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Color.fromARGB(255, 216, 216, 216)
                                          .withOpacity(.7)),
                                  child: Stack(
                                    children: [
                                      Text(
                                        '#$package_id',
                                        style: TextStyle(fontSize: 15),
                                      ),
                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child: Container(
                                          height: 23,
                                          width: 23,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: Colors.white,
                                          ),
                                          child: InkWell(
                                            onTap: () async {
                                              await Clipboard.setData(
                                                  ClipboardData(
                                                      text: package_id));
                                              _showToast();
                                              HapticFeedback.mediumImpact();
                                            },
                                            child: Icon(
                                              Icons.copy,
                                              color: Colors.grey,
                                              size: 15,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'Placed On: $time1',
                                  style: TextStyle(fontSize: 15),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'Order Number: $ordernum',
                                  style: TextStyle(fontSize: 15),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
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
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.7,
                                child: Text(
                                  '${address ?? ''}, ${location ?? ''}',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(),
                                ),
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

  Widget Cartbox2(BuildContext context, Pagnited value, int indexx) {
    return Container(
      margin: const EdgeInsets.all(10),
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.15,
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
                  modalpopup2(
                      context,
                      value.image,
                      value.multiple,
                      value.food,
                      value.sides,
                      value.amount,
                      value.total,
                      orderresults,
                      orderresults[indexx].date,
                      indexx);
                },
                child: Stack(
                  children: [
                    Row(
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
                              imageUrl: orderresults[indexx].image,
                              fit: BoxFit.cover,
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                              width: 90,
                              height: MediaQuery.of(context).size.width * 0.23,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.5,
                          height: MediaQuery.of(context).size.height * 0.13,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      child: Text(
                                        '${orderresults[indexx].multiple} X',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 19),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    SizedBox(
                                      width: 100,
                                      child: Text(
                                        '${orderresults[indexx].specialName}',
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 7,
                                ),
                                orderresults[indexx].sides!.isNotEmpty
                                    ? Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                            SizedBox(
                                              child: const Text(
                                                'Sides:',
                                                style: TextStyle(
                                                  fontSize: 17,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.03,
                                              width: 100,
                                              child: ListView.builder(
                                                  shrinkWrap: true,
                                                  physics:
                                                      const NeverScrollableScrollPhysics(),
                                                  itemCount:
                                                      orderresults[indexx]
                                                          .sides!
                                                          .length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return Text(
                                                      '${orderresults[indexx].sides![index]["1"]}',
                                                      // overflow-: TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                          fontSize: 17),
                                                    );
                                                  }),
                                            ),
                                          ])
                                    : SizedBox(),
                                orderresults[indexx].drinks!.isNotEmpty
                                    ? Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                            SizedBox(
                                              child: const Text(
                                                'Drinks:',
                                                style: TextStyle(
                                                  fontSize: 17,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.03,
                                              width: 100,
                                              child: ListView.builder(
                                                  shrinkWrap: true,
                                                  physics:
                                                      const NeverScrollableScrollPhysics(),
                                                  itemCount:
                                                      orderresults[indexx]
                                                          .drinks!
                                                          .length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return Text(
                                                      '${orderresults[indexx].drinks![index]["1"]}',
                                                      // overflow-: TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                          fontSize: 17),
                                                    );
                                                  }),
                                            ),
                                          ])
                                    : SizedBox(),
                                orderresults[indexx].foods!.isNotEmpty
                                    ? Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                            SizedBox(
                                              child: const Text(
                                                'Food:',
                                                style: TextStyle(
                                                  fontSize: 17,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.03,
                                              width: 100,
                                              child: ListView.builder(
                                                  shrinkWrap: true,
                                                  physics:
                                                      const NeverScrollableScrollPhysics(),
                                                  itemCount:
                                                      orderresults[indexx]
                                                          .foods!
                                                          .length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return Text(
                                                      '${orderresults[indexx].foods![index]["1"]}',
                                                      // overflow-: TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                          fontSize: 17),
                                                    );
                                                  }),
                                            ),
                                          ])
                                    : SizedBox(),
                              ]),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                            width: 60,
                            height: 30,
                            padding: EdgeInsets.symmetric(horizontal: 3),
                            decoration: BoxDecoration(
                                color: context
                                        .watch<checkcart>()
                                        .itemsquote[indexx]
                                        .contains(1)
                                    ? Colors.yellow.withOpacity(.5)
                                    : context
                                            .watch<checkcart>()
                                            .itemsquote[indexx]
                                            .contains(2)
                                        ? Color.fromARGB(255, 171, 122, 82)
                                            .withOpacity(.5)
                                        : context
                                                .watch<checkcart>()
                                                .itemsquote[indexx]
                                                .contains(3)
                                            ? Colors.green.withOpacity(.5)
                                            : context
                                                    .watch<checkcart>()
                                                    .itemsquote[indexx]
                                                    .contains(4)
                                                ? Colors.red.withOpacity(.5)
                                                : Colors.black,
                                borderRadius: BorderRadius.circular(10)),
                            child: FittedBox(
                                child: context
                                        .watch<checkcart>()
                                        .itemsquote[indexx]
                                        .contains(1)
                                    ? Text(
                                        'Processing',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.yellow.shade700,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    : context
                                            .watch<checkcart>()
                                            .itemsquote[indexx]
                                            .contains(2)
                                        ? const Text(
                                            'Packaged',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 251, 186, 45),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                        : context
                                                .watch<checkcart>()
                                                .itemsquote[indexx]
                                                .contains(3)
                                            ? const Text(
                                                'Sent Out',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 120, 228, 92),
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              )
                                            : context
                                                    .watch<checkcart>()
                                                    .itemsquote[indexx]
                                                    .contains(4)
                                                ? const Text(
                                                    'Returned',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 251, 45, 45),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  )
                                                : const Text('')),
                          ),
                        )
                      ],
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                          height: 20,
                          margin: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0.3),
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: Text('₦ ${orderresults[indexx].amount}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w400, fontSize: 17))),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<dynamic> modalpopup2(BuildContext context, image, multiple, food,
      extra, amount, total, List<Pagnited> cartresults, date, indexx) {
    return showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(35), topRight: Radius.circular(35))),
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
                            height: MediaQuery.of(context).size.height * 0.3,
                            color: Theme.of(context).primaryColorLight,
                            colorBlendMode: BlendMode.difference,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.265,
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    children: [
                                      Align(
                                        alignment: Alignment.topCenter,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          child: CachedNetworkImage(
                                            imageUrl: image ?? '',
                                            fit: BoxFit.cover,
                                            errorWidget:
                                                (context, url, error) =>
                                                    Icon(Icons.error),
                                            width: 110,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.27,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 110,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.14,
                                        child: ListView(
                                          children: [
                                            Text(
                                              'Code:',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Container(
                                              height: 45,
                                              padding: EdgeInsets.all(5),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  color: Color.fromARGB(
                                                          255, 216, 216, 216)
                                                      .withOpacity(.7)),
                                              child: Stack(
                                                children: [
                                                  Text(
                                                    '${orderresults[indexx].packageid}',
                                                    style:
                                                        TextStyle(fontSize: 15),
                                                  ),
                                                  Align(
                                                    alignment:
                                                        Alignment.bottomRight,
                                                    child: Container(
                                                      height: 23,
                                                      width: 23,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                        color: Colors.white,
                                                      ),
                                                      child: InkWell(
                                                        onTap: () async {
                                                          await Clipboard.setData(
                                                              ClipboardData(
                                                                  text:
                                                                      '${orderresults[indexx].packageid}'));
                                                          _showToast();
                                                          HapticFeedback
                                                              .mediumImpact();
                                                        },
                                                        child: Icon(
                                                          Icons.copy,
                                                          color: Colors.grey,
                                                          size: 15,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              'Placed On: $time1',
                                              style: TextStyle(fontSize: 15),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              'Order Number: ${orderresults[indexx].ordernum}',
                                              style: TextStyle(fontSize: 15),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.43,
                                    height: MediaQuery.of(context).size.height *
                                        0.265,
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              SizedBox(
                                                child: Text(
                                                  '${cartresults[indexx].multiple} X',
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 19),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              SizedBox(
                                                width: 100,
                                                child: Text(
                                                  '${cartresults[indexx].specialName}',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 17),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 7,
                                          ),
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.23,
                                            child: ListView(
                                              shrinkWrap: true,
                                              children: [
                                                cartresults[indexx]
                                                        .sides!
                                                        .isNotEmpty
                                                    ? Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                            SizedBox(
                                                              child: const Text(
                                                                'Sides:',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 17,
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 7,
                                                            ),
                                                            Container(
                                                              width: 100,
                                                              constraints:
                                                                  BoxConstraints(
                                                                maxHeight: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .height *
                                                                    0.12,
                                                                minHeight: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .height *
                                                                    0.03,
                                                              ),
                                                              child: ListView
                                                                  .builder(
                                                                      shrinkWrap:
                                                                          true,
                                                                      physics:
                                                                          const NeverScrollableScrollPhysics(),
                                                                      itemCount: cartresults[
                                                                              indexx]
                                                                          .sides!
                                                                          .length,
                                                                      itemBuilder:
                                                                          (context,
                                                                              index) {
                                                                        return Container(
                                                                          margin:
                                                                              EdgeInsets.only(bottom: 5),
                                                                          child:
                                                                              Text(
                                                                            '${cartresults[indexx].sides![index]["1"]}',
                                                                            // overflow-: TextOverflow.ellipsis,
                                                                            style:
                                                                                const TextStyle(fontSize: 17),
                                                                          ),
                                                                        );
                                                                      }),
                                                            ),
                                                          ])
                                                    : SizedBox(),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                cartresults[indexx]
                                                        .drinks!
                                                        .isNotEmpty
                                                    ? Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                            SizedBox(
                                                              child: const Text(
                                                                'Drinks:',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 17,
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 7,
                                                            ),
                                                            Container(
                                                              width: 100,
                                                              constraints:
                                                                  BoxConstraints(
                                                                maxHeight: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .height *
                                                                    0.12,
                                                                minHeight: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .height *
                                                                    0.03,
                                                              ),
                                                              child: ListView
                                                                  .builder(
                                                                      shrinkWrap:
                                                                          true,
                                                                      physics:
                                                                          const NeverScrollableScrollPhysics(),
                                                                      itemCount: cartresults[
                                                                              indexx]
                                                                          .drinks!
                                                                          .length,
                                                                      itemBuilder:
                                                                          (context,
                                                                              index) {
                                                                        return Container(
                                                                          margin:
                                                                              EdgeInsets.only(bottom: 5),
                                                                          child:
                                                                              Text(
                                                                            '${cartresults[indexx].drinks![index]["1"]}',
                                                                            style:
                                                                                const TextStyle(fontSize: 17),
                                                                          ),
                                                                        );
                                                                      }),
                                                            ),
                                                          ])
                                                    : SizedBox(),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                cartresults[indexx]
                                                        .foods!
                                                        .isNotEmpty
                                                    ? Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                            SizedBox(
                                                              child: const Text(
                                                                'Food:',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 17,
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 7,
                                                            ),
                                                            Container(
                                                              width: 100,
                                                              constraints:
                                                                  BoxConstraints(
                                                                maxHeight: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .height *
                                                                    0.12,
                                                                minHeight: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .height *
                                                                    0.03,
                                                              ),
                                                              child: ListView
                                                                  .builder(
                                                                      shrinkWrap:
                                                                          true,
                                                                      physics:
                                                                          const NeverScrollableScrollPhysics(),
                                                                      itemCount: cartresults[
                                                                              indexx]
                                                                          .foods!
                                                                          .length,
                                                                      itemBuilder:
                                                                          (context,
                                                                              index) {
                                                                        return Container(
                                                                          margin:
                                                                              EdgeInsets.only(bottom: 5),
                                                                          child:
                                                                              Text(
                                                                            '${cartresults[indexx].foods![index]["1"]}',
                                                                            style:
                                                                                const TextStyle(fontSize: 17),
                                                                          ),
                                                                        );
                                                                      }),
                                                            ),
                                                          ])
                                                    : SizedBox(),
                                              ],
                                            ),
                                          ),
                                        ]),
                                  ),
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: Container(
                                      width: 60,
                                      height: 30,
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 3),
                                      decoration: BoxDecoration(
                                          color: context
                                                  .watch<checkcart>()
                                                  .itemsquote[indexx]
                                                  .contains(1)
                                              ? Colors.yellow.withOpacity(.5)
                                              : context
                                                      .watch<checkcart>()
                                                      .itemsquote[indexx]
                                                      .contains(2)
                                                  ? Color.fromARGB(
                                                          255, 171, 122, 82)
                                                      .withOpacity(.5)
                                                  : context
                                                          .watch<checkcart>()
                                                          .itemsquote[indexx]
                                                          .contains(3)
                                                      ? Colors.green
                                                          .withOpacity(.5)
                                                      : context
                                                              .watch<
                                                                  checkcart>()
                                                              .itemsquote[
                                                                  indexx]
                                                              .contains(4)
                                                          ? Colors.red
                                                              .withOpacity(.5)
                                                          : Colors.black,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: FittedBox(
                                          child: context
                                                  .watch<checkcart>()
                                                  .itemsquote[indexx]
                                                  .contains(1)
                                              ? Text(
                                                  'Processing',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color:
                                                        Colors.yellow.shade700,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                )
                                              : context
                                                      .watch<checkcart>()
                                                      .itemsquote[indexx]
                                                      .contains(2)
                                                  ? const Text(
                                                      'Packaged',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 251, 186, 45),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    )
                                                  : context
                                                          .watch<checkcart>()
                                                          .itemsquote[indexx]
                                                          .contains(3)
                                                      ? const Text(
                                                          'Sent Out',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    120,
                                                                    228,
                                                                    92),
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        )
                                                      : context
                                                              .watch<
                                                                  checkcart>()
                                                              .itemsquote[
                                                                  indexx]
                                                              .contains(4)
                                                          ? const Text(
                                                              'Returned',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        251,
                                                                        45,
                                                                        45),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            )
                                                          : const Text('')),
                                    ),
                                  )
                                ]),
                          ),
                        ),
                      ],
                    ),
                  ],
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
                                orderresults[indexx].name ?? '',
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
                                orderresults[indexx].number ?? '',
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
                                orderresults[indexx].email ?? '',
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
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.7,
                                child: Text(
                                  '${orderresults[indexx].address ?? ''}, ${orderresults[indexx].location ?? ''}',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(),
                                ),
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
}
