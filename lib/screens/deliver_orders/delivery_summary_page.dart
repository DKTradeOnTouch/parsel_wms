import 'dart:convert';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:parsel_flutter/Provider/Delivery_Controller.dart';
import 'package:parsel_flutter/models/base_moel.dart';
import 'package:parsel_flutter/models/delivery_summary_model.dart';
import 'package:parsel_flutter/resource/app_colors.dart';
import 'package:parsel_flutter/resource/app_fonts.dart';
import 'package:parsel_flutter/resource/app_helper.dart';
import 'package:parsel_flutter/resource/app_strings.dart';
import 'package:parsel_flutter/screens/confirm_back_widget.dart';
import 'package:parsel_flutter/screens/deliver_orders/deliver_orders_page.dart';
import 'package:parsel_flutter/screens/deliver_orders/delivery_summary.dart';
import 'package:parsel_flutter/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/api.dart';
import '../../models/SalesOrderBYID_Model.dart' as SALES;
import '../../models/SalesOrderBYID_Model.dart';
import '../../models/UpdateSalesOrder_model.dart';
import '../../models/despatch_sum_item.dart';
import '../../models/uploadsalesorder_model.dart' as uplds;
import '../proof_of_delivery/proof_of_delivery_page.dart';

class DeliverySummaryPage extends StatefulWidget {
  const DeliverySummaryPage(
      {Key? key,
      required this.id,
      required this.dataList,
      required this.deliverOrdersList,
      required this.dataup,
      required this.Salesorderid,
      required this.salesOrder,
      required String diff})
      : super(key: key);

  final String id;
  final String? Salesorderid;
  final List<SALES.ItemList> deliverOrdersList;
  final List<SALES.ItemList> dataList;
  final List<uplds.ItemList> dataup;
  final SALES.SalesOrderBYID_Model salesOrder;

  @override
  State<DeliverySummaryPage> createState() => _DeliverySummaryPageState();
}

class _DeliverySummaryPageState extends State<DeliverySummaryPage> {
  List<DespatchSummaryItem> _deliveryValues = [];
  bool _isLoading = true;

  //adding static data as despatch summary details -
  DeliverySummaryData? deliverySumDetails;

  String? Salevale = '0';

  String? returnTotalValue = '0';

  converDStoList() {
    _deliveryValues.add(DespatchSummaryItem(
        title: 'INVOICE VALUE', value: deliverySumDetails!.orderedCount));
    _deliveryValues.add(DespatchSummaryItem(
        title: 'DELIVERED', value: deliverySumDetails!.deliveredCount));
    _deliveryValues.add(DespatchSummaryItem(
        title: 'RETURNED', value: deliverySumDetails!.returnCount));
    _deliveryValues.add(DespatchSummaryItem(
        title: 'NO OF BOXES', value: deliverySumDetails!.noOfBoxesCount));
    _deliveryValues.add(DespatchSummaryItem(
        title: 'SKU TEMPERATURE', value: deliverySumDetails!.skuTemp));
    _deliveryValues.add(DespatchSummaryItem(
        title: 'REMARKS', value: deliverySumDetails!.remarks));
    VariableUtilities.preferences.setString(
        "${LocalCacheKey.deliverySummaryValuesList}${widget.Salesorderid}",
        jsonEncode(_deliveryValues));
  }

