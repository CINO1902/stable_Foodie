import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:foodie_ios/invisible.dart';
import 'package:foodie_ios/linkfile/provider/internetchecker.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class nonetwork extends StatefulWidget {
  const nonetwork({super.key});

  @override
  State<nonetwork> createState() => _nonetworkState();
}

bool loading = true;
bool hasInternet = false;

class _nonetworkState extends State<nonetwork> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            "images/10_Connection.png",
            fit: BoxFit.cover,
            width: double.infinity,
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.15,
            left: MediaQuery.of(context).size.width * 0.3,
            right: MediaQuery.of(context).size.width * 0.3,
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 5),
                    blurRadius: 25,
                    color: Colors.black.withOpacity(0.17),
                  ),
                ],
              ),
              child: InkWell(
                onTap: () async {
                  final pref = await SharedPreferences.getInstance();
                  final value = pref.getBool('showhomeprovider') ?? true;
                  setState(() {
                    loading = true;
                  });
                  Future.delayed(const Duration(milliseconds: 4000), () {
// Here you can write your code
                    print(hasInternet);
                    if (hasInternet == true) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => invisible(internet: value),
                          ));
                    } else {
                      Navigator.pushNamed(context, '/nonetwork');
                    }
                  });
                },
                child: Container(
                  height: 40,
                  width: 80,
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(50)),
                  child: Align(
                      alignment: Alignment.center,
                      child: loading
                          ? SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              "Retry",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 63, 63, 63),
                                  fontSize: 18),
                            )),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void checknet(value) {
    InternetConnectionChecker().onStatusChange.listen((event) {
      final hasInternet1 = event == InternetConnectionStatus.connected;
      if (hasInternet1 == false) {
        Navigator.pushNamedAndRemoveUntil(
            context, '/nonetwork', (Route<dynamic> route) => false);
      } else {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => invisible(internet: value),
            ),
            (Route<dynamic> route) => false);
      }
    });
  }
}
