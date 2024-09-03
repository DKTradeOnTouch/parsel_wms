import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:parsel_flutter/Provider/Delivery_Controller.dart';
import 'package:parsel_flutter/utils/connectivity/connectivity.dart';
import 'package:parsel_flutter/utils/storage/storage.dart';
import 'package:parsel_flutter/resource/app_colors.dart';
import 'package:parsel_flutter/resource/app_fonts.dart';
import 'package:parsel_flutter/resource/app_icons.dart';
import 'package:parsel_flutter/resource/app_strings.dart';
import 'package:parsel_flutter/resource/app_styles.dart';
import 'package:parsel_flutter/screens/payment/cashPayment.dart';
import 'package:parsel_flutter/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/uploadsalesorder_model.dart' as uplds;
import '../../models/SalesOrderBYID_Model.dart' as SALES;

import '../../api/api.dart';
import '../../models/SalesOrderBYID_Model.dart';
import '../../resource/app_helper.dart';

class SummaryPage extends StatefulWidget {
  const SummaryPage(
      {Key? key,
      required this.id,
      required this.Salesorderid,
      required this.deliverOrdersList,
      required this.dataList,
      required this.dataup,
      required this.salesOrder})
      : super(key: key);
  final String id;
  final String Salesorderid;

  final List<SALES.ItemList> deliverOrdersList;
  final List<SALES.ItemList> dataList;
  final List<uplds.ItemList> dataup;
  final SALES.SalesOrderBYID_Model salesOrder;
  @override
  State<StatefulWidget> createState() {
    return SummaryPageState();
  }
}

