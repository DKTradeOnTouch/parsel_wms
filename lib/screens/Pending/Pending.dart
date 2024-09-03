import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:parsel_flutter/models/SkuList_model.dart';
import 'package:parsel_flutter/models/despatch_sum_model.dart';
import 'package:parsel_flutter/resource/app_fonts.dart';
import 'package:parsel_flutter/resource/app_logs.dart';
import 'package:parsel_flutter/resource/app_styles.dart';
import 'package:parsel_flutter/src/widget/widget.dart';
import 'package:parsel_flutter/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Provider/Invoice_Controller.dart';
import '../../api/api.dart';
import '../../models/COUNT_MODAL.dart';
import '../../models/InvoiceList_model.dart' as il;
import '../../resource/app_colors.dart';
import '../../resource/app_helper.dart';
import '../../resource/app_strings.dart';
import 'pickuppoint.dart';

class Pending extends StatefulWidget {
  final int tabSelection;
  const Pending({
    Key? key,
    required this.tabSelection,
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return Pendingstate();
  }
}

class Pendingstate extends State<Pending> {
  int? tabValue;
  bool _isLoading = false;

  List<il.ResultList> invoiceResultList = [];
  List<il.ItemList> itemList = [];
  List<SkuDetails> skuList = [];

  int pending = 0;
  @override
  void initState() {
    tabValue = widget.tabSelection;
    super.initState();
    getSalesOrderListByStatusInvoiceList(context);
    getSalesOrderSKUList(context);
    getCountAPINew(context);
  }

