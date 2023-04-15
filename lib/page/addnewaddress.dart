import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:foodie_ios/linkfile/customesnackbar.dart';
import 'package:foodie_ios/linkfile/enum/connectivity_status.dart';
import 'package:foodie_ios/linkfile/provider/addTocart.dart';
import 'package:foodie_ios/linkfile/provider/checkcart.dart';
import 'package:foodie_ios/linkfile/provider/internetchecker.dart';
import 'package:foodie_ios/linkfile/provider/onboarding.dart';
import 'package:foodie_ios/page/landingpage.dart';
import 'package:foodie_ios/page/overlay.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class addAddress extends StatefulWidget {
  const addAddress({super.key, required this.save});
  final bool save;
  @override
  State<addAddress> createState() => _addAddressState();
}

class _addAddressState extends State<addAddress> {
  String fullname = '';
  String phone = '';
  String? email;
  String address = '';
  late FixedExtentScrollController _scrollController;
  late TextEditingController _controller;
  final items = [
    'School',
    'Labuta',
    'Agbede',
    'Kofesu',
    'Gate',
    'Harmony',
    'Accord',
    'Oluwo',
    'Isolu',
    'Camp'
  ];
  String? token;

  int index = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = TextEditingController(text: items[index]);
    _scrollController = FixedExtentScrollController(initialItem: index);

    checkregistered();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();

