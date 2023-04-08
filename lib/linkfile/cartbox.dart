import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foodie_ios/linkfile/Model/cartrecieve.dart';

import 'package:foodie_ios/linkfile/provider/checkcart.dart';

Widget Cartbox(BuildContext context, checkcart value, int indexx, cart, image,
    multiple, food, extra, amount, total, cartresults) {
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
          child: Stack(
            children: [
              SizedBox(
                height: double.infinity,
                //  color: Colors.black,
                width: MediaQuery.of(context).size.width * 0.9,
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
                          height: MediaQuery.of(context).size.width * 0.23,
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
                                    fontWeight: FontWeight.bold, fontSize: 19),
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
                                  fontWeight: FontWeight.bold, fontSize: 17),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.07,
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: cartresults[indexx].extras!.length,
                                  itemBuilder: (context, index) {
                                    return Text(
                                      '${cartresults[indexx].extras![index].the5}',
                                      // overflow-: TextOverflow.ellipsis,
                                      style: const TextStyle(fontSize: 17),
                                    );
                                  }),
                            ),
                          ]),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.18,
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
                                    fontWeight: FontWeight.bold, fontSize: 17),
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.07,
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: cartresults[indexx].extras!.length,
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
                      left: MediaQuery.of(context).size.width * 0.19),
                  width: MediaQuery.of(context).size.width * 0.54,
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
                        errorWidget: (context, url, error) => Icon(Icons.error),
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                width: MediaQuery.of(context).size.width * 0.45,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(
                                        right:
                                            MediaQuery.of(context).size.width *
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
                                  height:
                                      MediaQuery.of(context).size.height * 0.6,
                                  width:
                                      MediaQuery.of(context).size.width * 0.45,
                                  padding: EdgeInsets.only(
                                    bottom: MediaQuery.of(context).size.height *
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
                                                MainAxisAlignment.spaceBetween,
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

Widget Cartbox2(BuildContext context, checkcart value, int indexx, cart, image,
    multiple, food, extra, amount, total, List<Pagnited> cartresults) {
  return Container(
    margin: const EdgeInsets.all(10),
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
                              height: MediaQuery.of(context).size.width * 0.23,
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
                                                  itemCount: cartresults[indexx]
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
                                                  itemCount: cartresults[indexx]
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
                                                  itemCount: cartresults[indexx]
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
          ],
        ),
      ],
    ),
  );
}

Future<dynamic> modalpopup2(BuildContext context, image, multiple, food, extra,
    amount, total, List<Pagnited> cartresults, indexx) {
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
                      style:
                          TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
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
                                width: MediaQuery.of(context).size.width * 0.55,
                                height:
                                    MediaQuery.of(context).size.height * 0.40,
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
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
                                        height:
                                            MediaQuery.of(context).size.height *
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
                                                          child:
                                                              ListView.builder(
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
                                                                        style: const TextStyle(
                                                                            fontSize:
                                                                                17),
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
                                                          child:
                                                              ListView.builder(
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
                                                                        style: const TextStyle(
                                                                            fontSize:
                                                                                17),
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
                                                          child:
                                                              ListView.builder(
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
                                                                        style: const TextStyle(
                                                                            fontSize:
                                                                                17),
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
