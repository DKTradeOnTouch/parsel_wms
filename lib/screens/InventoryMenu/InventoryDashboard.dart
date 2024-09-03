import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:parsel_flutter/resource/app_helper.dart';
import 'package:parsel_flutter/resource/app_styles.dart';
import 'package:parsel_flutter/screens/AUth/drawer.dart';
import 'package:parsel_flutter/screens/InventoryMenu/Inward/inward_list_page.dart';
import 'package:parsel_flutter/screens/InventoryMenu/Packing/PackingList.dart';
import 'package:parsel_flutter/screens/InventoryMenu/Sorting/sortingFirstScreen.dart';
import 'package:parsel_flutter/screens/InventoryMenu/Storage/Storage.dart';

import '../../resource/app_colors.dart';
import 'PickingList/pickinglist.dart';

class InventoryDashboardScreen extends StatefulWidget {
  InventoryDashboardScreen({Key? key}) : super(key: key);

  @override
  State<InventoryDashboardScreen> createState() =>
      _InventoryDashboardScreenState();
}

class _InventoryDashboardScreenState extends State<InventoryDashboardScreen> {
  int isSelected = 1;

  List<String> listTitle = [
    'INWARD',
    'SORTING',
    'STORAGE',
    'PICKING LIST',
    'PACKING'
  ];

  inwardNavigation(context) {
    AppHelper.changeScreen(context, InwardListPage());
  }

