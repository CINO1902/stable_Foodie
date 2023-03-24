import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_svg/flutter_svg.dart';

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

class Reviewspecial extends StatefulWidget {
  const Reviewspecial({
    super.key,
  });

  @override
  State<Reviewspecial> createState() => _ReviewspecialState();
}

class _ReviewspecialState extends State<Reviewspecial> {
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
  void addsoup(id) {}

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
                          border: Border.all(color: Colors.black, width: 1)),
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
                            Provider.of<calculatemeal>(context, listen: false)
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
                          border: Border.all(color: Colors.black, width: 1)),
                      child: Icon(Icons.add, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Big Boys Pack',
                        style: TextStyle(
                            fontSize: 19, fontWeight: FontWeight.bold),
                      ),
                      Text('₦ 5,700',
                          style: TextStyle(
                              fontSize: 19, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    child: Text(
                        'Saalaria Crumbs has chicken broth, coconut milk, lime, lettuce, tomataoes, seasame seeds.Get your taste buds clucking with our juicy and flavorful chicken! Order now and experience the ultimate poultry indulgence on your doorstep. Satisfaction guaranteed!',
                        style: TextStyle(fontSize: 17)),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      SvgPicture.asset('images/svg/Vector-9.svg'),
                      SizedBox(
                        width: 10,
                      ),
                      Text('7-10 minutes')
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                  ),
                  Container(
                    height: 50,
                    width: 170,
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(25)),
                    child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Add To Cart',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        )),
                  )
                ],
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
