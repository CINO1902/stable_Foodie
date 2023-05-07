import 'package:flutter/material.dart';

import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:foodie_ios/linkfile/enum/connectivity_status.dart';
import 'package:foodie_ios/linkfile/provider/internetchecker.dart';

import 'package:foodie_ios/onboarding.dart';

import 'package:foodie_ios/page/landingpage.dart';

import 'package:provider/provider.dart';

class invisible extends StatefulWidget {
  invisible({
    super.key,
    required this.internet,
  });

  bool internet;
  @override
  State<invisible> createState() => _invisibleState();
}

class _invisibleState extends State<invisible> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<internetcheck>().getinternet();
  }

  @override
  Widget build(BuildContext context) {
    if (Provider.of<ConnectivityStatus>(context) ==
        ConnectivityStatus.Cellular) {
      SmartDialog.showToast('Cellular Mode');
    } else if (Provider.of<ConnectivityStatus>(context) ==
        ConnectivityStatus.WiFi) {
      SmartDialog.showToast('Wifi Mode');
    }

    return widget.internet ? onBoarding() : homelanding();
  }
}
