import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

import 'package:foodie_ios/linkfile/Model/getsubhistory.dart';
import 'package:foodie_ios/linkfile/enum/connectivity_status.dart';
import 'package:foodie_ios/linkfile/provider/addTocart.dart';
import 'package:foodie_ios/linkfile/provider/getsubhistory.dart';
import 'package:foodie_ios/linkfile/provider/greetings.dart';
import 'package:foodie_ios/linkfile/provider/internetchecker.dart';
import 'package:foodie_ios/linkfile/provider/onboarding.dart';
import 'package:foodie_ios/page/overlay.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:provider/provider.dart';

class fullsubhistory extends StatefulWidget {
  const fullsubhistory({super.key});

  @override
  State<fullsubhistory> createState() => _fullsubhistoryState();
}

class _fullsubhistoryState extends State<fullsubhistory> {
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
  List<String> dateget = [];

  List<Pagnited> history = [];
  late ScrollController controller;
  bool network = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = ScrollController()
      ..addListener(() async {
        if (controller.position.maxScrollExtent == controller.position.pixels) {
          await context.read<getsubhistory>().loadmore();
        }
      });
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
        title: Text('History'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Container(
        margin: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.07, vertical: 20),
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        height: MediaQuery.of(context).size.height * 0.9,
        width: double.infinity,
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(15)),
        child: Consumer<getsubhistory>(builder: (context, value, child) {
          if (value.loading == false) {
            return Center(
              child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor),
            );
          } else if (value.loading == true) {
            history = value.fullresult;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: GroupedListView<Pagnited, DateTime>(
                      controller: controller,
                      shrinkWrap: true,
                      order: GroupedListOrder.ASC,
                      groupBy: (Pagnited element) => DateTime(
                            element.date.year,
                            element.date.month,
                            element.date.day,
                          ),
                      elements: history,
                      itemComparator: (Pagnited element1, Pagnited element2) =>
                          element2.date.compareTo(element1.date),
                      groupComparator: (DateTime value1, DateTime value2) =>
                          value2.compareTo(value1),
                      groupSeparatorBuilder: (DateTime date) {
                        DateTime? currentdate = context.watch<greetings>().time;
                        final day = date.hour;
                        final currentday = currentdate.hour;
                        String date1 = '';
                        final difference = currentdate.difference(date).inDays;
                        print(currentday);
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
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                        );
                      },
                      padding: EdgeInsets.zero,
                      itemBuilder: (BuildContext context, element) {
                        String getclass() {
                          switch (element.category) {
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

                        return InkWell(
                          onTap: () {
                            opensubhistory(
                                context,
                                element.image,
                                element.packagename,
                                element.status,
                                element.date,
                                element.ordernum,
                                element.address,
                                element.name,
                                element.number,
                                element.email,
                                element.location);
                          },
                          child: Container(
                            height: 70,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10)),
                            child: Row(
                              children: [
                                SizedBox(
                                  height: 50,
                                  width: 50,
                                  child: CachedNetworkImage(
                                    imageUrl: element.image,
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
                                    height: MediaQuery.of(context).size.width *
                                        0.35,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  padding: const EdgeInsets.only(top: 10),
                                  width:
                                      MediaQuery.of(context).size.width * 0.55,
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
                                                0.35,
                                            child: Text(
                                              ' ${element.packagename} ',
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.only(left: 5),
                                            child: Text(
                                              getclass(),
                                              style: TextStyle(
                                                fontSize: 17,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      element.status == '1'
                                          ? Container(
                                              width: 60,
                                              color: Colors.yellowAccent,
                                              child: const Text(
                                                'Order In progress',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            )
                                          : Container(
                                              width: 60,
                                              color: Colors.greenAccent,
                                              child: const Text(
                                                'Delivered',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                ),
                context.watch<getsubhistory>().isloadmore == true
                    ? Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 30),
                        child: Center(
                          child: CircularProgressIndicator(
                              color: Theme.of(context).primaryColor),
                        ))
                    : Container(),
                context.watch<getsubhistory>().hasnextpage == false
                    ? Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 0),
                        child: Container(
                          height: 50,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.amber),
                          child: Center(
                              child: Text(
                            'You have fetched all content',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color:
                                    Theme.of(context).colorScheme.onSecondary),
                          )),
                        ),
                      )
                    : Container()
              ],
            );
          } else {
            return Center(
                child: CircularProgressIndicator(
                    color: Theme.of(context).primaryColor));
          }
        }),
      ),
    );
  }

  Future<dynamic> opensubhistory(BuildContext context, image, name, status,
      date, ordernum, address, realname, number, email, location) {
    return showModalBottomSheet(
        context: context,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        builder: (BuildContext context) {
          String datestring = date.toString();
          DateTime? currentdate = context.watch<greetings>().time;
          final day = date.hour;
          final currentday = currentdate.hour;
          String date1 = '';
          final difference = currentdate.difference(date).inDays;
          print(currentday);
          if (difference == 0) {
            date1 = 'Today';
          } else if (difference == 1) {
            date1 = 'Yesterday';
          } else if (difference > 1) {
            date1 = '${date.day}, ${months[date.month - 1]} ${date.year}';
          } else {
            date1 = '${date.day}, ${months[date.month - 1]} ${date.year}';
          }
          return StatefulBuilder(builder: (context, setstate) {
            return Stack(
              children: [
                ListView(
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    Container(
                      padding:
                          const EdgeInsets.only(top: 5, left: 20, right: 10),
                      width: double.infinity,
                      height: 30,
                      color: Theme.of(context).primaryColor,
                      child: Center(
                        child: Text(
                          'Order History',
                          style: TextStyle(
                            fontSize: 23,
                            letterSpacing: -0.4,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onTertiary,
                          ),
                        ),
                      ),
                    ),
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              Align(
                                alignment: Alignment.topCenter,
                                child: SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.12,
                                  width: 100,
                                  child: CachedNetworkImage(
                                    imageUrl: image ?? '',
                                    fit: BoxFit.cover,
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
                                    height: MediaQuery.of(context).size.width *
                                        0.35,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.45,
                                        child: Container(
                                          margin: EdgeInsets.only(
                                            left: 30,
                                          ),
                                          child: Text(
                                            '$name',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20),
                                          ),
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.only(left: 8.0),
                                            child: Text(
                                              'Status:',
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                          status == '1'
                                              ? Container(
                                                  width: 80,
                                                  color: Colors.yellowAccent,
                                                  child: Text(
                                                    'Order In progress',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                )
                                              : Container(
                                                  width: 80,
                                                  color: Colors.greenAccent,
                                                  child: Text(
                                                    'Delivered',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Padding(
                                              padding:
                                                  EdgeInsets.only(left: 8.0),
                                              child: Text(
                                                'Order Number:',
                                                style: TextStyle(
                                                    fontSize: 17,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.4,
                                              padding:
                                                  EdgeInsets.only(left: 10),
                                              child: Text(
                                                ordernum,
                                                style: TextStyle(
                                                  fontSize: 19,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ]),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.only(left: 8.0),
                                            child: Text(
                                              'Date:',
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.4,
                                            child: Text(
                                              date1,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 19,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ]),
                              ]),
                        ]),
                  ],
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
                        color:
                            Color.fromARGB(255, 216, 216, 216).withOpacity(.7),
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(10.0))),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FittedBox(
                            child: Container(
                              // color: Colors.black,
                              width: MediaQuery.of(context).size.width * 0.9,
                              height: MediaQuery.of(context).size.height * 0.02,
                              child: Text(
                                'Billing Address:',
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
                                  realname ?? '',
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
        });
  }
}
