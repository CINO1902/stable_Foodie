import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_svg/svg.dart';
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
import 'package:foodie_ios/page/addperaddress.dart';
import 'package:foodie_ios/page/verifyquickbuy.dart';
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
  }

  bool proceed = false;
  List delete = [];
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

  bool loadingpaid = false;
  Future<void> markpaid() async {
    try {
      setState(() {
        loadingpaid = true;
      });

      var response = await networkHandler.client
          .post(networkHandler.builderUrl('/markpaid'),
              body: jsonEncode(<String, String>{
                'id': token != null
                    ? Provider.of<checkstate>(context, listen: false).email
                    : '${Provider.of<checkstate>(context, listen: false).ID}'
              }),
              headers: {
            'content-Type': 'application/json; charset=UTF-8',
          });
      final decodedres = jsonDecode(response.body);

      String successmark = decodedres['status'];

      if (successmark == 'success') {
        setState(() {
          proceed = true;
        });
        Provider.of<checkcart>(context, listen: false).moneytopay < 0
            ? Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => verifyquickbuy(
                          price: int.parse((context.watch<checkcart>().sumget +
                                  context.watch<checkcart>().delivery)
                              .toString()),
                          ref: 'free',
                        )),
                (Route<dynamic> route) => false)
            : taketoweb();
      } else if (successmark == 'fail') {
        SmartDialog.showToast('Something went wrong');
      }

      // print(decodedres);
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        loadingpaid = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    checkregistered();

    context.read<checkcart>().locationa();
    context.read<checkcart>().disposediscount();
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();
    if (proceed == false) {
      context.read<checkcart>().disposediscount();
      print('deact');
    }
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
                  if (token == null) {
                    context.read<checkstate>().notloggedname == ''
                        ? Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => addAddressper()))
                        : Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => addAddress(
                                      save: false,
                                    )));
                  } else {
                    context.read<checkstate>().address == ''
                        ? Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => addAddressper()))
                        : Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => addAddress(
                                      save: false,
                                    )));
                  }

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
                                '${context.watch<checkcart>().totalcartcall.toString()} X ₦ ${(context.watch<checkcart>().delivery / context.watch<checkcart>().totalcartcall).toString()}',
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
                      onTap: () async {
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
                          if (delete.isNotEmpty) {
                            SmartDialog.showToast(
                                'Please delete the marked item');
                          } else {
                            await markpaid();
                          }
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
                        child: Align(
                            alignment: Alignment.center,
                            child: loadingpaid
                                ? CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 3,
                                  )
                                : Text(
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

  Widget Cartbox(BuildContext context, checkcart value, int indexx, cart, image,
      multiple, food, extra, amount, total, cartresults) {
    var date = cartresults[indexx].date;
    var currentdate = DateTime.now();
    Duration diff = currentdate.difference(date);
    int difference = 300 - diff.inSeconds;
    int hour = diff.inSeconds ~/ 60;
    if (hour > 4) {
      delete.removeWhere((element) => element == cartresults[indexx].packageid);
      delete.add(cartresults[indexx].packageid);
    }

    String cancel() {
      String minute = '';
      String seconds = '';

      if (hour == 0) {
        minute = '4';
        seconds = (difference - (4 * 60) - 1).toString();
      } else if (hour == 1) {
        minute = '3';
        seconds = (difference - (3 * 60) - 1).toString();
      } else if (hour == 2) {
        minute = '2';
        seconds = (difference - (2 * 60) - 1).toString();
      } else if (hour == 3) {
        minute = '1';
        seconds = (difference - (1 * 60) - 1).toString();
      } else if (hour == 4) {
        minute = '0';
        seconds = (difference - (0 * 60) - 1).toString();
      }
      return '${minute.padLeft(2, '0')} : ${seconds.padLeft(2, '0')}';
    }

    return Container(
      margin: const EdgeInsets.only(top: 10),
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.13,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: SvgPicture.asset(
              'images/svg/Pattern-7.svg',
              fit: BoxFit.cover,
              height: MediaQuery.of(context).size.height * 0.45,
              color: Theme.of(context).primaryColorLight,
              colorBlendMode: BlendMode.difference,
            ),
          ),
          InkWell(
            onTap: () {
              modalpopup(context, image, multiple, food, extra, amount, total,
                  cartresults);
            },
            child: Row(
              children: [
                Stack(
                  children: [
                    SizedBox(
                      height: double.infinity,
                      //  color: Colors.black,
                      width: MediaQuery.of(context).size.width * 0.85,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: CachedNetworkImage(
                                imageUrl: cartresults[indexx].image ?? '',
                                fit: BoxFit.cover,
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                                width: 90,
                                height:
                                    MediaQuery.of(context).size.width * 0.23,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.17,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 5,
                                  ),
                                  SizedBox(
                                    child: Text(
                                      '${cartresults[indexx].multiple} X',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 19),
                                    ),
                                  ),
                                  SizedBox(
                                    child: const Text(
                                      'Extras:',
                                      style: TextStyle(
                                        fontSize: 17,
                                      ),
                                    ),
                                  ),
                                ]),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.23,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    '${cartresults[indexx].food}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17),
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.07,
                                    child: ListView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount:
                                            cartresults[indexx].extras!.length,
                                        itemBuilder: (context, index) {
                                          return Text(
                                            '${cartresults[indexx].extras![index].the5}',
                                            // overflow-: TextOverflow.ellipsis,
                                            style:
                                                const TextStyle(fontSize: 17),
                                          );
                                        }),
                                  ),
                                ]),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.15,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 5,
                                  ),
                                  SizedBox(
                                    child: Text(
                                      '₦ ${cartresults[indexx].amount}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17),
                                    ),
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.07,
                                    child: ListView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount:
                                            cartresults[indexx].extras!.length,
                                        itemBuilder: (context, index) {
                                          return Text(
                                            '₦ ${cartresults[indexx].extras![index].the1}',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 16),
                                          );
                                        }),
                                  ),
                                ]),
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 20,
                        margin: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.28),
                        width: MediaQuery.of(context).size.width * 0.53,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Total:',
                                style: TextStyle(
                                    fontWeight: FontWeight.w400, fontSize: 17)),
                            Text('₦ ${cartresults[indexx].total}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w400, fontSize: 17))
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Align(
                    alignment: Alignment.bottomRight,
                    child: delete.contains(cartresults[indexx].packageid)
                        ? Container(
                            margin: EdgeInsets.only(bottom: 5),
                            child: const Align(
                              alignment: Alignment.center,
                              child: Icon(
                                Icons.cancel,
                                color: Colors.red,
                              ),
                            ),
                          )
                        : Container(
                            width: 35,
                            height: 20,
                            margin: EdgeInsets.only(bottom: 5, right: 3),
                            child: FittedBox(
                              child: Text(
                                cancel(),
                                style: TextStyle(fontSize: 15),
                              ),
                            ))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<dynamic> modalpopup(BuildContext context, image, multiple, food, extra,
      amount, total, cartresults) {
    return showModalBottomSheet(
        context: context,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        builder: (BuildContext context) {
          return Stack(
            children: [
              ListView(
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  Container(
                    padding: const EdgeInsets.only(top: 5, left: 20, right: 10),
                    width: double.infinity,
                    height: 30,
                    color: Theme.of(context).primaryColor,
                    child: Center(
                      child: Text(
                        'Order Details',
                        style: TextStyle(
                          fontSize: 23,
                          letterSpacing: -0.4,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onTertiary,
                        ),
                      ),
                    ),
                  ),
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.12,
                        width: 100,
                        child: CachedNetworkImage(
                          imageUrl: image ?? '',
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                          width: MediaQuery.of(context).size.width * 0.4,
                          height: MediaQuery.of(context).size.width * 0.35,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.2,
                            child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Text(
                                      '$multiple X',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 19),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: const Text(
                                      'Extras:',
                                      style: TextStyle(fontSize: 17),
                                    ),
                                  ),
                                ]),
                          ),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.45,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(
                                          right: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.05,
                                        ),
                                        child: Text(
                                          '$food',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 19),
                                        ),
                                      ),
                                      Text(
                                        '$amount',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 17),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                    // color: Colors.black,
                                    height: MediaQuery.of(context).size.height *
                                        0.6,
                                    width: MediaQuery.of(context).size.width *
                                        0.45,
                                    padding: EdgeInsets.only(
                                      bottom:
                                          MediaQuery.of(context).size.height *
                                              0.2,
                                    ),
                                    child: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: extra.length,
                                        itemBuilder: (context, index) {
                                          return Container(
                                            margin: const EdgeInsets.only(
                                              bottom: 5,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.23,
                                                  child: Text(
                                                    '${extra![index].the5}',
                                                    // overflow-: TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                        fontSize: 19),
                                                  ),
                                                ),
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                      left: 30),
                                                  child: Text(
                                                    '${extra![index].the1}',
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 17),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        })),
                              ]),
                        ]),
                  ]),
                ],
              ),
              Positioned(
                  bottom: 0,
                  width: MediaQuery.of(context).size.width,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.09,
                      width: double.maxFinite,
                      // margin: EdgeInsets.only(
                      //   top: MediaQuery.of(context).size.height * 0.45,
                      // ),
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(10.0))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            height: 40,
                            child: const Align(
                              alignment: Alignment.center,
                              child: Text(
                                'Total:',
                                style: TextStyle(
                                    fontSize: 21,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {},
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                              decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(.8),
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      bottomLeft: Radius.circular(10))),
                              height: 40,
                              child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    '$total',
                                    style: const TextStyle(color: Colors.white),
                                  )),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ))
            ],
          );
        });
  }

  Widget Cartbox2(BuildContext context, checkcart value, int indexx, cart,
      image, multiple, food, extra, amount, total, List<Pagnited> cartresults) {
    var date = cartresults[indexx].date;
    var currentdate = DateTime.now();
    Duration diff = currentdate.difference(date);
    int difference = 300 - diff.inSeconds;
    int hour = diff.inSeconds ~/ 60;
    if (hour > 4) {
      delete.removeWhere((element) => element == cartresults[indexx].packageid);
      delete.add(cartresults[indexx].packageid);
    }

    String cancel() {
      String minute = '';
      String seconds = '';

      if (hour == 0) {
        minute = '4';
        seconds = (difference - (4 * 60) - 1).toString();
      } else if (hour == 1) {
        minute = '3';
        seconds = (difference - (3 * 60) - 1).toString();
      } else if (hour == 2) {
        minute = '2';
        seconds = (difference - (2 * 60) - 1).toString();
      } else if (hour == 3) {
        minute = '1';
        seconds = (difference - (1 * 60) - 1).toString();
      } else if (hour == 4) {
        minute = '0';
        seconds = (difference - (0 * 60) - 1).toString();
      }
      return '${minute.padLeft(2, '0')} : ${seconds.padLeft(2, '0')}';
    }

    return Container(
      margin: const EdgeInsets.only(top: 10),
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.15,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: SvgPicture.asset(
              'images/svg/Pattern-7.svg',
              fit: BoxFit.cover,
              height: MediaQuery.of(context).size.height * 0.45,
              color: Theme.of(context).primaryColorLight,
              colorBlendMode: BlendMode.difference,
            ),
          ),
          Row(
            children: [
              InkWell(
                onTap: () {
                  modalpopup2(context, image, multiple, food, extra, amount,
                      total, cartresults, indexx);
                },
                child: Stack(
                  children: [
                    SizedBox(
                      height: double.infinity,
                      //  color: Colors.black,
                      width: MediaQuery.of(context).size.width * 0.85,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: CachedNetworkImage(
                                imageUrl: cartresults[indexx].image,
                                fit: BoxFit.cover,
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                                width: 90,
                                height:
                                    MediaQuery.of(context).size.width * 0.23,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.55,
                            height: MediaQuery.of(context).size.height * 0.13,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        child: Text(
                                          '${cartresults[indexx].multiple} X',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 19),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      SizedBox(
                                        width: 150,
                                        child: Text(
                                          '${cartresults[indexx].specialName}',
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 17),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 7,
                                  ),
                                  cartresults[indexx].sides!.isNotEmpty
                                      ? Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                              SizedBox(
                                                child: const Text(
                                                  'Sides:',
                                                  style: TextStyle(
                                                    fontSize: 17,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.03,
                                                width: 150,
                                                child: ListView.builder(
                                                    shrinkWrap: true,
                                                    physics:
                                                        const NeverScrollableScrollPhysics(),
                                                    itemCount:
                                                        cartresults[indexx]
                                                            .sides!
                                                            .length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return Text(
                                                        '${cartresults[indexx].sides![index]["1"]}',
                                                        // overflow-: TextOverflow.ellipsis,
                                                        style: const TextStyle(
                                                            fontSize: 17),
                                                      );
                                                    }),
                                              ),
                                            ])
                                      : SizedBox(),
                                  cartresults[indexx].drinks!.isNotEmpty
                                      ? Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                              SizedBox(
                                                child: const Text(
                                                  'Drinks:',
                                                  style: TextStyle(
                                                    fontSize: 17,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.03,
                                                width: 150,
                                                child: ListView.builder(
                                                    shrinkWrap: true,
                                                    physics:
                                                        const NeverScrollableScrollPhysics(),
                                                    itemCount:
                                                        cartresults[indexx]
                                                            .drinks!
                                                            .length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return Text(
                                                        '${cartresults[indexx].drinks![index]["1"]}',
                                                        // overflow-: TextOverflow.ellipsis,
                                                        style: const TextStyle(
                                                            fontSize: 17),
                                                      );
                                                    }),
                                              ),
                                            ])
                                      : SizedBox(),
                                  cartresults[indexx].foods!.isNotEmpty
                                      ? Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                              SizedBox(
                                                child: const Text(
                                                  'Food:',
                                                  style: TextStyle(
                                                    fontSize: 17,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.03,
                                                width: 150,
                                                child: ListView.builder(
                                                    shrinkWrap: true,
                                                    physics:
                                                        const NeverScrollableScrollPhysics(),
                                                    itemCount:
                                                        cartresults[indexx]
                                                            .foods!
                                                            .length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return Text(
                                                        '${cartresults[indexx].foods![index]["1"]}',
                                                        // overflow-: TextOverflow.ellipsis,
                                                        style: const TextStyle(
                                                            fontSize: 17),
                                                      );
                                                    }),
                                              ),
                                            ])
                                      : SizedBox(),
                                ]),
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                          height: 20,
                          margin: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0.3),
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: Text('₦ ${cartresults[indexx].amount}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w400, fontSize: 17))),
                    ),
                  ],
                ),
              ),
              Align(
                  alignment: Alignment.bottomRight,
                  child: delete.contains(cartresults[indexx].packageid)
                      ? Container(
                          margin: EdgeInsets.only(bottom: 5),
                          child: const Align(
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.cancel,
                              color: Colors.red,
                            ),
                          ),
                        )
                      : Container(
                          width: 35,
                          height: 20,
                          margin: EdgeInsets.only(bottom: 5, right: 3),
                          child: FittedBox(
                            child: Text(
                              cancel(),
                              style: TextStyle(fontSize: 15),
                            ),
                          ))),
            ],
          ),
        ],
      ),
    );
  }

  Future<dynamic> modalpopup2(BuildContext context, image, multiple, food,
      extra, amount, total, List<Pagnited> cartresults, indexx) {
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
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Text(
                        'Order Detail',
                        style: TextStyle(
                            fontSize: 23, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: SvgPicture.asset(
                            'images/svg/Pattern-7.svg',
                            fit: BoxFit.cover,
                            height: MediaQuery.of(context).size.height * 0.45,
                            color: Theme.of(context).primaryColorLight,
                            colorBlendMode: BlendMode.difference,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Align(
                                  alignment: Alignment.topCenter,
                                  child: Align(
                                    alignment: Alignment.topCenter,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: CachedNetworkImage(
                                        imageUrl: image ?? '',
                                        fit: BoxFit.cover,
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error),
                                        width: 110,
                                        height:
                                            MediaQuery.of(context).size.width *
                                                0.27,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.55,
                                  height:
                                      MediaQuery.of(context).size.height * 0.40,
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            SizedBox(
                                              child: Text(
                                                '${cartresults[indexx].multiple} X',
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 19),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            SizedBox(
                                              width: 150,
                                              child: Text(
                                                '${cartresults[indexx].specialName}',
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 17),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 7,
                                        ),
                                        SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.34,
                                          child: ListView(
                                            shrinkWrap: true,
                                            children: [
                                              cartresults[indexx]
                                                      .sides!
                                                      .isNotEmpty
                                                  ? Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                          SizedBox(
                                                            child: const Text(
                                                              'Sides:',
                                                              style: TextStyle(
                                                                fontSize: 17,
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 7,
                                                          ),
                                                          Container(
                                                            width: 150,
                                                            constraints:
                                                                BoxConstraints(
                                                              maxHeight: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height *
                                                                  0.12,
                                                              minHeight: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height *
                                                                  0.03,
                                                            ),
                                                            child: ListView
                                                                .builder(
                                                                    shrinkWrap:
                                                                        true,
                                                                    physics:
                                                                        const NeverScrollableScrollPhysics(),
                                                                    itemCount: cartresults[
                                                                            indexx]
                                                                        .sides!
                                                                        .length,
                                                                    itemBuilder:
                                                                        (context,
                                                                            index) {
                                                                      return Container(
                                                                        margin: EdgeInsets.only(
                                                                            bottom:
                                                                                5),
                                                                        child:
                                                                            Text(
                                                                          '${cartresults[indexx].sides![index]["1"]}',
                                                                          // overflow-: TextOverflow.ellipsis,
                                                                          style:
                                                                              const TextStyle(fontSize: 17),
                                                                        ),
                                                                      );
                                                                    }),
                                                          ),
                                                        ])
                                                  : SizedBox(),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              cartresults[indexx]
                                                      .drinks!
                                                      .isNotEmpty
                                                  ? Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                          SizedBox(
                                                            child: const Text(
                                                              'Drinks:',
                                                              style: TextStyle(
                                                                fontSize: 17,
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 7,
                                                          ),
                                                          Container(
                                                            width: 150,
                                                            constraints:
                                                                BoxConstraints(
                                                              maxHeight: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height *
                                                                  0.12,
                                                              minHeight: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height *
                                                                  0.03,
                                                            ),
                                                            child: ListView
                                                                .builder(
                                                                    shrinkWrap:
                                                                        true,
                                                                    physics:
                                                                        const NeverScrollableScrollPhysics(),
                                                                    itemCount: cartresults[
                                                                            indexx]
                                                                        .drinks!
                                                                        .length,
                                                                    itemBuilder:
                                                                        (context,
                                                                            index) {
                                                                      return Container(
                                                                        margin: EdgeInsets.only(
                                                                            bottom:
                                                                                5),
                                                                        child:
                                                                            Text(
                                                                          '${cartresults[indexx].drinks![index]["1"]}',
                                                                          // overflow-: TextOverflow.ellipsis,
                                                                          style:
                                                                              const TextStyle(fontSize: 17),
                                                                        ),
                                                                      );
                                                                    }),
                                                          ),
                                                        ])
                                                  : SizedBox(),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              cartresults[indexx]
                                                      .foods!
                                                      .isNotEmpty
                                                  ? Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                          SizedBox(
                                                            child: const Text(
                                                              'Food:',
                                                              style: TextStyle(
                                                                fontSize: 17,
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 7,
                                                          ),
                                                          Container(
                                                            width: 150,
                                                            constraints:
                                                                BoxConstraints(
                                                              maxHeight: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height *
                                                                  0.12,
                                                              minHeight: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height *
                                                                  0.03,
                                                            ),
                                                            child: ListView
                                                                .builder(
                                                                    shrinkWrap:
                                                                        true,
                                                                    physics:
                                                                        const NeverScrollableScrollPhysics(),
                                                                    itemCount: cartresults[
                                                                            indexx]
                                                                        .foods!
                                                                        .length,
                                                                    itemBuilder:
                                                                        (context,
                                                                            index) {
                                                                      return Container(
                                                                        margin: EdgeInsets.only(
                                                                            bottom:
                                                                                5),
                                                                        child:
                                                                            Text(
                                                                          '${cartresults[indexx].foods![index]["1"]}',
                                                                          // overflow-: TextOverflow.ellipsis,
                                                                          style:
                                                                              const TextStyle(fontSize: 17),
                                                                        ),
                                                                      );
                                                                    }),
                                                          ),
                                                        ])
                                                  : SizedBox(),
                                            ],
                                          ),
                                        ),
                                      ]),
                                )
                              ]),
                        ),
                        Positioned(
                          top: MediaQuery.of(context).size.height * 0.4,
                          left: MediaQuery.of(context).size.width * 0.30,
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: SizedBox(
                              height: 20,
                              width: MediaQuery.of(context).size.width * 0.6,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Total:',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 17)),
                                  Text('₦ ${cartresults[indexx].amount}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 17))
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }
}
