import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:foodie_ios/linkfile/customesnackbar.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:foodie_ios/linkfile/networkhandler.dart';
import 'linkfile/provider/onboarding.dart';

class onBoarding extends StatefulWidget {
  const onBoarding({Key? key}) : super(key: key);

  @override
  State<onBoarding> createState() => _onBoardingState();
}

class _onBoardingState extends State<onBoarding> {
  final _controller = PageController();
  bool islastPage = false;
  bool loading = false;
  String msg = '';
  String status = '';
  String token = '';
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> createtoken() async {
    try {
      setState(() {
        loading = true;
      });
      var response = await networkHandler.client
          .post(networkHandler.builderUrl('/createunregistered'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      });

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        setState(() {
          msg = data['msg'];
          status = data['status'];
          token = data['token'];
        });
      }
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height * 0.15,
            ),
            child: PageView(
              controller: _controller,
              onPageChanged: (index) {
                setState(() {
                  islastPage = index == 2;
                });
              },
              children: const [
                buildPage2(
                  title: "EAT MORE AND SAVE MORE",
                  getImage: "images/logo.png",
                  subText:
                      "With our subscription plan, foodie gives you the opportunity to eat enough without spending much",
                ),
                buildPage2(
                  title: "MANAGE & ARRANGE HOW YOU EAT",
                  getImage: "images/logo.png",
                  subText:
                      "Foodie gives vairiety options of foods that will be best for your health",
                ),
                buildPage2(
                  title: "MANAGE YOUR NOTIFICATION",
                  getImage: "images/logo.png",
                  subText:
                      "Allow foodie send you notification so you can see incoming messages.",
                ),
              ],
            ),
          ),
        ),
      ),
      bottomSheet: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        height: MediaQuery.of(context).size.height * 0.25,
        child: Container(
          //color: Colors.red,
          margin: EdgeInsets.only(
            bottom: 40,
            left: MediaQuery.of(context).size.width * 0.15,
            right: MediaQuery.of(context).size.width * 0.15,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                child: SmoothPageIndicator(
                  controller: _controller,
                  count: 3,
                  onDotClicked: (index) => _controller.animateToPage(index,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut),
                  effect: CustomizableEffect(
                    activeDotDecoration: DotDecoration(
                      width: 23,
                      height: 12,
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    dotDecoration: DotDecoration(
                      width: 10,
                      height: 10,
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    spacing: 8.0,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () => _controller.jumpToPage(2),
                    child: Text(
                      "Skip",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  islastPage
                      ? ElevatedButton(
                          onPressed: () async {
                            performmagic();
                          },
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              backgroundColor: Theme.of(context).primaryColor),
                          child: loading
                              ? SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Theme.of(context).primaryColor,
                                    backgroundColor: Colors.white,
                                  ))
                              : const Text("Get Started"),
                        )
                      : ElevatedButton(
                          onPressed: () {
                            _controller.nextPage(
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeInOut);
                          },
                          child: Icon(Icons.arrow_forward_ios),
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              backgroundColor: Theme.of(context).primaryColor),
                        ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void performmagic() async {
    await createtoken();
    if (status == 'fail') {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: CustomeSnackbar(
          topic: 'Oh Snap!',
          msg: msg,
          color1: Color.fromARGB(255, 171, 51, 42),
          color2: Color.fromARGB(255, 127, 39, 33),
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ));
    } else if (status == 'success') {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: CustomeSnackbar(
          topic: 'Great!',
          msg: msg,
          color1: Color.fromARGB(255, 25, 107, 52),
          color2: Color.fromARGB(255, 19, 95, 40),
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ));
      context.read<checkstate>().gethome(token);
      Navigator.pushNamed(context, '/landingpage');
    }
  }
}

class buildPage2 extends StatelessWidget {
  const buildPage2({
    Key? key,
    required this.title,
    required this.subText,
    required this.getImage,
  }) : super(key: key);

  final String title;
  final String subText;
  final String getImage;

  @override
  Widget build(BuildContext context) {
    return Container(
      //color: Colors.black,
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.3,
            child: Center(
              child: Stack(
                children: [
                  Center(
                    child: Container(
                      // margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.05,),
                      height: MediaQuery.of(context).size.height * 0.20,
                      width: MediaQuery.of(context).size.height * 0.6,
                      //color: Colors.blue,
                      child: Image.asset(
                        getImage,

                        //height: MediaQuery.of(context).size.height * 0.25,
                        //width: MediaQuery.of(context).size.width * 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.65,
            height: MediaQuery.of(context).size.height * 0.05,
            child: FittedBox(
              child: Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
          ),
          Container(
            //color: Colors.black,
            width: MediaQuery.of(context).size.width * 1.5,
            height: MediaQuery.of(context).size.height * 0.17,
            margin: EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              subText,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          //SizedBox(height: 40,),
        ],
      ),
    );
  }
}
