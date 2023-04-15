import 'dart:async';

import 'package:flutter/material.dart';

class subcription2 extends StatefulWidget {
  const subcription2({super.key});

  @override
  State<subcription2> createState() => _subcription2State();
}

class _subcription2State extends State<subcription2> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    runcode();
  }

  double containtop = 100.0;
  double secondcontaintop = 20;
  changemargin() {
    setState(() {
      containtop = 30;
      secondcontaintop = 0;
    });
  }

  Timer? t;
  runcode() {
    t = Timer(Duration(milliseconds: 20), () {
      changemargin();
    });
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
      body: Align(
        alignment: Alignment.center,
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Container(
            margin: EdgeInsets.only(top: 60),
            height: 200,
            width: 200,
            child: Image.asset('images/subscription-model.png',
                color: Theme.of(context).primaryColorDark),
          ),
          AnimatedContainer(
            duration: Duration(milliseconds: 800),
            margin: EdgeInsets.only(top: containtop),
            child: Text(
              'Subscription is coming soon',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          AnimatedContainer(
            duration: Duration(milliseconds: 900),
            margin: EdgeInsets.only(top: secondcontaintop),
            child: Text(
              'We would let you know when it is ready',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
            ),
          )
        ]),
      ),
    );
  }
}
