import 'dart:convert';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:number_inc_dec/number_inc_dec.dart';
import 'package:parsel_flutter/models/despatch_sum_model.dart';
import 'package:parsel_flutter/resource/app_logs.dart';
import 'package:parsel_flutter/resource/app_styles.dart';
import 'package:parsel_flutter/screens/Pending/pickuppoint.dart';
import 'package:parsel_flutter/src/widget/widget.dart';
import 'package:parsel_flutter/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/api.dart';
import '../../models/SkuList_model.dart';
import '../../models/pickupQ_Model.dart';
import '../../resource/app_colors.dart';
import '../../resource/app_fonts.dart';
import '../../resource/app_helper.dart';
import '../../resource/app_strings.dart';
import '../despatch_summary/despatch_summery_page.dart';

class PickupOrderScreen extends StatefulWidget {
  const PickupOrderScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return PickupOrdersStateScreen();
  }
}

class PickupOrdersStateScreen extends State<PickupOrderScreen> {
  bool _isLoading = false;

  Future pickedUpQuantity(BuildContext context) async {
    final preference = await SharedPreferences.getInstance();
    setState(() {
      _isLoading = true;
    });
    return await API.pickedUpQuantity(context,
        showNoInternet: true,
        Authtoken: preference.getString("token").toString(),
        body: {}).then(
      (pickupQ_Model? response) async {
        setState(() {
          _isLoading = false;
        });
        appLogs('Response -->' + response.toString());
        if (response != null) {
          //   AppHelper.showSnackBar(context, AppStrings.strLoginSuccessFully);

          //  AppHelper.changeScreen(context, DashBoardScreen());
        } else {
          AppHelper.showSnackBar(context, AppStrings.strSomethingWentWrong);
        }
      },
    ).onError((error, stackTrace) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  bool? value = false;

  List<SkuDetails> skuList = [];

  @override
  void initState() {
    super.initState();
    if (ConnectivityHandler.connectivityResult .contains( ConnectivityResult.none) ){
      String pickUpOrderSkuList = VariableUtilities.preferences.getString(
            LocalCacheKey.pickUpOrderSkuList,
          ) ??
          '';
      appLogs("pickUpOrderSkuList--> $pickUpOrderSkuList");
      if (pickUpOrderSkuList.isNotEmpty) {
        List<SkuDetails> prefsSkuList = List<SkuDetails>.from(
            jsonDecode(pickUpOrderSkuList).map((x) => SkuDetails.fromJson(x)));

        skuList = prefsSkuList;
      }
    } else {
      getSalesOrderSKUList(context);
    }
    /* skuList.add(SkuDetails(skuName: "PILLSBURY WALNUT BROWNIE 1.4KG)",
        unitPrice: 577.5156,price:577.5156 ,qty: 1),);
    skuList.add(SkuDetails(skuName: "PILLSBURY CHOCO ECSRTACY LAVA CAKE(80GMSX36PC)",
        unitPrice: 1116.5042,price:1116.5042 ,qty: 1),);*/
    // getOrderedQuantityToDeliveryDriver(context);
  }

  Future getSalesOrderSKUList(BuildContext context) async {
    final preference = await SharedPreferences.getInstance();
    setState(() {
      _isLoading = true;
    });
    return await API
        .getSalesOrderSKUList(
      context,
      showNoInternet: true,
      Authtoken: preference.getString("token").toString(),
      DEIVERID: preference.getString("userID").toString(),
    )
        .then(
      (SkuListModel? response) async {
        setState(() {
          _isLoading = false;
        });
        appLogs('Response -->' + response.toString());
        // SkuListModel sk= SkuListModel.fromJson(json)
        if (response != null) {
          if (response.body != null) {
            response.body!.data.skuDetails.map((e) => skuList.add(e)).toList();
            appLogs("skuList==> ${skuList.length}");

            if (skuList.isNotEmpty) {
              VariableUtilities.preferences.setString(
                  LocalCacheKey.pickUpOrderSkuList, jsonEncode(skuList));
              appLogs(
                  "pickUpOrderSkuList--> ${VariableUtilities.preferences.getString(LocalCacheKey.pickUpOrderSkuList)}");
            }
          }
        } else {
          AppHelper.showSnackBar(context, AppStrings.strSomethingWentWrong);
        }
      },
    ).onError((error, stackTrace) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          bottomNavigationBar: skuList.isNotEmpty
              ? SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: InkWell(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              // To display the title it is optional
                              content: SizedBox(
                                height: 200,
                                width: 290,
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    SvgPicture.asset("assets/logo.svg",
                                        height: 40,
                                        width: 40,
                                        semanticsLabel: 'Acme Logo'),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Center(
                                        child: Text(
                                      'Pick Up Order',
                                      style: TextStyle(
                                          color: HexColor("#0137FF"),
                                          fontFamily: appFontFamily,
                                          fontWeight: FontWeight.bold),
                                    )),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    const Text(
                                      'Are you sure you want to pick\n up the orders that you have\n selected? You can not visit the\n same store again.',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontFamily: appFontFamily,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 15,
                                          color: AppColors.blackColor),
                                    ),
                                  ],
                                ),
                              ), // Message which will be pop up on the screen
                              // Action widget which will provide the user to acknowledge the choice
                              actions: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Expanded(
                                      child: InkWell(
                                          onTap: () {
                                            Navigator.of(context).pop();
                                          }, // function used to perform after pressing the button
                                          child: Container(
                                              height: 40,
                                              alignment: Alignment.center,
                                              padding: const EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                color: Colors.black,
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                                boxShadow: const [
                                                  BoxShadow(
                                                    color: Colors.black12,
                                                    offset: Offset(5, 5),
                                                    blurRadius: 10,
                                                  )
                                                ],
                                              ),
                                              child: const Text(
                                                'CANCEL',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ))),
                                    ),
                                    const SizedBox(width: 5),
                                    Expanded(
                                      child: InkWell(
                                          onTap: () {
                                            setState(() {});
                                            //  confirmGroupOrder(context);
                                            AppHelper.changeScreen(context,
                                                const DespatchSummary());
                                          },
                                          child: Container(
                                              height: 40,
                                              alignment: Alignment.center,
                                              padding: const EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                color: Colors.black,
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                                boxShadow: const [
                                                  BoxShadow(
                                                    color: Colors.black12,
                                                    offset: Offset(5, 5),
                                                    blurRadius: 10,
                                                  )
                                                ],
                                              ),
                                              child: const Text(
                                                'OK',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ))),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          });
                    },
                    child: Container(
                      color: HexColor('#0137FF'),
                      height: 60,
                      width: MediaQuery.of(context).size.width,
                      child: const Center(
                          child: Text(
                        "PICK UP",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w700),
                      )),
                    ),
                  ))
              : Container(
                  height: 50,
                ),
          appBar: AppHelper.appBar(
            context,
            'PICK UP ORDERS',
            Pickuppoint(
                despatchDetails: DespatchSummaryDetails(
                    deliveryPoint: '',
                    deliveryTime: '',
                    docTime: '',
                    driverName: '',
                    managerName: '',
                    noOfParcel: '',
                    photoUrl: '',
                    skuCount: 0,
                    skuQtyCount: '0',
                    temp: '0')),
            Icons.arrow_back_ios,
          ),
          body: skuList.isNotEmpty
              ? ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: skuList.length,
                  itemBuilder: (BuildContext context, index) {
                    return Container(
                      // height: MediaQuery.of(context).size.height * 0.1,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 8),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 4,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4.0, vertical: 2.0),
                                  child: Column(
                                    children: [
                                      Text(
                                        skuList[index].skuName.toString(),
                                        style: AppStyles.pickUpOrders,
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    // Expanded(
                                    //   flex: 2,
                                    //   child: Padding(
                                    //     padding: const EdgeInsets.all(4.0),
                                    //     child: Text("COST",
                                    //         style: AppStyles.pickUpOrdersBold),
                                    //   ),
                                    // ),
                                    // Expanded(
                                    //   flex: 3,
                                    //   child:
                                    Text("QTY",
                                        style: AppStyles.pickUpOrdersBold),
                                    // )
                                  ],
                                ),
                                Row(
                                  // mainAxisAlignment: MainAxisAlignment.start,
                                  // crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // Expanded(
                                    //   flex: 2,
                                    //   child: Padding(
                                    //     padding: const EdgeInsets.all(4.0),
                                    //     child: Text(
                                    //         '\u{20B9}${skuList[index].price}',
                                    //         style: AppStyles.pickUpOrdersCost),
                                    //   ),
                                    // ),
                                    // Expanded(
                                    //   flex: 3,
                                    //   child:
                                    Text(skuList[index].qty.toString(),
                                        style: AppStyles.pickUpOrdersCost),
                                    // )
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                              flex: 2,
                              child: SizedBox(
                                width: 45,
                                height: 30,
                                //   decoration: BoxDecoration(
                                //     border:
                                //         Border.all(color: Colors.grey, width: 1.0),
                                //     borderRadius: BorderRadius.all(Radius.circular(
                                //             5.0) //                 <--- border radius here
                                //         ),
                                //   ),
                                child: Center(
                                  child: NumberInputPrefabbed.roundedButtons(
                                    controller: TextEditingController(),
                                    incDecBgColor: Colors.lightBlue,
                                    style: const TextStyle(fontSize: 12),
                                    buttonArrangement:
                                        ButtonArrangement.incLeftDecRight,
                                    initialValue: skuList[index].qty,
                                  ),

                                  // Text(
                                  //   "${skuList[index].qty.toString()}",
                                  //   style: TextStyle(color: HexColor('#4FB24D')),
                                  // ),
                                ),
                              ))
                        ],
                      ),
                    );
                  })
              : const Center(
                  child: Text(
                  "No data",
                  style: TextStyle(color: Colors.black),
                )),
        ),
        Visibility(
            visible: _isLoading, child: CustomCircularProgressIndicator())
      ],
    );
  }
}
