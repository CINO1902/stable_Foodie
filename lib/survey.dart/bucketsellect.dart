import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:foodie_ios/linkfile/customesnackbar.dart';
import 'package:foodie_ios/linkfile/enum/connectivity_status.dart';
import 'package:foodie_ios/linkfile/provider/getsubdetails.dart';
import 'package:foodie_ios/linkfile/provider/internetchecker.dart';
import 'package:foodie_ios/linkfile/provider/sellectbucket.dart';
import 'package:foodie_ios/linkfile/provider/subscribed.dart';
import 'package:foodie_ios/page/landingpage.dart';
import 'package:foodie_ios/page/overlay.dart';
import 'package:foodie_ios/survey.dart/bucketlist1.dart';
import 'package:foodie_ios/survey.dart/bucketlist2.dart';
import 'package:foodie_ios/survey.dart/bucketlist3.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

class page2 extends StatefulWidget {
  const page2({super.key});

  @override
  State<page2> createState() => _page2State();
}

class _page2State extends State<page2> {
  String topic = 'Sellect your bucket';
  String topic2 = 'Sellect Your';
  String join = 'bucket';

  List question = [
    'Bucket List Sapa',
    'Bucket List Long Throat',
    'Bucket List Odogwu'
  ];
  List sellectpath = [];
  bool sellect = false;
  List selllect = [];

