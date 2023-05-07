
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_svg/flutter_svg.dart';


import 'package:foodie_ios/linkfile/enum/connectivity_status.dart';

import 'package:foodie_ios/linkfile/provider/addTocart.dart';
import 'package:foodie_ios/linkfile/provider/calculatemael.dart';

import 'package:text_scroll/text_scroll.dart';

import 'package:foodie_ios/linkfile/provider/specialoffermeal.dart';

import 'package:foodie_ios/linkfile/snackbar.dart';
import 'package:foodie_ios/page/overlay.dart';
import 'package:provider/provider.dart';

class Reviewspecial extends StatefulWidget {
  const Reviewspecial({
    super.key,
  });

  @override
  State<Reviewspecial> createState() => _ReviewspecialState();
}

class _ReviewspecialState extends State<Reviewspecial> {
  List _selecteCategorys = [];
  List<String> soupid = [];

  List<List<dynamic>> itemsquote = [];
  bool checkdone = false;
  String amount = '';
  int multiplier = 1;
  String msg1 = '';
  String success = '';
  bool error = false;
  bool waitresponse = false;
  void _onCategorySelected(bool selected, category_id) {
    if (selected == true) {
      setState(() {
        _selecteCategorys.add(category_id);
      });
    } else {
      setState(() {
        _selecteCategorys.remove(category_id);
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    addprocess();
    context.read<meal_calculate>().extracall();
    // Provider.of<calculatemeal>(context, listen: false).total();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    itemsquote.clear();
  }

  final ScrollController control = ScrollController();
  void addsoup(id) {}
  bool drinkerror = false;
  bool fooderror = false;
  bool sideerror = false;
  bool drinkcomplete = false;
  bool foodcomplete = false;
  bool sidecomplete = false;
  List<List> check = [
    [0],
    [0],
    [0]
  ];
  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();
    context.read<meal_calculate>().cancelresquest();
    context.read<meal_calculate>().clearclick();
  }

  addprocess() {
    if (Provider.of<meal_calculate>(context, listen: false).item_clicked[6] ==
        true) {
      setState(() {
        check[check.indexWhere((v) => v == check[0])] = [3];
      });
    }
    print(check[1][0]);
    if (Provider.of<meal_calculate>(context, listen: false).item_clicked[7] ==
        true) {
      setState(() {
        check[check.indexWhere((v) => v == check[1])] = [3];
      });
    }
    if (Provider.of<meal_calculate>(context, listen: false).item_clicked[8] ==
        true) {
      setState(() {
        check[check.indexWhere((v) => v == check[2])] = [3];
      });
    }
  }

  bool network = false;

  @override
  Widget build(BuildContext context) {
    if (Provider.of<ConnectivityStatus>(context) ==
        ConnectivityStatus.Offline) {
      showoverlay();
    } else {
      SmartDialog.dismiss(tag: 'network');
    }
    return Scaffold(
      body: Stack(children: [
        SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
            width: double.infinity,
            child: CachedNetworkImage(
              imageUrl: context.watch<meal_calculate>().item_clicked[1] ?? '',
              errorWidget: (context, url, error) => Icon(Icons.error),
              width: MediaQuery.of(context).size.width * 0.4,
              height: MediaQuery.of(context).size.width * 0.35,
              fit: BoxFit.cover,
            )),
        InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            margin: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.07, left: 20),
            height: 40,
            width: 40,
            decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .primaryContainer
                    .withOpacity(.8),
                borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Icon(
                Icons.arrow_back_ios,
                size: 20,
              ),
            ),
          ),
        ),
        Container(
          width: double.infinity,
          margin:
              EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.35),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
          ),
          child: Column(children: [
            Container(
              margin: EdgeInsets.only(top: 20),
              width: 140,
              height: 50,
              decoration: BoxDecoration(
                  color: Colors.black.withOpacity(.7),
                  borderRadius: BorderRadius.circular(20)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      context.read<meal_calculate>().removelist();
                    },
                    child: Container(
                      height: 30,
                      width: 30,
                      // decoration: BoxDecoration(border: Border.all(width: 1)),
                      child: Icon(
                        Icons.remove,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    height: 30,
                    width: 30,
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        context
                            .watch<meal_calculate>()
                            .item_clicked[5]
                            .toString(),
                        style: TextStyle(
                            fontSize: 21, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      if (Provider.of<meal_calculate>(context, listen: false)
                              .available1 ==
                          false) {
                        // print(object)
                        if (Provider.of<meal_calculate>(context, listen: false)
                                .remains !=
                            Provider.of<meal_calculate>(context, listen: false)
                                .item_clicked[5]) {
                          context.read<meal_calculate>().addlist();
                        } else {
                          SmartDialog.showToast(
                              "You can't add more than the remaing item");
                        }
                      } else {
                        context.read<meal_calculate>().addlist();
                      }
                    },
                    child: Container(
                      height: 30,
                      width: 30,
                      // decoration: BoxDecoration(border: Border.all(width: 1)),
                      child: Icon(Icons.add, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
                child: context.watch<meal_calculate>().available1
                    ? SizedBox()
                    : Column(children: [
                        Text(
                          'Remaining',
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 17,
                              fontWeight: FontWeight.w500),
                        ),
                        Text(
                          context.watch<meal_calculate>().remains.toString(),
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 17,
                              fontWeight: FontWeight.w500),
                        )
                      ])),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child:
                    Consumer<meal_calculate>(builder: (context, value, child) {
                  return ListView(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    physics: ClampingScrollPhysics(),
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            context.watch<meal_calculate>().item_clicked[0],
                            style: TextStyle(
                                fontSize: 19, fontWeight: FontWeight.bold),
                          ),
                          Text(
                              '₦ ${context.watch<meal_calculate>().item_clicked[4].toString()}',
                              style: TextStyle(
                                  fontSize: 19, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        child: Text(
                            context.watch<meal_calculate>().item_clicked[2],
                            style: TextStyle(fontSize: 17)),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          SvgPicture.asset(
                            'images/svg/Vector-9.svg',
                            color: Theme.of(context).primaryColorDark,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                              '${context.watch<meal_calculate>().item_clicked[3]} minutes')
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      //Side
                      context.watch<meal_calculate>().item_clicked[6]
                          ? SizedBox(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                    height: 130,
                                    width: 150,
                                    decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .primaryColor
                                            .withOpacity(.8),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: context
                                            .watch<meal_calculate>()
                                            .loading_extra
                                        ? Center(
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                            ),
                                          )
                                        : ListView.builder(
                                            padding: EdgeInsets.zero,
                                            itemCount: context
                                                .watch<meal_calculate>()
                                                .side
                                                .length,
                                            itemBuilder: (context, index) {
                                              return Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10),
                                                height: 35,
                                                width: 60,
                                                margin: EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    context
                                                                .watch<
                                                                    meal_calculate>()
                                                                .side[index]
                                                                .remaining ==
                                                            true
                                                        ? Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              LayoutBuilder(
                                                                  builder:
                                                                      (context,
                                                                          size) {
                                                                // Build the textspan
                                                                var span =
                                                                    TextSpan(
                                                                  text: context
                                                                      .watch<
                                                                          meal_calculate>()
                                                                      .side[
                                                                          index]
                                                                      .extraName,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          18),
                                                                );

                                                                // Use a textpainter to determine if it will exceed max lines
                                                                var tp =
                                                                    TextPainter(
                                                                  maxLines: 1,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                  textDirection:
                                                                      TextDirection
                                                                          .ltr,
                                                                  text: span,
                                                                );

                                                                // trigger it to layout
                                                                tp.layout(
                                                                    maxWidth:
                                                                        80);

                                                                // whether the text overflowed or not
                                                                var exceeded = tp
                                                                    .didExceedMaxLines;

                                                                return exceeded
                                                                    ? SizedBox(
                                                                        width:
                                                                            90,
                                                                        child: Align(
                                                                            alignment: Alignment.centerLeft,
                                                                            child: TextScroll(
                                                                              context.watch<meal_calculate>().side[index].extraName,
                                                                              mode: TextScrollMode.bouncing,
                                                                              velocity: Velocity(pixelsPerSecond: Offset(10, 0)),
                                                                              delayBefore: Duration(milliseconds: 500),
                                                                              numberOfReps: 20,
                                                                              pauseBetween: Duration(milliseconds: 50),
                                                                              style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500),
                                                                              textAlign: TextAlign.right,
                                                                              selectable: true,
                                                                            )),
                                                                      )
                                                                    : SizedBox(
                                                                        width:
                                                                            90,
                                                                        child:
                                                                            Align(
                                                                          alignment:
                                                                              Alignment.centerLeft,
                                                                          child:
                                                                              Text(
                                                                            context.watch<meal_calculate>().side[index].extraName,
                                                                            maxLines:
                                                                                1,
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                            style: TextStyle(
                                                                                color: Colors.black,
                                                                                fontSize: 18,
                                                                                fontWeight: FontWeight.w500),
                                                                          ),
                                                                        ),
                                                                      );
                                                              }),
                                                              SizedBox(
                                                                child: Text(
                                                                  'Remaining : ${context.watch<meal_calculate>().side[index].remainingvalue}',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .red),
                                                                ),
                                                              )
                                                            ],
                                                          )
                                                        : LayoutBuilder(builder:
                                                            (context, size) {
                                                            // Build the textspan
                                                            var span = TextSpan(
                                                              text: context
                                                                  .watch<
                                                                      meal_calculate>()
                                                                  .side[index]
                                                                  .extraName,
                                                              style: TextStyle(
                                                                  fontSize: 18),
                                                            );

                                                            // Use a textpainter to determine if it will exceed max lines
                                                            var tp =
                                                                TextPainter(
                                                              maxLines: 1,
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              textDirection:
                                                                  TextDirection
                                                                      .ltr,
                                                              text: span,
                                                            );

                                                            // trigger it to layout
                                                            tp.layout(
                                                                maxWidth: 80);

                                                            // whether the text overflowed or not
                                                            var exceeded = tp
                                                                .didExceedMaxLines;

                                                            return exceeded
                                                                ? SizedBox(
                                                                    width: 90,
                                                                    child: Align(
                                                                        alignment: Alignment.centerLeft,
                                                                        child: TextScroll(
                                                                          context
                                                                              .watch<meal_calculate>()
                                                                              .side[index]
                                                                              .extraName,
                                                                          mode:
                                                                              TextScrollMode.bouncing,
                                                                          velocity:
                                                                              Velocity(pixelsPerSecond: Offset(10, 0)),
                                                                          delayBefore:
                                                                              Duration(milliseconds: 500),
                                                                          numberOfReps:
                                                                              20,
                                                                          pauseBetween:
                                                                              Duration(milliseconds: 50),
                                                                          style: TextStyle(
                                                                              color: Colors.black,
                                                                              fontSize: 18,
                                                                              fontWeight: FontWeight.w500),
                                                                          textAlign:
                                                                              TextAlign.right,
                                                                          selectable:
                                                                              true,
                                                                        )),
                                                                  )
                                                                : SizedBox(
                                                                    width: 90,
                                                                    child:
                                                                        Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .centerLeft,
                                                                      child:
                                                                          Text(
                                                                        context
                                                                            .watch<meal_calculate>()
                                                                            .side[index]
                                                                            .extraName,
                                                                        maxLines:
                                                                            1,
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                        style: TextStyle(
                                                                            color: Colors
                                                                                .black,
                                                                            fontSize:
                                                                                18,
                                                                            fontWeight:
                                                                                FontWeight.w500),
                                                                      ),
                                                                    ),
                                                                  );
                                                          }),
                                                    InkWell(
                                                      onTap: () {
                                                        if (Provider.of<meal_calculate>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .side[index]
                                                                .remaining ==
                                                            true) {
                                                          if (Provider.of<meal_calculate>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .sidecollect
                                                                  .length !=
                                                              Provider.of<meal_calculate>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .side[index]
                                                                  .remainingvalue) {
                                                            setState(() {
                                                              sideerror = false;
                                                            });
                                                            if (Provider.of<meal_calculate>(
                                                                            context,
                                                                            listen:
                                                                                false)
                                                                        .item_clicked[9]
                                                                    [0]['0'] !=
                                                                Provider.of<meal_calculate>(
                                                                        context,
                                                                        listen:
                                                                            false)
                                                                    .sidecollect
                                                                    .length) {
                                                              context.read<meal_calculate>().addside(
                                                                  Provider.of<meal_calculate>(
                                                                          context,
                                                                          listen:
                                                                              false)
                                                                      .side[
                                                                          index]
                                                                      .extraId,
                                                                  Provider.of<meal_calculate>(
                                                                          context,
                                                                          listen:
                                                                              false)
                                                                      .side[
                                                                          index]
                                                                      .extraName);

                                                              if (value.item_clicked[
                                                                          9][0]
                                                                      ['0'] ==
                                                                  value
                                                                      .sidecollect
                                                                      .length) {
                                                                setState(() {
                                                                  check[check
                                                                      .indexWhere((v) =>
                                                                          v ==
                                                                          check[
                                                                              0])] = [
                                                                    0
                                                                  ];
                                                                });
                                                              }
                                                            } else {
                                                              SmartDialog.showToast(
                                                                  'You have added the max number of side for this offer');
                                                            }
                                                          } else {
                                                            SmartDialog.showToast(
                                                                'Cannot add more of this item');
                                                          }
                                                        } else {
                                                          setState(() {
                                                            sideerror = false;
                                                          });
                                                          if (Provider.of<meal_calculate>(
                                                                          context,
                                                                          listen:
                                                                              false)
                                                                      .item_clicked[
                                                                  9][0]['0'] !=
                                                              Provider.of<meal_calculate>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .sidecollect
                                                                  .length) {
                                                            context.read<meal_calculate>().addside(
                                                                Provider.of<meal_calculate>(
                                                                        context,
                                                                        listen:
                                                                            false)
                                                                    .side[index]
                                                                    .extraId,
                                                                Provider.of<meal_calculate>(
                                                                        context,
                                                                        listen:
                                                                            false)
                                                                    .side[index]
                                                                    .extraName);

                                                            if (value.item_clicked[
                                                                        9][0]
                                                                    ['0'] ==
                                                                value
                                                                    .sidecollect
                                                                    .length) {
                                                              setState(() {
                                                                check[check
                                                                    .indexWhere(
                                                                        (v) =>
                                                                            v ==
                                                                            check[0])] = [
                                                                  0
                                                                ];
                                                              });
                                                            }
                                                          } else {
                                                            SmartDialog.showToast(
                                                                'You have added the max number of side for this offer');
                                                          }
                                                        }
                                                      },
                                                      child: Container(
                                                        height: 20,
                                                        width: 20,
                                                        decoration: BoxDecoration(
                                                            color: Colors.blue,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5)),
                                                        child: FittedBox(
                                                          child: Icon(
                                                            Icons.add,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                  ),
                                  Container(
                                    height: 130,
                                    width: 150,
                                    decoration: BoxDecoration(
                                        color: sideerror
                                            ? Colors.red
                                            : Theme.of(context)
                                                .primaryColor
                                                .withOpacity(.8),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child:
                                        context
                                                .watch<meal_calculate>()
                                                .sidecollect
                                                .isEmpty
                                            ? Center(
                                                child: Text(
                                                  'Add Side',
                                                  style: TextStyle(
                                                      fontSize: 19,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white),
                                                ),
                                              )
                                            : ListView.builder(
                                                padding: EdgeInsets.zero,
                                                itemCount: context
                                                    .watch<meal_calculate>()
                                                    .sidecollect
                                                    .length,
                                                itemBuilder: (context, index) {
                                                  return Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 10),
                                                    height: 30,
                                                    width: 60,
                                                    margin: EdgeInsets.all(10),
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10)),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        LayoutBuilder(builder:
                                                            (context, size) {
                                                          // Build the textspan
                                                          var span = TextSpan(
                                                            text: context
                                                                    .watch<
                                                                        meal_calculate>()
                                                                    .sidecollect[
                                                                index][1],
                                                            style: TextStyle(
                                                                fontSize: 18),
                                                          );

                                                          // Use a textpainter to determine if it will exceed max lines
                                                          var tp = TextPainter(
                                                            maxLines: 1,
                                                            textAlign:
                                                                TextAlign.left,
                                                            textDirection:
                                                                TextDirection
                                                                    .ltr,
                                                            text: span,
                                                          );

                                                          // trigger it to layout
                                                          tp.layout(
                                                              maxWidth: 80);

                                                          // whether the text overflowed or not
                                                          var exceeded = tp
                                                              .didExceedMaxLines;

                                                          return exceeded
                                                              ? SizedBox(
                                                                  width: 90,
                                                                  child: Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .centerLeft,
                                                                      child:
                                                                          TextScroll(
                                                                        context
                                                                            .watch<meal_calculate>()
                                                                            .sidecollect[index][1],
                                                                        mode: TextScrollMode
                                                                            .bouncing,
                                                                        velocity:
                                                                            Velocity(pixelsPerSecond: Offset(10, 0)),
                                                                        delayBefore:
                                                                            Duration(milliseconds: 500),
                                                                        numberOfReps:
                                                                            20,
                                                                        pauseBetween:
                                                                            Duration(milliseconds: 50),
                                                                        style: TextStyle(
                                                                            color: Colors
                                                                                .black,
                                                                            fontSize:
                                                                                18,
                                                                            fontWeight:
                                                                                FontWeight.w500),
                                                                        textAlign:
                                                                            TextAlign.right,
                                                                        selectable:
                                                                            true,
                                                                      )),
                                                                )
                                                              : SizedBox(
                                                                  width: 90,
                                                                  child: Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .centerLeft,
                                                                    child: Text(
                                                                      context
                                                                          .watch<
                                                                              meal_calculate>()
                                                                          .sidecollect[index][1],
                                                                      maxLines:
                                                                          1,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .black,
                                                                          fontSize:
                                                                              18,
                                                                          fontWeight:
                                                                              FontWeight.w500),
                                                                    ),
                                                                  ),
                                                                );
                                                        }),
                                                        InkWell(
                                                          onTap: () {
                                                            context
                                                                .read<
                                                                    meal_calculate>()
                                                                .removeside(
                                                                    index);
                                                            if (value.item_clicked[
                                                                        9][0]
                                                                    ['0'] !=
                                                                value
                                                                    .sidecollect
                                                                    .length) {
                                                              setState(() {
                                                                check[check
                                                                    .indexWhere(
                                                                        (v) =>
                                                                            v ==
                                                                            check[0])] = [
                                                                  3
                                                                ];
                                                              });
                                                            }
                                                          },
                                                          child: Container(
                                                            height: 20,
                                                            width: 20,
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5)),
                                                            child: FittedBox(
                                                                child:
                                                                    SvgPicture
                                                                        .asset(
                                                              'images/svg/cancel1.svg',
                                                              color: Colors.red,
                                                            )),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              ),
                                  )
                                ],
                              ),
                            )
                          : SizedBox(),
                      SizedBox(
                        height: 20,
                      ),
                      //Food
                      context.watch<meal_calculate>().item_clicked[7]
                          ? SizedBox(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                    height: 130,
                                    width: 150,
                                    decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .primaryColor
                                            .withOpacity(.8),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: context
                                            .watch<meal_calculate>()
                                            .loading_extra
                                        ? Center(
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                            ),
                                          )
                                        : ListView.builder(
                                            padding: EdgeInsets.zero,
                                            itemCount: context
                                                .watch<meal_calculate>()
                                                .food
                                                .length,
                                            itemBuilder: (context, index) {
                                              return Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10),
                                                height: 30,
                                                width: 60,
                                                margin: EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    context
                                                                .watch<
                                                                    meal_calculate>()
                                                                .food[index]
                                                                .remaining ==
                                                            true
                                                        ? Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Align(
                                                                alignment: Alignment
                                                                    .centerLeft,
                                                                child: Text(
                                                                  context
                                                                      .watch<
                                                                          meal_calculate>()
                                                                      .food[
                                                                          index]
                                                                      .extraName,
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          18,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                child: Text(
                                                                  'Remaining : ${context.watch<meal_calculate>().food[index].remainingvalue}',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .red),
                                                                ),
                                                              )
                                                            ],
                                                          )
                                                        : LayoutBuilder(builder:
                                                            (context, size) {
                                                            // Build the textspan
                                                            var span = TextSpan(
                                                              text: context
                                                                  .watch<
                                                                      meal_calculate>()
                                                                  .food[index]
                                                                  .extraName,
                                                              style: TextStyle(
                                                                  fontSize: 18),
                                                            );

                                                            // Use a textpainter to determine if it will exceed max lines
                                                            var tp =
                                                                TextPainter(
                                                              maxLines: 1,
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              textDirection:
                                                                  TextDirection
                                                                      .ltr,
                                                              text: span,
                                                            );

                                                            // trigger it to layout
                                                            tp.layout(
                                                                maxWidth: 80);

                                                            // whether the text overflowed or not
                                                            var exceeded = tp
                                                                .didExceedMaxLines;

                                                            return exceeded
                                                                ? SizedBox(
                                                                    width: 90,
                                                                    child: Align(
                                                                        alignment: Alignment.centerLeft,
                                                                        child: TextScroll(
                                                                          context
                                                                              .watch<meal_calculate>()
                                                                              .food[index]
                                                                              .extraName,
                                                                          mode:
                                                                              TextScrollMode.bouncing,
                                                                          velocity:
                                                                              Velocity(pixelsPerSecond: Offset(10, 0)),
                                                                          delayBefore:
                                                                              Duration(milliseconds: 500),
                                                                          numberOfReps:
                                                                              20,
                                                                          pauseBetween:
                                                                              Duration(milliseconds: 50),
                                                                          style: TextStyle(
                                                                              color: Colors.black,
                                                                              fontSize: 18,
                                                                              fontWeight: FontWeight.w500),
                                                                          textAlign:
                                                                              TextAlign.right,
                                                                          selectable:
                                                                              true,
                                                                        )),
                                                                  )
                                                                : SizedBox(
                                                                    width: 90,
                                                                    child:
                                                                        Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .centerLeft,
                                                                      child:
                                                                          Text(
                                                                        context
                                                                            .watch<meal_calculate>()
                                                                            .food[index]
                                                                            .extraName,
                                                                        maxLines:
                                                                            1,
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                        style: TextStyle(
                                                                            color: Colors
                                                                                .black,
                                                                            fontSize:
                                                                                18,
                                                                            fontWeight:
                                                                                FontWeight.w500),
                                                                      ),
                                                                    ),
                                                                  );
                                                          }),
                                                    InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          fooderror = false;
                                                        });
                                                        if (Provider.of<meal_calculate>(
                                                                        context,
                                                                        listen:
                                                                            false)
                                                                    .item_clicked[
                                                                10][0]['0'] !=
                                                            Provider.of<meal_calculate>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .foodcollect
                                                                .length) {
                                                          context.read<meal_calculate>().addfood(
                                                              Provider.of<meal_calculate>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .food[index]
                                                                  .extraId,
                                                              Provider.of<meal_calculate>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .food[index]
                                                                  .extraName);
                                                          if (value.item_clicked[
                                                                  10][0]['0'] ==
                                                              value.foodcollect
                                                                  .length) {
                                                            setState(() {
                                                              check[check
                                                                  .indexWhere((v) =>
                                                                      v ==
                                                                      check[
                                                                          1])] = [
                                                                0
                                                              ];
                                                            });
                                                          }
                                                        } else {
                                                          SmartDialog.showToast(
                                                              'You have added the max number of food for this offer');
                                                        }
                                                      },
                                                      child: Container(
                                                        height: 20,
                                                        width: 20,
                                                        decoration: BoxDecoration(
                                                            color: Colors.blue,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5)),
                                                        child: FittedBox(
                                                          child: Icon(
                                                            Icons.add,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                  ),
                                  Container(
                                    height: 130,
                                    width: 150,
                                    decoration: BoxDecoration(
                                        color: fooderror
                                            ? Colors.red
                                            : Theme.of(context)
                                                .primaryColor
                                                .withOpacity(.8),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child:
                                        context
                                                .watch<meal_calculate>()
                                                .foodcollect
                                                .isEmpty
                                            ? Center(
                                                child: Text(
                                                  'Add Food',
                                                  style: TextStyle(
                                                      fontSize: 19,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white),
                                                ),
                                              )
                                            : ListView.builder(
                                                padding: EdgeInsets.zero,
                                                itemCount: context
                                                    .watch<meal_calculate>()
                                                    .foodcollect
                                                    .length,
                                                itemBuilder: (context, index) {
                                                  return Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 10),
                                                    height: 30,
                                                    width: 60,
                                                    margin: EdgeInsets.all(10),
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10)),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        LayoutBuilder(builder:
                                                            (context, size) {
                                                          // Build the textspan
                                                          var span = TextSpan(
                                                            text: context
                                                                    .watch<
                                                                        meal_calculate>()
                                                                    .foodcollect[
                                                                index][1],
                                                            style: TextStyle(
                                                                fontSize: 18),
                                                          );

                                                          // Use a textpainter to determine if it will exceed max lines
                                                          var tp = TextPainter(
                                                            maxLines: 1,
                                                            textAlign:
                                                                TextAlign.left,
                                                            textDirection:
                                                                TextDirection
                                                                    .ltr,
                                                            text: span,
                                                          );

                                                          // trigger it to layout
                                                          tp.layout(
                                                              maxWidth: 80);

                                                          // whether the text overflowed or not
                                                          var exceeded = tp
                                                              .didExceedMaxLines;

                                                          return exceeded
                                                              ? SizedBox(
                                                                  width: 90,
                                                                  child: Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .centerLeft,
                                                                      child:
                                                                          TextScroll(
                                                                        context
                                                                            .watch<meal_calculate>()
                                                                            .foodcollect[index][1],
                                                                        mode: TextScrollMode
                                                                            .bouncing,
                                                                        velocity:
                                                                            Velocity(pixelsPerSecond: Offset(10, 0)),
                                                                        delayBefore:
                                                                            Duration(milliseconds: 500),
                                                                        numberOfReps:
                                                                            20,
                                                                        pauseBetween:
                                                                            Duration(milliseconds: 50),
                                                                        style: TextStyle(
                                                                            color: Colors
                                                                                .black,
                                                                            fontSize:
                                                                                18,
                                                                            fontWeight:
                                                                                FontWeight.w500),
                                                                        textAlign:
                                                                            TextAlign.right,
                                                                        selectable:
                                                                            true,
                                                                      )),
                                                                )
                                                              : SizedBox(
                                                                  width: 90,
                                                                  child: Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .centerLeft,
                                                                    child: Text(
                                                                      context
                                                                          .watch<
                                                                              meal_calculate>()
                                                                          .foodcollect[index][1],
                                                                      maxLines:
                                                                          1,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .black,
                                                                          fontSize:
                                                                              18,
                                                                          fontWeight:
                                                                              FontWeight.w500),
                                                                    ),
                                                                  ),
                                                                );
                                                        }),
                                                        InkWell(
                                                          onTap: () {
                                                            context
                                                                .read<
                                                                    meal_calculate>()
                                                                .removefood(
                                                                    index);
                                                            if (value.item_clicked[
                                                                        10][0]
                                                                    ['0'] !=
                                                                value
                                                                    .foodcollect
                                                                    .length) {
                                                              setState(() {
                                                                check[check
                                                                    .indexWhere(
                                                                        (v) =>
                                                                            v ==
                                                                            check[1])] = [
                                                                  3
                                                                ];
                                                              });
                                                            }
                                                          },
                                                          child: Container(
                                                            height: 20,
                                                            width: 20,
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5)),
                                                            child: FittedBox(
                                                                child:
                                                                    SvgPicture
                                                                        .asset(
                                                              'images/svg/cancel1.svg',
                                                              color: Colors.red,
                                                            )),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              ),
                                  )
                                ],
                              ),
                            )
                          : SizedBox(),
                      SizedBox(
                        height: 20,
                      ),
                      //Drink
                      context.watch<meal_calculate>().item_clicked[8]
                          ? SizedBox(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                    height: 130,
                                    width: 150,
                                    decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .primaryColor
                                            .withOpacity(.8),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: context
                                            .watch<meal_calculate>()
                                            .loading_extra
                                        ? Center(
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                            ),
                                          )
                                        : ListView.builder(
                                            padding: EdgeInsets.zero,
                                            itemCount: context
                                                .watch<meal_calculate>()
                                                .drink
                                                .length,
                                            itemBuilder: (context, index) {
                                              return Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10),
                                                height: 30,
                                                width: 60,
                                                margin: EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    context
                                                                .watch<
                                                                    meal_calculate>()
                                                                .drink[index]
                                                                .remaining ==
                                                            true
                                                        ? Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Align(
                                                                alignment: Alignment
                                                                    .centerLeft,
                                                                child: Text(
                                                                  context
                                                                      .watch<
                                                                          meal_calculate>()
                                                                      .drink[
                                                                          index]
                                                                      .extraName,
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          18,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                child: Text(
                                                                  'Remaining : ${context.watch<meal_calculate>().drink[index].remainingvalue}',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .red),
                                                                ),
                                                              )
                                                            ],
                                                          )
                                                        : LayoutBuilder(builder:
                                                            (context, size) {
                                                            // Build the textspan
                                                            var span = TextSpan(
                                                              text: context
                                                                  .watch<
                                                                      meal_calculate>()
                                                                  .drink[index]
                                                                  .extraName,
                                                              style: TextStyle(
                                                                  fontSize: 18),
                                                            );

                                                            // Use a textpainter to determine if it will exceed max lines
                                                            var tp =
                                                                TextPainter(
                                                              maxLines: 1,
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              textDirection:
                                                                  TextDirection
                                                                      .ltr,
                                                              text: span,
                                                            );

                                                            // trigger it to layout
                                                            tp.layout(
                                                                maxWidth: 80);

                                                            // whether the text overflowed or not
                                                            var exceeded = tp
                                                                .didExceedMaxLines;

                                                            return exceeded
                                                                ? SizedBox(
                                                                    width: 90,
                                                                    child: Align(
                                                                        alignment: Alignment.centerLeft,
                                                                        child: TextScroll(
                                                                          context
                                                                              .watch<meal_calculate>()
                                                                              .drink[index]
                                                                              .extraName,
                                                                          mode:
                                                                              TextScrollMode.bouncing,
                                                                          velocity:
                                                                              Velocity(pixelsPerSecond: Offset(10, 0)),
                                                                          delayBefore:
                                                                              Duration(milliseconds: 500),
                                                                          numberOfReps:
                                                                              20,
                                                                          pauseBetween:
                                                                              Duration(milliseconds: 50),
                                                                          style: TextStyle(
                                                                              color: Colors.black,
                                                                              fontSize: 18,
                                                                              fontWeight: FontWeight.w500),
                                                                          textAlign:
                                                                              TextAlign.right,
                                                                          selectable:
                                                                              true,
                                                                        )),
                                                                  )
                                                                : SizedBox(
                                                                    width: 90,
                                                                    child:
                                                                        Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .centerLeft,
                                                                      child:
                                                                          Text(
                                                                        context
                                                                            .watch<meal_calculate>()
                                                                            .drink[index]
                                                                            .extraName,
                                                                        maxLines:
                                                                            1,
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                        style: TextStyle(
                                                                            color: Colors
                                                                                .black,
                                                                            fontSize:
                                                                                18,
                                                                            fontWeight:
                                                                                FontWeight.w500),
                                                                      ),
                                                                    ),
                                                                  );
                                                          }),
                                                    InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          drinkerror = false;
                                                        });
                                                        if (Provider.of<meal_calculate>(
                                                                        context,
                                                                        listen:
                                                                            false)
                                                                    .item_clicked[
                                                                11][0]['0'] !=
                                                            Provider.of<meal_calculate>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .drinkcollect
                                                                .length) {
                                                          context.read<meal_calculate>().adddrink(
                                                              Provider.of<meal_calculate>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .drink[index]
                                                                  .extraId,
                                                              Provider.of<meal_calculate>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .drink[index]
                                                                  .extraName);
                                                          if (value.item_clicked[
                                                                  11][0]['0'] ==
                                                              value.drinkcollect
                                                                  .length) {
                                                            setState(() {
                                                              check[check
                                                                  .indexWhere((v) =>
                                                                      v ==
                                                                      check[
                                                                          2])] = [
                                                                0
                                                              ];
                                                            });
                                                          }
                                                        } else {
                                                          SmartDialog.showToast(
                                                              'You have added the max number of drink for this offer');
                                                        }
                                                      },
                                                      child: Container(
                                                        height: 20,
                                                        width: 20,
                                                        decoration: BoxDecoration(
                                                            color: Colors.blue,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5)),
                                                        child: FittedBox(
                                                          child: Icon(
                                                            Icons.add,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                  ),
                                  Container(
                                    height: 130,
                                    width: 150,
                                    decoration: BoxDecoration(
                                        color: drinkerror
                                            ? Colors.red
                                            : Theme.of(context)
                                                .primaryColor
                                                .withOpacity(.8),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child:
                                        context
                                                .watch<meal_calculate>()
                                                .drinkcollect
                                                .isEmpty
                                            ? Center(
                                                child: Text(
                                                  'Add Drink',
                                                  style: TextStyle(
                                                      fontSize: 19,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white),
                                                ),
                                              )
                                            : ListView.builder(
                                                padding: EdgeInsets.zero,
                                                itemCount: context
                                                    .watch<meal_calculate>()
                                                    .drinkcollect
                                                    .length,
                                                itemBuilder: (context, index) {
                                                  return Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 10),
                                                    height: 30,
                                                    width: 60,
                                                    margin: EdgeInsets.all(10),
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10)),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        LayoutBuilder(builder:
                                                            (context, size) {
                                                          // Build the textspan
                                                          var span = TextSpan(
                                                            text: context
                                                                    .watch<
                                                                        meal_calculate>()
                                                                    .drinkcollect[
                                                                index][1],
                                                            style: TextStyle(
                                                                fontSize: 18),
                                                          );

                                                          // Use a textpainter to determine if it will exceed max lines
                                                          var tp = TextPainter(
                                                            maxLines: 1,
                                                            textAlign:
                                                                TextAlign.left,
                                                            textDirection:
                                                                TextDirection
                                                                    .ltr,
                                                            text: span,
                                                          );

                                                          // trigger it to layout
                                                          tp.layout(
                                                              maxWidth: 80);

                                                          // whether the text overflowed or not
                                                          var exceeded = tp
                                                              .didExceedMaxLines;

                                                          return exceeded
                                                              ? SizedBox(
                                                                  width: 90,
                                                                  child: Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .centerLeft,
                                                                      child:
                                                                          TextScroll(
                                                                        context
                                                                            .watch<meal_calculate>()
                                                                            .drinkcollect[index][1],
                                                                        mode: TextScrollMode
                                                                            .bouncing,
                                                                        velocity:
                                                                            Velocity(pixelsPerSecond: Offset(10, 0)),
                                                                        delayBefore:
                                                                            Duration(milliseconds: 500),
                                                                        numberOfReps:
                                                                            20,
                                                                        pauseBetween:
                                                                            Duration(milliseconds: 50),
                                                                        style: TextStyle(
                                                                            color: Colors
                                                                                .black,
                                                                            fontSize:
                                                                                18,
                                                                            fontWeight:
                                                                                FontWeight.w500),
                                                                        textAlign:
                                                                            TextAlign.right,
                                                                        selectable:
                                                                            true,
                                                                      )),
                                                                )
                                                              : SizedBox(
                                                                  width: 90,
                                                                  child: Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .centerLeft,
                                                                    child: Text(
                                                                      context
                                                                          .watch<
                                                                              meal_calculate>()
                                                                          .drinkcollect[index][1],
                                                                      maxLines:
                                                                          1,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .black,
                                                                          fontSize:
                                                                              18,
                                                                          fontWeight:
                                                                              FontWeight.w500),
                                                                    ),
                                                                  ),
                                                                );
                                                        }),

                                                        // Align(
                                                        //   alignment:
                                                        //       Alignment.centerLeft,
                                                        //   child: Text(
                                                        //     context
                                                        //         .watch<
                                                        //             meal_calculate>()
                                                        //         .drinkcollect[index][1],
                                                        //     style: TextStyle(
                                                        //         color: Colors.black,
                                                        //         fontSize: 18,
                                                        //         fontWeight:
                                                        //             FontWeight
                                                        //                 .w500),
                                                        //   ),
                                                        // ),
                                                        InkWell(
                                                          onTap: () {
                                                            context
                                                                .read<
                                                                    meal_calculate>()
                                                                .removedrink(
                                                                    index);
                                                            if (value.item_clicked[
                                                                        11][0]
                                                                    ['0'] !=
                                                                value
                                                                    .drinkcollect
                                                                    .length) {
                                                              setState(() {
                                                                check[check
                                                                    .indexWhere(
                                                                        (v) =>
                                                                            v ==
                                                                            check[2])] = [
                                                                  3
                                                                ];
                                                              });
                                                            }
                                                          },
                                                          child: Container(
                                                            height: 20,
                                                            width: 20,
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5)),
                                                            child: FittedBox(
                                                                child:
                                                                    SvgPicture
                                                                        .asset(
                                                              'images/svg/cancel1.svg',
                                                              color: Colors.red,
                                                            )),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              ),
                                  )
                                ],
                              ),
                            )
                          : SizedBox(),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.04,
                      ),
                      Consumer<meal_calculate>(
                          builder: (context, value, child) {
                        return InkWell(
                          onTap: () async {
                            if (check[0][0] == 3) {
                              setState(() {
                                sideerror = true;
                              });
                            }
                            if (check[1][0] == 3) {
                              setState(() {
                                fooderror = true;
                              });
                            }

                            if (check[2][0] == 3) {
                              setState(() {
                                drinkerror = true;
                              });
                            }

                            for (var i = 0; i < check.length; i++) {
                              if (check[i][0] != 0) {
                                setState(() {
                                  error = true;
                                  i = 3;
                                });
                              } else {
                                setState(() {
                                  error = false;
                                });
                              }
                            }

                            if (error == false) {
                              await context.read<meal_calculate>().sendtocart();
                              addprocess();
                              if (value.status == 'success') {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: CustomeSnackbar(
                                    topic: 'Great!',
                                    msg: value.report,
                                    color1:
                                        const Color.fromARGB(255, 25, 107, 52),
                                    color2:
                                        const Color.fromARGB(255, 19, 95, 40),
                                  ),
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: Colors.transparent,
                                  elevation: 0,
                                ));
                              } else if (value.status == 'fail') {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: CustomeSnackbar(
                                    topic: 'Oh Snap!',
                                    msg: value.report,
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
                            } else {
                              SmartDialog.showToast('Please add all Extras');
                            }
                          },
                          child: Container(
                            height: 50,
                            width: 170,
                            decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(25)),
                            child: value.sendload
                                ? Center(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Add To Cart',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    )),
                          ),
                        );
                      }),
                      SizedBox(
                        height: 30,
                      ),
                    ],
                  );
                }),
              ),
            )
          ]),
        ),
      ]),
    );
  }

  void addTocarts() {
    if (context.read<calculatemeal>().foodtotal() < 499) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: CustomeSnackbar(
          topic: 'Oh Snap!',
          msg: 'Total Amount of food per pack must be more than ₦500',
          color1: Color.fromARGB(255, 171, 51, 42),
          color2: Color.fromARGB(255, 127, 39, 33),
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ));
    } else {
      context.read<addTocart>().getClickedfood();

      context.read<calculatemeal>().reset();
      // print(context.watch<addTocart>().cartList);
      popupscaffold();
      setState(() {
        _selecteCategorys.clear();
        for (var i = 0; i < itemsquote.length; i++) {
          final thisquote = itemsquote[i];
          thisquote.contains(thisquote[2])
              ? thisquote[thisquote.indexWhere((v) => v == thisquote[2])] = 1
              : thisquote;
          thisquote.contains(thisquote[1])
              ? thisquote[thisquote.indexWhere((v) => v == thisquote[1])] =
                  thisquote[3]
              : thisquote;
        }
        multiplier = 1;
      });
    }
  }

  void popupscaffold() {
    if (success != '') {
      if (success == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: CustomeSnackbar(
            topic: 'Great!',
            msg: msg1,
            color1: Color.fromARGB(255, 25, 107, 52),
            color2: Color.fromARGB(255, 19, 95, 40),
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
            color1: Color.fromARGB(255, 171, 51, 42),
            color2: Color.fromARGB(255, 127, 39, 33),
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ));
      }
    }
  }

  void buynow() {
    Navigator.pushNamed(context, '/cart');
  }
}
