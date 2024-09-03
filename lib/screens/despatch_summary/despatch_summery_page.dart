// ignore_for_file: unnecessary_null_comparison

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:parsel_flutter/models/firebase_location_lat_lng_model.dart';
import 'package:parsel_flutter/resource/app_fonts.dart';
import 'package:parsel_flutter/resource/app_helper.dart';
import 'package:parsel_flutter/resource/app_logs.dart';
import 'package:parsel_flutter/resource/app_styles.dart';
import 'package:parsel_flutter/screens/AUth/prominent_Disclosure.dart';
import 'package:parsel_flutter/screens/dashboard.dart';
import 'package:parsel_flutter/screens/despatch_summary/despatch_details.dart';
import 'package:parsel_flutter/screens/in_progress/location_service.dart';
import 'package:parsel_flutter/screens/in_progress/progress_page.dart';
import 'package:parsel_flutter/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Provider/Invoice_Controller.dart';
import '../../api/api.dart';
import '../../models/GetGroupByUserID.dart' as get_group;
import '../../models/InvoiceList_model.dart';
import '../../models/SkuList_model.dart';
import '../../models/despatch_sum_item.dart';
import '../../models/despatch_sum_model.dart';
import '../../resource/app_colors.dart';
import '../../resource/app_strings.dart';
import '../Pending/PickupOrders.dart';

class DespatchSummary extends StatefulWidget {
  const DespatchSummary({Key? key}) : super(key: key);

  @override
  State<DespatchSummary> createState() => _DespatchSummaryState();
}

class _DespatchSummaryState extends State<DespatchSummary> {
  // var _despatchValues = List<>();
  List<SkuDetails> skuList = [];
  List<get_group.SkuDetails> getGroup = [];
  final List<DespatchSummaryItem> _despatchValues = [];
  DespatchSummaryDetails? despatchDetails;
  bool _isLoading = true;
  var sum = 0;
  String? groupId;

  String? sId;
  @override
  void initState() {
    super.initState();
    if (ConnectivityHandler.connectivityResult.contains( ConnectivityResult.none)) {
      String dispatchDetails = VariableUtilities.preferences
              .getString(LocalCacheKey.dispatchDetails) ??
          '';
      if (dispatchDetails.isNotEmpty) {
        despatchDetails =
            DespatchSummaryDetails.fromJson(jsonDecode(dispatchDetails));
        convertDStoList();
      }
    } else {
      String driverId =
          (VariableUtilities.preferences.getString('userID') ?? '');
      GlobalVariablesUtils.globalSalesOrdersDb = FirebaseDatabase.instance
          .ref("driverLogs")
          .child(driverId)
          .child(DateFormat("yyyy-MM-dd").format(DateTime.now().toUtc()));
      GlobalVariablesUtils.globalDriversDb =
          FirebaseDatabase.instance.ref("drivers").child(driverId);
      getGroupByUser(context);
    }
  }

  @override
  void didChangeDependencies() {
    // _counter = Provider.of<int>(context);
    //  appLogs('didChangeDependencies(), counter = $_counter');
    super.didChangeDependencies();
  }

