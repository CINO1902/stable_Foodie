import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_svg/svg.dart';
import 'package:foodie_ios/linkfile/Model/getsubhistory.dart';
import 'package:foodie_ios/linkfile/Model/mostcommon.dart';
import 'package:foodie_ios/linkfile/Model/submitsuborder.dart';
import 'package:foodie_ios/linkfile/customesnackbar.dart';
import 'package:foodie_ios/linkfile/enum/connectivity_status.dart';
import 'package:foodie_ios/linkfile/provider/getsubhistory.dart';
import 'package:foodie_ios/linkfile/provider/greetings.dart';
import 'package:foodie_ios/linkfile/provider/internetchecker.dart';
import 'package:foodie_ios/linkfile/provider/mostcommon.dart';
import 'package:foodie_ios/linkfile/provider/onboarding.dart';
import 'package:foodie_ios/linkfile/networkhandler.dart';
import 'package:foodie_ios/linkfile/provider/subscribed.dart';
import 'package:foodie_ios/linkfile/refresh.dart';
import 'package:foodie_ios/page/confirmsuborder.dart';
import 'package:foodie_ios/page/landingpage.dart';
import 'package:foodie_ios/page/overlay.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:percent_indicator/percent_indicator.dart';

class subscription extends StatefulWidget {
  const subscription({super.key});

  @override
  State<subscription> createState() => _subscriptionState();
}