class SummaryPageState extends State<SummaryPage> {
  bool _isLoading = true;
  String? Salevale;
  List<ItemList> _DeliverOrdersList = [];
  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (ConnectivityHandler.connectivityResult
          .contains(ConnectivityResult.none)) {
        Salevale = VariableUtilities.preferences.getString(
                "${LocalCacheKey.deliverySummaryPaymentSaleVal}${widget.Salesorderid}") ??
            '';
        String prefsDataDeliverOrder = VariableUtilities.preferences.getString(
                "${LocalCacheKey.deliverDeliverOrdersList}${widget.Salesorderid}") ??
            '';
        final deliveryController =
            Provider.of<DeliveryController>(context, listen: false);
        double returnAmount = 0;
        double totalSaleAmount = 0;
        for (int i = 0; i < deliveryController.dpItemList.length; i++) {
          totalSaleAmount =
              totalSaleAmount + widget.deliverOrdersList[i].totalPrice;
          returnAmount = returnAmount +
              (widget.deliverOrdersList[i].totalPrice -
                  (double.parse(
                              '${deliveryController.dpItemList[i].returned}') !=
                          0
                      ? (widget.deliverOrdersList[i].unitPrice *
                          double.parse(
                              '${deliveryController.dpItemList[i].returned}'))
                      : 0));
        }
        Salevale = totalSaleAmount.toStringAsFixed(0);
        setState(() {});

        if (prefsDataDeliverOrder != '') {
          // dataup
          _DeliverOrdersList = List<ItemList>.from(
              jsonDecode(prefsDataDeliverOrder)
                  .map((x) => ItemList.fromJson(x)));
        }
        print(
            "_DeliverOrdersList --->${Salevale == ''} ${_DeliverOrdersList.length}");
        setState(() {});
      } else {
        GetSalesorderbyID(context);
      }
    });
  }

  Future GetSalesorderbyID(BuildContext context) async {
    final preference = await SharedPreferences.getInstance();
    setState(() {
      _isLoading = true;
    });
    return await API.GetSalesorderbyID(
      context,
      showNoInternet: true,
      Authtoken: preference.getString("token").toString(),
      ID: widget.id,
    ).then(
      (SalesOrderBYID_Model? response) async {
        setState(() {
          _isLoading = false;
        });
        print('rsponse-->' + response.toString());
        if (response != null) {
          Salevale = response.data!.salesOrderValue.toString();
          _DeliverOrdersList.addAll(response.data!.itemList!);

          //  id =response.data!.id.toString();
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
    return Scaffold(
      backgroundColor: AppColors.lightBlueColor,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(AppStrings.strPayment, style: AppStyles.appBarTitleStyle),
        leading: GestureDetector(
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Container(
              height: 15,
              width: 15,
              child: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                iconSize: 20.0,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          Image.asset(
            AppIcons.icQuestionRound,
            height: 18,
            width: 18,
          ),
          const SizedBox(
            width: 15,
          ),
          Center(
              child: Text(
            AppStrings.strSkip,
            style: AppStyles.buttonSkipTextStyle,
          )),
          const SizedBox(
            width: 15,
          ),
        ],
      ),
      body: Salevale != null && Salevale != ''
          ? Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.only(
                                left: 35, right: 35, top: 16, bottom: 16),
                            color: AppColors.lightBlueColor,
                            child: Row(
                              children: [
                                //Invoice
                                Expanded(
                                    child: Column(
                                  children: [
                                    Text(
                                      AppStrings.strInvoiceNo,
                                      style: TextStyle(
                                          fontFamily: appFontFamily,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                          color: AppColors.black2Color),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      '${widget.Salesorderid}',
                                      style: TextStyle(
                                          fontFamily: appFontFamily,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12,
                                          color: AppColors.black2Color),
                                    ),
                                  ],
                                )),

                                Expanded(
                                    child: Column(
                                  children: [
                                    Text(
                                      AppStrings.strDocId,
                                      style: TextStyle(
                                          fontFamily: appFontFamily,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                          color: AppColors.black2Color),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      '',
                                      style: TextStyle(
                                          fontFamily: appFontFamily,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12,
                                          color: AppColors.black2Color),
                                    ),
                                  ],
                                )),

                                //Cost
                                Expanded(
                                    child: Column(
                                  children: [
                                    Text(
                                      AppStrings.strCost,
                                      style: TextStyle(
                                          fontFamily: appFontFamily,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                          color: AppColors.black2Color),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      '${Salevale != null ? double.parse(Salevale!).toStringAsFixed(2) : 0}',
                                      style: TextStyle(
                                          fontFamily: appFontFamily,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12,
                                          color: AppColors.black2Color),
                                    ),
                                  ],
                                ))
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(
                                left: 25, right: 25, top: 15, bottom: 15),
                            width: double.infinity,
                            color: AppColors.whiteColor,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      AppIcons.icRsCurrency,
                                      height: 18,
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      '${double.parse(Salevale!).toStringAsFixed(0)}',
                                      style: TextStyle(
                                          fontFamily: appFontFamily,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 20,
                                          color: AppColors.black2Color
                                              .withOpacity(0.6)),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 9,
                                ),
                                // Row(
                                //   mainAxisAlignment: MainAxisAlignment.center,
                                //   children: [
                                //     Image.asset(
                                //       AppIcons.icRsCurrency,
                                //       height: 12,
                                //     ),
                                //     const SizedBox(
                                //       width: 2,
                                //     ),
                                //     Text(
                                //       '${double.parse(Salevale!).toStringAsFixed(0)}',
                                //       style: TextStyle(
                                //           fontFamily: appFontFamily,
                                //           fontWeight: FontWeight.w400,
                                //           fontSize: 14,
                                //           color: AppColors.black2Color
                                //               .withOpacity(0.6)),
                                //     ),
                                //     Text(
                                //       ' + ',
                                //       style: TextStyle(
                                //           fontFamily: appFontFamily,
                                //           fontWeight: FontWeight.w400,
                                //           fontSize: 14,
                                //           color: AppColors.black2Color
                                //               .withOpacity(0.6)),
                                //     ),
                                //     Text(
                                //       'SC 0.0',
                                //       style: TextStyle(
                                //           fontFamily: appFontFamily,
                                //           fontWeight: FontWeight.w400,
                                //           fontSize: 14,
                                //           color: AppColors.black2Color
                                //               .withOpacity(0.6)),
                                //     ),
                                //     Text(
                                //       ' = ',
                                //       style: TextStyle(
                                //           fontFamily: appFontFamily,
                                //           fontWeight: FontWeight.w400,
                                //           fontSize: 14,
                                //           color: AppColors.black2Color
                                //               .withOpacity(0.6)),
                                //     ),
                                //     Text(
                                //       '${double.parse(Salevale!).toStringAsFixed(0)}',
                                //       style: TextStyle(
                                //           fontFamily: appFontFamily,
                                //           fontWeight: FontWeight.w400,
                                //           fontSize: 14,
                                //           color: AppColors.black2Color
                                //               .withOpacity(0.6)),
                                //     ),
                                //   ],
                                // ),

                                const SizedBox(
                                  height: 15,
                                ),
                                // Row(
                                //   mainAxisAlignment: MainAxisAlignment.center,
                                //   children: [
                                //     Image.asset(
                                //       AppIcons.icRsCurrency,
                                //       height: 20,
                                //       color: AppColors.blueColor,
                                //     ),
                                //     const SizedBox(
                                //       width: 5,
                                //     ),
                                //     Text(
                                //       '${double.parse(Salevale!).toStringAsFixed(0)}',
                                //       style: TextStyle(
                                //           fontFamily: appFontFamily,
                                //           fontWeight: FontWeight.w600,
                                //           fontSize: 20,
                                //           color: AppColors.blueColor),
                                //     ),
                                //   ],
                                // ),
                                // const SizedBox(
                                //   height: 15,
                                // ),
                                InkWell(
                                  onTap: () {
                                    // Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //         builder: (_) =>
                                    //             CashPaymentScreen()));
                                  },
                                  child: Container(
                                    height: 60,
                                    width: 250,
                                    decoration: BoxDecoration(
                                        color: AppColors.blackColor,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Center(
                                      child: Text(
                                        AppStrings.strPayment,
                                        style: AppStyles.buttonTextStyle,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                              ],
                            ),
                          ),

                          //Payment Summary
                          Container(
                            decoration: const BoxDecoration(
                              color: AppColors.lightBlueColor,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(30),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 25, left: 25, right: 25),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //Titles - Captions
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 130,
                                        child: Text(
                                          AppStrings.strSku,
                                          style: TextStyle(
                                              color: AppColors.black2Color
                                                  .withOpacity(0.6),
                                              fontFamily: appFontFamily,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 12),
                                        ),
                                      ),
                                      Text(
                                        AppStrings.strQty,
                                        style: TextStyle(
                                            color: AppColors.black2Color
                                                .withOpacity(0.6),
                                            fontFamily: appFontFamily,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 12),
                                      ),
                                      Text(
                                        AppStrings.strPrice,
                                        style: TextStyle(
                                            color: AppColors.black2Color
                                                .withOpacity(0.6),
                                            fontFamily: appFontFamily,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 12),
                                      ),
                                      Text(
                                        AppStrings.strCost,
                                        style: TextStyle(
                                            color: AppColors.black2Color
                                                .withOpacity(0.6),
                                            fontFamily: appFontFamily,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 15),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    height: 250,
                                    child: ListView.builder(
                                      itemCount: _DeliverOrdersList.length,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                width: 120,
                                                child: Text(
                                                  '${_DeliverOrdersList[index].productName}',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontFamily:
                                                          appFontFamily),
                                                  maxLines: 2,
                                                ),
                                              ),
                                              Text(
                                                '${_DeliverOrdersList[index].qty}',
                                                style: TextStyle(
                                                    fontFamily: appFontFamily,
                                                    fontSize: 14,
                                                    color: AppColors.black2Color
                                                        .withOpacity(0.6),
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                              Text(
                                                '${double.parse(_DeliverOrdersList[index].unitPrice.toString()).toStringAsFixed(0)}',
                                                style: TextStyle(
                                                    fontFamily: appFontFamily,
                                                    fontSize: 14,
                                                    color: AppColors.black2Color
                                                        .withOpacity(0.6),
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                              Text(
                                                '${double.parse(_DeliverOrdersList[index].totalPrice.toString()).toStringAsFixed(0)}',
                                                style: TextStyle(
                                                    fontFamily: appFontFamily,
                                                    fontSize: 14,
                                                    color: AppColors.black2Color
                                                        .withOpacity(0.6),
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),

                //Bottom
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //Sub Total
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            AppStrings.strSubTotal,
                            style: TextStyle(
                                fontFamily: appFontFamily,
                                fontSize: 12,
                                color: AppColors.black2Color.withOpacity(0.6),
                                fontWeight: FontWeight.w700),
                          ),
                          Text(
                            '${double.parse(Salevale!).toStringAsFixed(0)}',
                            style: TextStyle(
                                fontFamily: appFontFamily,
                                fontSize: 14,
                                color: AppColors.black2Color.withOpacity(0.6),
                                fontWeight: FontWeight.w600),
                          )
                        ],
                      ),
                    ),

                    const SizedBox(
                      height: 10,
                    ),

                    //Shipping Charge
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            AppStrings.strShippingCharges,
                            style: TextStyle(
                                fontFamily: appFontFamily,
                                fontSize: 12,
                                color: AppColors.black2Color.withOpacity(0.6),
                                fontWeight: FontWeight.w700),
                          ),
                          Text(
                            '${double.parse(Salevale!).toStringAsFixed(0)}',
                            style: TextStyle(
                                fontFamily: appFontFamily,
                                fontSize: 14,
                                color: AppColors.black2Color.withOpacity(0.6),
                                fontWeight: FontWeight.w600),
                          )
                        ],
                      ),
                    ),

                    const SizedBox(
                      height: 15,
                    ),

                    //Buttons - Ok & Cancel
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            margin: EdgeInsets.only(left: 5),
                            height: 60,
                            decoration: const BoxDecoration(
                              color: AppColors.blackColor,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10.0),
                                  topRight: Radius.circular(10.0)),
                            ),
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: Center(
                              child: Text(
                                AppStrings.strCancel,
                                style: AppStyles.buttonTextStyle,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            margin: EdgeInsets.only(right: 5),
                            height: 60,
                            decoration: const BoxDecoration(
                              color: AppColors.blackColor,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10.0),
                                  topRight: Radius.circular(10.0)),
                            ),
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: Center(
                              child: Text(
                                AppStrings.strOk,
                                style: AppStyles.buttonTextStyle,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ],
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