  void _onCategorySelected(category_id, idex) {
    if (category_id == 0) {
      // context.read<sellectbucket>().clearlist();
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => bucketlist1(pageid: idex)));
    } else if (category_id == 1) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => bucketlist2(pageid: idex)));
    } else if (category_id == 2) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => bucketlist3(pageid: idex)));
    }
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();
    //context.read<sellectbucket>().clearlist();
  }

  bool success = false;
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
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('Quick question'),
        actions: <Widget>[
          InkWell(
            onTap: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => const homelanding(),
                  ),
                  (Route<dynamic> route) => false);
              context.read<sellectbucket>().clearlist();
            },
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black,
                ),
                margin: EdgeInsets.only(right: 0),
                height: 30,
                width: 100,
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Back To Home',
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
          child: context.watch<getsubdetail>().oneday
              ? ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    questionbox(context, question, sellectpath, 0),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      width: MediaQuery.of(context).size.width * 2,
                      height: 50,
                      child: Consumer<sellectbucket>(
                          builder: (context, value, child) {
                        return ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                            ),
                            onPressed: () async {
                              context.read<sellectbucket>().getsellected();
                              if (context
                                      .read<sellectbucket>()
                                      .checkbucket(0, 1, 2, 0, 5, 5) ==
                                  true) {
                                SmartDialog.showLoading();
                                if (Provider.of<subscribed>(context,
                                            listen: false)
                                        .upgradeclick ==
                                    true) {
                                  await context
                                      .read<sellectbucket>()
                                      .checkupgrade();
                                } else if (Provider.of<subscribed>(context,
                                            listen: false)
                                        .rolloverclick ==
                                    true) {
                                  await context
                                      .read<sellectbucket>()
                                      .rollovercalculateammount();
                                } else {
                                  await context
                                      .read<sellectbucket>()
                                      .calculateammount();
                                }
                                if (value.success == true) {
                                  SmartDialog.dismiss();
                                  Navigator.pushNamed(context, '/checkout');
                                } else if (value.error == true) {
                                  SmartDialog.dismiss();
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: CustomeSnackbar(
                                      topic: 'Oh Snap!',
                                      msg: 'Something went wrong',
                                      color1: Color.fromARGB(255, 171, 51, 42),
                                      color2: Color.fromARGB(255, 127, 39, 33),
                                    ),
                                    behavior: SnackBarBehavior.floating,
                                    backgroundColor: Colors.transparent,
                                    elevation: 0,
                                  ));
                                } else if (value.success == false) {
                                  SmartDialog.dismiss();
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
                                }
                              } else {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: CustomeSnackbar(
                                    topic: 'Oh Snap!',
                                    msg: 'You have to sellect a packages',
                                    color1: Color.fromARGB(255, 171, 51, 42),
                                    color2: Color.fromARGB(255, 127, 39, 33),
                                  ),
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: Colors.transparent,
                                  elevation: 0,
                                ));
                              }
                            },
                            child: Text('Next'));
                      }),
                    ),
                  ],
                )
              : context.watch<getsubdetail>().twoday
                  ? ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        questionbox(context, question, sellectpath, 0),
                        questionbox(context, question, sellectpath, 1),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          width: MediaQuery.of(context).size.width * 2,
                          height: 50,
                          child: Consumer<sellectbucket>(
                              builder: (context, value, child) {
                            return ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  ),
                                ),
                                onPressed: () async {
                                  context.read<sellectbucket>().getsellected();
                                  if (context
                                          .read<sellectbucket>()
                                          .checkbucket(0, 1, 2, 0, 1, 5) ==
                                      true) {
                                    SmartDialog.showLoading();
                                    if (Provider.of<subscribed>(context,
                                                listen: false)
                                            .upgradeclick ==
                                        true) {
                                      await context
                                          .read<sellectbucket>()
                                          .checkupgrade();
                                    } else if (Provider.of<subscribed>(context,
                                                listen: false)
                                            .rolloverclick ==
                                        true) {
                                      print('hey');
                                      await context
                                          .read<sellectbucket>()
                                          .rollovercalculateammount();
                                    } else {
                                      await context
                                          .read<sellectbucket>()
                                          .calculateammount();
                                    }

                                    if (value.success == true) {
                                      SmartDialog.dismiss();
                                      Navigator.pushNamed(context, '/checkout');
                                    } else if (value.error == true) {
                                      SmartDialog.dismiss();
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: CustomeSnackbar(
                                          topic: 'Oh Snap!',
                                          msg: 'Something went wrong',
                                          color1:
                                              Color.fromARGB(255, 171, 51, 42),
                                          color2:
                                              Color.fromARGB(255, 127, 39, 33),
                                        ),
                                        behavior: SnackBarBehavior.floating,
                                        backgroundColor: Colors.transparent,
                                        elevation: 0,
                                      ));
                                    } else if (value.success == false) {
                                      SmartDialog.dismiss();
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: CustomeSnackbar(
                                          topic: 'Oh Snap!',
                                          msg: value.msg,
                                          color1:
                                              Color.fromARGB(255, 171, 51, 42),
                                          color2:
                                              Color.fromARGB(255, 127, 39, 33),
                                        ),
                                        behavior: SnackBarBehavior.floating,
                                        backgroundColor: Colors.transparent,
                                        elevation: 0,
                                      ));
                                    }
                                  } else {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: CustomeSnackbar(
                                        topic: 'Oh Snap!',
                                        msg: 'You have to sellect all package',
                                        color1:
                                            Color.fromARGB(255, 171, 51, 42),
                                        color2:
                                            Color.fromARGB(255, 127, 39, 33),
                                      ),
                                      behavior: SnackBarBehavior.floating,
                                      backgroundColor: Colors.transparent,
                                      elevation: 0,
                                    ));
                                  }
                                },
                                child: Text('Next'));
                          }),
                        ),
                      ],
                    )
                  : context.watch<getsubdetail>().threeday
                      ? ListView(
                          padding: EdgeInsets.zero,
                          children: [
                            questionbox(context, question, sellectpath, 0),
                            questionbox(context, question, sellectpath, 1),
                            questionbox(context, question, sellectpath, 2),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 20),
                              width: MediaQuery.of(context).size.width * 2,
                              height: 50,
                              child: Consumer<sellectbucket>(
                                  builder: (context, value, child) {
                                return ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Theme.of(context).primaryColor,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                      ),
                                    ),
                                    onPressed: () async {
                                      context
                                          .read<sellectbucket>()
                                          .getsellected();
                                      if (context
                                              .read<sellectbucket>()
                                              .checkbucket(0, 1, 2, 0, 1, 2) ==
                                          true) {
                                        SmartDialog.showLoading();
                                        if (Provider.of<subscribed>(context,
                                                    listen: false)
                                                .upgradeclick ==
                                            true) {
                                          await context
                                              .read<sellectbucket>()
                                              .checkupgrade();
                                        } else if (Provider.of<subscribed>(
                                                    context,
                                                    listen: false)
                                                .rolloverclick ==
                                            true) {
                                          print('hey');
                                          await context
                                              .read<sellectbucket>()
                                              .rollovercalculateammount();
                                        } else {
                                          await context
                                              .read<sellectbucket>()
                                              .calculateammount();
                                        }

                                        if (value.success == true) {
                                          SmartDialog.dismiss();
                                          Navigator.pushNamed(
                                              context, '/checkout');
                                        } else if (value.error == true) {
                                          SmartDialog.dismiss();
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            content: CustomeSnackbar(
                                              topic: 'Oh Snap!',
                                              msg: 'Something went wrong',
                                              color1: Color.fromARGB(
                                                  255, 171, 51, 42),
                                              color2: Color.fromARGB(
                                                  255, 127, 39, 33),
                                            ),
                                            behavior: SnackBarBehavior.floating,
                                            backgroundColor: Colors.transparent,
                                            elevation: 0,
                                          ));
                                        } else if (value.success == false) {
                                          SmartDialog.dismiss();
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            content: CustomeSnackbar(
                                              topic: 'Oh Snap!',
                                              msg: value.msg,
                                              color1: Color.fromARGB(
                                                  255, 171, 51, 42),
                                              color2: Color.fromARGB(
                                                  255, 127, 39, 33),
                                            ),
                                            behavior: SnackBarBehavior.floating,
                                            backgroundColor: Colors.transparent,
                                            elevation: 0,
                                          ));
                                        }
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: CustomeSnackbar(
                                            topic: 'Oh Snap!',
                                            msg:
                                                'You have to sellect all package',
                                            color1: Color.fromARGB(
                                                255, 171, 51, 42),
                                            color2: Color.fromARGB(
                                                255, 127, 39, 33),
                                          ),
                                          behavior: SnackBarBehavior.floating,
                                          backgroundColor: Colors.transparent,
                                          elevation: 0,
                                        ));
                                      }
                                    },
                                    child: const Text('Next'));
                              }),
                            ),
                          ],
                        )
                      : Container(),
        ),
      ]),
    );
  }

  Widget questionbox(
      BuildContext context, List question, List sellectpath, int idex) {
    return Consumer<getsubdetail>(builder: (context, value, child) {
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
                  child: value.oneday
                      ? Text(
                          topic,
                          style: TextStyle(
                              fontSize: 21, fontWeight: FontWeight.bold),
                        )
                      : Text(
                          topic2 + ' ' + value.join[idex] + ' ' + join,
                          style: TextStyle(
                              fontSize: 21, fontWeight: FontWeight.bold),
                        )),
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: question.length,
                itemBuilder: (context, index) {
                  Function unOrdDeepEq =
                      const DeepCollectionEquality.unordered().equals;
                  return InkWell(
                      onTap: () {
                        _onCategorySelected(index, idex);
                      },
                      child: context
                              .watch<sellectbucket>()
                              .index1[idex]
                              .contains(index)
                          ? Container(
                              height: 60,
                              width: double.infinity,
                              margin:
                                  EdgeInsets.only(top: 20, right: 20, left: 20),
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
                              margin:
                                  EdgeInsets.only(top: 20, right: 20, left: 20),
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
                            ));
                },
              ),
            ]),
      );
    });
  }
}
