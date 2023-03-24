import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

import 'package:flutter_svg/svg.dart';
import 'package:foodie_ios/linkfile/enum/connectivity_status.dart';
import 'package:foodie_ios/linkfile/provider/internetchecker.dart';
import 'package:foodie_ios/linkfile/provider/themeprovider.dart';
import 'package:foodie_ios/page/overlay.dart';
import 'package:provider/provider.dart';

class themepage extends StatefulWidget {
  const themepage({super.key});

  @override
  State<themepage> createState() => _themepageState();
}

bool network = false;

class _themepageState extends State<themepage> {
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
            'Theme',
            style: TextStyle(
                color: Theme.of(context).primaryColorDark,
                fontSize: 27,
                fontWeight: FontWeight.bold),
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.all(10),
              child: Text(
                'Appearance',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 180,
                        width: 100,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          color: Colors.white,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                "images/logo.png",
                                height:
                                    MediaQuery.of(context).size.width * 0.13,
                                width: MediaQuery.of(context).size.width * 0.13,
                              )
                            ],
                          ),
                        ),
                      ),
                      Radio(
                        value: 1,
                        groupValue: context.watch<Themeprovider>().group,
                        onChanged: (int? value) {
                          context.read<Themeprovider>().changetheme(value);
                        },
                      ),
                      Text('Light'),
                    ],
                  ),
                ),
                Container(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 180,
                        width: 100,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          color: Colors.black,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                "images/logo.png",
                                height:
                                    MediaQuery.of(context).size.width * 0.13,
                                width: MediaQuery.of(context).size.width * 0.13,
                              )
                            ],
                          ),
                        ),
                      ),
                      Radio(
                        value: 2,
                        groupValue: context.watch<Themeprovider>().group,
                        onChanged: (int? value) {
                          context.read<Themeprovider>().changetheme(value);
                        },
                      ),
                      Text('Dark')
                    ],
                  ),
                )
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              margin: EdgeInsets.all(20),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Use Device Settings',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        height: 80,
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: Text(
                          "Match appearance to your device's Display & Brightness settings",
                          softWrap: true,
                          style: TextStyle(fontSize: 16),
                        ),
                      )
                    ],
                  ),
                  buildSwitch(),
                ],
              ),
            )
          ],
        ));
  }

  Widget buildSwitch() => Switch.adaptive(
      value: context.watch<Themeprovider>().togg,
      onChanged: (value) {
        context.read<Themeprovider>().changetogg(value);
      });
}
