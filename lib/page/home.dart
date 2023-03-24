import 'dart:async';
import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/cli_commands.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_svg/svg.dart';
import 'package:foodie_ios/linkfile/Model/getItem_model.dart';
import 'package:foodie_ios/linkfile/Model/imageside.dart';
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
import 'package:foodie_ios/linkfile/networkhandler.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter_svg_provider/flutter_svg_provider.dart' as Svg;

class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> with SingleTickerProviderStateMixin {
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
    getslide();
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

  late final TabController controller = TabController(length: 3, vsync: this)
    ..addListener(() {
      setState(() {});
    });
  final ScrollController control = ScrollController();
  List itemsslide = [];
  List linkios = [];
  List linkandroid = [];
  bool loading = true;
  String sucess = '';
  Future<void> getslide() async {
    try {
      setState(() {
        loading = true;
      });

      var response = await networkHandler.client
          .get(networkHandler.builderUrl('/getimageslider'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      });

      final decodedresponse = imagesliderFromJson(response.body);
      setState(() {
        itemsslide = decodedresponse.item;
        linkandroid = decodedresponse.linkandroid;
        linkios = decodedresponse.linkios;
        sucess = decodedresponse.success;
      });
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  List<Widget> generateimage() {
    return itemsslide
        .map((e) => ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: CachedNetworkImage(
                imageUrl: e ?? '',
                fit: BoxFit.fill,
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ))
        .toList();
  }

  int index1 = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            // color: Colors.red,
            height: MediaQuery.of(context).size.height * 0.18,
            width: double.infinity,
            child: SafeArea(
              top: true,
              bottom: false,
              maintainBottomViewPadding: false,
              child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 25,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          context.watch<checkstate>().checkregisteredlogg()
                              ? SizedBox(
                                  height: 30,
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
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                )
                              : context.watch<checkstate>().notloggedname == ''
                                  ? const Text(
                                      'Hello User',
                                      style: TextStyle(
                                          fontSize: 21,
                                          fontWeight: FontWeight.bold),
                                    )
                                  : SizedBox(
                                      height: 30,
                                      width: MediaQuery.of(context).size.width *
                                          0.4,
                                      child: FittedBox(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          'Hello ${context.watch<checkstate>().notloggedname.split(' ')[0].capitalize()}',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize: 21,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                          Row(
                            children: [
                              Container(
                                height: 35,
                                width: 30,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Theme.of(context).primaryColor,
                                ),
                                child: Center(
                                    child: SvgPicture.asset(
                                  'images/svg/Group18.svg',
                                  color: Colors.white,
                                  width: 23,
                                  height: 23,
                                )),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Container(
                                constraints: BoxConstraints(
                                    minWidth: 50,
                                    maxWidth:
                                        MediaQuery.of(context).size.width *
                                            0.35),
                                child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  addAddressper()));
                                    },
                                    child: token != null
                                        ? context
                                                .watch<checkstate>()
                                                .checkaddress()
                                            ? SizedBox(
                                                child: Text(
                                                  context
                                                      .watch<checkstate>()
                                                      .address,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(),
                                                ),
                                              )
                                            : Text(
                                                'Set Location',
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
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(),
                                                ),
                                              )
                                            : Text(
                                                'Set Location',
                                              )),
                              )
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * 0.05,
                            width: MediaQuery.of(context).size.width * 0.7,
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                'Satisfy your cravings with a few taps - Order now on our food delivery app',
                                softWrap: true,
                                style: TextStyle(fontSize: 13),
                              ),
                            ),
                          ),
                          InkWell(
                              onTap: () {
                                Navigator.pushNamed(context, '/cart');
                              },
                              child: Row(
                                children: [
                                  Container(
                                    height: 35,
                                    width: 30,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    child: badges.Badge(
                                      badgeContent: Text(
                                        context
                                            .watch<checkcart>()
                                            .cartresult
                                            .length
                                            .toString(),
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                      child: Center(
                                          child: SvgPicture.asset(
                                        'images/svg/Vector.svg',
                                        color: Colors.white,
                                        width: 23,
                                        height: 23,
                                      )),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    'Cart',
                                    // style: TextStyle(fontSize: 18),
                                  )
                                ],
                              )),
                        ],
                      )
                    ],
                  )),
            ),
          ),
          Container(
            alignment: Alignment.topCenter,
            child: InkWell(
              onTap: () {
                if (loading == false) {
                  if (Platform.isIOS) {
                    if (linkios[index1] != '') {
                      whatsapp(linkios[index1]);
                    }
                  } else if (Platform.isAndroid) {
                    if (linkandroid[index1] != '') {
                      whatsapp(linkandroid[index1]);
                    }
                  }
                }
              },
              child: Container(
                width: MediaQuery.of(context).size.width * 0.86,
                height: 170,
                // constraints: BoxConstraints(
                //     minHeight: 100,
                //     maxHeight: 150,
                //     minWidth: MediaQuery.of(context).size.width * 0.9,
                //     maxWidth: 400),
                child: Card(
                  elevation: 2.7,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: loading == true
                      ? Center(
                          child: CircularProgressIndicator(
                            color: Theme.of(context).primaryColor,
                          ),
                        )
                      : CarouselSlider(
                          items: generateimage(),
                          options: CarouselOptions(
                            viewportFraction: 1,
                            initialPage: 0,
                            enableInfiniteScroll: true,
                            reverse: false,
                            autoPlay: true,
                            autoPlayInterval: Duration(seconds: 3),
                            autoPlayAnimationDuration:
                                Duration(milliseconds: 800),
                            autoPlayCurve: Curves.fastOutSlowIn,
                            disableCenter: true,
                            onPageChanged: (index, reason) {
                              setState(() {
                                index1 = index;
                              });
                            },
                            scrollDirection: Axis.horizontal,
                          )),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.85,
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              children: [
                ActionChip(
                  backgroundColor: controller.index == 0
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).primaryColorDark.withOpacity(.1),
                  shape: const StadiumBorder(),
                  onPressed: () {
                    controller.animateTo(0);
                  },
                  label: Text(
                    "Quick buy",
                    style: controller.index == 0
                        ? TextStyle(color: Theme.of(context).primaryColorLight)
                        : TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(.7)),
                  ),
                ),
                const SizedBox(width: 15),
                ActionChip(
                  backgroundColor: controller.index == 1
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).primaryColorDark.withOpacity(.1),
                  shape: const StadiumBorder(),
                  onPressed: () {
                    controller.animateTo(1);
                  },
                  label: Text(
                    "Special offer",
                    style: controller.index == 1
                        ? TextStyle(
                            color: Theme.of(context).primaryColorLight,
                          )
                        : TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(.7)),
                  ),
                ),
                const SizedBox(width: 15),
                ActionChip(
                  backgroundColor: controller.index == 2
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).primaryColorDark.withOpacity(.1),
                  shape: const StadiumBorder(),
                  onPressed: () {
                    controller.animateTo(2);
                  },
                  label: Text(
                    "Recommended",
                    style: controller.index == 2
                        ? TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                          )
                        : TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(.7)),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.06),
              child: TabBarView(
                controller: controller,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  Consumer<getiItem>(builder: (context, value, child) {
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
                                          color:
                                              Color.fromARGB(255, 63, 63, 63),
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
                        child: GridView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          primary: Platform.isAndroid ? true : false,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 4 / 5,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 20),
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const Review()));
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
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: Svg.Svg('images/svg/Pattern-7.svg',
                                        size: Size(400, 200)),
                                    colorFilter: ColorFilter.mode(
                                      Theme.of(context).primaryColor,
                                      BlendMode.difference,
                                    ),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Align(
                                      alignment: Alignment.center,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: CachedNetworkImage(
                                          imageUrl: items[index].imageUrl ?? '',
                                          fit: BoxFit.fill,
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons.error),
                                          width: 150,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.25,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12),
                                      child: Text(
                                        items[index].item ?? '',
                                        style: const TextStyle(
                                            fontSize: 18,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12),
                                      child: Text(
                                        'Min: ${items[index].mincost}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'See Details',
                                            style: const TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                          Center(
                                              child: SvgPicture.asset(
                                            'images/svg/Group19.svg',
                                            width: 23,
                                            height: 23,
                                          )),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }
                  }),
                  //second Tab
                  Consumer<getiItem>(builder: (context, value, child) {
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
                                          color:
                                              Color.fromARGB(255, 63, 63, 63),
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
                        child: ListView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          primary: Platform.isAndroid ? true : false,
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.only(bottom: 20),
                              height: 100,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: Svg.Svg('images/svg/Pattern-7.svg',
                                      size: Size(400, 200)),
                                  colorFilter: ColorFilter.mode(
                                    Theme.of(context).primaryColor,
                                    BlendMode.difference,
                                  ),
                                ),
                              ),
                              child: Row(children: [
                                SizedBox(
                                  width: 10,
                                ),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: CachedNetworkImage(
                                    imageUrl: items[index].imageUrl ?? '',
                                    fit: BoxFit.fill,
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                    width: 100,
                                    height:
                                        MediaQuery.of(context).size.width * 0.2,
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      'Big Boys Pack',
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Container(
                                      height: 40,
                                      width: MediaQuery.of(context).size.width *
                                          0.55,
                                      child: Text(
                                        'Big boys pack offers 6 value pack of carbs with a full bucket chicken and also four side',
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.55,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            '₦ 4700',
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          Container(
                                            height: 25,
                                            width: 50,
                                            padding: EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(7),
                                                color: Colors.white),
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: FittedBox(
                                                child: Text(
                                                  'Buy now',
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                          .primaryColor),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                )
                              ]),
                            );
                          },
                        ),
                      );
                    }
                  }),
                  //third tab
                  Container(
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
                                            color:
                                                Color.fromARGB(255, 63, 63, 63),
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
                            children: [],
                          ),
                        );
                      }
                    }),
                  ),
                ],
              ),
            ),
          ),
          Platform.isAndroid
              ? SizedBox(
                  height: 0,
                )
              : SizedBox(
                  height: 100,
                )
        ],
      ),
    );
  }

  whatsapp(link) async {
    try {
      if (await canLaunchUrl(Uri.parse(link))) {
        await launchUrl(Uri.parse(link));
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
