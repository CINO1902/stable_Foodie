import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:foodie_ios/invisible.dart';
import 'package:foodie_ios/linkfile/enum/connectivity_status.dart';
import 'package:foodie_ios/linkfile/provider/addTocart.dart';
import 'package:foodie_ios/linkfile/provider/calculatemael.dart';
import 'package:foodie_ios/linkfile/provider/checkbox.dart';
import 'package:foodie_ios/linkfile/provider/checkcart.dart';
import 'package:foodie_ios/linkfile/provider/confirmcart.dart';
import 'package:foodie_ios/linkfile/provider/fetchpakage.dart';
import 'package:foodie_ios/linkfile/provider/getItem.dart';
import 'package:foodie_ios/linkfile/provider/getItemextra.dart';
import 'package:foodie_ios/linkfile/provider/getsubdetails.dart';
import 'package:foodie_ios/linkfile/provider/getsubhistory.dart';
import 'package:foodie_ios/linkfile/provider/greetings.dart';
import 'package:foodie_ios/linkfile/provider/internetchecker.dart';
import 'package:foodie_ios/linkfile/provider/mostcommon.dart';
import 'package:foodie_ios/linkfile/provider/notification.dart';
import 'package:foodie_ios/linkfile/provider/onboarding.dart';
import 'package:foodie_ios/linkfile/provider/sellectbucket.dart';
import 'package:foodie_ios/linkfile/provider/special_offer.dart';
import 'package:foodie_ios/linkfile/provider/specialoffermeal.dart';
import 'package:foodie_ios/linkfile/provider/subscribed.dart';
import 'package:foodie_ios/linkfile/provider/themeprovider.dart';
import 'package:foodie_ios/linkfile/services/connectivity_service.dart';
import 'package:foodie_ios/page/Rollover/frequency.dart';
import 'package:foodie_ios/page/order.dart';

import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:foodie_ios/page/cart.dart';
import 'package:foodie_ios/page/checkoutpage.dart';
import 'package:foodie_ios/page/confirmorder.dart';

import 'package:foodie_ios/page/forgotpassword.dart';
import 'package:foodie_ios/page/fullsubhistory.dart';
import 'package:foodie_ios/page/home.dart';
import 'package:foodie_ios/page/landingpage.dart';
import 'package:foodie_ios/page/login.dart';
import 'package:foodie_ios/page/myaccount.dart';
import 'package:foodie_ios/page/nonetwork.dart';
import 'package:foodie_ios/page/notifications.dart';

import 'package:foodie_ios/page/regiter.dart';
import 'package:foodie_ios/page/theme.dart';
import 'package:foodie_ios/page/upgrade/sellectday.dart';

import 'package:foodie_ios/survey.dart/bucketsellect.dart';
import 'package:foodie_ios/survey.dart/page1.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> _firebasebackgroundhandler(RemoteMessage message) async {
  Firebase.initializeApp();
  print("handling message in ${message.messageId}");
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences pref = await SharedPreferences.getInstance();
  final value = pref.getBool('showhomeprovider') ?? true;
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebasebackgroundhandler);
  await FirebaseMessaging.instance
      .getInitialMessage()
      .then((RemoteMessage? message) {
    if (message != null) {
      Navigator.pushNamed(
        navigatorKey.currentState!.context,
        '/${message.data['page']}',
      );
    }
  });
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
    print("On message Opened: $message");

    Navigator.pushNamed(
      navigatorKey.currentState!.context,
      '/${message.data['page']}',
    );
  });
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(myApp(
    logged: value,
  ));
}

class myApp extends StatefulWidget {
  myApp({super.key, required this.logged});
  bool logged;
  @override
  State<myApp> createState() => _myAppState();
}

