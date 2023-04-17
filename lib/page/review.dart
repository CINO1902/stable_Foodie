import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

import 'package:foodie_ios/linkfile/Model/Extra_model.dart';
import 'package:foodie_ios/linkfile/enum/connectivity_status.dart';

import 'package:foodie_ios/linkfile/provider/addTocart.dart';
import 'package:foodie_ios/linkfile/provider/calculatemael.dart';
import 'package:foodie_ios/linkfile/provider/checkcart.dart';

import 'package:foodie_ios/linkfile/provider/getItemextra.dart';
import 'package:foodie_ios/linkfile/provider/internetchecker.dart';
import 'package:foodie_ios/linkfile/refresh.dart';
import 'package:foodie_ios/linkfile/snackbar.dart';
import 'package:foodie_ios/page/overlay.dart';
import 'package:provider/provider.dart';

class Review extends StatefulWidget {
  const Review({
    super.key,
  });

  @override
  State<Review> createState() => _ReviewState();
}

class _ReviewState extends State<Review> {
  List<List<ItemExtra>> items = [];
  bool sett = false;
  List _selecteCategorys = [];
  List<String> soupid = [];
  List soupadded = [];
  List foodquote = [];
  List itemindex = [];
  List soupindex = [];
  List<List<dynamic>> itemsquote = [];
  bool checkdone = false;
  String amount = '';
  int multiplier = 1;
  String msg1 = '';
  String success = '';
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
    items.clear();
    // Provider.of<calculatemeal>(context, listen: false).total();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    items.clear();
    itemsquote.clear();
  }

  final ScrollController control = ScrollController();
  void addsoup(id) {
    setState(() {
      soupadded.clear();
      soupadded.add(id);
    });

    checkempty();
  }

  bool checkempty() {
    bool checksoupempty = true;
    if (soupadded.isEmpty) {
      checksoupempty = true;
    } else {
      checksoupempty = false;
    }
    return checksoupempty;
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();
    context.read<getiItemExtra>().cancelresquest();
    context.read<calculatemeal>().clearlist();
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
              imageUrl: context.watch<calculatemeal>().clickedfood[1] ?? '',
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
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30), topRight: Radius.circular(30))),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.48,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 30, left: 20),
                        child: Text(
                          context.watch<calculatemeal>().clickedfood[0] ?? '',
                          style: TextStyle(
                              fontSize: 23, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10, left: 20),
                        child: Text(
                          'Min: ${context.watch<calculatemeal>().clickedfood[3]}',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  // color: Colors.black,
                  width: MediaQuery.of(context).size.width * 0.28,
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            if (multiplier != 1) {
                              multiplier = multiplier - 1;
                              context.read<calculatemeal>().substractlist();
                            }
                          });
                          context.read<addTocart>().checkbuy();
                        },
                        child: Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.black, width: 1)),
                          child: Icon(Icons.remove),
                        ),
                      ),
                      Container(
                        height: 30,
                        width: 30,
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            multiplier.toString(),
                            style: TextStyle(
                                fontSize: 21, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            if (multiplier !=
                                Provider.of<calculatemeal>(context,
                                        listen: false)
                                    .clickedfood[5]) {
                              multiplier = multiplier + 1;
                              context.read<calculatemeal>().addlist();
                            } else {
                              SmartDialog.showToast(
                                "Cannot add more of this item",
                              );
                            }
                          });
                          context.read<addTocart>().checkbuy();
                        },
                        child: Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.black, width: 1)),
                          child: Icon(Icons.add),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.14,
                  child: Text(
                    context.watch<calculatemeal>().clickedfood[2].toString(),
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 18),
                  ),
                )
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              width: double.infinity,
              height: 30,
              color: Theme.of(context).primaryColor.withOpacity(.3),
              padding: EdgeInsets.only(top: 5, left: 25),
              child: Text(
                'Add Some Extras',
                style: TextStyle(
                  fontSize: 17,
                ),
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(right: 20),
                child:
                    Consumer<getiItemExtra>(builder: (context, value, child) {
                  print(value.loading);
                  if (value.loading == true) {
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
                              await context.read<getiItemExtra>().getItemExtra(
                                  Provider.of<calculatemeal>(context,
                                          listen: false)
                                      .clickedfood[4]);
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
                  } else if (value.data == true) {
                    items = value.items;

                    soupindex.clear();
                    itemsquote = value.itemsquote;
                    soupid = value.soupid;
                    for (var i = 0; i < itemsquote.length; i++) {
                      itemindex.add(itemsquote[i][0]);
                    }
                    for (var i = 0; i < soupid.length; i++) {
                      soupindex.add(itemindex.indexOf(soupid[i]));
                    }

                    context.read<calculatemeal>().total();
                    context.read<calculatemeal>().getExtras(itemsquote);
                    // print(value.soupid);
                    return RefreshWidget(
                      control: control,
                      onRefresh: () async {
                        await context.read<getiItemExtra>().getItemExtra(
                            Provider.of<calculatemeal>(context, listen: false)
                                .clickedfood[4]);
                      },
                      child: ListView.builder(
                          shrinkWrap: true,
                          primary: Platform.isAndroid ? true : false,
                          padding: EdgeInsets.zero,
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            final list = items[index];
                            final remains = items[index][0].remaining;
                            return Container(
                                child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Checkbox(
                                      activeColor:
                                          Theme.of(context).primaryColor,
                                      value: _selecteCategorys.contains(
                                          items[index][0].itemExtraId),
                                      onChanged: (bool? selected) {
                                        if (soupid.contains(
                                            items[index][0].itemExtraId)) {
                                          addsoup(items[index][0].itemExtraId);
                                          for (var i = 0;
                                              i < soupid.length;
                                              i++) {
                                            _selecteCategorys.remove(soupid[i]);
                                          }
                                          for (var i = 0;
                                              i < soupindex.length;
                                              i++) {
                                            final thisquote = itemsquote[i];
                                            thisquote.contains(thisquote[4])
                                                ? thisquote[
                                                    thisquote.indexWhere((v) =>
                                                        v ==
                                                        thisquote[4])] = false
                                                : 0;
                                          }

                                          _onCategorySelected(selected!,
                                              items[index][0].itemExtraId);
                                          context
                                              .read<calculatemeal>()
                                              .getselected(_selecteCategorys);
                                          final thisquote = itemsquote[index];
                                          thisquote.contains(thisquote[4])
                                              ? thisquote[thisquote.indexWhere(
                                                      (v) =>
                                                          v == thisquote[4])] =
                                                  selected
                                              : 0;
                                        } else {
                                          _onCategorySelected(selected!,
                                              items[index][0].itemExtraId);
                                          context
                                              .read<calculatemeal>()
                                              .getselected(_selecteCategorys);
                                          final thisquote = itemsquote[index];
                                          thisquote.contains(thisquote[4])
                                              ? thisquote[thisquote.indexWhere(
                                                      (v) =>
                                                          v == thisquote[4])] =
                                                  selected
                                              : 0;
                                        }

                                        context.read<addTocart>().checkbuy();
                                      },
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.4,
                                          child: Text(
                                            items[index][0].item ?? '',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 19),
                                          ),
                                        ),
                                        remains
                                            ? Text(
                                                'Remaining: ${items[index][0].remainingInt}',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.red),
                                                textAlign: TextAlign.center,
                                              )
                                            : SizedBox(),
                                      ],
                                    )
                                  ],
                                ),
                                Container(
                                  // color: Colors.black,
                                  width:
                                      MediaQuery.of(context).size.width * 0.3,
                                  child: Row(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          if (itemsquote[index][2] != 1) {
                                            setState(() {
                                              final thisquote =
                                                  itemsquote[index];
                                              thisquote.contains(thisquote[2])
                                                  ? thisquote[thisquote
                                                          .indexWhere((v) =>
                                                              v ==
                                                              thisquote[2])] =
                                                      thisquote[2] - 1
                                                  : thisquote;
                                              thisquote.contains(thisquote[1])
                                                  ? thisquote[thisquote
                                                          .indexWhere((v) =>
                                                              v ==
                                                              thisquote[1])] =
                                                      thisquote[1] -
                                                          thisquote[3]
                                                  : thisquote;
                                            });
                                          }

                                          context
                                              .read<calculatemeal>()
                                              .total2();
                                          context.read<addTocart>().checkbuy();
                                        },
                                        child: Container(
                                          height: 30,
                                          width: 30,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.black,
                                                  width: 1)),
                                          child: Icon(Icons.remove),
                                        ),
                                      ),
                                      Container(
                                        height: 30,
                                        width: 30,
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            itemsquote[index][2].toString(),
                                            style: TextStyle(
                                                fontSize: 21,
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          if (itemsquote[index][2] !=
                                              itemsquote[index][6]) {
                                            setState(() {
                                              final thisquote =
                                                  itemsquote[index];
                                              thisquote.contains(thisquote[2])
                                                  ? thisquote[thisquote
                                                          .indexWhere((v) =>
                                                              v ==
                                                              thisquote[2])] =
                                                      thisquote[2] + 1
                                                  : thisquote;
                                              thisquote.contains(thisquote[1])
                                                  ? thisquote[thisquote
                                                          .indexWhere((v) =>
                                                              v ==
                                                              thisquote[1])] =
                                                      thisquote[1] +
                                                          thisquote[3]
                                                  : thisquote;
                                            });
                                          } else {
                                            SmartDialog.showToast(
                                              "Cannot add more of this item",
                                            );
                                          }

                                          context
                                              .read<calculatemeal>()
                                              .total2();
                                          context.read<addTocart>().checkbuy();
                                        },
                                        child: Container(
                                          height: 30,
                                          width: 30,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.black,
                                                  width: 1)),
                                          child: Icon(Icons.add),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.1,
                                  child: Text(
                                    itemsquote[index][1].toString(),
                                    style: TextStyle(fontSize: 18),
                                  ),
                                )
                              ],
                            ));
                          }),
                    );
                  } else {
                    return Container();
                  }
                }),
              ),
            ),
            Consumer<calculatemeal>(builder: (context, value, child) {
              //Provider.of<calculatemeal>(context, listen: false).total();

              return Container(
                height: MediaQuery.of(context).size.height * 0.15,
                width: double.maxFinite,
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20.0))),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          height: 40,
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              'Duplicate Pack',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          height: 40,
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              'Total: ${context.watch<calculatemeal>().total()}',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  context
                                      .read<calculatemeal>()
                                      .substractdupplicate();
                                  context.read<addTocart>().checkbuy();
                                },
                                child: Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          color: Colors.white, width: 1)),
                                  child: Icon(
                                    Icons.remove,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Container(
                                height: 40,
                                width: 40,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    context
                                        .watch<calculatemeal>()
                                        .dupplicate
                                        .toString(),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 21,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  context.read<calculatemeal>().addduplicate();
                                  context.read<addTocart>().checkbuy();
                                },
                                child: Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          color: Colors.white, width: 1)),
                                  child: Icon(
                                    Icons.add,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Consumer<addTocart>(builder: (context, value, child) {
                          return InkWell(
                            onTap: () {
                              Provider.of<addTocart>(context, listen: false)
                                      .buynow
                                  ? buynow()
                                  : soupid.isNotEmpty
                                      ? checkempty()
                                          ? SmartDialog.showToast(
                                              'Select a soup')
                                          : addTocarts(value)
                                      : addTocarts(value);
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                              decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(.8),
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      bottomLeft: Radius.circular(10))),
                              height: 40,
                              child: Align(
                                alignment: Alignment.center,
                                child: context.watch<addTocart>().buynow
                                    ? Text(
                                        'Buy Now',
                                        style: TextStyle(color: Colors.white),
                                      )
                                    : context.watch<addTocart>().loading
                                        ? SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(
                                                color: Theme.of(context)
                                                    .primaryColor))
                                        : Text(
                                            'Add to Cart',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                              ),
                            ),
                          );
                        })
                      ],
                    ),
                  ],
                ),
              );
            })
          ]),
        ),
      ]),
    );
  }

  void addTocarts(value) async {
    if (value.loading != true) {
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
        await context.read<addTocart>().sendcart();
        if (value.success == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: CustomeSnackbar(
              topic: 'Great!',
              msg: value.msg1,
              color1: Color.fromARGB(255, 25, 107, 52),
              color2: Color.fromARGB(255, 19, 95, 40),
            ),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            elevation: 0,
          ));
        } else if (value.success == 'fail') {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: CustomeSnackbar(
              topic: 'Oh Snap!',
              msg: value.msg1,
              color1: Color.fromARGB(255, 171, 51, 42),
              color2: Color.fromARGB(255, 127, 39, 33),
            ),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            elevation: 0,
          ));
        }
        context.read<calculatemeal>().reset();

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
