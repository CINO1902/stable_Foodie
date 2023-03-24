import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

void showoverlay() {
  SmartDialog.show(
      tag: 'network',
      clickMaskDismiss: false,
      backDismiss: false,
      builder: (context) {
        return Align(
          alignment: Alignment.topCenter,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.12,
            width: double.infinity,
            color: Color.fromARGB(255, 35, 35, 35),
            child: SafeArea(
              bottom: false,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      'Network Not Available',
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          color: Colors.white),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          'Reconnecting ',
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              color: Colors.white),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.0,
                            color: Colors.white,
                          ),
                        )
                      ],
                    )
                  ]),
            ),
          ),
        );
      });
}
