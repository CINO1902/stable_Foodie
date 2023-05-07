import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:foodie_ios/linkfile/customesnackbar.dart';
import 'package:foodie_ios/linkfile/enum/connectivity_status.dart';
import 'package:foodie_ios/linkfile/provider/getsubdetails.dart';

import 'package:foodie_ios/linkfile/provider/sellectbucket.dart';
import 'package:foodie_ios/page/overlay.dart';


import 'package:provider/provider.dart';

class frequency extends StatefulWidget {
  const frequency({super.key});

  @override
  State<frequency> createState() => _frequencyState();
}

class _frequencyState extends State<frequency> {
  List frequency = ['Once a Day', 'Twice a Day', 'Three times a Day'];
  List food = [
    'Rice(Fried Rice, Jollof Rice or White Rice)',
    'Pasta',
    'Noodles',
    'Swallow',
    'Yam'
  ];
  List sellectfood = [];
  List sellectfoodstring = [];
  List sellectfrequency = [];
  bool selected = false;
  int catergoryfood = 1;
  int categoryfrequency = 0;
  bool hasInternet = false;
  bool network = false;
  late StreamSubscription subscription;
  void _onCategorySelected(bool selected, category_id, category) {
    if (category == 0) {
      if (selected == true) {
        setState(() {
          sellectfrequency.clear();
          sellectfrequency.add(category_id);
        });
      } else {
        setState(() {
          sellectfrequency.remove(category_id);
        });
      }
    }
    if (category == 1) {
      if (selected == true) {
        if (sellectfood.length < 2) {
          setState(() {
            sellectfood.add(category_id);
            sellectfoodstring.add(food[category_id]);
          });
        } else {
          print(sellectfrequency.length);
          setState(() {
            sellectfood.removeAt(0);
            sellectfoodstring.removeAt(0);
            sellectfood.add(category_id);
            sellectfoodstring.add(food[category_id]);
          });
        }
      } else {
        setState(() {
          sellectfood.remove(category_id);
        });
      }
    }
  }

  String topic = 'How many times a Day would you like to recieve a meal';
  String topic2 =
      'What meal do you enjoy the most(You can sellect two options)';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<sellectbucket>().clearlist();
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
        iconTheme: IconThemeData(color: Theme.of(context).primaryColorDark),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          'Quick question',
          style: TextStyle(
              color: Theme.of(context).primaryColorDark,
              fontSize: 27,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          questionbox(
            context,
            topic,
            frequency,
            selected,
            categoryfrequency,
            sellectfrequency,
          ),
          SizedBox(
            height: 20,
          ),
          questionbox(
              context, topic2, food, selected, catergoryfood, sellectfood),
          SizedBox(
            height: 20,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            width: MediaQuery.of(context).size.width * 2,
            height: 50,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                onPressed: () async {
                  if (sellectfood.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: CustomeSnackbar(
                        topic: 'Oh Snap!',
                        msg: 'Please Answer Both question',
                        color1: Color.fromARGB(255, 171, 51, 42),
                        color2: Color.fromARGB(255, 127, 39, 33),
                      ),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                    ));
                  } else if (sellectfrequency.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: CustomeSnackbar(
                        topic: 'Oh Snap!',
                        msg: 'Please Answer Both question',
                        color1: Color.fromARGB(255, 171, 51, 42),
                        color2: Color.fromARGB(255, 127, 39, 33),
                      ),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                    ));
                  } else {
                    context
                        .read<sellectbucket>()
                        .getfrequency(sellectfrequency[0]);
                    context.read<getsubdetail>().getdetails(
                        sellectfrequency[0].toString(),
                        sellectfoodstring,
                        sellectfood);
                    Navigator.pushNamed(context, '/page2');
                  }
                },
                child: const Text('Next')),
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  Widget questionbox(BuildContext context, topic, List question, sellect,
      categoryint, List sellectpath) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        image: DecorationImage(
          fit: BoxFit.cover,
          image: Svg('images/svg/Pattern-7.svg', size: Size(400, 200)),
          colorFilter: ColorFilter.mode(
            Theme.of(context).primaryColorLight,
            BlendMode.difference,
          ),
        ),
      ),
      child: ListView(
          padding: EdgeInsets.only(top: 0, bottom: 20),
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          children: [
            Container(
              margin: EdgeInsets.only(top: 20, right: 20, left: 20),
              child: Text(
                topic,
                style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
              ),
            ),
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemCount: question.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      sellect = true;
                    });

                    _onCategorySelected(sellect, index, categoryint);
                  },
                  child: sellectpath.contains(index)
                      ? Container(
                          height: 60,
                          width: double.infinity,
                          margin: EdgeInsets.only(top: 20, right: 20, left: 20),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(.7),
                              border: Border.all(
                                  color: Colors.black.withOpacity(.5),
                                  width: 2)),
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                margin: EdgeInsets.only(left: 20),
                                child: Text(
                                  question[index],
                                  style: TextStyle(fontSize: 17),
                                ),
                              )),
                        )
                      : Container(
                          height: 60,
                          width: double.infinity,
                          margin: EdgeInsets.only(top: 20, right: 20, left: 20),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: Colors.black.withOpacity(.5),
                                  width: 2)),
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                margin: EdgeInsets.only(left: 20),
                                child: Text(
                                  question[index],
                                  style: TextStyle(fontSize: 17),
                                ),
                              )),
                        ),
                );
              },
            )
          ]),
    );
  }
}
