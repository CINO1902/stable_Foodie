import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:foodie_ios/linkfile/Model/cartrecieve.dart';
import 'package:foodie_ios/linkfile/Model/fetchcart.dart';
import 'package:foodie_ios/linkfile/cartbox.dart';
import 'package:foodie_ios/linkfile/customesnackbar.dart';
import 'package:foodie_ios/linkfile/enum/connectivity_status.dart';
import 'package:foodie_ios/linkfile/payment/paystack_payment.dart';
import 'package:foodie_ios/linkfile/provider/checkcart.dart';
import 'package:foodie_ios/linkfile/provider/confirmcart.dart';
import 'package:foodie_ios/linkfile/provider/greetings.dart';
import 'package:foodie_ios/linkfile/provider/internetchecker.dart';
import 'package:foodie_ios/linkfile/provider/onboarding.dart';
import 'package:foodie_ios/page/addnewaddress.dart';
import 'package:foodie_ios/page/webpage.dart';
import 'package:foodie_ios/linkfile/networkhandler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart' as Svg;
import 'overlay.dart';

class confirmorder extends StatefulWidget {
  const confirmorder({super.key});

  @override
  State<confirmorder> createState() => _confirmorderState();
}

class _confirmorderState extends State<confirmorder> {
  String code = '';
  String? token;
  bool hasInternet = false;

  late StreamSubscription subscription;

  bool network = false;