class _subscriptionState extends State<subscription>
    with SingleTickerProviderStateMixin {
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
  int? frequency;
  List<String> dateget = [];
  var time1;
  var time;
  var twenty1;
  var twentyto1;
  var twenty;
  var twentyto;
  String? todayorder;
  List sellected = [];
  String addressString = '';
  final myController = TextEditingController();
  late final TabController controller = TabController(length: 3, vsync: this)
    ..addListener(() {
      setState(() {});
    });
  List<Drink> Mostcommon = [];
  List<Drink> notcommon = [];
  List<Extra> drinks = [];
  List<Pagnited> history = [];
  int newindex = 0;
  int? frequencydigit;
  bool address = true;
  String success = '';
  String? category;
  String? image;
  String? packagename;
  String msg = '';

  Future<void> sendsuborder() async {
    final pref = await SharedPreferences.getInstance();
    String email = pref.getString('email') ?? '';
    String addressget() {
      String add = '';
      if (address == true) {
        setState(() {
          add = Provider.of<checkstate>(context, listen: false).address;
        });
      } else if (address == false) {
        setState(() {
          add = myController.text;
        });
      }
      return add;
    }

    SmartDialog.showLoading();

    try {
      Submitsuborder fetch = Submitsuborder(
          email: email,
          id: sellected[0],
          address: addressget(),
          category: category,
          packagename: packagename,
          image: image);
      var response = await networkHandler.client.post(
          networkHandler.builderUrl('/ordersub'),
          body: submitsuborderToJson(fetch),
          headers: {'content-Type': 'application/json; charset=UTF-8'});

      final decodedresponse = jsonDecode(response.body);
      if (response.statusCode == 200) {
        setState(() {
          success = decodedresponse['success'];
          msg = decodedresponse['msg'];
        });
      } else {
        print('error');
      }
    } catch (e) {
      print(e);
    } finally {
      SmartDialog.dismiss();
    }
  }

  bool network = false;
  final ScrollController control = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(context.read<subscribed>().days);
  }

  Text getdate() {
    String day = DateFormat('EEEE').format( context.watch<greetings>().time);
    String date = DateFormat('d').format(context.watch<greetings>().time);
    String month = DateFormat('MMMM').format(context.watch<greetings>().time);

    String prefix() {
      String pre = '';
      if (date.endsWith('1')) {
        pre = 'th';
      } else if (date.endsWith('2')) {
        pre = 'nd';
      } else if (date.endsWith('3')) {
        pre = 'rd';
      } else {
        pre = 'th';
      }
      return pre;
    }

    return Text(
      '${day}, ${date}${prefix()} of ${month}',
      style: const TextStyle(fontSize: 17),
    );
  }

  getrefresh() async {
    context.read<subscribed>().getsubdetails();
    context.read<getmostcommon>().getcommon();
    context.read<getsubhistory>().getordersub();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: Text(
            'Subscription',
            style: TextStyle(
                color: Theme.of(context).primaryColorDark,
                fontSize: 27,
                fontWeight: FontWeight.bold),
          ),
        ),
        body: context.watch<subscribed>().subscribe
            ? RefreshWidget(
                control: control,
                onRefresh: () async {
                  await getrefresh();
                },
                child: ListView(
                  shrinkWrap: true,
                  primary: Platform.isAndroid ? true : false,
                  children: [
                    Visibility(
                        visible: context.watch<subscribed>().showrollover,
                        child: InkWell(
                          onTap: () {
                            context.read<subscribed>().clickrollover();
                            Navigator.pushNamed(context, '/rolloverfrequenct');
                          },
                          child: Container(
                            margin: EdgeInsets.all(20),
                            height: MediaQuery.of(context).size.height * 0.13,
                            width: double.infinity,
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(.6),
                                borderRadius: BorderRadius.circular(10)),
                            child: Column(children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Rollover',
                                    style: TextStyle(
                                        fontSize: 21,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  InkWell(
                                      onTap: () {
                                        context.read<subscribed>().cancel();
                                      },
                                      child: Icon(Icons.cancel))
                                ],
                              ),
                              RichText(
                                text: TextSpan(
                                  text: 'Your subscription plan expires ',
                                  style: DefaultTextStyle.of(context).style,
                                  children: <TextSpan>[
                                    context.read<subscribed>().days == 0
                                        ? TextSpan(text: "today")
                                        : context.read<subscribed>().days == 1
                                            ? TextSpan(text: "tomorrow")
                                            : TextSpan(
                                                text:
                                                    "in ${context.read<subscribed>().days.toString()} days"),
                                    TextSpan(
                                        text:
                                            ', Click this modal to renew your plan and enjoy 10% of any subscription plan of your choice')
                                  ],
                                ),
                              )
                            ]),
                          ),
                        )),
                    Visibility(
                        visible: context.watch<subscribed>().shownewplan,
                        child: Container(
                          margin: EdgeInsets.all(20),
                          height: MediaQuery.of(context).size.height * 0.1,
                          width: double.infinity,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.greenAccent.withOpacity(.6),
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Rollover',
                                  style: TextStyle(
                                      fontSize: 21,
                                      fontWeight: FontWeight.bold),
                                ),
                                InkWell(
                                    onTap: () {
                                      context.read<subscribed>().cancel();
                                    },
                                    child: Icon(
                                      Icons.cancel,
                                      color: Colors.greenAccent,
                                    ))
                              ],
                            ),
                            RichText(
                              text: TextSpan(
                                text:
                                    'Your have a new subscription that plan begins  ',
                                style: DefaultTextStyle.of(context).style,
                                children: <TextSpan>[
                                  context.read<subscribed>().days == 0
                                      ? TextSpan(text: "tomorrow")
                                      : TextSpan(
                                          text:
                                              "in ${context.read<subscribed>().days.toString()} days"),
                                ],
                              ),
                            )
                          ]),
                        )),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child:
                          Opacity(opacity: true ? 0.7 : 0.1, child: getdate()),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(
                          vertical: MediaQuery.of(context).size.height * 0.03,
                          horizontal: MediaQuery.of(context).size.width * 0.06),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Activity',
                            style: TextStyle(
                                fontSize: 21, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.25,
                            width: double.infinity,
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: SvgPicture.asset(
                                    'images/svg/Pattern-3.svg',
                                    fit: BoxFit.cover,
                                    color: Theme.of(context).primaryColorLight,
                                    colorBlendMode: BlendMode.difference,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.3,
                                        child: ListView(
                                          children: [
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  'Ordered',
                                                  style: TextStyle(
                                                      fontSize: 19,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Opacity(
                                                    opacity: true ? 0.5 : 1,
                                                    child: context
                                                            .watch<
                                                                getmostcommon>()
                                                            .data
                                                        ? context
                                                                        .watch<
                                                                            getsubhistory>()
                                                                        .todorder >
                                                                    context
                                                                        .watch<
                                                                            getmostcommon>()
                                                                        .frequency ||
                                                                context
                                                                        .watch<
                                                                            getsubhistory>()
                                                                        .todorder ==
                                                                    context
                                                                        .watch<
                                                                            getmostcommon>()
                                                                        .frequency
                                                            ? Text('Completed')
                                                            : Text(
                                                                '${context.watch<getsubhistory>().todorder.toString()}/${context.watch<getmostcommon>().frequency.toString()}',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        19),
                                                              )
                                                        : Text('')),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                const Text(
                                                  'Total Ordered',
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Opacity(
                                                  opacity: true ? 0.5 : 1,
                                                  child: context
                                                          .watch<
                                                              getsubhistory>()
                                                          .loading
                                                      ? Text(
                                                          context
                                                              .watch<
                                                                  getsubhistory>()
                                                              .totalordered
                                                              .toString(),
                                                          style: TextStyle(
                                                              fontSize: 19),
                                                        )
                                                      : Text(''),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                const Text(
                                                  'Roll-over',
                                                  style: TextStyle(
                                                      fontSize: 19,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Opacity(
                                                  opacity: true ? 0.5 : 1,
                                                  child: context
                                                          .watch<
                                                              getsubhistory>()
                                                          .loading
                                                      ? Text(
                                                          '${context.watch<getsubhistory>().rollover.toString()} Package',
                                                          style: TextStyle(
                                                              fontSize: 19),
                                                        )
                                                      : Text(''),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      context.watch<getmostcommon>().data
                                          ? Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                CircularPercentIndicator(
                                                  radius: 60,
                                                  lineWidth: 10,
                                                  percent: context
                                                          .watch<subscribed>()
                                                          .daysback /
                                                      30,
                                                  progressColor:
                                                      Theme.of(context)
                                                          .primaryColor,
                                                  circularStrokeCap:
                                                      CircularStrokeCap.round,
                                                  animation: true,
                                                  center: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      const Text(
                                                        'Day',
                                                        style: TextStyle(
                                                            fontSize: 19),
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      Opacity(
                                                        opacity: true ? 0.7 : 1,
                                                        child: Text(
                                                          '${context.watch<subscribed>().daysback.toString()}/30 days',
                                                          style: TextStyle(
                                                              fontSize: 19),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    context
                                                        .read<subscribed>()
                                                        .clickupgrade();
                                                    Navigator.pushNamed(context,
                                                        '/upgradefrequency');
                                                  },
                                                  child: Text(
                                                    'Upgrade Plan',
                                                    style: TextStyle(
                                                        fontSize: 19,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Theme.of(context)
                                                            .primaryColor),
                                                  ),
                                                )
                                              ],
                                            )
                                          : SizedBox()
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            height: 40,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              children: [
                                ActionChip(
                                  backgroundColor: controller.index == 0
                                      ? Theme.of(context).primaryColor
                                      : Theme.of(context)
                                          .primaryColorDark
                                          .withOpacity(.1),
                                  shape: const StadiumBorder(),
                                  onPressed: () {
                                    controller.animateTo(0);
                                  },
                                  label: Text(
                                    "  Most Common  ",
                                    style: controller.index == 0
                                        ? TextStyle(
                                            color: Theme.of(context)
                                                .primaryColorLight)
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
                                      : Theme.of(context)
                                          .primaryColorDark
                                          .withOpacity(.1),
                                  shape: const StadiumBorder(),
                                  onPressed: () {
                                    controller.animateTo(1);
                                  },
                                  label: Text(
                                    "Request   ",
                                    style: controller.index == 1
                                        ? TextStyle(
                                            color: Theme.of(context)
                                                .primaryColorLight,
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
                                      : Theme.of(context)
                                          .primaryColorDark
                                          .withOpacity(.1),
                                  shape: const StadiumBorder(),
                                  onPressed: () {
                                    controller.animateTo(2);
                                  },
                                  label: Text(
                                    "  Drinks  ",
                                    style: controller.index == 2
                                        ? TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface,
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
                          Container(
                            height: MediaQuery.of(context).size.height * 0.45,
                            width: double.infinity,
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: SvgPicture.asset(
                                    'images/svg/Pattern-3.svg',
                                    fit: BoxFit.cover,
                                    height: MediaQuery.of(context).size.height *
                                        0.45,
                                    color: Theme.of(context).primaryColorLight,
                                    colorBlendMode: BlendMode.difference,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 10),
                                  child: TabBarView(
                                    controller: controller,
                                    physics: const BouncingScrollPhysics(),
                                    children: [
                                      Consumer<getmostcommon>(
                                          builder: (context, value, child) {
                                        if (value.data == false) {
                                          return Center(
                                            child: CircularProgressIndicator(
                                                color: Theme.of(context)
                                                    .primaryColor),
                                          );
                                        } else if (value.error == true) {
                                          return Center(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Something Went wrong',
                                                  style:
                                                      TextStyle(fontSize: 17),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                InkWell(
                                                  onTap: () async {
                                                    await context
                                                        .read<getmostcommon>()
                                                        .getcommon();
                                                  },
                                                  child: Container(
                                                    height: 30,
                                                    width: 80,
                                                    decoration: BoxDecoration(
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10)),
                                                    child: Align(
                                                        alignment:
                                                            Alignment.center,
                                                        child: Text(
                                                          "Retry",
                                                          style: TextStyle(
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      63,
                                                                      63,
                                                                      63),
                                                              fontSize: 18),
                                                        )),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        } else {
                                          Mostcommon = value.mostcommon;
                                          sellected = context
                                              .watch<getmostcommon>()
                                              .sellected;

                                          return Column(
                                            children: [
                                              Expanded(
                                                child: ListView.builder(
                                                    itemCount:
                                                        value.mostcommon.length,
                                                    clipBehavior:
                                                        Clip.antiAlias,
                                                    itemBuilder:
                                                        ((context, index) {
                                                      String getclass() {
                                                        switch (
                                                            Mostcommon[index]
                                                                .category) {
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

                                                      return Container(
                                                        height: 70,
                                                        width: double.infinity,
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)),
                                                        child: Row(
                                                          children: [
                                                            SizedBox(
                                                              height: 50,
                                                              width: 50,
                                                              child:
                                                                  CachedNetworkImage(
                                                                imageUrl: Mostcommon[
                                                                            index]
                                                                        .image ??
                                                                    '',
                                                                errorWidget: (context,
                                                                        url,
                                                                        error) =>
                                                                    Icon(Icons
                                                                        .error),
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.4,
                                                                height: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.35,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              width: 10,
                                                            ),
                                                            Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      top: 10),
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.55,
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      SizedBox(
                                                                        width: MediaQuery.of(context).size.width *
                                                                            0.4,
                                                                        child:
                                                                            Text(
                                                                          ' ${Mostcommon[index].packageName} ',
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                          style: const TextStyle(
                                                                              fontSize: 17,
                                                                              fontWeight: FontWeight.bold),
                                                                        ),
                                                                      ),
                                                                      Container(
                                                                        padding:
                                                                            EdgeInsets.only(left: 5),
                                                                        child:
                                                                            Text(
                                                                          getclass(),
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                17,
                                                                          ),
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                  Checkbox(
                                                                      value: context
                                                                          .watch<
                                                                              getmostcommon>()
                                                                          .sellected
                                                                          .contains(Mostcommon[index]
                                                                              .drinkId),
                                                                      activeColor:
                                                                          Theme.of(context)
                                                                              .primaryColor,
                                                                      onChanged:
                                                                          (valuech) {
                                                                        setState(
                                                                            () {
                                                                          newindex =
                                                                              index;
                                                                        });

                                                                        context
                                                                            .read<getmostcommon>()
                                                                            .getsellected(Mostcommon[index].drinkId);
                                                                      })
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    })),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  const confirmsuborder()));
                                                    },
                                                    child: Container(
                                                      height: 40,
                                                      width: 40,
                                                      decoration: BoxDecoration(
                                                          color: const Color
                                                                      .fromARGB(
                                                                  255,
                                                                  224,
                                                                  224,
                                                                  224)
                                                              .withOpacity(.8),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10)),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: SvgPicture.asset(
                                                          'images/shopping-cart-svgrepo-com.svg',
                                                          height: 10,
                                                          width: 10,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    margin: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 20),
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            .3,
                                                    height: 35,
                                                    child: ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          backgroundColor: Provider
                                                                      .of<getmostcommon>(
                                                                          context,
                                                                          listen:
                                                                              false)
                                                                  .emptysellect
                                                              ? Theme.of(
                                                                      context)
                                                                  .primaryColor
                                                              : Theme.of(
                                                                      context)
                                                                  .primaryColor
                                                                  .withOpacity(
                                                                      .5),
                                                          shape:
                                                              const RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            10)),
                                                          ),
                                                        ),
                                                        onPressed: () async {
                                                          setState(() {
                                                            packagename =
                                                                Mostcommon[
                                                                        newindex]
                                                                    .packageName;
                                                            category =
                                                                Mostcommon[
                                                                        newindex]
                                                                    .category;
                                                            image = Mostcommon[
                                                                    newindex]
                                                                .image;
                                                          });
                                                          Provider.of<getmostcommon>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .emptysellect
                                                              ? openconfirmbox(
                                                                  context,
                                                                  Mostcommon[
                                                                          newindex]
                                                                      .image,
                                                                  Mostcommon[
                                                                          newindex]
                                                                      .packageName,
                                                                  category,
                                                                  Mostcommon[
                                                                          newindex]
                                                                      .extras,
                                                                  sellected[0])
                                                              : null;
                                                        },
                                                        child: const Text(
                                                            'Order')),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          );
                                        }
                                      }),

                                      //Second Tab

                                      Consumer<getmostcommon>(
                                          builder: (context, value, child) {
                                        if (value.data == false) {
                                          return Center(
                                            child: CircularProgressIndicator(
                                                color: Theme.of(context)
                                                    .primaryColor),
                                          );
                                        } else {
                                          notcommon = value.notcommon;
                                          if (notcommon.isEmpty) {
                                            return Center(
                                              child: Text(
                                                  'Nothing to show here',
                                                  style: TextStyle(
                                                      fontSize: 19,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            );
                                          } else {
                                            return Column(
                                              children: [
                                                Expanded(
                                                  child: ListView.builder(
                                                      itemCount:
                                                          notcommon.length,
                                                      clipBehavior:
                                                          Clip.antiAlias,
                                                      itemBuilder:
                                                          ((context, index) {
                                                        return Container(
                                                          height: 70,
                                                          width:
                                                              double.infinity,
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10)),
                                                          child: Row(
                                                            children: [
                                                              SizedBox(
                                                                height: 50,
                                                                width: 50,
                                                                child:
                                                                    CachedNetworkImage(
                                                                  imageUrl:
                                                                      Mostcommon[index]
                                                                              .image ??
                                                                          '',
                                                                  errorWidget: (context,
                                                                          url,
                                                                          error) =>
                                                                      Icon(Icons
                                                                          .error),
                                                                  width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.4,
                                                                  height: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.35,
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                width: 10,
                                                              ),
                                                              Container(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        top:
                                                                            10),
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.55,
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Text(
                                                                          ' ${Mostcommon[index].packageName} ',
                                                                          style: const TextStyle(
                                                                              fontSize: 18,
                                                                              fontWeight: FontWeight.bold),
                                                                        ),
                                                                        const Text(
                                                                          'Odogwu',
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                17,
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                    Checkbox(
                                                                        value: context
                                                                            .watch<
                                                                                getmostcommon>()
                                                                            .sellected
                                                                            .contains(Mostcommon[index]
                                                                                .drinkId),
                                                                        activeColor:
                                                                            Theme.of(context)
                                                                                .primaryColor,
                                                                        onChanged:
                                                                            (valuech) {
                                                                          setState(
                                                                              () {
                                                                            newindex =
                                                                                index;
                                                                          });

                                                                          context
                                                                              .read<getmostcommon>()
                                                                              .getsellected(Mostcommon[index].drinkId);
                                                                        })
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      })),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        const confirmsuborder()));
                                                      },
                                                      child: Container(
                                                        height: 40,
                                                        width: 40,
                                                        decoration: BoxDecoration(
                                                            color: const Color
                                                                        .fromARGB(
                                                                    255,
                                                                    224,
                                                                    224,
                                                                    224)
                                                                .withOpacity(
                                                                    .8),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child:
                                                              SvgPicture.asset(
                                                            'images/shopping-cart-svgrepo-com.svg',
                                                            height: 10,
                                                            width: 10,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      margin: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 20),
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              .3,
                                                      height: 35,
                                                      child: ElevatedButton(
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            backgroundColor:
                                                                Theme.of(
                                                                        context)
                                                                    .primaryColor,
                                                            shape:
                                                                const RoundedRectangleBorder(
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          10)),
                                                            ),
                                                          ),
                                                          onPressed:
                                                              () async {},
                                                          child: const Text(
                                                              'Order')),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            );
                                          }
                                        }
                                      }),

                                      //third tab
                                      Consumer<getmostcommon>(
                                          builder: (context, value, child) {
                                        if (value.data == false) {
                                          return Center(
                                            child: CircularProgressIndicator(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                          );
                                        } else if (value.drinks.isEmpty) {
                                          return const Center(
                                            child: Text(
                                              'No drinks available',
                                              style: TextStyle(
                                                  fontSize: 19,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          );
                                        } else {
                                          drinks = value.drinks[0].extras;
                                          sellected = context
                                              .watch<getmostcommon>()
                                              .sellected;

                                          return Column(
                                            children: [
                                              Expanded(
                                                child: ListView.builder(
                                                    itemCount: drinks.length,
                                                    clipBehavior:
                                                        Clip.antiAlias,
                                                    itemBuilder:
                                                        ((context, index) {
                                                      return Container(
                                                        height: 70,
                                                        width: double.infinity,
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)),
                                                        child: Row(
                                                          children: [
                                                            SizedBox(
                                                              height: 50,
                                                              width: 50,
                                                              child:
                                                                  CachedNetworkImage(
                                                                imageUrl: drinks[
                                                                            index]
                                                                        .the1 ??
                                                                    '',
                                                                errorWidget: (context,
                                                                        url,
                                                                        error) =>
                                                                    Icon(Icons
                                                                        .error),
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.4,
                                                                height: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.35,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              width: 10,
                                                            ),
                                                            Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      top: 10),
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.55,
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      SizedBox(
                                                                        width: MediaQuery.of(context).size.width *
                                                                            0.4,
                                                                        child:
                                                                            Text(
                                                                          ' ${drinks[index].the0} ',
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                          style: const TextStyle(
                                                                              fontSize: 17,
                                                                              fontWeight: FontWeight.bold),
                                                                        ),
                                                                      ),
                                                                      Container(
                                                                        padding:
                                                                            EdgeInsets.only(left: 5),
                                                                        child:
                                                                            Text(
                                                                          'Drinks',
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                17,
                                                                          ),
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                  Checkbox(
                                                                      value: context
                                                                          .watch<
                                                                              getmostcommon>()
                                                                          .sellected
                                                                          .contains(drinks[index]
                                                                              .the0),
                                                                      activeColor:
                                                                          Theme.of(context)
                                                                              .primaryColor,
                                                                      onChanged:
                                                                          (valuech) {
                                                                        setState(
                                                                            () {
                                                                          newindex =
                                                                              index;
                                                                        });

                                                                        context
                                                                            .read<getmostcommon>()
                                                                            .getsellected(drinks[index].the0);
                                                                      })
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    })),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  const confirmsuborder()));
                                                    },
                                                    child: Container(
                                                      height: 40,
                                                      width: 40,
                                                      decoration: BoxDecoration(
                                                          color: const Color
                                                                      .fromARGB(
                                                                  255,
                                                                  224,
                                                                  224,
                                                                  224)
                                                              .withOpacity(.8),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10)),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: SvgPicture.asset(
                                                          'images/shopping-cart-svgrepo-com.svg',
                                                          height: 10,
                                                          width: 10,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    margin: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 20),
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            .3,
                                                    height: 35,
                                                    child:
                                                        Consumer<getmostcommon>(
                                                            builder: (context,
                                                                value, child) {
                                                      return ElevatedButton(
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            backgroundColor: Provider.of<
                                                                            getmostcommon>(
                                                                        context,
                                                                        listen:
                                                                            false)
                                                                    .emptysellect
                                                                ? Theme.of(
                                                                        context)
                                                                    .primaryColor
                                                                : Theme.of(
                                                                        context)
                                                                    .primaryColor
                                                                    .withOpacity(
                                                                        .5),
                                                            shape:
                                                                const RoundedRectangleBorder(
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          10)),
                                                            ),
                                                          ),
                                                          onPressed: () async {
                                                            setState(() {
                                                              packagename =
                                                                  drinks[newindex]
                                                                      .the0;
                                                              category = '4';
                                                              image = drinks[
                                                                      newindex]
                                                                  .the1;
                                                            });

                                                            // ignore: use_build_context_synchronously
                                                            Provider.of<getmostcommon>(
                                                                        context,
                                                                        listen:
                                                                            false)
                                                                    .emptysellect
                                                                ? senddrink(
                                                                    value)
                                                                : null;
                                                          },
                                                          child: const Text(
                                                              'Order'));
                                                    }),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          );
                                        }
                                      }),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'History',
                                  style: TextStyle(
                                      fontSize: 21,
                                      fontWeight: FontWeight.bold),
                                ),
                                InkWell(
                                  onTap: () {
                                    if (history.isNotEmpty) {
                                      Navigator.pushNamed(context, '/showmore');
                                    }
                                  },
                                  child: Text(
                                    'Show More',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).primaryColor),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.3,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                                borderRadius: BorderRadius.circular(15)),
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: SvgPicture.asset(
                                    'images/svg/Pattern-3.svg',
                                    fit: BoxFit.cover,
                                    height: MediaQuery.of(context).size.height *
                                        0.45,
                                    color: Theme.of(context).primaryColorLight,
                                    colorBlendMode: BlendMode.difference,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 10),
                                  child: Consumer<getsubhistory>(
                                      builder: (context, value, child) {
                                    if (value.loading == false) {
                                      return Center(
                                        child: CircularProgressIndicator(
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      );
                                    } else if (value.fullresult.isEmpty) {
                                      return const Center(
                                        child: Text(
                                          'Nothing to show here',
                                          style: TextStyle(
                                              fontSize: 19,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      );
                                    } else if (value.fullresult.isNotEmpty) {
                                      history =
                                          value.fullresult.take(3).toList();

                                      return GroupedListView<Pagnited,
                                              DateTime>(
                                          padding: EdgeInsets.zero,
                                          order: GroupedListOrder.ASC,
                                          groupBy: (Pagnited element) =>
                                              DateTime(
                                                element.date.year,
                                                element.date.month,
                                                element.date.day,
                                              ),
                                          elements: history,
                                          shrinkWrap: true,
                                          itemComparator: (Pagnited element1,
                                                  Pagnited element2) =>
                                              element2.date
                                                  .compareTo(element1.date),
                                          groupComparator: (DateTime value1,
                                                  DateTime value2) =>
                                              value2.compareTo(value1),
                                          groupSeparatorBuilder:
                                              (DateTime date) {
                                            DateTime? currentdate =
                                                context.watch<greetings>().time;

                                            final day = date.day;
                                            final currentday = currentdate.day;
                                            String date1 = '';

                                            if ((currentday - day) == 0) {
                                              date1 = 'Today';
                                            } else if ((currentday - day) ==
                                                1) {
                                              date1 = 'Yesterday';
                                            } else if ((currentday - day) > 1) {
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
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            );
                                          },
                                          itemBuilder:
                                              (BuildContext context, index) {
                                            String getclass() {
                                              switch (index.category) {
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
                                                    index.image,
                                                    index.packagename,
                                                    index.status,
                                                    index.date,
                                                    index.ordernum,
                                                    index.address,
                                                    index.name,
                                                    index.phone,
                                                    index.email,
                                                    index.location);
                                              },
                                              child: Container(
                                                height: 70,
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                child: Row(
                                                  children: [
                                                    SizedBox(
                                                      height: 50,
                                                      width: 50,
                                                      child: CachedNetworkImage(
                                                        imageUrl: index.image,
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            Icon(Icons.error),
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.4,
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.35,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 10),
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.55,
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Container(
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.35,
                                                                child: Text(
                                                                  ' ${index.packagename} ',
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          17,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                              ),
                                                              Container(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        left:
                                                                            5),
                                                                child: Text(
                                                                  getclass(),
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        17,
                                                                  ),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                          Align(
                                                            alignment: Alignment
                                                                .center,
                                                            child: Container(
                                                              width: 60,
                                                              height: 30,
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          3),
                                                              decoration: BoxDecoration(
                                                                  color: index.status == 1
                                                                      ? Colors.yellow.withOpacity(.5)
                                                                      : index.status == 2
                                                                          ? Color.fromARGB(255, 171, 122, 82).withOpacity(.5)
                                                                          : index.status == 3
                                                                              ? Colors.green.withOpacity(.5)
                                                                              : index.status == 4
                                                                                  ? Colors.red.withOpacity(.5)
                                                                                  : Colors.black,
                                                                  borderRadius: BorderRadius.circular(10)),
                                                              child: FittedBox(
                                                                  child: index.status ==
                                                                          1
                                                                      ? Text(
                                                                          'Processing',
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Colors.yellow.shade700,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                          ),
                                                                        )
                                                                      : index.status ==
                                                                              2
                                                                          ? const Text(
                                                                              'Packaged',
                                                                              textAlign: TextAlign.center,
                                                                              style: TextStyle(
                                                                                color: Color.fromARGB(255, 251, 186, 45),
                                                                                fontWeight: FontWeight.bold,
                                                                              ),
                                                                            )
                                                                          : index.status == 3
                                                                              ? const Text(
                                                                                  'Sent Out',
                                                                                  textAlign: TextAlign.center,
                                                                                  style: TextStyle(
                                                                                    color: Color.fromARGB(255, 120, 228, 92),
                                                                                    fontWeight: FontWeight.bold,
                                                                                  ),
                                                                                )
                                                                              : index.status == 4
                                                                                  ? const Text(
                                                                                      'Returned',
                                                                                      textAlign: TextAlign.center,
                                                                                      style: TextStyle(
                                                                                        color: Color.fromARGB(255, 251, 45, 45),
                                                                                        fontWeight: FontWeight.bold,
                                                                                      ),
                                                                                    )
                                                                                  : const Text('')),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          });
                                    } else {
                                      return Center(
                                          child: CircularProgressIndicator(
                                              color: Theme.of(context)
                                                  .primaryColor));
                                    }
                                  }),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              )
            : Container(
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.2,
                          right: MediaQuery.of(context).size.width * 0.05,
                          left: MediaQuery.of(context).size.width * 0.05),
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: 400,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Get up to 1-3 meals a day at a lower price with our subscription plan.',
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Text(
                            'Enjoy variety options of meals just as you want.',
                            style: TextStyle(fontSize: 17),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  ),
                                ),
                                onPressed: () async {
                                  final prefs =
                                      await SharedPreferences.getInstance();
                                  String? token =
                                      prefs.getString("tokenregistered");
                                  if (token != null) {
                                    Navigator.pushNamed(context, '/page1');
                                  } else {
                                    Navigator.pushNamed(context, '/login');
                                  }
                                },
                                child: const Text('Start Subscriptiom')),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ));
  }

  Future<dynamic> modalpopup(
      BuildContext context, List<Extra>? packageinclude, image) {
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
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'Package Details',
                        style: TextStyle(
                            fontSize: 23, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 20),
                      child: Text(
                        'What is inside the package:',
                        style: TextStyle(
                          fontSize: 21,
                          letterSpacing: -0.4,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 15),
                      child: Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.55,
                            child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: packageinclude!.length,
                                itemBuilder: (context, index) {
                                  return Row(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(top: 10),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${index + 1}',
                                              style: TextStyle(fontSize: 17),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            SizedBox(
                                              height: 40,
                                              width: 180,
                                              child: Text(
                                                '${packageinclude[index].the0}',
                                                // overflow-: TextOverflow.ellipsis,
                                                style: TextStyle(fontSize: 17),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                }),
                          ),
                          SizedBox(
                            height: 130,
                            width: 130,
                            child: CachedNetworkImage(
                              imageUrl: image ?? '',
                              fit: BoxFit.fill,
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                              width: MediaQuery.of(context).size.width * 0.4,
                              height: MediaQuery.of(context).size.width * 0.35,
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          );
        });
  }

  Future<dynamic> openconfirmbox(
      BuildContext context, image, name, getclass, List<Extra>? extra, sellec) {
    context.read<getmostcommon>().getsoup();

    return showModalBottomSheet(
        context: context,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setstate) {
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
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          'Order Details',
                          style: TextStyle(
                              fontSize: 23, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 20),
                        child: Text(
                          'What is inside the package:',
                          style: TextStyle(
                            fontSize: 21,
                            letterSpacing: -0.4,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.only(left: 15, right: 15),
                            height: MediaQuery.of(context).size.height * 0.25,
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      Align(
                                        alignment: Alignment.topCenter,
                                        child: SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.12,
                                          width: 100,
                                          child: CachedNetworkImage(
                                            imageUrl: image ?? '',
                                            fit: BoxFit.cover,
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
                                      ),
                                    ],
                                  ),
                                  Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.50,
                                          child: Container(
                                            child: Text(
                                              '$name',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20),
                                            ),
                                          ),
                                        ),
                                        Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.2,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.5,
                                            child: ListView.builder(
                                                shrinkWrap: true,
                                                itemCount: extra!.length,
                                                itemBuilder: (context, index) {
                                                  return Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                      bottom: 5,
                                                    ),
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          '${index + 1}',
                                                          style: TextStyle(
                                                              fontSize: 17),
                                                        ),
                                                        SizedBox(
                                                          width: 5,
                                                        ),
                                                        SizedBox(
                                                          height: 40,
                                                          width: 110,
                                                          child: Text(
                                                            '${extra[index].the0}',
                                                            style: const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontSize: 17),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                })),
                                      ]),
                                ]),
                          ),
                          context.watch<getmostcommon>().swallow.contains(name)
                              ? Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.6,
                                  margin: EdgeInsets.only(left: 10),
                                  child: Consumer<getmostcommon>(
                                      builder: (context, value, child) {
                                    if (value.loadingsoup == true) {
                                      return Center(
                                          child: CircularProgressIndicator(
                                        color: Theme.of(context).primaryColor,
                                      ));
                                    } else if (value.errorsoup == true) {
                                      return Center(
                                        child: Text('Something Went wrong'),
                                      );
                                    } else {
                                      return ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: value.soup.length,
                                          itemBuilder: (context, index) {
                                            return Container(
                                              height: 30,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    value.soup[index]
                                                        .packageName,
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 20),
                                                  ),
                                                  Checkbox(
                                                      value: context
                                                          .watch<
                                                              getmostcommon>()
                                                          .sellectedsoup
                                                          .contains(value
                                                              .soup[index]
                                                              .packageName),
                                                      activeColor:
                                                          Theme.of(context)
                                                              .primaryColor,
                                                      onChanged: (valuech) {
                                                        context
                                                            .read<
                                                                getmostcommon>()
                                                            .getsellectedsoup(
                                                                value
                                                                    .soup[index]
                                                                    .packageName);
                                                      })
                                                ],
                                              ),
                                            );
                                          });
                                    }
                                  }),
                                )
                              : Container()
                        ],
                      ),
                    ],
                  ),
                ),
                Consumer<getmostcommon>(builder: (context, value, child) {
                  return Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.09,
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () async {
                              if (Provider.of<getmostcommon>(context,
                                          listen: false)
                                      .swallow
                                      .contains(name) &&
                                  context
                                          .read<getmostcommon>()
                                          .emptysellectsoup() ==
                                      true) {
                                SmartDialog.showToast('Please Sellect a soup');
                              } else {
                                SmartDialog.showLoading();
                                if (Provider.of<getmostcommon>(context,
                                        listen: false)
                                    .swallow
                                    .contains(name)) {
                                  await context.read<getmostcommon>().addtosubcart(
                                      getclass,
                                      '${name} with ${Provider.of<getmostcommon>(context, listen: false).sellectedsoup[0]}',
                                      image,
                                      sellec);
                                } else {
                                  await context
                                      .read<getmostcommon>()
                                      .addtosubcart(
                                          getclass, name, image, sellec);
                                }

                                context.read<getmostcommon>().clearsellect();
                                if (value.success == 'fail') {
                                  SmartDialog.dismiss();
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: CustomeSnackbar(
                                      topic: 'Oh Snap!',
                                      msg: value.msg,
                                      color1: Color.fromARGB(255, 171, 51, 42),
                                      color2: Color.fromARGB(255, 127, 39, 33),
                                    ),
                                    behavior: SnackBarBehavior.floating,
                                    backgroundColor: Colors.transparent,
                                    elevation: 0,
                                  ));
                                } else if (value.success == 'success') {
                                  SmartDialog.dismiss();
                                  Navigator.pop(context);

                                  // ignore: use_build_context_synchronously
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const confirmsuborder()));
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: CustomeSnackbar(
                                      topic: 'Great!',
                                      msg: value.msg,
                                      color1: Color.fromARGB(255, 25, 107, 52),
                                      color2: Color.fromARGB(255, 19, 95, 40),
                                    ),
                                    behavior: SnackBarBehavior.floating,
                                    backgroundColor: Colors.transparent,
                                    elevation: 0,
                                  ));
                                }
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
                              child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Proceed',
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 19),
                                  )),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                })
              ],
            );
          });
        });
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
                                            CrossAxisAlignment.center,
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
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Align(
                                            alignment: Alignment.center,
                                            child: Container(
                                              width: 60,
                                              height: 30,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 3),
                                              decoration: BoxDecoration(
                                                  color: status == 1
                                                      ? Colors.yellow
                                                          .withOpacity(.5)
                                                      : status == 2
                                                          ? Color.fromARGB(255,
                                                                  171, 122, 82)
                                                              .withOpacity(.5)
                                                          : status == 3
                                                              ? Colors.green
                                                                  .withOpacity(
                                                                      .5)
                                                              : status == 4
                                                                  ? Colors.red
                                                                      .withOpacity(
                                                                          .5)
                                                                  : Colors
                                                                      .black,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: FittedBox(
                                                  child: status == 1
                                                      ? Text(
                                                          'Processing',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            color: Colors.yellow
                                                                .shade700,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        )
                                                      : status == 2
                                                          ? const Text(
                                                              'Packaged',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        251,
                                                                        186,
                                                                        45),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            )
                                                          : status == 3
                                                              ? const Text(
                                                                  'Sent Out',
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style:
                                                                      TextStyle(
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            120,
                                                                            228,
                                                                            92),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                )
                                                              : status == 4
                                                                  ? const Text(
                                                                      'Returned',
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style:
                                                                          TextStyle(
                                                                        color: Color.fromARGB(
                                                                            255,
                                                                            251,
                                                                            45,
                                                                            45),
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                      ),
                                                                    )
                                                                  : const Text(
                                                                      '')),
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

  senddrink(value) async {
    SmartDialog.showLoading();
    await context
        .read<getmostcommon>()
        .addtosubcart('4', packagename, image, packagename);
    context.read<getmostcommon>().clearsellect();
    if (value.success == 'fail') {
      SmartDialog.dismiss();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: CustomeSnackbar(
          topic: 'Oh Snap!',
          msg: value.msg,
          color1: Color.fromARGB(255, 171, 51, 42),
          color2: Color.fromARGB(255, 127, 39, 33),
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ));
    } else if (value.success == 'success') {
      SmartDialog.dismiss();

      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const confirmsuborder()));
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: CustomeSnackbar(
          topic: 'Great!',
          msg: value.msg,
          color1: Color.fromARGB(255, 25, 107, 52),
          color2: Color.fromARGB(255, 19, 95, 40),
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ));
    }
  }
}
