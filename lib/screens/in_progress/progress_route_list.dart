import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:parsel_flutter/models/routeOptimised_modal.dart' as RO;
import 'package:parsel_flutter/resource/app_colors.dart';
import 'package:parsel_flutter/resource/app_fonts.dart';
import 'package:parsel_flutter/screens/AUth/prominent_Disclosure.dart';
import 'package:parsel_flutter/screens/in_progress/location_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Provider/Delivery_Controller.dart';
import '../../api/api.dart';
import '../../models/InvoiceList_model.dart';
import '../../resource/app_helper.dart';
import '../../resource/app_strings.dart';

// ignore: must_be_immutable
class ProgressRouteList extends StatefulWidget {
  final void Function(ResultList order) startTrip;

  const ProgressRouteList({
    Key? key,
    required List<ResultList> routeDataList,
    required this.startTrip,
  })  : _routeDataList = routeDataList,
        super(key: key);
  final List<ResultList> _routeDataList;

  @override
  State<ProgressRouteList> createState() => _ProgressRouteListState();
}

class _ProgressRouteListState extends State<ProgressRouteList> {
  List<ResultList> _InvoiceResultList = [];
  List<RO.Data> _dataList = [];

  bool _isLoading = false;

  int? index = 0;

  int isSelected = 0;

  String? salesOrderId;

  List<String> rolist = [];
  String? rolist1 = '';
  double lat_single = 0.0;
  double lon_single = 0.0;
  int? roLength = 0;

  @override
  void initState() {
    // TODO: implement initState
    print("Progress Route -->");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget._routeDataList.isNotEmpty
        ? ListView.builder(
            itemCount:
                // widget._roList.length,
                widget._routeDataList.length,
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, index) {
              return routeItem(widget._routeDataList[index]
                  // , widget._groupId!
                  );
            })
        : const Center(
            child: Text("No Data"),
          );
  }

  Future INpgetSalesOrderListByStatusInvoiceList(
      BuildContext context, index) async {
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
        print("Progress --> Loading");
        setState(() {
          _isLoading = false;
        });
        if (response != null) {
          response.body!.data!.resultList!
              .map((e) => _InvoiceResultList.add(e))
              .toList();
          // lat_single =
          //     _InvoiceResultList[index].store!.addressList![0].latitude!;
          // lon_single =
          //     _InvoiceResultList[index].store!.addressList![0].longitude!;
          print('invoiceResultList-->' + _InvoiceResultList.toString());
        } else {
          print('in response null');
          AppHelper.showSnackBar(context, AppStrings.strSomethingWentWrong);
        }
      },
    ).onError((error, stackTrace) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  Widget routeItem(ResultList routeDataList) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, left: 15.0, right: 15.0),
      child: InkWell(
          onTap: () => _ensureLocationActive(routeDataList),
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                elevation: 3.0,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Expanded(
                              child: Text(
                            'Customer ID',
                            style: TextStyle(
                                fontFamily: appFontFamily,
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: AppColors.blueColor),
                          )),
                          const Padding(
                            padding: EdgeInsets.only(left: 10.0, right: 10.0),
                          ),
                          Expanded(
                              child: Text(
                            "${routeDataList.id}",
                            style: TextStyle(
                                fontFamily: appFontFamily,
                                fontWeight: FontWeight.w500,
                                color: AppColors.black2Color.withOpacity(0.6)),
                          )),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          const Expanded(
                              child: Text(
                            'Customer Name',
                            style: TextStyle(
                                fontFamily: appFontFamily,
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: AppColors.blueColor),
                          )),
                          const Padding(
                            padding: EdgeInsets.only(left: 10.0, right: 10.0),
                          ),
                          Expanded(
                              child: Text(
                            routeDataList.store!.storeName.toString(),
                            style: TextStyle(
                                fontFamily: appFontFamily,
                                fontWeight: FontWeight.w500,
                                color: AppColors.black2Color.withOpacity(0.6)),
                          )),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Expanded(
                              child: Text(
                            'Address',
                            style: TextStyle(
                                fontFamily: appFontFamily,
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: AppColors.blueColor),
                          )),
                          const Padding(
                            padding: EdgeInsets.only(left: 10.0, right: 10.0),
                          ),
                          Expanded(
                              child: Text(
                            routeDataList.deliveryAddress.toString(),
                            style: TextStyle(
                                fontFamily: appFontFamily,
                                fontWeight: FontWeight.w500,
                                color: AppColors.black2Color.withOpacity(0.6)),
                          ))
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          const Expanded(
                              child: Text(
                            'Invoice No',
                            style: TextStyle(
                                fontFamily: appFontFamily,
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: AppColors.blueColor),
                          )),
                          const Padding(
                            padding: EdgeInsets.only(left: 10.0, right: 10.0),
                          ),
                          Expanded(
                              child: Text(
                            "${routeDataList.salesOrderId}",
                            style: TextStyle(
                                fontFamily: appFontFamily,
                                fontWeight: FontWeight.w500,
                                color: AppColors.black2Color.withOpacity(0.6)),
                          )),
                        ],
                      )
                    ],
                  ),
                )),
          )
          // : SizedBox(),
          ),
    );
  }

  Future<void> _ensureLocationActive(ResultList routeDataList) async {
    if (!await LocationService.instance.isPermissionGranted() ||
        !await LocationService.instance.checkServiceEnabled()) {
      if (!await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const ProminentDisclosure()))) {
        return;
      }
    }
    showAlert(context, false, routeDataList);
  }

  showAlert(BuildContext context, bool showMapLink, ResultList resultList) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Consumer<DeliveryController>(builder: (context, Ddata, child) {
          return AlertDialog(
            title: Column(
              children: [
                Container(
                    alignment: Alignment.center,
                    child: Container(
                        width: 40,
                        height: 40,
                        child: SvgPicture.asset("assets/logo.svg",
                            semanticsLabel: 'Acme Logo'))),
                const Padding(
                  padding: const EdgeInsets.only(top: 15.0, bottom: 2.0),
                  child: Text(
                    'START TRIP',
                    style: TextStyle(
                        color: AppColors.blueColor,
                        fontSize: 13,
                        fontFamily: appFontFamily,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            content: SizedBox(
              height: showMapLink ? 130.0 : 90.0,
              child: const Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 32.0),
                    child: Text("Are you sure you want to start trip?",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 13,
                            fontFamily: appFontFamily,
                            fontWeight: FontWeight.w400,
                            letterSpacing: -1)),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    Visibility(
                      visible: !showMapLink,
                      child: Expanded(
                        child: InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                              widget.startTrip(resultList);
                            },
                            child: Container(
                                height: 40,
                                alignment: Alignment.center,
                                padding: const EdgeInsets.all(10),
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
                                child: Text(
                                  showMapLink ? 'CLOSE' : 'START TRIP',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12,
                                      letterSpacing: 1),
                                ))),
                      ),
                    )
                  ],
                ),
              ),
            ],
          );
        });
      },
    );
  }
}
