import 'package:flutter/material.dart';

class Loadingwidget2 extends StatelessWidget {
  const Loadingwidget2({super.key});
  static show(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Loadingwidget2());
  }

  static hide(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          padding: const EdgeInsets.all(15),
          height: 70,
          width: 70,
          child: CircularProgressIndicator(
            color: Theme.of(context).primaryColor,
          )),
    );
    
  }
}
