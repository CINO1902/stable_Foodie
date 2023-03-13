import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_native_splash/cli_commands.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_svg/svg.dart';
import 'package:foodie_ios/linkfile/Model/getItem_model.dart';
import 'package:foodie_ios/linkfile/customesnackbar.dart';
import 'package:foodie_ios/linkfile/enum/connectivity_status.dart';

import 'package:foodie_ios/linkfile/provider/calculatemael.dart';
import 'package:foodie_ios/linkfile/provider/checkcart.dart';
import 'package:foodie_ios/linkfile/provider/getItem.dart';
import 'package:foodie_ios/linkfile/provider/getItemextra.dart';
import 'package:foodie_ios/linkfile/provider/getsubhistory.dart';
import 'package:foodie_ios/linkfile/provider/greetings.dart';
import 'package:foodie_ios/linkfile/provider/internetchecker.dart';
import 'package:foodie_ios/linkfile/provider/mostcommon.dart';
import 'package:foodie_ios/linkfile/provider/notification.dart';
import 'package:foodie_ios/linkfile/provider/onboarding.dart';
import 'package:foodie_ios/linkfile/provider/subscribed.dart';
import 'package:foodie_ios/linkfile/refresh.dart';
import 'package:foodie_ios/onboarding.dart';
import 'package:foodie_ios/page/addnewaddress.dart';
import 'package:foodie_ios/page/addperaddress.dart';
import 'package:foodie_ios/page/notifications.dart';
import 'package:foodie_ios/page/overlay.dart';
import 'package:foodie_ios/page/review.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  List<String> cartmain = [];
  bool hasInternet = false;

  late StreamSubscription subscription;
  @override
  void initState() {
    super.initState();
    context.read<greetings>().gettim();
    context.read<getiItem>().getItem();
    context.read<checkstate>().getID();

    context.read<notifications>().getnotification();

    checkregistered();
  }

  List<Item> items = [];
  String? token;
  //String? address;
  bool network = false;
  checkregistered() async {
    final prefs = await SharedPreferences.getInstance();
    context.read<checkcart>().checkcarts();
    context.read<checkcart>().checkcartforcart();
    print(prefs.getInt('ID'));
    context.read<checkstate>().getaddress();
    setState(() {
      token = prefs.getString("tokenregistered");
    });

    if (token != null) {
      context.read<checkstate>().getregisterdID();
      context.read<getmostcommon>().getcommon();
      context.read<getsubhistory>().getordersub();
      context.read<subscribed>().getsubscribed();
    }
  }

  final ScrollController control = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.25,
            width: double.infinity,
            decoration: const BoxDecoration(
                color: Color.fromARGB(255, 255, 46, 31),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20))),
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: MediaQuery.of(context).size.height * 0.06),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.watch<greetings>().greetingss,
                            style: TextStyle(
                                color: Colors.white.withOpacity(.8),
                                fontSize: 19),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01,
                          ),
                          context.watch<checkstate>().checkregisteredlogg()
                              ? SizedBox(
                                  height: 20,
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
                                  child: FittedBox(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      context
                                                  .watch<checkstate>()
                                                  .firstname
                                                  .split(' ')[0] !=
                                              ''
                                          ? 'Hello ${context.watch<checkstate>().firstname.split(' ')[0].capitalize()}'
                                          : '',
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                )
                              : context.watch<checkstate>().notloggedname == ''
                                  ? const Text(
                                      'Hello User',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 21,
                                          fontWeight: FontWeight.bold),
                                    )
                                  : SizedBox(
                                      height: 25,
                                      width: MediaQuery.of(context).size.width *
                                          0.4,
                                      child: FittedBox(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          'Hello ${context.watch<checkstate>().notloggedname.split(' ')[0].capitalize()}',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 21,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01,
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.047,
                            //width: MediaQuery.of(context).size.width * 0.025,
                            child: Text(
                              'Find a food you like us to deliver',
                              softWrap: true,
                              style: TextStyle(
                                  color: Colors.white.withOpacity(.8),
                                  fontSize: 16),
                            ),
                          )
                        ]),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            color: Colors.white,
                          ),
                          Container(
                            constraints: BoxConstraints(
                                minWidth: 50,
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.4),
                            child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              addAddressper()));
                                },
                                child: token != null
                                    ? context.watch<checkstate>().checkaddress()
                                        ? SizedBox(
                                            child: Text(
                                              context
                                                  .watch<checkstate>()
                                                  .address,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          )
                                        : Text(
                                            'Set Location',
                                            style:
                                                TextStyle(color: Colors.white),
                                          )
                                    : context
                                                .watch<checkstate>()
                                                .notloggedaddress !=
                                            ''
                                        ? SizedBox(
                                            child: Text(
                                              context
                                                  .watch<checkstate>()
                                                  .notloggedaddress,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          )
                                        : Text(
                                            'Set Location',
                                            style:
                                                TextStyle(color: Colors.white),
                                          )),
                          )
                        ],
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, '/cart');
                        },
                        child: Stack(
                          alignment: AlignmentDirectional.topEnd,
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              margin: EdgeInsets.only(
                                  top:
                                      MediaQuery.of(context).size.height * 0.03,
                                  left: 20),
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 224, 224, 224)
                                          .withOpacity(.8),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SvgPicture.asset(
                                  'images/shopping-cart-svgrepo-com.svg',
                                  height: 10,
                                  width: 10,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Positioned(
                                top: MediaQuery.of(context).size.height * 0.03,
                                right: 3,
                                child: Container(
                                  // color: Colors.red,
                                  child: Text(
                                    context
                                        .watch<checkcart>()
                                        .cartresult
                                        .length
                                        .toString(),
                                    style: const TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16),
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Container(
            alignment: Alignment.topCenter,
            margin:
                EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.21),
            child: Card(
              elevation: 2.7,
              color: Colors.black,
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.17,
                width: MediaQuery.of(context).size.width * 0.9,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin:
                          const EdgeInsets.only(left: 20, top: 20, right: 20),
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'New and Hot',
                            style: TextStyle(color: Colors.yellow),
                          ),
                          Text(
                            'Enjoy 2 meals per day for as low a ₦35,000',
                            style: TextStyle(color: Colors.white, fontSize: 22),
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: Image.asset(
                          'images/rice.jpg',
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Container(
            margin:
                EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.4),
            decoration: BoxDecoration(
                color: Colors.red.withOpacity(.1),
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20))),
            child: Consumer<getiItem>(builder: (context, value, child) {
              if (value.data == false) {
                return Center(
                  child: CircularProgressIndicator(
                    color: Theme.of(context).primaryColor,
                  ),
                );
              } else if (value.error == true) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Something Went wrong',
                        style: TextStyle(fontSize: 17),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      InkWell(
                        onTap: () async {
                          await context.read<getiItem>().getItem();
                        },
                        child: Container(
                          height: 30,
                          width: 80,
                          decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(10)),
                          child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                "Retry",
                                style: TextStyle(
                                    color: Color.fromARGB(255, 63, 63, 63),
                                    fontSize: 18),
                              )),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                items = value.items
                    .where((element) => element.extraable == false)
                    .toList();

                return RefreshWidget(
                  control: control,
                  onRefresh: () async {
                    await checkregistered();
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 10),
                        child: const Text(
                          'Quick Buy',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Platform.isAndroid
                          ? Expanded(
                              child: GridView.builder(
                                shrinkWrap: true,
                                padding: EdgeInsets.zero,
                                primary: Platform.isAndroid ? true : false,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 10,
                                        mainAxisSpacing: 20),
                                itemCount: items.length,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const Review()));
                                      //  Navigator.pushNamed(context, '/review');
                                      context.read<calculatemeal>().itemclick(
                                            items[index].item,
                                            items[index].imageUrl,
                                            int.parse(items[index].mincost),
                                            int.parse(items[index].mincost),
                                            items[index].itemId,
                                            items[index].maxspoon,
                                          );
                                      context
                                          .read<getiItemExtra>()
                                          .getItemExtra(items[index].itemId);
                                    },
                                    child: SizedBox(
                                      height: 70,
                                      width: 30,
                                      child: Column(
                                          //
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  child: CachedNetworkImage(
                                                    imageUrl:
                                                        items[index].imageUrl ??
                                                            '',
                                                    fit: BoxFit.fill,
                                                    errorWidget:
                                                        (context, url, error) =>
                                                            Icon(Icons.error),
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.4,
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.35,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  items[index].item ?? '',
                                                  style: const TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                    'Min: ${items[index].mincost}')
                                              ],
                                            ),
                                          ]),
                                    ),
                                  );
                                },
                              ),
                            )
                          : GridView.builder(
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              primary: Platform.isAndroid ? true : false,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      // childAspectRatio: 3 / 2,
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 20),
                              itemCount: items.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const Review()));
                                    //  Navigator.pushNamed(context, '/review');
                                    context.read<calculatemeal>().itemclick(
                                        items[index].item,
                                        items[index].imageUrl,
                                        int.parse(items[index].mincost),
                                        int.parse(items[index].mincost),
                                        items[index].itemId,
                                        items[index].maxspoon);
                                    context
                                        .read<getiItemExtra>()
                                        .getItemExtra(items[index].itemId);
                                  },
                                  child: SizedBox(
                                    height: 70,
                                    width: 30,
                                    //color: Colors.black,
                                    child: Column(
                                        //
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                child: CachedNetworkImage(
                                                  imageUrl:
                                                      items[index].imageUrl ??
                                                          '',
                                                  fit: BoxFit.fill,
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          Icon(Icons.error),
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.4,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.35,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                items[index].item ?? '',
                                                style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                  'Min: ${items[index].mincost}')
                                            ],
                                          ),
                                        ]),
                                  ),
                                );
                              },
                            ),
                    ],
                  ),
                );
              }
            }),
          ),
        ],
      ),
    );
  }
}
