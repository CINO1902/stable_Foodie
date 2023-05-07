import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foodie_ios/linkfile/Model/fetchpackage.dart';
import 'package:foodie_ios/linkfile/customesnackbar.dart';
import 'package:foodie_ios/linkfile/enum/connectivity_status.dart';
import 'package:foodie_ios/linkfile/provider/fetchpakage.dart';

import 'package:foodie_ios/linkfile/provider/sellectbucket.dart';

import 'package:foodie_ios/page/overlay.dart';
import 'package:foodie_ios/survey.dart/bucketsellect.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

class bucketlist3 extends StatefulWidget {
  const bucketlist3({super.key, required this.pageid});

  final int pageid;

  @override
  State<bucketlist3> createState() => _bucketlist3State();
}

class _bucketlist3State extends State<bucketlist3> {
  List<Item> Odogwu = [];
  List<Item> Drinks = [];
  List _selecteCategorys = [];
  List _selecteDrinks = [];
  List ID = [];

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

  void _onCategorySelectedDrinks(bool selected, category_id) {
    if (selected == true) {
      setState(() {
        _selecteDrinks.clear();
        _selecteDrinks.add(category_id);
      });
    } else {
      setState(() {
        _selecteDrinks.remove(category_id);
      });
    }
  }

  void _onCategorySelected2(bool selected) {
    if (selected == true) {
      setState(() {
        _selecteCategorys.clear();
        _selecteCategorys.addAll(ID);
      });
    } else {
      setState(() {
        _selecteCategorys.clear();
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<fetchprovider>().fetchprovide();
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
        appBar: AppBar(
          iconTheme: IconThemeData(color: Theme.of(context).primaryColorDark),
          centerTitle: false,
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: Text('Biggie Bucket',
              style: TextStyle(
                  color: Theme.of(context).primaryColorDark,
                  fontSize: 27,
                  fontWeight: FontWeight.bold)),
          actions: <Widget>[
            InkWell(
              onTap: () {
                if (context
                    .read<sellectbucket>()
                    .checkempty(widget.pageid, 2)) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: CustomeSnackbar(
                      topic: 'Oh Snap!',
                      msg: 'You have to sellect a package',
                      color1: Color.fromARGB(255, 171, 51, 42),
                      color2: Color.fromARGB(255, 127, 39, 33),
                    ),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                  ));
                } else {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => const page2(),
                      ),
                      (Route<dynamic> route) => false);
                  context.read<sellectbucket>().savelistfinal(2, widget.pageid);
                }
              },
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Theme.of(context).primaryColor,
                  ),
                  margin: EdgeInsets.only(right: 10),
                  height: 30,
                  width: 80,
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Next',
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
        body: Column(children: [
          Expanded(
              child: ListView(
            padding: EdgeInsets.zero,
            children: [
              questionbox(context),
              questionbox2(context),
              context.watch<fetchprovider>().loading
                  ? Container()
                  : Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: 50,
                      margin: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.2,
                        right: MediaQuery.of(context).size.width * 0.2,
                        bottom: MediaQuery.of(context).size.width * 0.1,
                      ),
                    )
            ],
          ))
        ]));
  }

  Widget questionbox(BuildContext context) {
    return Consumer<fetchprovider>(builder: (context, value, child) {
      if (value.loading == true) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.9,
          child: Align(
              alignment: Alignment.center,
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              )),
        );
      } else if (value.loading == false) {
        Odogwu = value.odogwu;
        ID.clear();
        for (var i = 0; i < Odogwu.length; i++) {
          ID.add(Odogwu[i].itemId);
        }
        Function unOrdDeepEq = const DeepCollectionEquality.unordered().equals;
        context.read<sellectbucket>().getbucket(ID, Odogwu, 2);
        return Container(
          margin: EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              color: Theme.of(context).colorScheme.primaryContainer),
          child: ListView(
              padding: EdgeInsets.only(top: 0, bottom: 20),
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: [
                Container(
                    margin: EdgeInsets.only(top: 20, right: 20, left: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Sellect package',
                          style: TextStyle(
                              fontSize: 21, fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: [
                            Text(
                              'Sellect All',
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                            widget.pageid == 0
                                ? Checkbox(
                                    activeColor: Theme.of(context).primaryColor,
                                    value: unOrdDeepEq(
                                        context.watch<sellectbucket>().allthird,
                                        context
                                            .watch<sellectbucket>()
                                            .thirdselectedid),
                                    onChanged: (bool? selecte) {
                                      context
                                          .read<sellectbucket>()
                                          .onCategorySelected2(
                                              selecte!, 2, widget.pageid);
                                    },
                                  )
                                : widget.pageid == 1
                                    ? Checkbox(
                                        activeColor:
                                            Theme.of(context).primaryColor,
                                        value: unOrdDeepEq(
                                            context
                                                .watch<sellectbucket>()
                                                .allthird,
                                            context
                                                .watch<sellectbucket>()
                                                .thirdselectedid1),
                                        onChanged: (bool? selecte) {
                                          context
                                              .read<sellectbucket>()
                                              .onCategorySelected2(
                                                  selecte!, 2, widget.pageid);
                                        },
                                      )
                                    : Checkbox(
                                        activeColor:
                                            Theme.of(context).primaryColor,
                                        value: unOrdDeepEq(
                                            context
                                                .watch<sellectbucket>()
                                                .allthird,
                                            context
                                                .watch<sellectbucket>()
                                                .thirdselectedid2),
                                        onChanged: (bool? selecte) {
                                          context
                                              .read<sellectbucket>()
                                              .onCategorySelected2(
                                                  selecte!, 2, widget.pageid);
                                        },
                                      )
                          ],
                        ),
                      ],
                    )),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: value.Sapa.length,
                  itemBuilder: (context, index) {
                    List<Extra>? packageinclude = Odogwu[index].extras;
                    String? image = Odogwu[index].image;
                    return InkWell(
                      onTap: () {
                        modalpopup(context, packageinclude, image);
                      },
                      child: Container(
                        height: 60,
                        width: double.infinity,
                        margin: EdgeInsets.only(top: 20, right: 20, left: 20),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: Colors.black.withOpacity(.5), width: 2)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  margin: EdgeInsets.only(left: 20),
                                  child: Text(
                                    '${Odogwu[index].packageName}',
                                    style: TextStyle(fontSize: 17),
                                  ),
                                )),
                            widget.pageid == 0
                                ? Checkbox(
                                    activeColor: Theme.of(context).primaryColor,
                                    value: context
                                        .watch<sellectbucket>()
                                        .thirdselectedid
                                        .contains(Odogwu[index].itemId),
                                    onChanged: (bool? selected) {
                                      context
                                          .read<sellectbucket>()
                                          .onCategorySelected(
                                              selected!,
                                              Odogwu[index].itemId,
                                              2,
                                              widget.pageid);
                                    },
                                  )
                                : widget.pageid == 1
                                    ? Checkbox(
                                        activeColor:
                                            Theme.of(context).primaryColor,
                                        value: context
                                            .watch<sellectbucket>()
                                            .thirdselectedid1
                                            .contains(Odogwu[index].itemId),
                                        onChanged: (bool? selected) {
                                          context
                                              .read<sellectbucket>()
                                              .onCategorySelected(
                                                  selected!,
                                                  Odogwu[index].itemId,
                                                  2,
                                                  widget.pageid);
                                        },
                                      )
                                    : Checkbox(
                                        activeColor:
                                            Theme.of(context).primaryColor,
                                        value: context
                                            .watch<sellectbucket>()
                                            .thirdselectedid2
                                            .contains(Odogwu[index].itemId),
                                        onChanged: (bool? selected) {
                                          context
                                              .read<sellectbucket>()
                                              .onCategorySelected(
                                                  selected!,
                                                  Odogwu[index].itemId,
                                                  2,
                                                  widget.pageid);
                                        },
                                      )
                          ],
                        ),
                      ),
                    );
                  },
                )
              ]),
        );
      } else {
        return Container();
      }
    });
  }

  Widget questionbox2(BuildContext context) {
    return Consumer<fetchprovider>(builder: (context, value, child) {
      if (value.loading == true) {
        return Container();
      } else if (value.loading == false) {
        Drinks = value.drinks;
        return Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              color: Theme.of(context).colorScheme.primaryContainer),
          child: ListView(
              padding: EdgeInsets.only(top: 0, bottom: 20),
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: [
                Container(
                    margin: EdgeInsets.only(top: 20, right: 20, left: 20),
                    child: Text(
                      'Sellect Drinks',
                      style:
                          TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                    )),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: value.drinks.length,
                  itemBuilder: (context, index) {
                    List<Extra>? packageinclude = Drinks[index].extras;
                    String? image = Drinks[index].image;
                    return InkWell(
                      onTap: () {
                        modalpopup(context, packageinclude, image);
                      },
                      child: Container(
                        height: 60,
                        width: double.infinity,
                        margin: EdgeInsets.only(top: 20, right: 20, left: 20),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: Colors.black.withOpacity(.5), width: 2)),
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              margin: EdgeInsets.only(left: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${Drinks[index].packageName}',
                                    style: TextStyle(fontSize: 17),
                                  ),
                                  widget.pageid == 0
                                      ? Checkbox(
                                          activeColor:
                                              Theme.of(context).primaryColor,
                                          value: context
                                              .watch<sellectbucket>()
                                              .thirddrinkid
                                              .contains(Drinks[index].itemId),
                                          onChanged: (bool? selected) {
                                            context
                                                .read<sellectbucket>()
                                                .onCategorySelectedDrinks(
                                                    selected!,
                                                    Drinks[index].itemId,
                                                    2,
                                                    widget.pageid);
                                          },
                                        )
                                      : widget.pageid == 1
                                          ? Checkbox(
                                              activeColor: Theme.of(context)
                                                  .primaryColor,
                                              value: context
                                                  .watch<sellectbucket>()
                                                  .thirddrinkid1
                                                  .contains(
                                                      Drinks[index].itemId),
                                              onChanged: (bool? selected) {
                                                context
                                                    .read<sellectbucket>()
                                                    .onCategorySelectedDrinks(
                                                        selected!,
                                                        Drinks[index].itemId,
                                                        2,
                                                        widget.pageid);
                                              },
                                            )
                                          : Checkbox(
                                              activeColor: Theme.of(context)
                                                  .primaryColor,
                                              value: context
                                                  .watch<sellectbucket>()
                                                  .thirddrinkid2
                                                  .contains(
                                                      Drinks[index].itemId),
                                              onChanged: (bool? selected) {
                                                context
                                                    .read<sellectbucket>()
                                                    .onCategorySelectedDrinks(
                                                        selected!,
                                                        Drinks[index].itemId,
                                                        2,
                                                        widget.pageid);
                                              },
                                            )
                                ],
                              ),
                            )),
                      ),
                    );
                  },
                )
              ]),
        );
      } else {
        return Container();
      }
    });
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
}
