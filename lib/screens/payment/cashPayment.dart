import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:parsel_flutter/screens/dashboard.dart';
import 'package:parsel_flutter/screens/despatch_summary/despatch_summery_page.dart';
import 'package:parsel_flutter/screens/in_progress/progress_page.dart';
import 'package:parsel_flutter/screens/payment/payment_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../resource/app_colors.dart';
import '../../../resource/app_helper.dart';
import '../../../resource/app_styles.dart';
import '../../api/api.dart';
import '../../models/InvoiceList_model.dart';
import '../../resource/app_fonts.dart';
import '../../resource/app_strings.dart';
import '../../models/SalesOrderBYID_Model.dart' as SALES;

class CashPaymentScreen extends StatefulWidget {
  const CashPaymentScreen({Key? key}) : super(key: key);

  @override
  State<CashPaymentScreen> createState() => _CashPaymentScreenState();
}

class _CashPaymentScreenState extends State<CashPaymentScreen> {
  List<String> storageList = [
    'INR 1',
    'INR 2',
    'INR 5',
    'INR 10',
    'INR 20',
    'INR 50',
    'INR 100',
    'INR 200',
    'INR 500',
    'INR 2000'
  ];
  bool isBottomBar = false;

  String? salesORDERID;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  Future INpgetSalesOrderListByStatusInvoiceList(BuildContext context) async {
    final preference = await SharedPreferences.getInstance();
    setState(() {
      _isLoading = true;
    });
    return await API
        .getSalesOrderListByStatusInvoiceList(context,
            showNoInternet: true,
            Authtoken: preference.getString("token").toString(),
            DEIVERID: preference.getString("userID").toString(),
            STATUS: 'ON_GOING',
            TODAYDATE: DateFormat('yyyy-MM-dd').format((DateTime.now())))
        .then(
      (InvoiceListModel? response) async {
        setState(() {
          _isLoading = false;
        });
        print('rsponse-->' + response.toString());
        if (response != null) {
          salesORDERID = response.body!.data!.resultList![0].salesOrderId;

          final preference = await SharedPreferences.getInstance();
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

  textFieldValue() {
    return Container(
      height: 40,
      padding: EdgeInsets.only(right: 10),
      alignment: Alignment.centerRight,
      margin: EdgeInsets.only(left: 20, top: 10, bottom: 5),
      width: MediaQuery.of(context).size.width * 0.50,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [BoxShadow(color: Colors.black12, spreadRadius: 1)]),
      child: Text(
        '',
        style: AppStyles.inwardTextDATAStyle,
      ),
    );
  }

  textFieldBottomBar() {
    return Container(
      height: 30,
      padding: EdgeInsets.only(right: 10),
      alignment: Alignment.centerRight,
      margin: EdgeInsets.only(left: 20, top: 10),
      width: MediaQuery.of(context).size.width * 0.50,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [BoxShadow(color: Colors.black12, spreadRadius: 1)]),
      child: Text(
        '',
        style: AppStyles.inwardTextDATAStyle,
      ),
    );
  }

  showAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            children: [
              Container(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: 40,
                    height: 40,
                    child: SvgPicture.asset("assets/logo.svg",
                        height: 40, width: 40, semanticsLabel: 'Acme Logo'),
                  )),
              const Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 8.0),
                child: Text(
                  "CONFIRM START TRIP",
                  style: TextStyle(
                      fontFamily: appFontFamily,
                      color: AppColors.blueColor,
                      fontSize: 13),
                ),
              ),
            ],
          ),
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
                "Are you sure you want to start\n the trip to destination?",
                textAlign: TextAlign.center,
                style: AppStyles.blackTextStyle),
          ),
          actions: <Widget>[
            Row(
              children: [
                Expanded(
                  child: InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                          height: 40,
                          width: 130,
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(4),
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
                            style: TextStyle(color: Colors.white),
                          ))),
                ),
                SizedBox(
                  width: 15.0,
                ),
                Expanded(
                  child: InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => InProgressPage()));
                      },
                      child: Container(
                          height: 40,
                          width: 130,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(4),
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
                            style: TextStyle(color: Colors.white),
                          ))),
                )
              ],
            ),
          ],
        );
      },
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppHelper.appBar(
          context,
          'CASH PAYMENT',
          PaymentPage(
            id: '',
            Salesorderid: '',
            dataList: [],
            dataup: [],
            salesOrder: SALES.SalesOrderBYID_Model(),
            deliverOrdersList: [],
          ),
          Icons.arrow_back_ios),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 100,
              padding: const EdgeInsets.only(left: 35, right: 35, bottom: 5),
              color: AppColors.lightBlueColor,
              child: Column(
                children: [
                  //Invoice
                  Expanded(
                      child: Row(
                    children: [
                      Container(
                        width: 110,
                        child: Text(
                          'TOTAL PAYMENT',
                          style: TextStyle(
                              fontFamily: appFontFamily,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                              color: AppColors.black2Color),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      textFieldBottomBar()
                    ],
                  )),

                  Expanded(
                      child: Row(
                    children: [
                      Container(
                        width: 110,
                        child: Text(
                          'TOTAL CASH',
                          style: TextStyle(
                              fontFamily: appFontFamily,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                              color: AppColors.black2Color),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      textFieldBottomBar()
                    ],
                  )),
                  Expanded(
                      child: Row(
                    children: [
                      Container(
                        width: 110,
                        child: Text(
                          'TOTAL CHANGE',
                          style: TextStyle(
                              fontFamily: appFontFamily,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                              color: AppColors.black2Color),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      textFieldBottomBar()
                    ],
                  )),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 23, vertical: 13),
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IntrinsicHeight(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            storageList[0],
                            style: AppStyles.inwardTextBLUEStyle,
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              height: 40,
                              child: VerticalDivider(
                                thickness: 2,
                              ),
                            ),
                            textFieldValue()
                          ],
                        ),
                      ],
                    ),
                  ),
                  IntrinsicHeight(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            storageList[1],
                            style: AppStyles.inwardTextBLUEStyle,
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              height: 40,
                              child: VerticalDivider(
                                thickness: 2,
                              ),
                            ),
                            textFieldValue()
                          ],
                        ),
                      ],
                    ),
                  ),
                  IntrinsicHeight(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            storageList[2],
                            style: AppStyles.inwardTextBLUEStyle,
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              height: 40,
                              child: VerticalDivider(
                                thickness: 2,
                              ),
                            ),
                            textFieldValue()
                          ],
                        ),
                      ],
                    ),
                  ),
                  IntrinsicHeight(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            storageList[3],
                            style: AppStyles.inwardTextBLUEStyle,
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              height: 40,
                              child: VerticalDivider(
                                thickness: 2,
                              ),
                            ),
                            textFieldValue()
                          ],
                        ),
                      ],
                    ),
                  ),
                  IntrinsicHeight(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            storageList[4],
                            style: AppStyles.inwardTextBLUEStyle,
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              height: 40,
                              child: VerticalDivider(
                                thickness: 2,
                              ),
                            ),
                            textFieldValue()
                          ],
                        ),
                      ],
                    ),
                  ),
                  IntrinsicHeight(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            storageList[5],
                            style: AppStyles.inwardTextBLUEStyle,
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              height: 40,
                              child: VerticalDivider(
                                thickness: 2,
                              ),
                            ),
                            textFieldValue()
                          ],
                        ),
                      ],
                    ),
                  ),
                  IntrinsicHeight(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            storageList[6],
                            style: AppStyles.inwardTextBLUEStyle,
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              height: 40,
                              child: VerticalDivider(
                                thickness: 2,
                              ),
                            ),
                            textFieldValue()
                          ],
                        ),
                      ],
                    ),
                  ),
                  IntrinsicHeight(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            storageList[7],
                            style: AppStyles.inwardTextBLUEStyle,
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              height: 40,
                              child: VerticalDivider(
                                thickness: 2,
                              ),
                            ),
                            textFieldValue()
                          ],
                        ),
                      ],
                    ),
                  ),
                  IntrinsicHeight(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            storageList[9],
                            style: AppStyles.inwardTextBLUEStyle,
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              height: 40,
                              child: VerticalDivider(
                                thickness: 2,
                              ),
                            ),
                            textFieldValue()
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      )),
      bottomNavigationBar: InkWell(
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => DashBoardScreen()));
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8), topRight: Radius.circular(8)),
            color: AppColors.blueColor,
          ),
          alignment: Alignment.center,
          height: 60,
          child: Text(
            'SUBMIT',
            style: AppStyles.submitButtonStyle,
          ),
        ),
      ),
    );
  }
}
