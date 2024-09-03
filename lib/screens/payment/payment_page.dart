import 'dart:convert';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:parsel_flutter/Provider/Delivery_Controller.dart';
import 'package:parsel_flutter/models/InvoiceList_model.dart' as invoice;
import 'package:parsel_flutter/models/base_moel.dart';
import 'package:parsel_flutter/resource/app_colors.dart';
import 'package:parsel_flutter/resource/app_fonts.dart';
import 'package:parsel_flutter/resource/app_helper.dart';
import 'package:parsel_flutter/resource/app_icons.dart';
import 'package:parsel_flutter/resource/app_logs.dart';
import 'package:parsel_flutter/resource/app_strings.dart';
import 'package:parsel_flutter/resource/app_styles.dart';
import 'package:parsel_flutter/screens/confirm_back_widget.dart';
import 'package:parsel_flutter/screens/dashboard.dart';
import 'package:parsel_flutter/screens/view_summary/summary_page.dart';
import 'package:parsel_flutter/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Provider/Invoice_Controller.dart';
import '../../api/api.dart';
import '../../models/AddPaymet_model.dart';
import '../../models/CreatePayment_model.dart' as CREATEPAYMENT;
import '../../models/InvoideDeliverd_model.dart';
import '../../models/SalesOrderBYID_Model.dart' as SALES;
import '../../models/SalesOrderBYID_Model.dart';
import '../../models/uploadsalesorder_model.dart' as uplds;

class PaymentPage extends StatefulWidget {
  PaymentPage({
    Key? key,
    required this.id,
    required this.Salesorderid,
    required this.deliverOrdersList,
    required this.dataList,
    required this.dataup,
    required this.salesOrder,
  }) : super(key: key);
  final String id;
  final String Salesorderid;

  final List<SALES.ItemList> deliverOrdersList;
  final List<SALES.ItemList> dataList;
  final List<uplds.ItemList> dataup;
  final SALES.SalesOrderBYID_Model salesOrder;
  String salevalue = '';

  @override
  State<StatefulWidget> createState() {
    return PaymentPageState();
  }
}

class PaymentPageState extends State<PaymentPage> {
  final _formKey = GlobalKey<FormState>();
  String? Salevale;
  String? returnTotalValue;
  List<PaymentsList> paty = [];
  List<CREATEPAYMENT.Data> createPayment = [];
  String Dropdownvlue = "PDC";
  String? dataList;
  String? paymentValue;
  String? dataList1;
  String? dataList2;
  int diff = 0;

