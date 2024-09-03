import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:parsel_flutter/models/despatch_sum_model.dart';
import 'package:parsel_flutter/resource/app_fonts.dart';
import 'package:parsel_flutter/resource/app_logs.dart';
import 'package:parsel_flutter/src/widget/widget.dart';
import 'package:parsel_flutter/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Provider/Invoice_Controller.dart';
import '../../api/api.dart';
import '../../models/COUNT_MODAL.dart';
import '../../models/GetGroupByUserID.dart' as get_group;
import '../../resource/app_helper.dart';
import '../../resource/app_strings.dart';
import '../dashboard.dart';
import 'Pending.dart';
import 'pickuppoint.dart';

class PendingfirstScreen extends StatefulWidget {
  const PendingfirstScreen({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return PendingfirstScreenState();
  }
}

class PendingfirstScreenState extends State<PendingfirstScreen> {
  int tabSelection = 2;
  bool _isLoading = false;

  int pending = 0;

  @override
  void initState() {
    // tabValue = widget.tabSelection;
    super.initState();
    getCountAPINew(context);
    if (ConnectivityHandler.connectivityResult .contains( ConnectivityResult.none)) {
      updateCountForOrderTask();
    }
  }

  updateCountForOrderTask() {
    pending =
        VariableUtilities.preferences.getInt(LocalCacheKey.pendingOrderCount) ??
            0;
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

  // Future getSalesOrderListByStatusCountPending(BuildContext context) async {
  //   final preference = await SharedPreferences.getInstance();
  //   setState(() {
  //     _isLoading = true;
  //   });
  //   return await API
  //       .getSalesOrderListByStatusInvoiceList(context,
  //           showNoInternet: true,
  //           Authtoken: preference.getString("token").toString(),
  //           DEIVERID: preference.getString("userID").toString(),
  //           STATUS: 'IN_GROUP',
  //           TODAYDATE: DateFormat('yyyy-MM-dd').format((DateTime.now())))
  //       .then(
  //     (InvoiceListModel? response) async {
  //       setState(() {
  //         _isLoading = false;
  //       });
  //       appLogs('Response-->' + response.toString());
  //       if (response != null) {
  //         var list = Provider.of<Invoice_Controller>(context, listen: false);
  //         list.setTotalCount(response.body!.data!.totalCount!);
  //         final preference = await SharedPreferences.getInstance();
  //       } else {
  //         AppHelper.showSnackBar(context, AppStrings.strSomethingWentWrong);
  //       }
  //     },
  //   ).onError((error, stackTrace) {
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Consumer<InvoiceController>(
        builder: (context, invoiceController, child) {
      return Stack(
        children: [
          Scaffold(
            appBar: AppHelper.appBar(context, 'PENDING(${pending.toString()})',
                const DashBoardScreen(), Icons.arrow_back_ios),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 50,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      DateFormat("dd-MM-yyyy")
                          .format(DateTime.now())
                          .toString(),
                      style: TextStyle(
                          fontSize: 20,
                          color: ColorUtils.dateColor,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  width: 124,
                  height: 48,
                  decoration: BoxDecoration(
                    border: Border.all(width: 1.0),
                    borderRadius: const BorderRadius.all(Radius.circular(
                            5.0) //                 <--- border radius here
                        ),
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: ColorUtils.buttonColor),
                    onPressed: () async {
                      final preference = await SharedPreferences.getInstance();
                      setState(() {
                        _isLoading = true;
                      });
                      return await API
                          .getGroupByUserID(
                        context,
                        showNoInternet: true,
                        Authtoken: preference.getString("token").toString(),
                        DEIVERID: preference.getString("userID").toString(),
                      )
                          .then(
                        (get_group.GetGroupByUserIDModel? response) async {
                          setState(() {
                            _isLoading = false;
                          });
                          double sum = 0;
                          log('Response--> Dispatch' +
                              response!.toJson().toString());
                          // SkuListModel sk= SkuListModel.fromJson(json)
                          // ignore: unnecessary_null_comparison
                          if (response != null) {
                            if (response.status == true) {
                              for (int i = 0;
                                  i < response.body.data.skuDetails.length;
                                  i++) {
                                // getGroup.add(skuList[index].qty as get_group.SkuDetails);
                                sum += response.body.data.skuDetails[i].qty;
                              }
                              appLogs("sum: " + sum.toString());
                              DespatchSummaryDetails despatchDetails =
                                  DespatchSummaryDetails(
                                      driverName: response
                                          .body.data.userDetails.username,
                                      managerName: 'Srinivasan',
                                      deliveryTime: response
                                          .body.data.createdTime
                                          .toString(),
                                      skuCount:
                                          response.body.data.skuDetails.length,
                                      skuQtyCount: sum.toString(),
                                      deliveryPoint: response
                                          .body.data.extraInfo.salesOrderCount
                                          .toString(),
                                      noOfParcel: response.body.data.noOfBoxes
                                          .toString(),
                                      temp: response.body.data.temperature
                                          .toString(),
                                      docTime: response.body.data.createdTime
                                          .toString(),
                                      photoUrl: '');
                              log('Response--> Pending' +
                                  despatchDetails.toJson().toString());
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => Pickuppoint(
                                            despatchDetails: despatchDetails,
                                          )));
                            }
                            // response.body!.data!.skuDetails![index].qty;
                            // .map((e) => getGroup.add(e)).toList();
                          } else {
                            AppHelper.showSnackBar(
                                context, AppStrings.strSomethingWentWrong);
                          }
                        },
                      ).onError((error, stackTrace) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => Pickuppoint(
                                    despatchDetails: DespatchSummaryDetails(
                                        driverName: '',
                                        managerName: 'Srinivasan',
                                        deliveryTime: ''.toString(),
                                        skuCount: 0,
                                        skuQtyCount: '0',
                                        deliveryPoint: '',
                                        noOfParcel: '',
                                        temp: '',
                                        docTime: '',
                                        photoUrl: ''))));
                        appLogs("error --> $error");
                        setState(() {
                          _isLoading = false;
                        });
                      });
                    },
                    child: const Text(
                      "START",
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontFamily: appFontFamily,
                          letterSpacing: 0.2,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  width: 124,
                  height: 48,
                  decoration: BoxDecoration(
                    border: Border.all(width: 1.0),
                    borderRadius: const BorderRadius.all(Radius.circular(
                            5.0) //                 <--- border radius here
                        ),
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: ColorUtils.buttonColor),
                    onPressed: () {
                      setState(() {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const Pending(
                                      tabSelection: 1,
                                    )));
                      });
                    },
                    child: Text(
                      "INVOICE(${pending.toString()})",
                      style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontFamily: appFontFamily,
                          letterSpacing: 0.2,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  width: 85,
                  height: 48,
                  decoration: BoxDecoration(
                    border: Border.all(width: 1.0),
                    borderRadius: const BorderRadius.all(Radius.circular(
                            5.0) //                 <--- border radius here
                        ),
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: ColorUtils.buttonColor),
                    onPressed: () {
                      setState(() {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const Pending(
                                      tabSelection: 2,
                                    )));
                      });
                    },
                    child: const Text(
                      "SKU'S",
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontFamily: appFontFamily,
                          letterSpacing: 0.2,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
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
              const SizedBox(
                height: 10,
              ),
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
          ),
          Visibility(
              visible: _isLoading, child: CustomCircularProgressIndicator())
        ],
      );
    });
  }
}