    _scrollController.dispose();
  }

  bool namechange = false;
  bool phonechange = false;
  bool addresschange = false;
  bool network = false;
  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();
    context.read<showrecent>().disposeint();
  }

  checkregistered() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      token = prefs.getString("tokenregistered");
    });
  }

  final GlobalKey<FormState> _key4 = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    if (Provider.of<ConnectivityStatus>(context) ==
        ConnectivityStatus.Offline) {
      showoverlay();
    } else {
      SmartDialog.dismiss(tag: 'network');
    }
    print(context.watch<checkcart>().fullname);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).primaryColorDark),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          'Add Address',
          style: TextStyle(
              color: Theme.of(context).primaryColorDark,
              fontSize: 27,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10, top: 8),
          child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(20)),
              child: Form(
                  key: _key4,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Full Name:',
                            style: TextStyle(
                                fontSize: 19, fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            onChanged: (value) {
                              setState(() {
                                fullname = value;
                                namechange = true;
                              });
                            },
                            initialValue: context.watch<checkcart>().fullname,
                            validator: _validateName,
                            decoration: InputDecoration(
                              errorBorder: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.red, width: 1.0),
                              ),
                              focusedErrorBorder: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.red, width: 1.7),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromARGB(255, 70, 70, 70),
                                    width: 1.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                    color: Color.fromARGB(255, 70, 70, 70),
                                    width: 1.7),
                              ),
                              hintText: 'Enter Your Full name here',
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Phone Number:',
                        style: TextStyle(
                            fontSize: 19, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        onChanged: (value) {
                          setState(() {
                            phone = value;
                            phonechange = true;
                          });
                        },
                        initialValue: context.watch<checkcart>().number,
                        keyboardType: TextInputType.number,
                        validator: _validatephone,
                        decoration: InputDecoration(
                          errorBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.red, width: 1.0),
                          ),
                          focusedErrorBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.red, width: 1.7),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 70, 70, 70),
                                width: 1.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 70, 70, 70),
                                width: 1.7),
                          ),
                          hintText: 'Mobile Number',
                        ),
                      ),
                      token == null
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  'Email:',
                                  style: TextStyle(
                                      fontSize: 19,
                                      fontWeight: FontWeight.w500),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  onChanged: (value) {
                                    setState(() {
                                      email = value;
                                    });
                                  },
                                  initialValue: token == null
                                      ? context
                                          .watch<checkstate>()
                                          .notloggedemail
                                      : context.watch<checkstate>().email,
                                  keyboardType: TextInputType.emailAddress,
                                  validator: _validateEmail,
                                  decoration: InputDecoration(
                                    errorBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.red, width: 1.0),
                                    ),
                                    focusedErrorBorder:
                                        const OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.red, width: 1.7),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              Color.fromARGB(255, 70, 70, 70),
                                          width: 1.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                          color:
                                              Color.fromARGB(255, 70, 70, 70),
                                          width: 1.7),
                                    ),
                                    hintText: 'Enter your email',
                                  ),
                                ),
                              ],
                            )
                          : SizedBox(),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Location:',
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      InkWell(
                        onTap: () {
                          _scrollController.dispose();
                          _scrollController =
                              FixedExtentScrollController(initialItem: index);
                          Platform.isIOS
                              ? showCupertinoModalPopup(
                                  context: context,
                                  builder: (context) => CupertinoActionSheet(
                                        title: Container(
                                          child: Text(
                                            'Choose Location',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 19),
                                          ),
                                        ),
                                        cancelButton:
                                            CupertinoActionSheetAction(
                                                child: Text(
                                                  'Cancel',
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                          .primaryColor),
                                                ),
                                                onPressed: (() =>
                                                    Navigator.pop(context))),
                                        actions: [
                                          buildpicker(),
                                        ],
                                      ))
                              : showModalBottomSheet(
                                  isDismissible: false,
                                  context: context,
                                  backgroundColor:
                                      Theme.of(context).scaffoldBackgroundColor,
                                  builder: (context) => Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.4,
                                        child: Column(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.all(20),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    'Choose Location',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 18),
                                                  ),
                                                  InkWell(
                                                      onTap: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: Icon(Icons.cancel))
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              child: ListView.builder(
                                                  itemCount: items.length,
                                                  shrinkWrap: true,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    return InkWell(
                                                      onTap: () {
                                                        context
                                                            .read<showrecent>()
                                                            .showindex(index);
                                                      },
                                                      child: picknetwork(
                                                          context, index),
                                                    );
                                                  }),
                                            )
                                          ],
                                        ),
                                      ));
                        },
                        child: Container(
                            height: 60,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 1,
                                    color: Color.fromARGB(255, 101, 101, 101)),
                                borderRadius: BorderRadius.circular(5)),
                            child: Center(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                  children: [
                                    Text(
                                      items[context.watch<showrecent>().index],
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ),
                            )),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Address:',
                        style: TextStyle(
                            fontSize: 19, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        onChanged: (value) {
                          setState(() {
                            address = value;
                            addresschange = true;
                          });
                        },
                        initialValue: context.watch<checkcart>().address,
                        validator: _validateaddress,
                        decoration: InputDecoration(
                          errorBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.red, width: 1.0),
                          ),
                          focusedErrorBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.red, width: 1.7),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 70, 70, 70),
                                width: 1.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 70, 70, 70),
                                width: 1.7),
                          ),
                          hintText: 'A detailed decription of where you live',
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            widget.save == false
                                ? SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.35,
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Theme.of(context)
                                                    .primaryColor
                                                    .withOpacity(.7)),
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                        )),
                                      ),
                                      onPressed: () {
                                        context
                                            .read<checkcart>()
                                            .usedefaultaddress();
                                        context.read<checkcart>().locationa();
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        'Use Defualt',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  )
                                : SizedBox(),
                            Consumer<checkstate>(
                                builder: (context, value, child) {
                              return SizedBox(
                                width: MediaQuery.of(context).size.width * 0.35,
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
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
                                    if (_key4.currentState!.validate()) {
                                      _key4.currentState!.save();

                                      String phoneget() {
                                        String value = '';
                                        if (phonechange == true) {
                                          value = phone;
                                        } else {
                                          value = Provider.of<checkcart>(
                                                  context,
                                                  listen: false)
                                              .number;
                                        }
                                        return value;
                                      }

                                      String addressget() {
                                        String value = '';
                                        if (addresschange == true) {
                                          value = address;
                                        } else {
                                          value = Provider.of<checkcart>(
                                                  context,
                                                  listen: false)
                                              .address;
                                        }
                                        return value;
                                      }

                                      String nameget() {
                                        String value = '';
                                        if (addresschange == true) {
                                          value = fullname;
                                        } else {
                                          value = Provider.of<checkcart>(
                                                  context,
                                                  listen: false)
                                              .fullname;
                                        }
                                        return value;
                                      }

                                      context.read<checkcart>().gettempaddress(
                                          nameget().trim(),
                                          phoneget().trim(),
                                          addressget().trim(),
                                          items[index]);
                                      context.read<checkcart>().locationa();
                                      Navigator.pop(context);
                                    }
                                  },
                                  child: Text(
                                    'Save',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    ],
                  ))),
        ),
      ),
    );
  }

  String? _validateName(String? value) {
    if (value!.length == 0) {
      return "Please Input Your Full Name";
    } else {
      return null;
    }
  }

  String? _validateaddress(String? value) {
    if (value!.length == 0) {
      return "Please Input Your Address";
    } else {
      return null;
    }
  }

  String? _validatephone(String? value) {
    if (value!.length != 11) {
      return "Must be Eleven digits";
    } else {
      return null;
    }
  }

  String? _validateEmail(String? value) {
    RegExp regex = new RegExp('[a-z0-9]+@[a-z]+\.[a-z]{2,3}.com');
    if (value!.length == 0) {
      return "Please Input a Email";
    } else if (!regex.hasMatch(value)) {
      return "Must Be a valid email";
    } else {
      return null;
    }
  }

  Container picknetwork(BuildContext context, int index) {
    final isSeleted = this.context.read<showrecent>().index == index;
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.05,
        vertical: MediaQuery.of(context).size.height * 0.01,
      ),
      height: 70,
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: isSeleted
              ? Border.all(color: Theme.of(context).primaryColor, width: 2)
              : Border.all(
                  color: Theme.of(context).colorScheme.onSurface,
                )),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SizedBox(
                width: 20,
              ),
              Text(
                '${items[index]}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Radio(
            value: index,
            activeColor: Theme.of(context).primaryColor,
            groupValue: context.watch<showrecent>().group,
            onChanged: (value) {
              context.read<showrecent>().showindex(value);
            },
          ),
        ],
      ),
    );
  }

  SizedBox buildpicker() {
    return SizedBox(
      height: 200,
      child: StatefulBuilder(
        builder: (context, setState) => CupertinoPicker(
          scrollController: _scrollController,
          selectionOverlay: CupertinoPickerDefaultSelectionOverlay(
            background:
                Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
          ),
          itemExtent: 60,
          children: List.generate(items.length, (index) {
            final isSelected = this.index == index;
            final item = items[index];
            final color = isSelected
                ? Theme.of(context).colorScheme.onSurface
                : Theme.of(context).colorScheme.onSurface.withOpacity(.5);
            return Center(
              child: Text(
                item,
                style: TextStyle(fontSize: 23, color: color),
              ),
            );
          }),
          onSelectedItemChanged: (index) {
            context.read<showrecent>().showindex(index);
            setState(() {
              this.index = index;
            });
          },
        ),
      ),
    );
  }
}