  checkregistered() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      token = prefs.getString("tokenregistered");
    });
    print(token);
  }

  collectdetails() {
    String addressget() {
      String add = '';
      token != null
          ? Provider.of<checkcart>(context, listen: false).usedefault
              ? add = context.watch<checkstate>().address
              : add = context.watch<checkcart>().address
          : Provider.of<checkcart>(context, listen: false).usedefault
              ? add = '${context.watch<checkstate>().notloggedaddress}'
              : add = context.watch<checkcart>().address;
      return add;
    }

    String number() {
      String add = '';
      token != null
          ? Provider.of<checkcart>(context, listen: false).usedefault
              ? add = context.watch<checkstate>().phone
              : add = context.watch<checkcart>().number
          : Provider.of<checkcart>(context, listen: false).usedefault
              ? add = '${context.watch<checkstate>().notloggednumber ?? ''}'
              : add = context.watch<checkcart>().number;
      return add;
    }

    String name() {
      String add = '';
      token != null
          ? Provider.of<checkcart>(context, listen: false).usedefault
              ? add =
                  '${context.watch<checkstate>().firstname} ${context.watch<checkstate>().lastname}'
              : add = context.watch<checkcart>().fullname
          : Provider.of<checkcart>(context, listen: false).usedefault
              ? add = '${context.watch<checkstate>().notloggedname}'
              : add = context.watch<checkcart>().fullname;
      return add;
    }

    String getlocation() {
      String add = '';
      token != null
          ? Provider.of<checkcart>(context, listen: false).usedefault
              ? add = context.watch<checkstate>().location
              : add = context.watch<checkcart>().location
          : Provider.of<checkcart>(context, listen: false).usedefault
              ? add = '${context.watch<checkstate>().notloggedlocation ?? ''}'
              : add = context.watch<checkcart>().location;
      return add;
    }

    Provider.of<confirmcart>(context, listen: false)
        .collect(name(), number(), addressget(), getlocation());
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    checkregistered();

    context.read<checkcart>().locationa();
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();
    context.read<checkcart>().disposediscount();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    collectdetails();
  }

  bool loading = false;

  String success = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).primaryColorDark),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          'Order Confirmation',
          style: TextStyle(
              color: Theme.of(context).primaryColorDark,
              fontSize: 27,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10, top: 8),
            child: ListView(children: [
              InkWell(
                onTap: () {
                  context.read<checkstate>().notloggedemail == null &&
                          context.read<checkstate>().email == ''
                      ? Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => addAddress(
                                    save: true,
                                  )))
                      : Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => addAddress(
                                    save: false,
                                  )));

                  context.read<checkcart>().disposediscount();
                },
                child: Container(
                  padding: const EdgeInsets.all(7),
                  height: MediaQuery.of(context).size.height * 0.19,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: Svg.Svg('images/svg/Pattern-7.svg',
                          size: Size(400, 200)),
                      colorFilter: ColorFilter.mode(
                        Theme.of(context).primaryColorLight,
                        BlendMode.difference,
                      ),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.location_on,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        child: Expanded(
                            child: context.watch<checkstate>().notloggedname ==
                                        '' &&
                                    token == null
                                ? Center(
                                    child: Text(
                                    'Click to add Location',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ))
                                : ListView(
                                    shrinkWrap: true,
                                    children: [
                                      Text(
                                        token != null
                                            ? Provider.of<checkcart>(context,
                                                        listen: false)
                                                    .usedefault
                                                ? '${context.watch<checkstate>().firstname} ${context.watch<checkstate>().lastname}'
                                                : context
                                                    .watch<checkcart>()
                                                    .fullname
                                            : Provider.of<checkcart>(context,
                                                        listen: false)
                                                    .usedefault
                                                ? '${context.watch<checkstate>().notloggedname}'
                                                : context
                                                    .watch<checkcart>()
                                                    .fullname,
                                        style: TextStyle(
                                            fontSize: 19,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        token != null
                                            ? Provider.of<checkcart>(context,
                                                        listen: false)
                                                    .usedefault
                                                ? context
                                                    .watch<checkstate>()
                                                    .phone
                                                : context
                                                    .watch<checkcart>()
                                                    .number
                                            : Provider.of<checkcart>(context,
                                                        listen: false)
                                                    .usedefault
                                                ? '${context.watch<checkstate>().notloggednumber ?? ''}'
                                                : context
                                                    .watch<checkcart>()
                                                    .number,
                                        style: TextStyle(
                                          fontSize: 17,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        token != null
                                            ? Provider.of<checkcart>(context,
                                                        listen: false)
                                                    .usedefault
                                                ? context
                                                    .watch<checkstate>()
                                                    .email
                                                : context
                                                    .watch<checkstate>()
                                                    .email
                                            : Provider.of<checkcart>(context,
                                                        listen: false)
                                                    .usedefault
                                                ? '${context.watch<checkstate>().notloggedemail ?? ''}'
                                                : '${context.watch<checkstate>().notloggedemail ?? ''}',
                                        style: TextStyle(
                                          fontSize: 17,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      SizedBox(
                                        //color: Colors.white,

                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.8,
                                        child: Text(
                                          token != null
                                              ? Provider.of<checkcart>(context,
                                                          listen: false)
                                                      .usedefault
                                                  ? context
                                                      .watch<checkstate>()
                                                      .address
                                                  : context
                                                      .watch<checkcart>()
                                                      .address
                                              : Provider.of<checkcart>(context,
                                                          listen: false)
                                                      .usedefault
                                                  ? '${context.watch<checkstate>().notloggedaddress}'
                                                  : context
                                                      .watch<checkcart>()
                                                      .address,
                                          softWrap: true,
                                          style: TextStyle(
                                            fontSize: 17,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        token != null
                                            ? Provider.of<checkcart>(context,
                                                        listen: false)
                                                    .usedefault
                                                ? context
                                                    .watch<checkstate>()
                                                    .location
                                                : context
                                                    .watch<checkcart>()
                                                    .location
                                            : Provider.of<checkcart>(context,
                                                        listen: false)
                                                    .usedefault
                                                ? '${context.watch<checkstate>().notloggedlocation ?? ''}'
                                                : context
                                                    .watch<checkcart>()
                                                    .location,
                                        style: TextStyle(
                                          fontSize: 17,
                                        ),
                                      )
                                    ],
                                  )),
                      )
                    ],
                  ),
                ),
              ),
              Consumer<checkcart>(builder: (context, value, child) {
                List<Pagnited> cartresults = [];
                return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: value.cartresult.length,
                    itemBuilder: (context, index) {
                      cartresults = value.cartresult;
                      final cart = cartresults[index];
                      final image = cartresults[index].image;
                      final multiple = cartresults[index].multiple;
                      final food = cartresults[index].food;
                      final amount = cartresults[index].amount;
                      final total = cartresults[index].total;
                      List<Extra>? extra = cartresults[index].extras;

                      return cartresults[index].specialName == null
                          ? Cartbox(context, value, index, cart, image,
                              multiple, food, extra, amount, total, cartresults)
                          : Cartbox2(
                              context,
                              value,
                              index,
                              cart,
                              image,
                              multiple,
                              food,
                              extra,
                              amount,
                              total,
                              cartresults);
                    });
              }),
              Container(
                padding: EdgeInsets.all(15),
                height: 150,
                margin: EdgeInsets.only(
                    bottom: MediaQuery.of(context).size.height * 0.14, top: 10),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: Svg.Svg('images/svg/Pattern-7.svg',
                        size: Size(400, 200)),
                    colorFilter: ColorFilter.mode(
                      Theme.of(context).primaryColorLight,
                      BlendMode.difference,
                    ),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Food cost:',
                          style: TextStyle(fontSize: 19),
                        ),
                        Text(
                            '₦ ${context.watch<checkcart>().sumget.toString()}',
                            style: TextStyle(fontSize: 19))
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Delivery Fee:',
                          style: TextStyle(fontSize: 19),
                        ),
                        context.watch<checkcart>().loading
                            ? CircularProgressIndicator(
                                color: Theme.of(context).primaryColor,
                              )
                            : Text(
                                '₦ ${context.watch<checkcart>().delivery.toString()}',
                                style: TextStyle(fontSize: 19))
                      ],
                    ),
                    Consumer<checkcart>(builder: (context, value, child) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Promo code',
                            style: TextStyle(fontSize: 19),
                          ),
                          InkWell(
                            onTap: () {
                              modalbox(context);
                            },
                            child: value.verified
                                ? value.type == 'discount'
                                    ? Text('${value.discount.toString()}% off',
                                        style: TextStyle(fontSize: 19))
                                    : value.type == 'money'
                                        ? Text('- ₦ ${value.amount.toString()}',
                                            style: TextStyle(fontSize: 19))
                                        : Text('Enter coupon code')
                                : Text('Enter coupon code',
                                    style: TextStyle(fontSize: 19)),
                          )
                        ],
                      );
                    }),
                  ],
                ),
              ),
            ]),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
                padding: EdgeInsets.all(10),
                height: MediaQuery.of(context).size.height * 0.14,
                width: double.maxFinite,
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(20.0))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total:',
                          style: TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        context.watch<checkcart>().moneytopay < 0
                            ? Text('₦ 0.00',
                                style: TextStyle(
                                    fontSize: 21, fontWeight: FontWeight.bold))
                            : Text(
                                '₦ ${context.watch<checkcart>().moneytopay.toString()}',
                                style: TextStyle(
                                    fontSize: 21,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        if (Provider.of<checkcart>(context, listen: false)
                                .error ==
                            true) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: CustomeSnackbar(
                              topic: 'Oh Snap!',
                              msg: 'Payment cannot proceed',
                              color1: const Color.fromARGB(255, 171, 51, 42),
                              color2: const Color.fromARGB(255, 127, 39, 33),
                            ),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                          ));
                        } else if (Provider.of<checkcart>(context,
                                    listen: false)
                                .loading ==
                            true) {
                          SmartDialog.showToast('System is busy');
                        } else if (context
                                    .read<checkstate>()
                                    .notloggedaddress ==
                                '' &&
                            token == null) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: CustomeSnackbar(
                              topic: 'Oh Snap!',
                              msg: "You haven't set a location yet",
                              color1: const Color.fromARGB(255, 171, 51, 42),
                              color2: const Color.fromARGB(255, 127, 39, 33),
                            ),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                          ));
                        } else if (context.read<checkstate>().address == '' &&
                            token != null) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: CustomeSnackbar(
                              topic: 'Oh Snap!',
                              msg: "You haven't set a location yet",
                              color1: const Color.fromARGB(255, 171, 51, 42),
                              color2: const Color.fromARGB(255, 127, 39, 33),
                            ),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                          ));
                        } else if (Provider.of<checkcart>(context,
                                    listen: false)
                                .error !=
                            true) {
                          //checkpayment();
                          taketoweb();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: CustomeSnackbar(
                              topic: 'Oh Snap!',
                              msg: 'Something Went wrong',
                              color1: const Color.fromARGB(255, 171, 51, 42),
                              color2: const Color.fromARGB(255, 127, 39, 33),
                            ),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                          ));
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.only(
                            bottom: MediaQuery.of(context).size.height * 0.02),
                        width: double.infinity,
                        height: 40,
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(20)),
                        child: const Align(
                            alignment: Alignment.center,
                            child: Text(
                              'Place Order',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold),
                            )),
                      ),
                    )
                  ],
                )),
          ),
        ],
      ),
    );
  }

  void modalbox(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).size.width * 0.5,
            child: Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                child: Consumer<checkcart>(builder: (context, value, child) {
                  return Form(
                    //key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          child: const Text(
                            'Apply Coupon Code',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                'A coupon code is a combination if letters(case sensitive) and numbers without spaces',
                                style: TextStyle(fontSize: 19),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              SizedBox(
                                height: 75,
                                width: MediaQuery.of(context).size.width * 0.6,
                                child: TextFormField(
                                  autocorrect: false,
                                  onChanged: (value) {
                                    code = value;
                                  },
                                  autofocus: true,
                                  initialValue: code,
                                  decoration: const InputDecoration(
                                      hintText: 'Enter code',
                                      border: OutlineInputBorder(),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.black))),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            child: const Text("Submit"),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Theme.of(context)
                                      .primaryColor
                                      .withOpacity(.7)),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              )),
                            ),
                            onPressed: () async {
                              SmartDialog.showLoading();
                              await context
                                  .read<checkcart>()
                                  .verifycoupon(code);

                              if (value.success == 'success') {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: CustomeSnackbar(
                                    topic: 'Great!',
                                    msg: value.msg,
                                    color1:
                                        const Color.fromARGB(255, 25, 107, 52),
                                    color2:
                                        const Color.fromARGB(255, 19, 95, 40),
                                  ),
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: Colors.transparent,
                                  elevation: 0,
                                ));
                              } else if (value.success == 'fail') {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: CustomeSnackbar(
                                    topic: 'Oh Snap!',
                                    msg: value.msg,
                                    color1:
                                        const Color.fromARGB(255, 171, 51, 42),
                                    color2:
                                        const Color.fromARGB(255, 127, 39, 33),
                                  ),
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: Colors.transparent,
                                  elevation: 0,
                                ));
                              }
                              SmartDialog.dismiss();
                              Navigator.of(context).pop();
                            },
                          ),
                        )
                      ],
                    ),
                  );
                }),
              ),
            ),
          );
        });
  }

  void checkpayment() {
    MakePayment(
      context: context,
      price:
          (Provider.of<checkcart>(context, listen: false).moneytopay).round(),
      email: token != null
          ? Provider.of<checkstate>(context, listen: false).email
          : '${Provider.of<checkstate>(context, listen: false).notloggedemail}',
    ).chargeCardAndMakePayment();
  }

  taketoweb() async {
    String addressget() {
      String add = '';
      token != null
          ? Provider.of<checkcart>(context, listen: false).usedefault
              ? add = context.watch<checkstate>().address
              : add = context.watch<checkcart>().address
          : Provider.of<checkcart>(context, listen: false).usedefault
              ? add = '${context.watch<checkstate>().notloggedaddress}'
              : add = context.watch<checkcart>().address;
      return add;
    }

    String number() {
      String add = '';
      token != null
          ? Provider.of<checkcart>(context, listen: false).usedefault
              ? add = context.watch<checkstate>().phone
              : add = context.watch<checkcart>().number
          : Provider.of<checkcart>(context, listen: false).usedefault
              ? add = '${context.watch<checkstate>().notloggednumber ?? ''}'
              : add = context.watch<checkcart>().number;
      return add;
    }

    String name() {
      String add = '';
      token != null
          ? Provider.of<checkcart>(context, listen: false).usedefault
              ? add =
                  '${context.watch<checkstate>().firstname} ${context.watch<checkstate>().lastname}'
              : add = context.watch<checkcart>().fullname
          : Provider.of<checkcart>(context, listen: false).usedefault
              ? add = '${context.watch<checkstate>().notloggedname}'
              : add = context.watch<checkcart>().fullname;
      return add;
    }

    String getlocation() {
      String add = '';
      token != null
          ? Provider.of<checkcart>(context, listen: false).usedefault
              ? add = context.watch<checkstate>().location
              : add = context.watch<checkcart>().location
          : Provider.of<checkcart>(context, listen: false).usedefault
              ? add = '${context.watch<checkstate>().notloggedlocation ?? ''}'
              : add = context.watch<checkcart>().location;
      return add;
    }

    Future<String> getReference() async {
      await context.read<greetings>().gettim();
      String platform;
      if (Platform.isIOS) {
        platform = 'iOS';
      } else {
        platform = 'Android';
      }

      return 'ChargedFrom${platform}_${Provider.of<greetings>(context, listen: false).time.millisecondsSinceEpoch}';
    }

    final ref = await getReference();
    // final ref = 'ChargedFrom${platform}_${context.watch<greetings>().time.millisecondsSinceEpoch}';
    await createref(
        token != null
            ? Provider.of<checkstate>(context, listen: false).email
            : '${Provider.of<checkstate>(context, listen: false).ID}',
        ref);

    if (success == 'success') {
      // ignore: use_build_context_synchronously
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => webpage(
                    email: token != null
                        ? Provider.of<checkstate>(context, listen: false).email
                        : '${Provider.of<checkstate>(context, listen: false).notloggedemail}',
                    price: (Provider.of<checkcart>(context, listen: false)
                            .moneytopay)
                        .round()
                        .toString(),
                    ID: token != null
                        ? Provider.of<checkstate>(context, listen: false).email
                        : '${Provider.of<checkstate>(context, listen: false).ID}',
                    ref: ref,
                    type: 'quickbuycheck',
                  )),
          (Route<dynamic> route) => false);
    } else if (success == 'fail') {
      SmartDialog.dismiss();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: CustomeSnackbar(
          topic: 'Oh Snap!',
          msg: 'Something went wrong',
          color1: const Color.fromARGB(255, 171, 51, 42),
          color2: const Color.fromARGB(255, 127, 39, 33),
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ));
    }
  }

  Future<void> createref(email, ref) async {
    SmartDialog.showLoading();
    setState(() {
      loading = true;
    });

    try {
      FetchcartModel send = FetchcartModel(id: email, ref: ref, email: '');
      var response = await networkHandler.client.post(
          networkHandler.builderUrl('/insertingref'),
          body: fetchcartModelToJson(send),
          headers: {
            'content-Type': 'application/json; charset=UTF-8',
          });
      print(send.id);
      final decodedres = jsonDecode(response.body);
      setState(() {
        success = decodedres['success'];
      });
      print(decodedres);
    } catch (e) {
      print(e);
      setState(() {
        success = 'fail';
      });
    } finally {
      setState(() {
        loading = false;
      });
      SmartDialog.dismiss();
    }
  }
}