  Future getSalesOrderListByStatusInvoiceList(BuildContext context) async {
    final preference = await SharedPreferences.getInstance();
    setState(() {
      _isLoading = true;
    });
    return await API
        .getSalesOrderListByStatusInvoiceList(context,
            showNoInternet: true,
            Authtoken: preference.getString("token").toString(),
            DEIVERID: preference.getString("userID").toString(),
            STATUS: 'IN_GROUP',
            TODAYDATE: DateFormat('yyyy-MM-dd').format((DateTime.now())))
        .then(
      (il.InvoiceListModel? response) async {
        setState(() {
          _isLoading = false;
        });

        appLogs('Response-->' + response.toString());
        if (response != null) {
          response.body.data.resultList
              .map((e) => invoiceResultList.add(e))
              .toList();
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

  Future getCountAPINew(BuildContext context) async {
    appLogs('count--> in CountAPINEW');
    final preference = await SharedPreferences.getInstance();
    String token = preference.getString('token').toString();
    String userID = preference.getString('userID').toString();
    appLogs('Token-->' + token);
    appLogs('userId-->' + userID);
    setState(() {
      _isLoading = true;
    });
    return await API
        .getCountApiNew(context,
            showNoInternet: true,
            Authtoken: token,
            userId: userID,
            TODAYDATE: DateFormat('yyyy-MM-dd').format((DateTime.now())))
        .then(
      (CountApiModalNew? response) async {
        setState(() {
          _isLoading = false;
        });
        appLogs('count api new Response-->' + response.toString());
        if (response != null) {
          if (response.status == true) {
            pending = response.body.inGroup;
            appLogs('pending-->' + pending.toString());
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
        appLogs('Response-->' + response.toString());
        if (response != null && response.body != null) {
          response.body!.data.skuDetails.map((e) => skuList.add(e)).toList();
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
    Size size = MediaQuery.of(context).size;

    return Consumer<InvoiceController>(
        builder: (context, invoiceController, child) {
      return Stack(
        children: [
          Scaffold(
            body: SingleChildScrollView(
                child: Column(children: [
              Container(
                height: 155,
                color: Colors.white,
                child: SizedBox(
                  height: size.height * 0.20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 39,
                      ),
                      InkWell(
                          onTap: () {
                            setState(() {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => Pickuppoint(
                                          despatchDetails:
                                              DespatchSummaryDetails(
                                                  deliveryPoint: '',
                                                  deliveryTime: '',
                                                  docTime: '',
                                                  driverName: '',
                                                  managerName: '',
                                                  noOfParcel: '',
                                                  photoUrl: '',
                                                  skuCount: 0,
                                                  skuQtyCount: '0',
                                                  temp: '0'))));
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 40),
                            child: Text(
                              DateFormat("dd.MM.yyyy")
                                  .format(DateTime.now())
                                  .toString(),
                              style: TextStyle(
                                  fontSize: 18,
                                  color: ColorUtils.dateColor,
                                  fontFamily: appFontFamily,
                                  fontWeight: FontWeight.w600),
                            ),
                          )),
                      const SizedBox(
                        height: 17,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 35),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 48,
                              decoration: BoxDecoration(
                                border: Border.all(width: 1.0),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(
                                        5.0) //                 <--- border radius here
                                    ),
                              ),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: ColorUtils.buttonColor),
                                onPressed: () {
                                  setState(() {
                                    tabValue = 1;
                                    // getSalesOrderListByStatusInvoiceList(context);
                                    // getSalesOrderListByStatus(context);
                                  });
                                },
                                child: Text(
                                  "INVOICE (${pending.toString()})",
                                  style: TextStyle(
                                      color: tabValue == 1
                                          ? Colors.yellow
                                          : Colors.white,
                                      fontSize: 13,
                                      fontFamily: appFontFamily,
                                      letterSpacing: 1,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 30,
                            ),
                            Container(
                              height: 48,
                              decoration: BoxDecoration(
                                border: Border.all(width: 1.0),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(
                                        5.0) //                 <--- border radius here
                                    ),
                              ),
                              child: ElevatedButton(
                                // color: ColorUtils.ButtonColor,
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: ColorUtils.buttonColor),
                                onPressed: () {
                                  setState(() {
                                    //  getSalesOrderListByStatusSKUList(context);
                                    tabValue = 2;
                                    appLogs(tabValue);
                                  });
                                },
                                child: Text(
                                  "SKU'S",
                                  style: TextStyle(
                                      color: tabValue == 2
                                          ? Colors.yellow
                                          : Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              tabValue == 1
                  ? invoiceResultList.isNotEmpty
                      ? SizedBox(
                          height: 400,
                          child: ListView.builder(
                              itemCount: invoiceResultList.length,
                              itemBuilder: (BuildContext context, index) {
                                appLogs(invoiceResultList.length);
                                return Stack(
                                  clipBehavior: Clip.antiAlias,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 10),
                                      child: Card(
                                        elevation: 4,
                                        shadowColor:
                                            Colors.black.withOpacity(0.2),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 2.0,
                                                      horizontal: 8.0),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  const Expanded(
                                                    flex: 2,
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.all(8.0),
                                                      child: Text(
                                                        'CUSTOMER ID',
                                                        style: TextStyle(
                                                            fontFamily:
                                                                appFontFamily,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: AppColors
                                                                .blueColor),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 3,
                                                    child: Text(
                                                        invoiceResultList[index]
                                                            .id
                                                            .toString(),
                                                        style: TextStyle(
                                                            fontFamily:
                                                                appFontFamily,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: AppColors
                                                                .black2Color
                                                                .withOpacity(
                                                                    0.6))),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 2.0,
                                                      horizontal: 8.0),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  const Expanded(
                                                    flex: 2,
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.all(8.0),
                                                      child: Text(
                                                        'CUSTOMER NAME',
                                                        style: TextStyle(
                                                            fontFamily:
                                                                appFontFamily,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: AppColors
                                                                .blueColor),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 3,
                                                    child: Text(
                                                        invoiceResultList[index]
                                                            .store
                                                            .storeName
                                                            .toString(),
                                                        style: TextStyle(
                                                            fontFamily:
                                                                appFontFamily,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: AppColors
                                                                .black2Color
                                                                .withOpacity(
                                                                    0.6))),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 2.0,
                                                      horizontal: 8.0),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  const Expanded(
                                                    flex: 2,
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.all(8.0),
                                                      child: Text(
                                                        'ADDRESS',
                                                        style: TextStyle(
                                                            fontFamily:
                                                                appFontFamily,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: AppColors
                                                                .blueColor),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 3,
                                                    child: Column(
                                                      children: [
                                                        Text(
                                                            invoiceResultList[
                                                                    index]
                                                                .deliveryAddress
                                                                .toString(),
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    appFontFamily,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: AppColors
                                                                    .black2Color
                                                                    .withOpacity(
                                                                        0.6))),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 2.0,
                                                      horizontal: 8.0),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  const Expanded(
                                                    flex: 2,
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.all(8.0),
                                                      child: Text(
                                                        'INVOICE NO.',
                                                        style: TextStyle(
                                                            fontFamily:
                                                                appFontFamily,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: AppColors
                                                                .blueColor),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 3,
                                                    child: Text(
                                                        invoiceResultList[index]
                                                            .salesOrderId
                                                            .toString(),
                                                        style: TextStyle(
                                                            fontFamily:
                                                                appFontFamily,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: AppColors
                                                                .black2Color
                                                                .withOpacity(
                                                                    0.6))),
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                        right: 35,
                                        left: null,
                                        top: 22,
                                        child: Container(
                                          child: const Icon(
                                            Icons.phone,
                                            size: 30,
                                            color: Colors.white,
                                          ),
                                          decoration: BoxDecoration(
                                            shape: BoxShape
                                                .circle, // You can use like this way or like the below line
                                            //borderRadius: new BorderRadius.circular(30.0),
                                            color: ColorUtils.primaryColor,
                                          ),
                                          height: 40,
                                          width: 40,
                                        )),
                                  ],
                                );
                              }),
                        )
                      : const Padding(
                          padding: EdgeInsets.only(top: 58.0),
                          child: Center(
                              child: Center(
                            child: Text("No Data found"),
                          )),
                        )
                  : skuList.isNotEmpty
                      ? SizedBox(
                          height: 400,
                          child: ListView.builder(
                              itemCount: skuList.length,
                              itemBuilder: (BuildContext context, index) {
                                return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 18.0, vertical: 0.0),
                                    child: SizedBox(
                                      height: 114,
                                      child: Card(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 14.0, vertical: 4),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      skuList[index]
                                                          .skuName
                                                          .toString(),
                                                      style: const TextStyle(
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 0.0,
                                                        horizontal: 8.0),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Expanded(
                                                      flex: 2,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(4.0),
                                                        child: Text(
                                                          "COST",
                                                          style: TextStyle(
                                                              fontSize: 10,
                                                              color: HexColor(
                                                                  '#99202020'),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700),
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 3,
                                                      child: Text(
                                                        "QTY",
                                                        style: TextStyle(
                                                            fontSize: 10,
                                                            color: HexColor(
                                                                '#99202020'),
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 0.0,
                                                        horizontal: 8.0),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Expanded(
                                                      flex: 2,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(4.0),
                                                        child: Text(
                                                          "₹ ${skuList[index].unitPrice.toString()}",
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .grey,
                                                                  fontSize: 12),
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 3,
                                                      child: Text(
                                                        skuList[index]
                                                            .qty
                                                            .toString(),
                                                        style: const TextStyle(
                                                            fontSize: 12,
                                                            color: Colors.grey),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ));
                              }),
                        )
                      : const Center(child: Text('NO SKU LIST'))
            ])),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            floatingActionButton:
                Column(mainAxisAlignment: MainAxisAlignment.end, children: [
              FloatingActionButton(
                backgroundColor: ColorUtils.kBottomButtonColor,
                child: const Icon(
                  Icons.question_mark,
                  color: Colors.white,
                ),
                onPressed: () {
                  //...
                },
                heroTag: null,
              ),
              const SizedBox(height: 10),
              FloatingActionButton(
                backgroundColor: ColorUtils.kBottomButtonColor,
                child: const Icon(
                  Icons.phone_outlined,
                  color: Colors.white,
                ),
                onPressed: () {},
                heroTag: null,
              ),
            ]),
            appBar: PreferredSize(
              preferredSize:
                  const Size.fromHeight(80.0), // here the desired height
              child: AppBar(
                backgroundColor: Colors.black,
                title: Container(
                  padding: const EdgeInsets.only(top: 20),
                  margin: const EdgeInsets.only(top: 43, left: 34, bottom: 21),
                  child: Text('PENDING(${pending.toString()})',
                      style: AppStyles.appBarTitleStyle),
                ),
                leading: GestureDetector(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Container(
                      padding: const EdgeInsets.only(top: 30),
                      height: 15,
                      width: 15,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back_ios),
                          iconSize: 20.0,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ),
                  ),
                  onTap: () {},
                ),
              ),
            ),
          ),
          Visibility(
              visible: _isLoading, child: CustomCircularProgressIndicator())
        ],
      );
    });
  }
}
