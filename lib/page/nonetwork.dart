import 'dart:async';

import 'package:flutter/material.dart';

import 'package:foodie_ios/invisible.dart';

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
  void dispose() {
    // TODO: implement dispose

    super.dispose();
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
                    // print(hasInternet);
                    checknet(value);
                    // if (hasInternet == true) {
                    //   Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //         builder: (context) => invisible(internet: value),
                    //       ));
                    // } else {
                    //   Navigator.pushNamedAndRemoveUntil(context, '/nonetwork',
                    //       (Route<dynamic> route) => false);
                    // }
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
                                  color: Color.fromARGB(255, 211, 211, 211),
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
    print(hasInternet);
    if (hasInternet == false) {
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
  }
}