  @override
  void initState() {
    print("WidgetsBinding.instance --> deliver Summary page");
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (ConnectivityHandler.connectivityResult
          .contains(ConnectivityResult.none)) {
        String prefsDeliverySummaryValuesList = VariableUtilities.preferences
                .getString(
                    "${LocalCacheKey.deliverySummaryValuesList}${widget.Salesorderid}") ??
            '';

        if (prefsDeliverySummaryValuesList != '') {
          _deliveryValues = List<DespatchSummaryItem>.from(
              jsonDecode(prefsDeliverySummaryValuesList)
                  .map((x) => DespatchSummaryItem.fromJson(x)));
        }
        setState(() {});
        checkOrder();
      } else {
        // GetSalesorderbyID(context);
        checkOrder();
      }
    });
    // converDStoList();
    //updateSalesorderbyID(context);
  }

  checkOrder() {
    final deliveryController =
        Provider.of<DeliveryController>(context, listen: false);
    double returnAmount = 0;
    double totalSaleAmount = 0;
    double totalDeliveredCount = 0;
    double totalReturnCount = 0;
    double totalInvoiceAmount = 0;
    widget.salesOrder.data!.temperature;

    for (int i = 0; i < deliveryController.dpItemList.length; i++) {
      totalReturnCount = totalReturnCount +
          double.parse('${deliveryController.dpItemList[i].returned}');
      totalDeliveredCount = totalDeliveredCount +
          double.parse('${deliveryController.dpItemList[i].delivered}');
      totalSaleAmount =
          totalSaleAmount + widget.deliverOrdersList[i].totalPrice;
      returnAmount = returnAmount +
          (widget.deliverOrdersList[i].totalPrice -
              (widget.deliverOrdersList[i].unitPrice *
                  double.parse(
                      '${deliveryController.dpItemList[i].returned}')));
    }

    _deliveryValues.add(DespatchSummaryItem(
        title: 'INVOICE VALUE',
        value: returnAmount.round().toStringAsFixed(0)));
    _deliveryValues.add(
        DespatchSummaryItem(title: 'DELIVERED', value: '$totalDeliveredCount'));
    _deliveryValues.add(
        DespatchSummaryItem(title: 'RETURNED', value: '$totalReturnCount'));
    _deliveryValues.add(DespatchSummaryItem(title: 'NO OF BOXES', value: '0'));
    _deliveryValues
        .add(DespatchSummaryItem(title: 'SKU TEMPERATURE', value: '0'));
    _deliveryValues
        .add(DespatchSummaryItem(title: 'REMARKS', value: 'nothing'));
    setState(() {});
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
        final deliveryController =
            Provider.of<DeliveryController>(context, listen: false);
        print(
            "deliveryController.dpitemList -->${deliveryController.dpItemList.length}");

        for (int i = 0; i < deliveryController.dpItemList.length; i++) {
          print(
              "deliveryController.dpitemList -->$i ${widget.deliverOrdersList[i].totalPrice - (widget.deliverOrdersList[i].unitPrice * double.parse('${deliveryController.dpItemList[i].returned}'))} ${widget.deliverOrdersList[i].unitPrice * widget.deliverOrdersList[i].qty} ");
        }
        print('rsponse-->' + response.toString());
        print('sale total-->' + response!.data!.salesOrderValue.toString());
        print(
            'return total-->' + response.data!.totalReturnSkuValue.toString());
        if (response != null) {
          //   _DeliverOrdersList.addAll( response.data!.itemList!);
          Salevale = response.data!.salesOrderValue!.toString();
          returnTotalValue = response.data!.totalReturnSkuValue!.toString();
          deliverySumDetails = DeliverySummaryData(
            orderedCount:
                (double.parse(Salevale!) - double.parse(returnTotalValue!))
                    .toStringAsFixed(0),
            returnCount: '${response.data!.totalReturnSkuValue!}',
            invoiceNo: '${response.data!.id!}',
            remarks: 'nothing',
            deliveredCount: '${response.data!.itemList!.length}',
            noOfBoxesCount: '',
            skuTemp: '${response.data!.temperature!}',
          );
          checkOrder();
          // converDStoList();
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

  Future updateSalesorderbyID(BuildContext context) async {
    final preference = await SharedPreferences.getInstance();
    setState(() {
      _isLoading = true;
    });
    return await API
        .updateSalesorderbyIDInProgress(context,
            showNoInternet: true,
            Authtoken: preference.getString("token").toString(),
            temperature: 200,
            executionStatus: '',
            ID: widget.Salesorderid!)
        .then(
      (BaseModel? response) async {
        setState(() {
          _isLoading = false;
        });
        print('rsponse-->' + response.toString());
        if (response != null) {
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
    return ConfirmBackWrapperWidget(
      child: Scaffold(
        appBar: AppHelper.appBar(
            context,
            'DELIVERY SUMMARY',
            DeliverOrdersPage(
              salesOrder: SalesOrderBYID_Model(),
              dataList: widget.dataList,
              dataUp: widget.dataup,
              deliverOrdersList: widget.deliverOrdersList,
              salesOrderId: widget.id,
              id: '',
              diff: '',
            ),
            Icons.arrow_back_ios),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppStrings.strInvoiceNo,
                        style: const TextStyle(
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
                        style: const TextStyle(
                            fontFamily: appFontFamily,
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                            color: AppColors.black2Color),
                      ),
                    ],
                  )),

                  /*      Expanded(
                    child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const ReturnOldSKU()));
                        },
                        child: Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: AppColors.black2Color,
                              borderRadius: BorderRadius.circular(5),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  offset: Offset(5, 5),
                                  blurRadius: 10,
                                )
                              ],
                            ),
                            child: const Text(
                              'RETURN OLD SKU',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: appFontFamily,
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                              ),
                            ))),
                  ), //Cost*/
                ],
              ),
            ),
            Expanded(
              child: Container(
                  height: MediaQuery.of(context).size.height,
                  child: _deliveryValues.isNotEmpty
                      ? DeliverySummary(deliverySummaryList: _deliveryValues)
                      : const Center(child: CircularProgressIndicator())),
            ),
          ],
        ),
        bottomNavigationBar: Container(
          color: Colors.white,
          child: MaterialButton(
            height: 60.0,
            onPressed: () {
              if (ConnectivityHandler.connectivityResult
                  .contains(ConnectivityResult.none)) {
                String prefsQueApi = VariableUtilities.preferences
                        .getString(LocalCacheKey.paymentApiInQue) ??
                    '';
                log("prefsQueApis --> $prefsQueApi");
                List<dynamic> prefsList = [];
                if (prefsQueApi.isNotEmpty) {
                  prefsList = List<dynamic>.from(jsonDecode(prefsQueApi)
                      .map((x) => jsonDecode(jsonEncode(x))));
                }
                for (int i = 0; i < prefsList.length; i++) {
                  Map<String, dynamic> prefsJson = {};
                  if (prefsList[i].runtimeType == String) {
                    prefsJson = jsonDecode(prefsList[i]);
                  } else {
                    prefsJson = jsonDecode(jsonEncode(prefsList[i]));
                  }
                  jsonDecode(jsonEncode(prefsList[i]));
                  print(
                      'prefsJsonwidget.Salesorderid.toString()--> ${prefsJson['parameters']['ID'] == widget.Salesorderid.toString()}');
                  if (prefsJson['parameters']['ID'] ==
                      widget.Salesorderid.toString()) {
                    if (prefsJson['function_name'] ==
                        'updateSalesorderbyID1OnGoing') {
                      AppHelper.showSnackBar(
                          context, "Your Request is already submitted");
                      AppHelper.showAlert(
                          'DELIVER ORDER',
                          'Are you sure you want to\ncomplete this shipment',
                          context,
                          ProofOfDeliveryPage(
                            dataList: widget.dataList,
                            dataup: widget.dataup,
                            deliverOrdersList: widget.deliverOrdersList,
                            salesOrder: widget.salesOrder,
                            Id: widget.id,
                            SalesOrderID: widget.Salesorderid!,
                          ));
                      return;
                    }
                  }
                }

                Map<String, dynamic> updateSalesorderbyID1OnGoing = {
                  "function_name": "updateSalesorderbyID1OnGoing",
                  'parameters': {
                    'showNoInternet': true,
                    'Authtoken': VariableUtilities.preferences
                        .getString("token")
                        .toString(),
                    'temperature': 200,
                    'executionStatus': '',
                    'ID': widget.Salesorderid!
                  }
                };
                List<dynamic> updatedPrefsList = [];
                if (prefsQueApi.isNotEmpty) {
                  updatedPrefsList = List<dynamic>.from(jsonDecode(prefsQueApi)
                      .map((x) => jsonDecode(jsonEncode(x))));
                  updatedPrefsList
                      .add(jsonEncode(updateSalesorderbyID1OnGoing));
                } else {
                  updatedPrefsList
                      .add(jsonEncode(updateSalesorderbyID1OnGoing));
                }

                VariableUtilities.preferences.setString(
                    LocalCacheKey.paymentApiInQue,
                    jsonEncode(updatedPrefsList));
                AppHelper.showSnackBar(context, "Your Request is Submitted!");

                // return;
              } else {
                updateSalesorderbyID(context);
              }
              AppHelper.showAlert(
                  'DELIVER ORDER',
                  'Are you sure you want to\ncomplete this shipment',
                  context,
                  ProofOfDeliveryPage(
                    dataList: widget.dataList,
                    dataup: widget.dataup,
                    deliverOrdersList: widget.deliverOrdersList,
                    salesOrder: widget.salesOrder,
                    Id: widget.id,
                    SalesOrderID: widget.Salesorderid!,
                  ));
              // checkOrder();
            },
            child: const Text(
              AppConstants.kSUBMIT_BUTTON_TITLE,
              style: TextStyle(
                color: Colors.white,
                fontFamily: appFontFamily,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
            color: ColorUtils.kBottomButtonColor,
          ),
        ),
      ),
    );
  }
}
