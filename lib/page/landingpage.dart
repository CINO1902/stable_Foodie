import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foodie_ios/linkfile/enum/connectivity_status.dart';
import 'package:foodie_ios/linkfile/provider/internetchecker.dart';
import 'package:foodie_ios/page/account.dart';
import 'package:foodie_ios/page/home.dart';
import 'package:foodie_ios/page/order.dart';
import 'package:foodie_ios/page/overlay.dart';
import 'package:foodie_ios/page/subscription.dart';
import 'package:provider/provider.dart';

class homelanding extends StatefulWidget {
  const homelanding({Key? key}) : super(key: key);

  @override
  State<homelanding> createState() => _homelandingState();
}

class _homelandingState extends State<homelanding> {
  int currentIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<internetcheck>().getinternet();
    SmartDialog.dismiss();
  }

  static const screens = [
    home(),
    subscription(),
    Order(),
    Account(),
  ];

  @override
  Widget build(BuildContext context) {
    if (Provider.of<ConnectivityStatus>(context) ==
        ConnectivityStatus.Offline) {
      showoverlay();
    } else {
      SmartDialog.dismiss(tag: 'network');
    }
    return Theme.of(context).platform == TargetPlatform.iOS
        ? Scaffold(
            body: CupertinoTabScaffold(
            tabBar: CupertinoTabBar(
                iconSize: 20,
                //  backgroundColor: Colors.grey[3],
                currentIndex: currentIndex,
                onTap: (index) => setState(() {
                      currentIndex = index;
                    }),
                activeColor: Theme.of(context).primaryColor,
                inactiveColor: Theme.of(context).colorScheme.onBackground,
                items: <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    activeIcon: SvgPicture.asset(
                      'images/svg/Vector-3.svg',
                      color: Theme.of(context).primaryColor,
                    ),
                    icon: SvgPicture.asset(
                      'images/svg/Vector-3.svg',
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    activeIcon: SvgPicture.asset(
                      'images/svg/Vector-2.svg',
                      color: Theme.of(context).primaryColor,
                    ),
                    icon: SvgPicture.asset(
                      'images/svg/Vector-2.svg',
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                    label: 'Subscription',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.history),
                    label: 'Order',
                  ),
                  BottomNavigationBarItem(
                    activeIcon: SvgPicture.asset(
                      'images/svg/Group.svg',
                      color: Theme.of(context).primaryColor,
                    ),
                    icon: SvgPicture.asset(
                      'images/svg/Group.svg',
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                    label: 'Account',
                  )
                ]),
            tabBuilder: (BuildContext context, int index) {
              return IndexedStack(
                index: currentIndex,
                children: screens,
              );
            },
          ))
        : Scaffold(
            body: IndexedStack(
              index: currentIndex,
              children: screens,
            ),
            bottomNavigationBar: BottomNavigationBar(
                showUnselectedLabels: true,
                //backgroundColor: Theme.of(context).primaryColor,
                currentIndex: currentIndex,
                onTap: (index) => setState(() {
                      currentIndex = index;
                    }),
                selectedItemColor: Theme.of(context).primaryColor,
                selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
                unselectedItemColor: Theme.of(context).colorScheme.onBackground,
                items: [
                  BottomNavigationBarItem(
                    activeIcon: SvgPicture.asset(
                      'images/svg/Vector-3.svg',
                      color: Theme.of(context).primaryColor,
                    ),
                    icon: SvgPicture.asset(
                      'images/svg/Vector-3.svg',
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                    label: 'Home',
                    //  backgroundColor: Color.fromARGB(200, 39, 39, 39),
                  ),
                  BottomNavigationBarItem(
                    activeIcon: SvgPicture.asset(
                      'images/svg/Vector-2.svg',
                      color: Theme.of(context).primaryColor,
                    ),
                    icon: SvgPicture.asset(
                      'images/svg/Vector-2.svg',
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                    label: 'Subscription',
                    //  backgroundColor: Color.fromARGB(200, 39, 39, 39),
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.history),
                    label: 'Order',
                    // backgroundColor: Color.fromARGB(200, 39, 39, 39),
                  ),
                  BottomNavigationBarItem(
                    activeIcon: SvgPicture.asset(
                      'images/svg/Group.svg',
                      color: Theme.of(context).primaryColor,
                    ),
                    icon: SvgPicture.asset(
                      'images/svg/Group.svg',
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                    label: 'Account',
                    //  backgroundColor: Color.fromARGB(200, 39, 39, 39),
                  )
                ]),
          );
  }
}