  Future iNpGetSalesOrderListByStatusInvoiceList(BuildContext context) async {
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
        appLogs('Response-->' + response.toString());
        if (response != null) {
          sId = response.body.data.resultList[0].salesOrderId;
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

  Future getSalesOrderListByStatusCountPending(BuildContext context) async {
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
      (InvoiceListModel? response) async {
        setState(() {
          _isLoading = false;
        });
        appLogs('Response-->' + response.toString());
        if (response != null) {
          var list = Provider.of<InvoiceController>(context, listen: false);
          list.setTotalCount(0);
          setState(() {});
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

  convertDStoList() {
    _despatchValues.add(DespatchSummaryItem(
        title: 'Driver Name', value: despatchDetails!.driverName));

    _despatchValues.add(DespatchSummaryItem(
        title: 'Delivery Time', value: despatchDetails!.deliveryTime));
    _despatchValues.add(DespatchSummaryItem(
        title: 'SKU Count', value: despatchDetails!.skuCount.toString()));
    _despatchValues.add(DespatchSummaryItem(
        title: 'SKU Qty Count', value: despatchDetails!.skuQtyCount));
    _despatchValues.add(DespatchSummaryItem(
        title: 'Delivery Point', value: despatchDetails!.deliveryPoint));
    _despatchValues.add(DespatchSummaryItem(
        title: 'No of Boxes', value: despatchDetails!.noOfParcel));
    _despatchValues
        .add(DespatchSummaryItem(title: 'Temp', value: despatchDetails!.temp));
    _despatchValues.add(DespatchSummaryItem(
        title: 'Dock Time', value: despatchDetails!.docTime));
    _despatchValues.add(
        DespatchSummaryItem(title: 'Photo', value: despatchDetails!.photoUrl));
  }

  Future getGroupByUser(BuildContext context) async {
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
        log('Response-->' + response!.toJson().toString());
        // SkuListModel sk= SkuListModel.fromJson(json)
        if (response != null) {
          // response.body!.data!.skuDetails![index].qty;
          // .map((e) => getGroup.add(e)).toList();
          groupId = response.body.data.id.toString();
          for (int i = 0; i < response.body.data.skuDetails.length; i++) {
            // getGroup.add(skuList[index].qty as get_group.SkuDetails);
            sum += response.body.data.skuDetails[i].qty;
          }
          appLogs("sum: " + sum.toString());
          despatchDetails = DespatchSummaryDetails(
              driverName: response.body.data.userDetails.username,
              managerName: 'Srinivasan',
              deliveryTime: response.body.data.createdTime.toString(),
              skuCount: response.body.data.skuDetails.length,
              skuQtyCount: sum.toString(),
              deliveryPoint:
                  response.body.data.extraInfo.salesOrderCount.toString(),
              noOfParcel: response.body.data.noOfBoxes.toString(),
              temp: response.body.data.temperature.toString(),
              docTime: response.body.data.createdTime.toString(),
              photoUrl: '');
          VariableUtilities.preferences.setString(
              LocalCacheKey.dispatchDetails, jsonEncode(despatchDetails));
          if (groupId != null || groupId != '') {
            VariableUtilities.preferences
                .setString(LocalCacheKey.groupIdForDisplayOrder, groupId ?? '');
          }
          convertDStoList();
        } else {
          AppHelper.showSnackBar(context, AppStrings.strSomethingWentWrong);
        }
      },
    ).onError((error, stackTrace) {
      appLogs("error --> $error");
      setState(() {
        _isLoading = false;
      });
    });
  }

  Future updateGroupIdDetails(
      BuildContext context, File file, int boxT, double temp) async {
    final preference = await SharedPreferences.getInstance();
    setState(() {
      _isLoading = true;
    });
    return await API
        .updateGroupIdDetails(
      context,
      showNoInternet: true,
      Authtoken: preference.getString("token").toString(),
      STATUS: 'ON_GOING',
      GROUPID: groupId.toString(),
      noOfBoxes: boxT,
      temperature: temp,
      Ifile: file,
    )
        .then(
      (bool response) async {
        setState(() {
          _isLoading = false;
        });
        print("response --> ${response != null} $response");
        if (response != null) {
          if (response == true) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const InProgressPage()),
                ((route) => false));
          } else {
            AppHelper.showSnackBar(context, AppStrings.strSomethingWentWrong);
          }
        } else {}
      },
    ).onError((error, stackTrace) {
      print("error --> $error");
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppHelper.appBarWithActionIcon(
          context,
          'DISPATCH SUMMARY',
          const PickupOrderScreen(),
          '',
          Icons.arrow_back_ios,
          Icons.question_mark),
      body: DespatchDetailsList(despatchValues: _despatchValues),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8), topRight: Radius.circular(8)),
          color: AppColors.blueColor,
        ),
        child: MaterialButton(
          height: 60.0,
          onPressed: () {
            showAlert(context);
          },
          child: const Text(
            'START TRIP',
            style: TextStyle(
              color: Colors.white,
              fontFamily: appFontFamily,
              letterSpacing: 0.1,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
          color: ColorUtils.kBottomButtonColor,
        ),
      ),
    );
  }

  //adding static data as despatch summary details - Srini
  //Show dialog for start trip
  showAlert(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Consumer<InvoiceController>(
            builder: (context, invoiceController, child) {
              return AlertDialog(
                title: Column(
                  children: [
                    Container(
                        alignment: Alignment.center,
                        child: SizedBox(
                          width: 40,
                          height: 40,
                          child: SvgPicture.asset("assets/logo.svg",
                              height: 40,
                              width: 40,
                              semanticsLabel: 'Acme Logo'),
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
                                  'CANCEL',
                                  style: TextStyle(color: Colors.white),
                                ))),
                      ),
                      const SizedBox(
                        width: 15.0,
                      ),
                      Expanded(
                        child: InkWell(
                            onTap: () async {
                              if (!await LocationService.instance
                                      .isPermissionGranted() ||
                                  !await LocationService.instance
                                      .checkServiceEnabled()) {
                                Navigator.pop(context);

                                if (!await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const ProminentDisclosure()))) {
                                  // Navigator.pop(context);
                                  return;
                                }
                              }
                              // if (!kDebugMode) {
                              final GeolocatorPlatform _geolocatorPlatform =
                                  GeolocatorPlatform.instance;
                              try {
                                final locationSettings = AndroidSettings(
                                  accuracy: LocationAccuracy.high,
                                  distanceFilter: 50,
                                  foregroundNotificationConfig:
                                      const ForegroundNotificationConfig(
                                    notificationText:
                                        "Parsel will continue to receive your location even when you aren't using it",
                                    notificationTitle: "Running in Background",
                                    enableWakeLock: true,
                                  ),
                                );
                                GlobalVariablesUtils.globalCurrentPosition =
                                    await _geolocatorPlatform
                                        .getCurrentPosition(
                                            locationSettings: locationSettings);
                                _pushLocationUpdate(GlobalVariablesUtils
                                    .globalCurrentPosition!);
                                if (GlobalVariablesUtils
                                        .globalLocationStreamSub !=
                                    null) {
                                  // if (_locationStreamSub.isPaused) {}
                                  GlobalVariablesUtils.globalLocationStreamSub!
                                      .cancel();
                                  GlobalVariablesUtils.globalLocationStreamSub =
                                      null;
                                }
                                if (GlobalVariablesUtils.globalUpdateTimer !=
                                    null) {
                                  GlobalVariablesUtils.globalUpdateTimer!
                                      .cancel();
                                }
                                GlobalVariablesUtils.globalUpdateTimer = null;
                                String driverId = (VariableUtilities.preferences
                                        .getString('userID') ??
                                    '');

                                VariableUtilities.preferences.setBool(
                                    '${LocalCacheKey.isDriverStartedTrip}-$driverId',
                                    true);

                                GlobalVariablesUtils.globalLocationStreamSub =
                                    _geolocatorPlatform
                                        .getPositionStream(
                                            locationSettings: locationSettings)
                                        .listen(_onPositionUpdate);
                              } catch (e) {
                                appLogs(e);
                              }
                              // }

                              if (ConnectivityHandler.connectivityResult.contains(
                                  ConnectivityResult.none)) {
                                String prefsQueApi = VariableUtilities
                                        .preferences
                                        .getString(LocalCacheKey.apiInQue) ??
                                    '';
                                List<dynamic> prefsList = [];
                                if (prefsQueApi.isNotEmpty) {
                                  prefsList = List<dynamic>.from(
                                      jsonDecode(prefsQueApi).map(
                                          (x) => jsonDecode(jsonEncode(x))));
                                }
                                for (int i = 0; i < prefsList.length; i++) {
                                  Map<String, dynamic> prefsJson = {};
                                  if (jsonDecode(jsonEncode(prefsList[i]))
                                          .runtimeType ==
                                      String) {
                                    prefsJson = jsonDecode(prefsList[i]);
                                  } else {
                                    prefsJson =
                                        jsonDecode(jsonEncode(prefsList[i]));
                                  }
                                  if (prefsJson['parameters']['GROUPID'] ==
                                      groupId.toString()) {
                                    AppHelper.showSnackBar(context,
                                        "Your Request is already submitted");
                                    // Navigator.pop(context);
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const DashBoardScreen()),
                                    );

                                    return;
                                  }
                                }
                                var jsonMap = {
                                  "function_name": "updateGroupIdDetails",
                                  "parameters": {
                                    "showNoInternet": true,
                                    "Authtoken": VariableUtilities.preferences
                                        .getString("token")
                                        .toString(),
                                    "STATUS": 'ON_GOING',
                                    "GROUPID": groupId.toString(),
                                    "noOfBoxes": invoiceController.getNOfBox,
                                    "temperature": invoiceController.getTemp,
                                    "Ifile": invoiceController.fileData!.path
                                  }
                                };
                                int pending = VariableUtilities.preferences
                                        .getInt(
                                            LocalCacheKey.pendingOrderCount) ??
                                    0;
                                pending = pending - 1;
                                if (pending.isNegative) {
                                  VariableUtilities.preferences.setInt(
                                      LocalCacheKey.pendingOrderCount, 0);
                                } else {
                                  VariableUtilities.preferences.setInt(
                                      LocalCacheKey.pendingOrderCount, pending);
                                }
                                int onGoing = VariableUtilities.preferences
                                        .getInt(LocalCacheKey
                                            .inProgressOrderCount) ??
                                    0;
                                if (onGoing.isNegative) {
                                  onGoing = 0;
                                  VariableUtilities.preferences.setInt(
                                      LocalCacheKey.inProgressOrderCount, 0);
                                } else {
                                  onGoing = onGoing + 1;
                                  VariableUtilities.preferences.setInt(
                                      LocalCacheKey.inProgressOrderCount,
                                      onGoing);
                                }

                                String updatedPrefsQueApi = VariableUtilities
                                        .preferences
                                        .getString(LocalCacheKey.apiInQue) ??
                                    '';
                                List<dynamic> updatedPrefsList = [];
                                if (updatedPrefsQueApi.isNotEmpty) {
                                  updatedPrefsList = List<dynamic>.from(
                                      jsonDecode(updatedPrefsQueApi).map(
                                          (x) => jsonDecode(jsonEncode(x))));
                                  updatedPrefsList.add(jsonEncode(jsonMap));
                                } else {
                                  updatedPrefsList.add(jsonEncode(jsonMap));
                                }

                                VariableUtilities.preferences.setString(
                                    LocalCacheKey.apiInQue,
                                    jsonEncode(updatedPrefsList));
                                AppHelper.showSnackBar(
                                    context, "Your Request is submitted");

                                // Navigator.pop(context);
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const DashBoardScreen()),
                                );

                                return;
                              }

                              // if (Invoice_Controller.fileData.path != '') {
                              // getSalesOrderListByStatusCountPending(context);
                              updateGroupIdDetails(
                                  context,
                                  invoiceController.fileData!,
                                  invoiceController.getNOfBox,
                                  invoiceController.getTemp);

                              // } else {
                              //   AppHelper.showSnackBar(
                              //       context, "Upload File First");
                              // }
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
        });
  }

  Future<void> _onPositionUpdate(Position position) async {
    appLogs('Listening position --> $position ');
    if (ConnectivityHandler.connectivityResult.contains( ConnectivityResult.none)) {
      List<FirebaseLocationLatLngModel> latLongList = [];
      if (GlobalVariablesUtils.globalUpdateTimer == null) {
        GlobalVariablesUtils.globalUpdateTimer =
            Timer.periodic(const Duration(seconds: 10), (timer) async {
          log('timer if offline-->> ${timer.tick}');
          if (ConnectivityHandler.connectivityResult.contains(
              ConnectivityResult.none) ){
            String prefsLatLongList = VariableUtilities.preferences
                    .getString(LocalCacheKey.latLongOfDriver) ??
                '';
            if (prefsLatLongList.isNotEmpty) {
              latLongList = List<FirebaseLocationLatLngModel>.from(
                  jsonDecode(prefsLatLongList).map((x) {
                return FirebaseLocationLatLngModel.fromJson(x);
              }));
              latLongList.add(FirebaseLocationLatLngModel(
                  lat: position.latitude,
                  lon: position.longitude,
                  heading: position.heading,
                  timestamp: DateTime.now().toUtc().toString()));
            } else {
              latLongList.add(FirebaseLocationLatLngModel(
                  lat: position.latitude,
                  lon: position.longitude,
                  heading: position.heading,
                  timestamp: DateTime.now().toUtc().toString()));
            }
            VariableUtilities.preferences.setString(
                LocalCacheKey.latLongOfDriver, jsonEncode(latLongList));
            log('latLongList --> $latLongList');
          } else {
            if (GlobalVariablesUtils.globalUpdateTimer != null) {
              GlobalVariablesUtils.globalUpdateTimer!.cancel();
            }
            GlobalVariablesUtils.globalUpdateTimer = null;
            timer.cancel();
          }
        });
      } else {
        GlobalVariablesUtils.globalUpdateTimer!.cancel();
        GlobalVariablesUtils.globalUpdateTimer =
            Timer.periodic(const Duration(seconds: 10), (timer) async {
          log('timer else-->> offline ${timer.tick}');
          if (ConnectivityHandler.connectivityResult.contains(
              ConnectivityResult.none)) {
            String prefsLatLongList = VariableUtilities.preferences
                    .getString(LocalCacheKey.latLongOfDriver) ??
                '';
            if (prefsLatLongList.isNotEmpty) {
              latLongList = List<FirebaseLocationLatLngModel>.from(
                  jsonDecode(prefsLatLongList).map((x) {
                return FirebaseLocationLatLngModel.fromJson(x);
              }));
              latLongList.add(FirebaseLocationLatLngModel(
                  lat: position.latitude,
                  lon: position.longitude,
                  heading: position.heading,
                  timestamp: DateTime.now().toUtc().toString()));
            } else {
              latLongList.add(FirebaseLocationLatLngModel(
                  lat: position.latitude,
                  lon: position.longitude,
                  heading: position.heading,
                  timestamp: DateTime.now().toUtc().toString()));
            }
            VariableUtilities.preferences.setString(
                LocalCacheKey.latLongOfDriver, jsonEncode(latLongList));
            log('latLongList --> $latLongList');
          } else {
            if (GlobalVariablesUtils.globalUpdateTimer != null) {
              GlobalVariablesUtils.globalUpdateTimer!.cancel();
            }
            GlobalVariablesUtils.globalUpdateTimer = null;
            timer.cancel();
          }
        });
      }
    }
    if (ConnectivityHandler.connectivityResult.contains( ConnectivityResult.mobile) ||
        ConnectivityHandler.connectivityResult.contains( ConnectivityResult.wifi)) {
      GlobalVariablesUtils.globalLastPosition =
          GlobalVariablesUtils.globalCurrentPosition;
      GlobalVariablesUtils.globalCurrentPosition = position;
      if (GlobalVariablesUtils.globalUpdateTimer == null) {
        // await _pushLocationUpdate(GlobalVariablesUtils.globalCurrentPosition!);
        GlobalVariablesUtils.globalUpdateTimer =
            Timer.periodic(const Duration(seconds: 10), (timer) async {
          log('timer if -->> online ${timer.tick}');
          if (ConnectivityHandler.connectivityResult.contains(
                  ConnectivityResult.wifi) ||
              ConnectivityHandler.connectivityResult.contains(
                  ConnectivityResult.mobile)) {
            if (GlobalVariablesUtils.globalCurrentPosition != null) {
              await _pushLocationUpdate(
                  GlobalVariablesUtils.globalCurrentPosition!);
            }
          } else {
            if (GlobalVariablesUtils.globalUpdateTimer != null) {
              GlobalVariablesUtils.globalUpdateTimer!.cancel();
            }
            GlobalVariablesUtils.globalUpdateTimer = null;
            timer.cancel();
          }
        });
      } else {
        GlobalVariablesUtils.globalUpdateTimer!.cancel();
        GlobalVariablesUtils.globalUpdateTimer =
            Timer.periodic(const Duration(seconds: 10), (timer) async {
          log('timer else-->> online ${timer.tick}');
          if (ConnectivityHandler.connectivityResult.contains(
                  ConnectivityResult.wifi) ||
              ConnectivityHandler.connectivityResult.contains(
                  ConnectivityResult.mobile)) {
            if (GlobalVariablesUtils.globalCurrentPosition != null) {
              await _pushLocationUpdate(
                  GlobalVariablesUtils.globalCurrentPosition!);
            }
          } else {
            if (GlobalVariablesUtils.globalUpdateTimer != null) {
              GlobalVariablesUtils.globalUpdateTimer!.cancel();
            }
            GlobalVariablesUtils.globalUpdateTimer = null;
            timer.cancel();
          }
        });
      }
    }
  }

  Future<void> _pushLocationUpdate(Position position) async {
    final time = DateTime.now().toUtc();
    final _currentTime = time.millisecondsSinceEpoch;
    final shouldUpdate = (Duration(
                    milliseconds: _currentTime -
                        GlobalVariablesUtils.globalLastUpdateTime)
                .inSeconds >=
            10) ||
        (position.latitude !=
            GlobalVariablesUtils.globalLastPosition?.latitude) ||
        (position.longitude !=
            GlobalVariablesUtils.globalLastPosition?.longitude);

    // appLogs("shouldUpdate: $shouldUpdate");
    if (!shouldUpdate) {
      return;
    }
    GlobalVariablesUtils.globalLastUpdateTime = time.millisecondsSinceEpoch;
    try {
      /*appLogs(
          "---------------dbRef: ${_firebaseDb.path}\t\t${_firebaseDb.key}\t\t${_firebaseDb.root.path}");*/
      final locationEntry = {
        "lat": position.latitude,
        "lon": position.longitude,
        "heading": position.heading,
        "timestamp": time.toString(),
      };
      log("locationEntry --> $locationEntry");
      String driverId =
          (VariableUtilities.preferences.getString('userID') ?? '');
      GlobalVariablesUtils.globalSalesOrdersDb = FirebaseDatabase.instance
          .ref("driverLogs")
          .child(driverId)
          .child(DateFormat("yyyy-MM-dd").format(DateTime.now().toUtc()));
      GlobalVariablesUtils.globalDriversDb =
          FirebaseDatabase.instance.ref("drivers").child(driverId);

      await Future.wait([
        // _sendLocationUpdateToBackend(position),
        GlobalVariablesUtils.globalSalesOrdersDb.push().set(locationEntry),
        GlobalVariablesUtils.globalDriversDb.set({
          ...locationEntry,
          "status": 'active',
        }),
      ]);
    } catch (e) {
      appLogs(
          "---------------- firebase db update error: -----------------------------");
      appLogs(e);
    }
  }
}
