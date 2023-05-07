import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:foodie_ios/linkfile/customesnackbar.dart';
import 'package:foodie_ios/linkfile/provider/checkcart.dart';
import 'package:foodie_ios/linkfile/provider/confirmcart.dart';
import 'package:foodie_ios/linkfile/provider/sellectbucket.dart';
import 'package:foodie_ios/linkfile/provider/subscribed.dart';
import 'package:provider/provider.dart';

class verifyquickbuy extends StatefulWidget {
  verifyquickbuy({super.key, required this.price, required this.ref, required this.ordernum});

  int price;
  String ref;
  String ordernum;
  @override
  State<verifyquickbuy> createState() => _verifyquickbuyState();
}

class _verifyquickbuyState extends State<verifyquickbuy> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    performpayment();
  }

  void performpayment() async {
    SmartDialog.showLoading(msg: 'Processing Purchase... Do not leave the app');
    await context.read<confirmcart>().checkcarts(widget.price, widget.ref, widget.ordernum);
    if (Provider.of<confirmcart>(context, listen: false).success == 'success') {
      SmartDialog.dismiss();
      Navigator.pushNamedAndRemoveUntil(
          context, '/landingpage', (Route<dynamic> route) => false);
      context.read<checkcart>().checkcartforcart();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: CustomeSnackbar(
          topic: 'Great!',
          msg: 'Successfully Placed Order',
          color1: const Color.fromARGB(255, 25, 107, 52),
          color2: const Color.fromARGB(255, 19, 95, 40),
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ));
    } else if (Provider.of<confirmcart>(context, listen: false).success ==
        'fail') {
      SmartDialog.dismiss();
      Navigator.pushNamedAndRemoveUntil(
          context, '/landingpage', (Route<dynamic> route) => false);
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

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Payment on process'),
      ),
    );
  }
}

class verifysuborder extends StatefulWidget {
  verifysuborder({super.key, required this.price, required this.ref});

  int price;
  String ref;
  @override
  State<verifysuborder> createState() => _verifysuborderState();
}

class _verifysuborderState extends State<verifysuborder> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    performpayment();
  }

  void performpayment() async {
    SmartDialog.showLoading(msg: 'Processing Purchase... Do not leave the app');

    if (Provider.of<subscribed>(context, listen: false).rolloverclick == true) {
      await context.read<sellectbucket>().sendsubscriptionrollover();
      if (Provider.of<sellectbucket>(context, listen: false).status ==
          'success') {
        Navigator.pushNamedAndRemoveUntil(
            context, '/landingpage', (route) => false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: CustomeSnackbar(
            topic: 'Great!',
            msg: 'Successfully Placed Order',
            color1: const Color.fromARGB(255, 25, 107, 52),
            color2: const Color.fromARGB(255, 19, 95, 40),
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ));
      }
    } else if (Provider.of<subscribed>(context, listen: false).upgradeclick ==
        true) {
      await context.read<sellectbucket>().sendupgrade();
      if (Provider.of<sellectbucket>(context, listen: false).success == true) {
        SmartDialog.dismiss();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: CustomeSnackbar(
            topic: 'Great!',
            msg: 'Payment Made successfully',
            color1: Color.fromARGB(255, 25, 107, 52),
            color2: Color.fromARGB(255, 19, 95, 40),
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ));
        Navigator.pushNamedAndRemoveUntil(
            context, '/landingpage', (route) => false);
      } else {
        SmartDialog.dismiss();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
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
      }
    } else {
      await context.read<sellectbucket>().sendsubscription();

      SmartDialog.dismiss();
      if (Provider.of<sellectbucket>(context, listen: false).success == true) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: CustomeSnackbar(
            topic: 'Great!',
            msg: 'Payment Made successfully',
            color1: Color.fromARGB(255, 25, 107, 52),
            color2: Color.fromARGB(255, 19, 95, 40),
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ));
        Navigator.pushNamedAndRemoveUntil(
            context, '/landingpage', (route) => false);
      } else {
        SmartDialog.dismiss();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
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
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Payment on process'),
      ),
    );
  }
}