  String amountTotal = '';
  // TextEditingController _value = TextEditingController();
  @override
  void initState() {
    super.initState();
    dataList = Salevale;
    dataList1 = returnTotalValue;
    // int paymentValueTem = int.parse(Salevale!) - int.parse(returnTotalValue!);
    // paymentValue = paymentValueTem.toString();

    //_getLocation();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // if (ConnectivityHandler.connectivityResult == ConnectivityResult.none) {
      final deliveryController =
          Provider.of<DeliveryController>(context, listen: false);
      double returnAmount = 0;
      double totalSaleAmount = 0;
      for (int i = 0; i < deliveryController.dpItemList.length; i++) {
        totalSaleAmount =
            totalSaleAmount + widget.deliverOrdersList[i].totalPrice;
        returnAmount = returnAmount +
            (widget.deliverOrdersList[i].totalPrice -
                (double.parse('${deliveryController.dpItemList[i].returned}') !=
                        0
                    ? (widget.deliverOrdersList[i].unitPrice *
                        double.parse(
                            '${deliveryController.dpItemList[i].returned}'))
                    : 0));
      }
      Salevale = totalSaleAmount.toStringAsFixed(0);
      returnTotalValue = (totalSaleAmount - returnAmount).toStringAsFixed(0);
      setState(() {});
      String prefsSalevale = VariableUtilities.preferences.getString(
              '${LocalCacheKey.deliverySummaryPaymentSaleVal}${widget.Salesorderid}') ??
          '';
      if (prefsSalevale != '') {
        setState(() {});
      }
      String prefsReturnTotal = VariableUtilities.preferences.getString(
              '${LocalCacheKey.deliverySummaryPaymentReturnTotal}${widget.Salesorderid}') ??
          '';
      if (prefsReturnTotal != '') {}
      String prefsPayId = VariableUtilities.preferences.getString(
              '${LocalCacheKey.deliverySummaryPaymentId}${widget.Salesorderid}') ??
          '';
      if (prefsPayId != '') {
        id = prefsPayId;
        setState(() {});
      }
      // } else {
      //   GetSalesorderbyID(context);
      // }
    });
  }

  final TextEditingController _codcontroller = TextEditingController();
  final TextEditingController _ononlinecontroller = TextEditingController();
  final TextEditingController _ononlineNamecontroller = TextEditingController();
  final TextEditingController _chequecontroller = TextEditingController();
  final TextEditingController _onChequeNamecontroller = TextEditingController();
  final TextEditingController _creditcontroller = TextEditingController();
  final TextEditingController _remarkcreditcontroller = TextEditingController();
  final TextEditingController _remarkonlinecontroller = TextEditingController();
  final TextEditingController _remarkchequecontroller = TextEditingController();
  final TextEditingController _cashcontroller = TextEditingController();

  final TextEditingController _changecontroller = TextEditingController();

  //_chequedatecontroller
  final TextEditingController _chequedatecontroller = TextEditingController();

  //DatePicker
  DateTime? _selectedDate;
  TextEditingController _textEditingController = TextEditingController();
  static void showToastMessage(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  // DateTime _selectedDate = DateTime.now();

  _selectDate(BuildContext context) async {
    DateTime? newSelectedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
      lastDate: DateTime(2040),
    );

    if (newSelectedDate != null) {
      _selectedDate = newSelectedDate;
      _chequedatecontroller
        ..text = DateFormat('yyyy-MM-dd').format(_selectedDate!)

        // DateFormat.yMMMd().format(_selectedDate!)
        ..selection = TextSelection.fromPosition(TextPosition(
            offset: _textEditingController.text.length,
            affinity: TextAffinity.upstream));
    }
  }

  //  if (_selectDate) {
  //     _selectedDate = _selectDate;
  //     _textEditingController
  //       ..text = DateFormat.yMMMd().format(_selectedDate!)
  //       ..selection = TextSelection.fromPosition(TextPosition(
  //           offset: _textEditingController.text.length,
  //           affinity: TextAffinity.upstream));
  //   }

  validate() {
    paty.clear();
    if (_codcontroller.text.isNotEmpty) {
      paty.add(PaymentsList(
        value: int.parse(_codcontroller.text),
        paymentDate:
            DateFormat('yyyy-MM-dd').format((DateTime.now())).toString(),
        paymentRemark: "COD Payment",
        paymentTypes: "CASH_ON_DELIVERY",
        chequePaymentTypes: "NONE",
        paymentMode: 'cod',
      ));
    }
    if (_chequecontroller.text.isNotEmpty ||
        _chequedatecontroller.text.isNotEmpty ||
        _remarkchequecontroller.text.isNotEmpty) {
      if (_chequecontroller.text.isEmpty) {
        AppHelper.showSnackBar(context, "Must fill Cheque amount");
        return false;
      } else if (_chequedatecontroller.text.isEmpty) {
        AppHelper.showSnackBar(context, "Must fill Cheque Date");
        return false;
      } else if (_remarkchequecontroller.text.isEmpty) {
        AppHelper.showSnackBar(context, "Must fill Cheque Remark");
        return false;
      } else {
        appLogs('cheq payment type-->' + Dropdownvlue.toString());
        appLogs(
            'cheq payment date-->' + _textEditingController.text.toString());
        paty.add(PaymentsList(
            value: int.parse(_chequecontroller.text),
            paymentDate: _chequedatecontroller.text.toString(),
            paymentRemark:
                _remarkchequecontroller.text.toString() + "," + Dropdownvlue,
            paymentTypes: 'CHEQUE',
            chequePaymentTypes: Dropdownvlue,
            paymentMode: 'cheque'));
      }
    }

    if (_ononlinecontroller.text.isNotEmpty ||
        _remarkonlinecontroller.text.isNotEmpty) {
      if (_ononlinecontroller.text.isEmpty) {
        AppHelper.showSnackBar(context, "Must fill Online Amount");
        return false;
      } else if (_remarkonlinecontroller.text.isEmpty) {
        AppHelper.showSnackBar(context, "Must fill Online Remark");
        return false;
      } else {
        paty.add(PaymentsList(
          value: int.parse(_ononlinecontroller.text),
          paymentDate:
              DateFormat('yyyy-MM-dd').format((DateTime.now())).toString(),
          paymentRemark: _remarkonlinecontroller.text,
          paymentTypes: 'ONLINE',
          chequePaymentTypes: 'NONE',
          paymentMode: 'online',
        ));
      }
    }

    if (_creditcontroller.text.isNotEmpty ||
        _remarkcreditcontroller.text.isNotEmpty) {
      if (_creditcontroller.text.isEmpty) {
        AppHelper.showSnackBar(context, "Must fill Credit Amount");
        return false;
      } else if (_remarkcreditcontroller.text.isEmpty) {
        AppHelper.showSnackBar(context, "Must fill Credit Remark");
        return false;
      } else {
        paty.add(PaymentsList(
          value: int.parse(_creditcontroller.text),
          paymentDate:
              DateFormat('yyyy-MM-dd').format((DateTime.now())).toString(),
          paymentRemark: _remarkcreditcontroller.text.toString(),
          paymentTypes: 'CREDIT',
          chequePaymentTypes: 'NONE',
          paymentMode: 'credit',
        ));
      }
    }

    appLogs("part ${paty.length}");
    if (paty.isNotEmpty) {
      return true;
    } else {
      AppHelper.showSnackBar(context, 'Please enter atleast one payment mode');
      return false;
    }
  }

  bool _isLoading = true;
  String? id;

  Future GetSalesorderbyID(BuildContext context) async {
    final preference = await SharedPreferences.getInstance();
    setState(() {
      _isLoading = true;
    });
    final deliveryController =
        Provider.of<DeliveryController>(context, listen: false);
    appLogs(
        "deliveryController.dpitemList -->${deliveryController.dpItemList.length}");

    for (int i = 0; i < deliveryController.dpItemList.length; i++) {
      appLogs(
          "deliveryController.dpitemList -->$i ${widget.deliverOrdersList[i].totalPrice - (widget.deliverOrdersList[i].unitPrice * double.parse('${deliveryController.dpItemList[i].returned}'))} ${widget.deliverOrdersList[i].unitPrice * widget.deliverOrdersList[i].qty} ");
    }
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
        appLogs('sale total-->' + response!.data!.salesOrderValue.toString());
        appLogs(
            'return total-->' + response.data!.totalReturnSkuValue.toString());

        if (response != null) {
          Salevale = response.data!.salesOrderValue!.toString();

          returnTotalValue = response.data!.totalReturnSkuValue!.toString();
          appLogs("returnTotalValue -->$Salevale ${returnTotalValue}");

          id = response.data!.id.toString();

          VariableUtilities.preferences.setString(
              '${LocalCacheKey.deliverySummaryPaymentSaleVal}${widget.Salesorderid}',
              Salevale ?? '');

          VariableUtilities.preferences.setString(
              '${LocalCacheKey.deliverySummaryPaymentReturnTotal}${widget.Salesorderid}',
              returnTotalValue ?? '');
          VariableUtilities.preferences.setString(
              '${LocalCacheKey.deliverySummaryPaymentId}${widget.Salesorderid}',
              id ?? '');
        }
        // else {
        //   AppHelper.showSnackBar(context, AppStrings.strSomethingWentWrong);
        // }
      },
    ).onError((error, stackTrace) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  Future Payment(BuildContext context, List<PaymentsList> payt) async {
    final preference = await SharedPreferences.getInstance();
    setState(() {
      _isLoading = true;
    });
    return await API.Payment(
      context,
      showNoInternet: true,
      Authtoken: preference.getString("token").toString(),
      ID: int.parse(widget.id),
      payment: payt,
    ).then(
      (response) async {
        setState(() {
          _isLoading = false;
        });
        appLogs('rsponse-->' + response.toString());
        if (response != null) {
          //  _DeliverOrdersList.addAll( response.data!.itemList!);
        }
        // else {
        //   AppHelper.showSnackBar(context, AppStrings.strSomethingWentWrong);
        // }
      },
    ).onError((error, stackTrace) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  Future createPayments(
    BuildContext context,
    List<PaymentsList> payt,
    // int id,
    // String salesOrderId,
    // String creationTime,
    // String paymentType,
    // int value,
    // String paymentRemark,
    // String paymentDate,
    // String chequeType,
    // String status,
    // Null? doneByUserId
  ) async {
    setState(() {
      _isLoading = true;
    });
    return await API
        .createPaymentInProgress(context,
            salesOrderId: widget.id.toString(), payment: payt
            // id: id.toString(),
            // createdDateTime: DateFormat('yyyy-MM-dd').format((DateTime.now())),
            // value: value.toString(),
            // paymentRemark: paymentRemark.toString(),
            // paymentDate: DateFormat('yyyy-MM-dd').format((DateTime.now())),
            // chequePaymentTypes: chequeType.toString(),
            // paymentTypes: paymentType.toString()
            )
        .then(
      (BaseModel? response) async {
        setState(() {
          _isLoading = false;
        });
        appLogs('create payment rsponse-->' + response.toString());
        if (response != null) {
          String resultListString = VariableUtilities.preferences
                  .getString(LocalCacheKey.invoiceInProgressList) ??
              '';

          AppHelper.showSnackBar(context, response.message.toString());
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (_) => const DashBoardScreen()));
          updateSalesorderbyID(context);
          if (resultListString.isNotEmpty) {
            List<invoice.ResultList> resultList = [];
            resultList = List<invoice.ResultList>.from(
                jsonDecode(resultListString)
                    .map((x) => invoice.ResultList.fromJson(x)));
            resultList.removeWhere(
                (element) => element.salesOrderId == widget.Salesorderid);
            appLogs(resultList);
            VariableUtilities.preferences.setString(
                LocalCacheKey.invoiceInProgressList, jsonEncode(resultList));
          }
          // response.body!.data!.map((e) => createPayment.add(e)).toList();
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

  Future DEpgetSalesOrderListByStatusInvoiceList(BuildContext context) async {
    final preference = await SharedPreferences.getInstance();
    setState(() {
      _isLoading = true;
    });
    return await API
        .getSalesOrderListByStatusInvoiceList1(context,
            showNoInternet: true,
            Authtoken: preference.getString("token").toString(),
            DEIVERID: preference.getString("userID").toString(),
            STATUS: 'DELIVERED',
            TODAYDATE: DateFormat('yyyy-MM-dd').format((DateTime.now())))
        .then(
      (InvoiceListModel1? response) async {
        setState(() {
          _isLoading = false;
        });
        appLogs('rsponse-->' + response.toString());
        if (response != null) {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => const DashBoardScreen()));
          var list = Provider.of<InvoiceController>(context, listen: false);
          list.setDEPtotalCount(response.body!.data!.totalCount!);
          final preference = await SharedPreferences.getInstance();
        }
        //  else {
        //   AppHelper.showSnackBar(context, AppStrings.strSomethingWentWrong);
        // }
      },
    ).onError((error, stackTrace) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  Future updateSalesorderbyID(BuildContext context) async {
    var Ddata = Provider.of<DeliveryController>(context, listen: false);

    return await API
        .updateSalesorderbyID1InProgress(context,
            showNoInternet: true,
            itemList: Ddata.uploadParticularListItem,
            executionStatus: 'DELIVERED',
            ID: widget.Salesorderid)
        .then(
      (BaseModel? response) async {
        appLogs('rsponse-->' + response.toString());
        if (response != null) {
          // DEpgetSalesOrderListByStatusInvoiceList(context);
        }
        // else {
        //   AppHelper.showSnackBar(context, AppStrings.strSomethingWentWrong);
        // }
      },
    ).onError((error, stackTrace) {});
  }

  @override
  Widget build(BuildContext context) {
    return ConfirmBackWrapperWidget(
      child: Scaffold(
        backgroundColor: AppColors.lightBlueColor,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80.0), // here the desired height
          child: AppBar(
            backgroundColor: Colors.black,
            title: Container(
              padding: const EdgeInsets.only(top: 20),
              margin: const EdgeInsets.only(top: 43, left: 25, bottom: 21),
              child: Text('PAYMENT', style: AppStyles.appBarTitleStyle),
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
                      Navigator.of(context).maybePop();
                    },
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios),
                      iconSize: 20.0,
                      onPressed: () {
                        Navigator.maybePop(context);
                      },
                    ),
                  ),
                ),
              ),
              onTap: () {},
            ),
            actions: [
              Container(
                // padding: const EdgeInsets.only(top: 30),
                margin: const EdgeInsets.only(top: 40),
                child: Image.asset(
                  AppIcons.icQuestionRound,
                  // height: 18,
                  // width: 18,
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              Container(
                // padding: const EdgeInsets.only(top: 30),
                margin: const EdgeInsets.only(top: 40),
                child: Text(
                  AppStrings.strSkip,
                  style: AppStyles.buttonSkipTextStyle,
                ),
              ),
              const SizedBox(
                width: 15,
              ),
            ],
          ),
        ),
        body: Salevale != null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.only(
                                  left: 35, right: 35, top: 16, bottom: 16),
                              color: AppColors.lightBlueColor,
                              child: Column(
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
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(
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
                                      Image.asset(AppIcons.icRsCurrency),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        (double.parse(Salevale!) -
                                                double.parse(
                                                    returnTotalValue == null
                                                        ? '0'
                                                        : returnTotalValue!))
                                            .toStringAsFixed(0),
                                        style: TextStyle(
                                            fontFamily: appFontFamily,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 20,
                                            color: AppColors.black2Color
                                                .withOpacity(0.6)),
                                      ),
                                    ],
                                  ),
                                  // const SizedBox(
                                  //   height: 9,
                                  // ),
                                  // Row(
                                  //   mainAxisAlignment: MainAxisAlignment.center,
                                  //   children: [
                                  //     Image.asset(
                                  //       AppIcons.icRsCurrency,
                                  //       height: 10,
                                  //     ),
                                  //     const SizedBox(
                                  //       width: 2,
                                  //     ),
                                  //     Text(
                                  //       (double.parse(Salevale!) -
                                  //               double.parse(returnTotalValue!))
                                  //           .toStringAsFixed(0),
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
                                  //       double.parse(Salevale!)
                                  //           .toStringAsFixed(0),
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
                                  //       color: AppColors.greenColor,
                                  //     ),
                                  //     const SizedBox(
                                  //       width: 5,
                                  //     ),
                                  //     Text(
                                  //       double.parse(Salevale!)
                                  //           .toStringAsFixed(2),
                                  //       style: const TextStyle(
                                  //           fontFamily: appFontFamily,
                                  //           fontWeight: FontWeight.w600,
                                  //           fontSize: 20,
                                  //           color: AppColors.greenColor),
                                  //     ),
                                  //   ],
                                  // ),
                                  // const SizedBox(
                                  //   height: 15,
                                  // ),
                                  InkWell(
                                    onTap: () {
                                      AppHelper.changeScreen(
                                          context,
                                          SummaryPage(
                                            id: widget.id,
                                            Salesorderid: widget.Salesorderid,
                                            dataList: widget.dataList,
                                            dataup: widget.dataup,
                                            deliverOrdersList:
                                                widget.deliverOrdersList,
                                            salesOrder: widget.salesOrder,
                                          ));
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
                                          AppStrings.strViewSummary,
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
                          ],
                        ),
                        //Mode Of Payment
                        Expanded(
                          child: Container(
                            height: MediaQuery.of(context).size.width * 0.6,
                            decoration: const BoxDecoration(
                              color: AppColors.lightBlueColor,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(30),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 25, left: 36, right: 56, bottom: 15),
                              child: SingleChildScrollView(
                                child: Form(
                                  key: _formKey,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        AppStrings.strModeOfPayment,
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      const SizedBox(
                                        height: 25,
                                      ),

                                      //COD
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.grey, width: 1.0),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(
                                                  5.0) //                 <--- border radius here
                                              ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    AppStrings.strCOD,
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: AppColors
                                                            .black2Color),
                                                  ),
                                                  const SizedBox(
                                                    width: 45,
                                                  ),
                                                  Expanded(
                                                    child: TextFormField(
                                                      keyboardType:
                                                          TextInputType.number,
                                                      controller:
                                                          _codcontroller,
                                                      onChanged: (text) {
                                                        int difference = widget
                                                                .salevalue
                                                                .length -
                                                            int.parse(text);
                                                        dataList = difference
                                                            .toString();
                                                        appLogs('datalist-->' +
                                                            dataList
                                                                .toString());
                                                        setState(() {});
                                                        // value = text;
                                                      },
                                                      decoration:
                                                          InputDecoration(
                                                        hintText: "Amount",
                                                        filled: true,
                                                        fillColor: Colors.white,
                                                        focusColor:
                                                            Colors.white,
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      8.0),
                                                          borderSide:
                                                              const BorderSide(
                                                            color: Colors.white,
                                                            width: 1.0,
                                                          ),
                                                        ),
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      8.0),
                                                          borderSide:
                                                              const BorderSide(
                                                            color: Colors.white,
                                                            width: 1.0,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    AppStrings.strCashGiven,
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: AppColors
                                                            .black2Color),
                                                  ),
                                                  const SizedBox(
                                                    width: 25,
                                                  ),
                                                  Expanded(
                                                    child: TextFormField(
                                                      keyboardType:
                                                          TextInputType.number,
                                                      controller:
                                                          _cashcontroller,
                                                      validator: (value) {
                                                        amountTotal = (double.parse(
                                                                    Salevale!) -
                                                                double.parse(
                                                                    returnTotalValue!))
                                                            .toStringAsFixed(0);
                                                        if (int.parse(value
                                                                .toString()) <
                                                            int.parse(
                                                                amountTotal)) {
                                                          return 'Value is less';
                                                        }
                                                      },
                                                      onChanged: (text) {
                                                        setState(() {});
                                                        amountTotal = (double.parse(
                                                                    Salevale!) -
                                                                double.parse(
                                                                    returnTotalValue!))
                                                            .toStringAsFixed(0);
                                                        diff = int.parse(
                                                                amountTotal) -
                                                            int.parse(
                                                                _cashcontroller
                                                                    .text);
                                                      },
                                                      decoration:
                                                          InputDecoration(
                                                        hintText:
                                                            "Enter the Cash Given",
                                                        filled: true,
                                                        fillColor: Colors.white,
                                                        focusColor:
                                                            Colors.white,
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      8.0),
                                                          borderSide:
                                                              const BorderSide(
                                                            color: Colors.white,
                                                            width: 1.0,
                                                          ),
                                                        ),
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      8.0),
                                                          borderSide:
                                                              const BorderSide(
                                                            color: Colors.white,
                                                            width: 1.0,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    AppStrings.strChangeGiven,
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: AppColors
                                                            .black2Color),
                                                  ),
                                                  const SizedBox(
                                                    width: 20,
                                                  ),
                                                  Expanded(
                                                    child: TextFormField(
                                                      readOnly: true,
                                                      keyboardType:
                                                          TextInputType.number,
                                                      controller:
                                                          _changecontroller,
                                                      decoration:
                                                          InputDecoration(
                                                        hintText:
                                                            diff.toString(),
                                                        filled: true,
                                                        fillColor: Colors.white,
                                                        focusColor:
                                                            Colors.white,
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      8.0),
                                                          borderSide:
                                                              const BorderSide(
                                                            color: Colors.white,
                                                            width: 1.0,
                                                          ),
                                                        ),
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      8.0),
                                                          borderSide:
                                                              const BorderSide(
                                                            color: Colors.white,
                                                            width: 1.0,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),

                                      //Online
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.grey, width: 1.0),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(
                                                  5.0) //                 <--- border radius here
                                              ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                AppStrings.strOnline,
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    color:
                                                        AppColors.black2Color),
                                              ),
                                              const SizedBox(
                                                width: 25,
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    children: [
                                                      // Container(
                                                      //   height: 50,
                                                      //   child: TextFormField(
                                                      //     keyboardType:
                                                      //         TextInputType.name,
                                                      //     controller:
                                                      //         _ononlineNamecontroller,
                                                      //     decoration:
                                                      //         InputDecoration(
                                                      //       hintText: "Name",
                                                      //       filled: true,
                                                      //       fillColor:
                                                      //           Colors.white,
                                                      //       focusColor:
                                                      //           Colors.white,
                                                      //       enabledBorder:
                                                      //           OutlineInputBorder(
                                                      //         borderRadius:
                                                      //             BorderRadius
                                                      //                 .circular(
                                                      //                     8.0),
                                                      //         borderSide:
                                                      //             const BorderSide(
                                                      //           color:
                                                      //               Colors.white,
                                                      //           width: 1.0,
                                                      //         ),
                                                      //       ),
                                                      //       focusedBorder:
                                                      //           OutlineInputBorder(
                                                      //         borderRadius:
                                                      //             BorderRadius
                                                      //                 .circular(
                                                      //                     8.0),
                                                      //         borderSide:
                                                      //             const BorderSide(
                                                      //           color:
                                                      //               Colors.white,
                                                      //           width: 1.0,
                                                      //         ),
                                                      //       ),
                                                      //     ),
                                                      //   ),
                                                      // ),
                                                      // SizedBox(
                                                      //   height: 10,
                                                      // ),
                                                      Container(
                                                        height: 50,
                                                        child: TextFormField(
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          controller:
                                                              _ononlinecontroller,
                                                          decoration:
                                                              InputDecoration(
                                                            hintText: "Amount",
                                                            filled: true,
                                                            fillColor:
                                                                Colors.white,
                                                            focusColor:
                                                                Colors.white,
                                                            enabledBorder:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8.0),
                                                              borderSide:
                                                                  const BorderSide(
                                                                color: Colors
                                                                    .white,
                                                                width: 1.0,
                                                              ),
                                                            ),
                                                            focusedBorder:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8.0),
                                                              borderSide:
                                                                  const BorderSide(
                                                                color: Colors
                                                                    .white,
                                                                width: 1.0,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      Container(
                                                        height: 50,
                                                        child: TextFormField(
                                                            controller:
                                                                _remarkonlinecontroller,
                                                            decoration:
                                                                InputDecoration(
                                                              hintText:
                                                                  "Remark",
                                                              errorStyle: const TextStyle(
                                                                  color: AppColors
                                                                      .blackColor),
                                                              filled: true,
                                                              fillColor:
                                                                  Colors.white,
                                                              focusColor:
                                                                  Colors.white,
                                                              enabledBorder:
                                                                  OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8.0),
                                                                borderSide:
                                                                    const BorderSide(
                                                                  color: Colors
                                                                      .white,
                                                                  width: 1.0,
                                                                ),
                                                              ),
                                                              focusedBorder:
                                                                  OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8.0),
                                                                borderSide:
                                                                    const BorderSide(
                                                                  color: Colors
                                                                      .white,
                                                                  width: 1.0,
                                                                ),
                                                              ),
                                                            ),
                                                            validator: (value) {
                                                              if (value!
                                                                  .isEmpty)
                                                                return ' Please Enter Remark';
                                                            }),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),

                                      //Cheque
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.grey, width: 1.0),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(
                                                  5.0) //                 <--- border radius here
                                              ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                AppStrings.strCheque,
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    color:
                                                        AppColors.black2Color),
                                              ),
                                              const SizedBox(
                                                width: 20,
                                              ),
                                              Expanded(
                                                child: Column(
                                                  children: [
                                                    // Container(
                                                    //   height: 50,
                                                    //   child: TextFormField(
                                                    //     keyboardType:
                                                    //         TextInputType.name,
                                                    //     controller:
                                                    //         _onChequeNamecontroller,
                                                    //     decoration:
                                                    //         InputDecoration(
                                                    //       hintText: "Name",
                                                    //       filled: true,
                                                    //       fillColor: Colors.white,
                                                    //       focusColor:
                                                    //           Colors.white,
                                                    //       enabledBorder:
                                                    //           OutlineInputBorder(
                                                    //         borderRadius:
                                                    //             BorderRadius
                                                    //                 .circular(
                                                    //                     8.0),
                                                    //         borderSide:
                                                    //             const BorderSide(
                                                    //           color: Colors.white,
                                                    //           width: 1.0,
                                                    //         ),
                                                    //       ),
                                                    //       focusedBorder:
                                                    //           OutlineInputBorder(
                                                    //         borderRadius:
                                                    //             BorderRadius
                                                    //                 .circular(
                                                    //                     8.0),
                                                    //         borderSide:
                                                    //             const BorderSide(
                                                    //           color: Colors.white,
                                                    //           width: 1.0,
                                                    //         ),
                                                    //       ),
                                                    //     ),
                                                    //   ),
                                                    // ),

                                                    Container(
                                                      height: 50,
                                                      child: TextFormField(
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        controller:
                                                            _chequecontroller,
                                                        decoration:
                                                            InputDecoration(
                                                          hintText: "Amount",
                                                          filled: true,
                                                          fillColor:
                                                              Colors.white,
                                                          focusColor:
                                                              Colors.white,
                                                          enabledBorder:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8.0),
                                                            borderSide:
                                                                const BorderSide(
                                                              color:
                                                                  Colors.white,
                                                              width: 1.0,
                                                            ),
                                                          ),
                                                          focusedBorder:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8.0),
                                                            borderSide:
                                                                const BorderSide(
                                                              color:
                                                                  Colors.white,
                                                              width: 1.0,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      color: Colors.white,
                                                      child: DropdownButton<
                                                          String>(
                                                        underline:
                                                            const SizedBox(),
                                                        value: Dropdownvlue,
                                                        hint: const Text("PDC"),
                                                        items: <String>[
                                                          'PDC',
                                                          'CDC'
                                                        ].map((String value) {
                                                          return DropdownMenuItem<
                                                              String>(
                                                            value: value,
                                                            child: Container(
                                                                width: 100,
                                                                color: Colors
                                                                    .white,
                                                                child: Text(
                                                                    value)),
                                                          );
                                                        }).toList(),
                                                        onChanged: (_) {
                                                          Dropdownvlue = _!;
                                                          setState(() {});
                                                        },
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        // AppHelper.changeScreen(
                                                        //     context,
                                                        //     TestPickerWidget());
                                                      },
                                                      child: Container(
                                                        height: 50,
                                                        child: TextField(
                                                          readOnly: true,
                                                          onTap: () {
                                                            setState(() {
                                                              _selectDate(
                                                                  context);
                                                            });
                                                          },
                                                          controller:
                                                              _chequedatecontroller,
                                                          decoration:
                                                              InputDecoration(
                                                            hintText: "Date",
                                                            filled: true,
                                                            fillColor:
                                                                Colors.white,
                                                            focusColor:
                                                                Colors.white,
                                                            enabledBorder:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8.0),
                                                              borderSide:
                                                                  const BorderSide(
                                                                color: Colors
                                                                    .white,
                                                                width: 1.0,
                                                              ),
                                                            ),
                                                            focusedBorder:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8.0),
                                                              borderSide:
                                                                  const BorderSide(
                                                                color: Colors
                                                                    .white,
                                                                width: 1.0,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    Container(
                                                      height: 50,
                                                      child: TextFormField(
                                                        controller:
                                                            _remarkchequecontroller,
                                                        decoration:
                                                            InputDecoration(
                                                          hintText: "Remark",
                                                          filled: true,
                                                          fillColor:
                                                              Colors.white,
                                                          focusColor:
                                                              Colors.white,
                                                          enabledBorder:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8.0),
                                                            borderSide:
                                                                const BorderSide(
                                                              color:
                                                                  Colors.white,
                                                              width: 1.0,
                                                            ),
                                                          ),
                                                          errorStyle:
                                                              const TextStyle(
                                                                  color: AppColors
                                                                      .blackColor),
                                                          focusedBorder:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8.0),
                                                            borderSide:
                                                                const BorderSide(
                                                              color:
                                                                  Colors.white,
                                                              width: 1.0,
                                                            ),
                                                          ),
                                                        ),
                                                        validator: (value) {
                                                          if (value!.isEmpty) {
                                                            return 'Please Enter Remark';
                                                          }
                                                          return null;
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),

                                      //Credit
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.grey, width: 1.0),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(
                                                  5.0) //                 <--- border radius here
                                              ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                AppStrings.strCredit,
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    color:
                                                        AppColors.black2Color),
                                              ),
                                              const SizedBox(
                                                width: 25,
                                              ),
                                              Expanded(
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      height: 50,
                                                      child: TextFormField(
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        controller:
                                                            _creditcontroller,
                                                        decoration:
                                                            InputDecoration(
                                                          hintText: "Amount",
                                                          filled: true,
                                                          fillColor:
                                                              Colors.white,
                                                          focusColor:
                                                              Colors.white,
                                                          enabledBorder:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8.0),
                                                            borderSide:
                                                                const BorderSide(
                                                              color:
                                                                  Colors.white,
                                                              width: 1.0,
                                                            ),
                                                          ),
                                                          focusedBorder:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8.0),
                                                            borderSide:
                                                                const BorderSide(
                                                              color:
                                                                  Colors.white,
                                                              width: 1.0,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    Container(
                                                      height: 50,
                                                      child: TextFormField(
                                                        controller:
                                                            _remarkcreditcontroller,
                                                        decoration:
                                                            InputDecoration(
                                                          hintText: "Remark",
                                                          filled: true,
                                                          fillColor:
                                                              Colors.white,
                                                          focusColor:
                                                              Colors.white,
                                                          enabledBorder:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8.0),
                                                            borderSide:
                                                                const BorderSide(
                                                              color:
                                                                  Colors.white,
                                                              width: 1.0,
                                                            ),
                                                          ),
                                                          errorStyle:
                                                              const TextStyle(
                                                                  color: AppColors
                                                                      .blackColor),
                                                          focusedBorder:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8.0),
                                                            borderSide:
                                                                const BorderSide(
                                                              color:
                                                                  Colors.white,
                                                              width: 1.0,
                                                            ),
                                                          ),
                                                        ),
                                                        validator: (value) {
                                                          if (value!.isEmpty) {
                                                            return 'Please Enter Remark';
                                                          }
                                                          return null;
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  //Bottom Button
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 60,
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            color: AppColors.blackColor,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10.0),
                                topRight: Radius.circular(10.0)),
                          ),
                          child: Center(
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                AppStrings.strCancel,
                                style: AppStyles.buttonTextStyle,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          child: InkWell(
                        onTap: () {
                          AppHelper.hideKeyboard(context);
                          String resultListString =
                              VariableUtilities.preferences.getString(
                                      LocalCacheKey.invoiceInProgressList) ??
                                  '';

                          if (validate()) {
                            appLogs(paty.length);
                            if (paty.isNotEmpty) {
                              String amountTotal = (double.parse(Salevale!) -
                                      double.parse(returnTotalValue!))
                                  .toStringAsFixed(0);
                              double paymentModeTotal = 0.0;
                              for (int i = 0; i < paty.length; i++) {
                                // appLogs('value-->' + paty[i].value.toString());
                                paymentModeTotal = paymentModeTotal +
                                    double.parse(paty[i].value.toString());
                              }
                              //  appLogs('paymentModeTotal-->' +
                              //     paymentModeTotal.toString());
                              if (amountTotal ==
                                  paymentModeTotal
                                      .toStringAsFixed(0)
                                      .toString()) {
                                if (ConnectivityHandler.connectivityResult
                                    .contains(ConnectivityResult.none)) {
                                  String prefsQueApi =
                                      VariableUtilities.preferences.getString(
                                              LocalCacheKey.paymentApiInQue) ??
                                          '';
                                  log("prefsQueApi --> $prefsQueApi");
                                  List<dynamic> prefsList = [];
                                  if (prefsQueApi.isNotEmpty) {
                                    prefsList = List<dynamic>.from(
                                        jsonDecode(prefsQueApi).map(
                                            (x) => jsonDecode(jsonEncode(x))));
                                  }
                                  for (int i = 0; i < prefsList.length; i++) {
                                    Map<String, dynamic> prefsJson = {};
                                    if (prefsList[i].runtimeType == String) {
                                      prefsJson = jsonDecode(prefsList[i]);
                                    } else {
                                      prefsJson =
                                          jsonDecode(jsonEncode(prefsList[i]));
                                    }
                                    if (prefsJson['parameters']
                                            ['salesOrderId'] ==
                                        widget.Salesorderid.toString()) {
                                      if (prefsJson['function_name'] ==
                                          'createPayMentFunction') {
                                        if (resultListString.isNotEmpty) {
                                          List<invoice.ResultList> resultList =
                                              [];
                                          resultList =
                                              List<invoice.ResultList>.from(
                                                  jsonDecode(resultListString)
                                                      .map((x) =>
                                                          invoice.ResultList
                                                              .fromJson(x)));
                                          resultList.removeWhere((element) =>
                                              element.salesOrderId ==
                                              widget.Salesorderid);
                                          appLogs(resultList);
                                          VariableUtilities.preferences
                                              .setString(
                                                  LocalCacheKey
                                                      .invoiceInProgressList,
                                                  jsonEncode(resultList));
                                        }
                                        AppHelper.showSnackBar(context,
                                            "Your Request is already submitted");
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) =>
                                                    const DashBoardScreen()));

                                        return;
                                      }
                                    }
                                  }
                                  var Ddata = Provider.of<DeliveryController>(
                                      context,
                                      listen: false);

                                  Map<String, dynamic> createPayMentFunction = {
                                    "function_name": "createPayMentFunction",
                                    'parameters': {
                                      "paymentMode": paty[0].paymentMode,
                                      "salesOrderId":
                                          widget.Salesorderid.toString(),
                                      "id": widget.id.toString(),
                                      "deliverId":
                                          widget.Salesorderid.toString(),
                                      "payment": paty,
                                      "itemList": Ddata.uploadParticularListItem
                                    }
                                  };

                                  int onGoing = VariableUtilities.preferences
                                          .getInt(LocalCacheKey
                                              .inProgressOrderCount) ??
                                      0;
                                  onGoing = onGoing - 1;
                                  if (onGoing.isNegative) {
                                    onGoing = 0;
                                    VariableUtilities.preferences.setInt(
                                        LocalCacheKey.inProgressOrderCount, 0);
                                  } else {
                                    VariableUtilities.preferences.setInt(
                                        LocalCacheKey.inProgressOrderCount,
                                        onGoing);
                                  }

                                  List<dynamic> updatedPrefsList = [];
                                  if (prefsQueApi.isNotEmpty) {
                                    updatedPrefsList = List<dynamic>.from(
                                        jsonDecode(prefsQueApi).map(
                                            (x) => jsonDecode(jsonEncode(x))));
                                    updatedPrefsList
                                        .add(jsonEncode(createPayMentFunction));
                                  } else {
                                    updatedPrefsList
                                        .add(jsonEncode(createPayMentFunction));
                                  }

                                  VariableUtilities.preferences.setString(
                                      LocalCacheKey.paymentApiInQue,
                                      jsonEncode(updatedPrefsList));
                                  if (resultListString.isNotEmpty) {
                                    List<invoice.ResultList> resultList = [];
                                    resultList = List<invoice.ResultList>.from(
                                        jsonDecode(resultListString).map((x) =>
                                            invoice.ResultList.fromJson(x)));
                                    resultList.removeWhere((element) =>
                                        element.salesOrderId ==
                                        widget.Salesorderid);
                                    appLogs(resultList);
                                    VariableUtilities.preferences.setString(
                                        LocalCacheKey.invoiceInProgressList,
                                        jsonEncode(resultList));
                                  }
                                  AppHelper.showSnackBar(
                                      context, "Your Request is Submitted!");
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) =>
                                              const DashBoardScreen()));
                                  return;
                                }
                                // updateSalesDeliveryOrder();
                                createPayments(context, paty);
                              } else {
                                AppHelper.showSnackBar(context,
                                    'Payment amount should be equal to total amount');
                              }
                            } else {
                              AppHelper.showSnackBar(context,
                                  " Please Choose Minimum  1 payment mode");
                            }
                          }
                        },
                        child: Container(
                          height: 60,
                          decoration: const BoxDecoration(
                            color: AppColors.blackColor,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10.0),
                                topRight: Radius.circular(10.0)),
                          ),
                          width: double.infinity,
                          child: Center(
                            child: Text(
                              AppStrings.strOk,
                              style: AppStyles.buttonTextStyle,
                            ),
                          ),
                        ),
                      ))
                    ],
                  ),
                ],
              )
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  updateSalesDeliveryOrder() async {
    var Ddata = Provider.of<DeliveryController>(context, listen: false);
    if (ConnectivityHandler.connectivityResult
        .contains(ConnectivityResult.none)) {
      String prefsQueApi = VariableUtilities.preferences
              .getString(LocalCacheKey.paymentApiInQue) ??
          '';
      // log("prefsQueApi --> $prefsQueApi");
      List<dynamic> prefsList = [];
      if (prefsQueApi.isNotEmpty) {
        prefsList = List<dynamic>.from(
            jsonDecode(prefsQueApi).map((x) => jsonDecode(jsonEncode(x))));
      }
      for (int i = 0; i < prefsList.length; i++) {
        Map<String, dynamic> prefsJson = {};
        if (prefsList[i].runtimeType == String) {
          prefsJson = jsonDecode(prefsList[i]);
        } else {
          prefsJson = jsonDecode(jsonEncode(prefsList[i]));
        }
        if (prefsJson['parameters']['ID'] == widget.Salesorderid.toString()) {
          if (prefsJson['function_name'] == 'updateSalesorderbyID1') {
            Map<String, dynamic> updateSalesorderbyID1 = {
              "function_name": "updateSalesorderbyID1",
              'parameters': {
                'showNoInternet': true,
                'itemList': Ddata.uploadParticularListItem,
                'executionStatus': 'ARRIVED',
                'ID': widget.Salesorderid
              }
            };

            prefsList.insert(i, updateSalesorderbyID1);
            prefsList.removeWhere((element) {
              Map<String, dynamic> elementJson = {};

              if (element.runtimeType == String) {
                elementJson = jsonDecode(element);
              } else {
                elementJson = jsonDecode(jsonEncode(element));
              }
              return elementJson['function_name'] == prefsJson['function_name'];
            });

            AppHelper.showSnackBar(
                context, "Your Request is already submitted");
            VariableUtilities.preferences.setString(
                LocalCacheKey.paymentApiInQue, jsonEncode(prefsList));

            return;
          }
        }
      }

      Map<String, dynamic> updateSalesorderbyID1 = {
        "function_name": "updateSalesorderbyID1",
        'parameters': {
          'showNoInternet': true,
          'itemList': Ddata.uploadParticularListItem,
          'executionStatus': 'ARRIVED',
          'ID': widget.Salesorderid
        }
      };
      List<dynamic> updatedPrefsList = [];
      if (prefsQueApi.isNotEmpty) {
        updatedPrefsList = List<dynamic>.from(
            jsonDecode(prefsQueApi).map((x) => jsonDecode(jsonEncode(x))));
        updatedPrefsList.add(jsonEncode(updateSalesorderbyID1));
      } else {
        updatedPrefsList.add(jsonEncode(updateSalesorderbyID1));
      }

      VariableUtilities.preferences.setString(
          LocalCacheKey.paymentApiInQue, jsonEncode(updatedPrefsList));
      AppHelper.showSnackBar(context, "Your Request is Submitted!");
      // return;
    } else {
      updateSalesorderbyID1(context, Ddata.uploadParticularListItem);
    }
  }

  Future updateSalesorderbyID1(
      BuildContext context, List<uplds.ItemList> itm) async {
    final preference = await SharedPreferences.getInstance();
    setState(() {
      _isLoading = true;
    });
    log('itm --> ${jsonEncode(itm)}');
    return await API
        .updateSalesorderbyID1InProgress(context,
            showNoInternet: true,
            itemList: itm,
            executionStatus: 'ARRIVED',
            ID: widget.Salesorderid)
        .then(
      (BaseModel? response) async {
        setState(() {
          _isLoading = false;
        });
        appLogs('response-->' + response.toString());
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
}