  sortingNavigation(context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (_) => const SortingFirstScreen()));
  }

  PickingListSnavigation(context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (_) => const PickingListScreen()));
  }

  packingListnavigation(context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (_) => const PackingListScreen()));
  }

  storageNavigation(context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (_) => const StorageScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppHelper.appBar(
            context, 'INVENTORY', DrawerScreen(onLogoutTap: () {}), Icons.menu),
        body: SafeArea(
          child: Container(
            padding: const EdgeInsets.all(4),
            child: Center(
              child: Column(
                children: [
                  const SizedBox(
                    height: 32,
                  ),
                  InkWell(
                      onTap: () {
                        setState(() {
                          isSelected = 1;
                        });
                        inwardNavigation(context);
                      },
                      child: isSelected == 1
                          ? Container(
                              height: 56,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: AppColors.whiteColor,
                                boxShadow: const [
                                  BoxShadow(
                                    color: AppColors
                                        .dashBoardCardBackground, //color of shadow
                                    spreadRadius: 1, //spread radius
                                    blurRadius: 1, // blur radius
                                  ),
                                  //you can set more BoxShadow() here
                                ],
                              ),
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 35, vertical: 8),
                              child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.transparent, width: 1.0),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(
                                            5.0) //                 <--- border radius here
                                        ),
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        HexColor('#0137FF'),
                                        HexColor('#002BCA')
                                      ],
                                    ),
                                  ),
                                  width: MediaQuery.of(context).size.width,
                                  child: ListTile(
                                    leading: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SvgPicture.asset(
                                        "assets/inward.svg",
                                        semanticsLabel: 'Acme Logo',
                                        color: Colors.yellow,
                                      ),
                                    ),
                                    title: Text(
                                      listTitle[0],
                                      style: AppStyles.dashBoardWhiteTextStyle,
                                    ),
                                  )),
                            )
                          : Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: AppColors.whiteColor,
                                boxShadow: const [
                                  BoxShadow(
                                    color: AppColors
                                        .dashBoardCardBackground, //color of shadow
                                    spreadRadius: 1, //spread radius
                                    blurRadius: 1, // blur radius
                                  ),
                                  //you can set more BoxShadow() here
                                ],
                              ),
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 35, vertical: 8),
                              child: ListTile(
                                leading: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SvgPicture.asset("assets/inward.svg",
                                      color: HexColor('#0137FF'),
                                      semanticsLabel: 'Acme Logo'),
                                ),
                                title: Text(
                                  listTitle[0],
                                  style: AppStyles.dashBoardTextStyle,
                                ),
                              ))),
                  InkWell(
                      onTap: () {
                        setState(() {
                          isSelected = 2;
                        });
                        sortingNavigation(context);
                      },
                      child: isSelected == 2
                          ? Container(
                              height: 56,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: AppColors.whiteColor,
                                boxShadow: const [
                                  BoxShadow(
                                    color: AppColors
                                        .dashBoardCardBackground, //color of shadow
                                    spreadRadius: 1, //spread radius
                                    blurRadius: 1, // blur radius
                                  ),
                                  //you can set more BoxShadow() here
                                ],
                              ),
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 35, vertical: 8),
                              child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.transparent, width: 1.0),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(
                                            5.0) //                 <--- border radius here
                                        ),
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        HexColor('#0137FF'),
                                        HexColor('#002BCA')
                                      ],
                                    ),
                                  ),
                                  width: MediaQuery.of(context).size.width,
                                  child: ListTile(
                                    leading: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SvgPicture.asset(
                                        "assets/sorting.svg",
                                        semanticsLabel: 'Acme Logo',
                                        color: Colors.yellow,
                                      ),
                                    ),
                                    title: Text(
                                      listTitle[1],
                                      style: AppStyles.dashBoardWhiteTextStyle,
                                    ),
                                  )),
                            )
                          : Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: AppColors.whiteColor,
                                boxShadow: const [
                                  BoxShadow(
                                    color: AppColors
                                        .dashBoardCardBackground, //color of shadow
                                    spreadRadius: 1, //spread radius
                                    blurRadius: 1, // blur radius
                                  ),
                                  //you can set more BoxShadow() here
                                ],
                              ),
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 35, vertical: 8),
                              child: ListTile(
                                leading: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SvgPicture.asset("assets/sorting.svg",
                                      color: HexColor('#0137FF'),
                                      semanticsLabel: 'Acme Logo'),
                                ),
                                title: Text(
                                  listTitle[1],
                                  style: AppStyles.dashBoardTextStyle,
                                ),
                              ))),
                  InkWell(
                      onTap: () {
                        setState(() {
                          isSelected = 3;
                        });
                        storageNavigation(context);
                      },
                      child: isSelected == 3
                          ? Container(
                              height: 56,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: AppColors.whiteColor,
                                boxShadow: const [
                                  BoxShadow(
                                    color: AppColors
                                        .dashBoardCardBackground, //color of shadow
                                    spreadRadius: 1, //spread radius
                                    blurRadius: 1, // blur radius
                                  ),
                                  //you can set more BoxShadow() here
                                ],
                              ),
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 35, vertical: 8),
                              child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.transparent, width: 1.0),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(
                                            5.0) //                 <--- border radius here
                                        ),
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        HexColor('#0137FF'),
                                        HexColor('#002BCA')
                                      ],
                                    ),
                                  ),
                                  width: MediaQuery.of(context).size.width,
                                  child: ListTile(
                                    leading: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SvgPicture.asset(
                                        "assets/inward.svg",
                                        semanticsLabel: 'Acme Logo',
                                        color: Colors.yellow,
                                      ),
                                    ),
                                    title: Text(
                                      listTitle[2],
                                      style: AppStyles.dashBoardWhiteTextStyle,
                                    ),
                                  )),
                            )
                          : Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: AppColors.whiteColor,
                                boxShadow: const [
                                  BoxShadow(
                                    color: AppColors
                                        .dashBoardCardBackground, //color of shadow
                                    spreadRadius: 1, //spread radius
                                    blurRadius: 1, // blur radius
                                  ),
                                  //you can set more BoxShadow() here
                                ],
                              ),
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 35, vertical: 8),
                              child: ListTile(
                                leading: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SvgPicture.asset("assets/inward.svg",
                                      color: HexColor('#0137FF'),
                                      semanticsLabel: 'Acme Logo'),
                                ),
                                title: Text(
                                  listTitle[2],
                                  style: AppStyles.dashBoardTextStyle,
                                ),
                              ))),
                  InkWell(
                      onTap: () {
                        setState(() {
                          isSelected = 4;
                        });
                        PickingListSnavigation(context);
                      },
                      child: isSelected == 4
                          ? Container(
                              height: 56,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: AppColors.whiteColor,
                                boxShadow: const [
                                  BoxShadow(
                                    color: AppColors
                                        .dashBoardCardBackground, //color of shadow
                                    spreadRadius: 1, //spread radius
                                    blurRadius: 1, // blur radius
                                  ),
                                  //you can set more BoxShadow() here
                                ],
                              ),
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 35, vertical: 8),
                              child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.transparent, width: 1.0),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(
                                            5.0) //                 <--- border radius here
                                        ),
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        HexColor('#0137FF'),
                                        HexColor('#002BCA')
                                      ],
                                    ),
                                  ),
                                  width: MediaQuery.of(context).size.width,
                                  child: ListTile(
                                    leading: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SvgPicture.asset(
                                        "assets/packingList.svg",
                                        semanticsLabel: 'Acme Logo',
                                        color: Colors.yellow,
                                      ),
                                    ),
                                    title: Text(
                                      listTitle[3],
                                      style: AppStyles.dashBoardWhiteTextStyle,
                                    ),
                                  )),
                            )
                          : Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: AppColors.whiteColor,
                                boxShadow: const [
                                  BoxShadow(
                                    color: AppColors
                                        .dashBoardCardBackground, //color of shadow
                                    spreadRadius: 1, //spread radius
                                    blurRadius: 1, // blur radius
                                  ),
                                  //you can set more BoxShadow() here
                                ],
                              ),
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 35, vertical: 8),
                              child: ListTile(
                                leading: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SvgPicture.asset(
                                      "assets/packingList.svg",
                                      color: HexColor('#0137FF'),
                                      semanticsLabel: 'Acme Logo'),
                                ),
                                title: Text(
                                  listTitle[3],
                                  style: AppStyles.dashBoardTextStyle,
                                ),
                              ))),
                  InkWell(
                      onTap: () {
                        setState(() {
                          isSelected = 5;
                        });
                        packingListnavigation(context);
                      },
                      child: isSelected == 5
                          ? Container(
                              height: 56,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: AppColors.whiteColor,
                                boxShadow: const [
                                  BoxShadow(
                                    color: AppColors
                                        .dashBoardCardBackground, //color of shadow
                                    spreadRadius: 1, //spread radius
                                    blurRadius: 1, // blur radius
                                  ),
                                  //you can set more BoxShadow() here
                                ],
                              ),
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 35, vertical: 8),
                              child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.transparent, width: 1.0),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(
                                            5.0) //                 <--- border radius here
                                        ),
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        HexColor('#0137FF'),
                                        HexColor('#002BCA')
                                      ],
                                    ),
                                  ),
                                  width: MediaQuery.of(context).size.width,
                                  child: ListTile(
                                    leading: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SvgPicture.asset(
                                        "assets/storage.svg",
                                        semanticsLabel: 'Acme Logo',
                                        color: Colors.yellow,
                                      ),
                                    ),
                                    title: Text(
                                      listTitle[4],
                                      style: AppStyles.dashBoardWhiteTextStyle,
                                    ),
                                  )),
                            )
                          : Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: AppColors.whiteColor,
                                boxShadow: const [
                                  BoxShadow(
                                    color: AppColors
                                        .dashBoardCardBackground, //color of shadow
                                    spreadRadius: 1, //spread radius
                                    blurRadius: 1, // blur radius
                                  ),
                                  //you can set more BoxShadow() here
                                ],
                              ),
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 35, vertical: 8),
                              child: ListTile(
                                leading: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SvgPicture.asset("assets/storage.svg",
                                      color: HexColor('#0137FF'),
                                      semanticsLabel: 'Acme Logo'),
                                ),
                                title: Text(
                                  listTitle[4],
                                  style: AppStyles.dashBoardTextStyle,
                                ),
                              ))),
                ],
              ),
              // itemBuilder: (context, indx) {
              //   return InkWell(
              //     onTap: () {
              //       listTitle[indx] == 'Inward'
              //           ? inwardNavigation(context)
              //           : listTitle[indx] == 'Sorting'
              //               ? sortingNavigation(context)
              //               : listTitle[indx] == 'Packing List'
              //                   ?
              //                   // packingListnavigation(context)
              //                   AppHelper.changeScreen(
              //                       context, PackingListPage())
              //                   : storageNavigation(context);
              //     },
              //     child: Card(
              //       shadowColor: Colors.black,
              //       elevation: 5,
              //       margin: EdgeInsets.all(4.0),
              //       color: Colors.white,
              //       child: Padding(
              //         padding: const EdgeInsets.only(
              //             left: 12.0, top: 6.0, bottom: 2.0),
              //         child: Row(
              //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //           children: [
              //             Container(
              //                 height: 20,
              //                 width: 20,
              //                 child: Image.asset('assets/parsellogo.png')),
              //             Text(
              //               listTitle[indx],
              //               style: TextStyle(
              //                   fontSize: 20,
              //                   color: Colors.black,
              //                   fontWeight: FontWeight.bold),
              //             ),
              //           ],
              //         ),
              //       ),
              //     ),
              //   );
              // },
            ),
          ),
        ));
  }
}