class _myAppState extends State<myApp> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => initialization());
  }

  bool checkuser = false;

  bool hasInternet = false;
  void initialization() async {
    final hasInternet1 = await InternetConnectionChecker().hasConnection;
    setState(() {
      hasInternet = hasInternet1;
    });

    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => checkstate()),
        ChangeNotifierProvider(create: (context) => greetings()),
        ChangeNotifierProvider(create: (context) => checkme()),
        ChangeNotifierProvider(create: (context) => getiItem()),
        ChangeNotifierProvider(create: (context) => getiItemExtra()),
        ChangeNotifierProvider<calculatemeal>(
            create: (context) => calculatemeal()),
        ChangeNotifierProvider<addTocart>(create: (context) => addTocart()),
        ChangeNotifierProxyProvider<calculatemeal, addTocart>(
            create: (context) => addTocart(),
            update: (BuildContext context, calculatemeal calculatmeal,
                addTocart? addocart) {
              addocart!.update(calculatmeal);
              return addocart;
            }),
        ChangeNotifierProvider(create: (context) => checkcart()),
        ChangeNotifierProvider(create: (context) => getsubdetail()),
        ChangeNotifierProvider(create: (context) => fetchprovider()),
        ChangeNotifierProvider(create: (context) => sellectbucket()),
        ChangeNotifierProvider(create: (context) => confirmcart()),
        ChangeNotifierProvider(create: (context) => subscribed()),
        ChangeNotifierProvider(create: (context) => getsubhistory()),
        ChangeNotifierProvider(create: (context) => getmostcommon()),
        ChangeNotifierProvider(create: (context) => showrecent()),
        ChangeNotifierProvider(create: (context) => notifications()),
        ChangeNotifierProvider(create: (context) => internetcheck()),
        ChangeNotifierProvider(create: (context) => special_offer()),
        ChangeNotifierProvider(create: (context) => meal_calculate()),
        ChangeNotifierProxyProvider<subscribed, sellectbucket>(
            create: (context) => sellectbucket(),
            update: (BuildContext context, subscribed checkstate,
                sellectbucket? getcommon) {
              getcommon!.update(checkstate);
              return getcommon;
            }),
        ChangeNotifierProxyProvider<checkstate, checkcart>(
            create: (context) => checkcart(),
            update: (BuildContext context, checkstate checkstate,
                checkcart? checkcart) {
              checkcart!.update(checkstate);
              return checkcart;
            }),
        ChangeNotifierProxyProvider<checkcart, confirmcart>(
            create: (context) => confirmcart(),
            update: (BuildContext context, checkcart checkcat,
                confirmcart? confirmcat) {
              confirmcat!.update(checkcat);
              return confirmcat;
            }),
        ChangeNotifierProvider(
          create: (context) => Themeprovider(),
          builder: (context, _) {
            return StreamProvider<ConnectivityStatus>(
                initialData: ConnectivityStatus.Cellular,
                create: (context) {
                  return ConnectivityService().secondCountStream;
                },
                builder: (context, child) {
                  return MaterialApp(
                    debugShowCheckedModeBanner: false,
                    navigatorObservers: [FlutterSmartDialog.observer],
                    title: 'Flutter Demo',
                    builder: FlutterSmartDialog.init(),
                    initialRoute: '/',
                    themeMode: context.watch<Themeprovider>().getTheme(),
                    theme: myTheme.lighttheme,
                    darkTheme: myTheme.darktheme,
                    navigatorKey: navigatorKey,
                    routes: {
                      '/': (context) => hasInternet
                          ? invisible(
                              internet: widget.logged,
                            )
                          : nonetwork(),
                      '/home': (context) => const home(),
                      '/order': (context) => const Order(),
                      '/cart': (context) => const cart(),
                      '/notification': (context) => notification(),
                      '/nonetwork': (context) => const nonetwork(),
                      '/page1': (context) => const page1(),
                      '/page2': (context) => const page2(),
                      '/checkout': ((context) => const checkoutsub()),
                      '/register': ((context) => const register()),
                      '/login': ((context) => const login()),
                      '/forgotpassword': ((context) => const forgotpassword()),
                      '/landingpage': ((context) => const homelanding()),
                      '/myaccount': ((context) => const myaccount()),
                      '/notifications': ((context) => const notification()),
                      '/theme': ((context) => const themepage()),
                      '/showmore': ((context) => const fullsubhistory()),
                      '/rolloverfrequenct': ((context) => const frequency()),
                      '/upgradefrequency': ((context) => const sellectday()),
                      '/confirmorder': ((context) => const confirmorder()),
                    },
                  );
                });
          },
        )
      ],
    );
  }
}
