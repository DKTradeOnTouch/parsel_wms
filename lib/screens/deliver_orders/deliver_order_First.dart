// ignore_for_file: constant_identifier_names

import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:parsel_flutter/api/endpoints.dart';
import 'package:parsel_flutter/models/InvoiceList_model.dart';
import 'package:parsel_flutter/models/LocationCreate_model.dart';
import 'package:parsel_flutter/models/base_moel.dart';
import 'package:parsel_flutter/resource/app_icons.dart';
import 'package:parsel_flutter/resource/app_logs.dart';
import 'package:parsel_flutter/screens/dashboard.dart';
import 'package:parsel_flutter/screens/in_progress/google_map/mapsDirect.dart';
import 'package:parsel_flutter/utils/dialogs.dart';
import 'package:parsel_flutter/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Provider/Delivery_Controller.dart';
import '../../api/api.dart';
import '../../models/SalesOrderBYID_Model.dart' as sales;
import '../../models/UpdateSalesOrder_model.dart' as up;
import '../../models/startTrip_modal.dart';
import '../../models/uploadsalesorder_model.dart' as uploads;
import '../../resource/app_colors.dart';
import '../../resource/app_fonts.dart';
import '../../resource/app_helper.dart';
import '../../resource/app_strings.dart';
import '../../resource/app_styles.dart';
import 'deliver_orders_page.dart';

///Store currentPosition with invoice number
class DeliveredOrderFirstPage extends StatefulWidget {
  DeliveredOrderFirstPage(
      {Key? key,
      required String diff,
      required this.salesOrderId,
      required this.id,
      required ResultList routeDataList})
      : _routeDataList = routeDataList,
        super(key: key);
  ResultList _routeDataList;

  final String salesOrderId;
  final String id;

  @override
  State<DeliveredOrderFirstPage> createState() => _DeliverOrdersState();
}

class _DeliverOrdersState extends State<DeliveredOrderFirstPage> {
  static const String _STATUS_PAUSED = "paused";
  static const String _STATUS_ACTIVE = "active";
  static const String _STATUS_COMPLETED = "completed";
  sales.Store? store;

  // List<ItemList> dataList = [];
  List<uploads.ItemList> dataUp = [];
  List<sales.ItemList> deliverOrdersList = [];
  List<sales.ItemList> dataList = [];

//  List< INVOICE.ResultList>  resultList1=[];
  // final List<ItemList> temp = [];

  StreamSubscription<Position>? _locationStreamSub;
  Timer? _updateTimer;
  Position? _lastPosition;
  Position? _currentPosition;
  int _lastUpdateTime = 0;

  bool _canCompleteTrip = false;

  late final SharedPreferences _prefs;
  late final DatabaseReference _salesOrdersDb;
  late final DatabaseReference _driversDb;
  late final String driverId;
  late sales.SalesOrderBYID_Model salesOrder;
  final _formKey = GlobalKey<FormState>();
  String arrived = '';
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    //_getLocation();
    WidgetsBinding.instance.addPostFrameCallback((timestamp) {
      setState(() {
        arrived = VariableUtilities.preferences.getString(
                "${LocalCacheKey.deliverOrderArrivedByInvoice}Arrived${widget.salesOrderId}") ??
            '';
        appLogs("arrived ------------> $arrived");
      });
      if (ConnectivityHandler.connectivityResult
          .contains(ConnectivityResult.none)) {
        getSalesDataFromPrefs();
      } else {
        // GetSalesorderbyID(context);
        _initialize();
      }
    });
  }

  getSalesDataFromPrefs() {
    String prefsSalesOrder = VariableUtilities.preferences.getString(
            "${LocalCacheKey.salesOrderBySalesOrderId}${widget.salesOrderId}") ??
        '';
    if (prefsSalesOrder != '') {
      salesOrder =
          sales.SalesOrderBYID_Model.fromJson(jsonDecode(prefsSalesOrder));
    }

    String prefsDataList = VariableUtilities.preferences.getString(
            "${LocalCacheKey.deliveredOrderDataList}${widget.salesOrderId}") ??
        '';

    if (prefsDataList != '') {
      dataList = List<sales.ItemList>.from(
          jsonDecode(prefsDataList).map((x) => sales.ItemList.fromJson(x)));
    }

    String prefsDataUp = VariableUtilities.preferences.getString(
            "${LocalCacheKey.deliveredOrderDataUp}${widget.salesOrderId}") ??
        '';

    if (prefsDataUp != '') {
      dataUp = List<uploads.ItemList>.from(
          jsonDecode(prefsDataUp).map((x) => uploads.ItemList.fromJson(x)));
      var list = Provider.of<DeliveryController>(context, listen: false);
      for (int i = 0; i < dataUp.length; i++) {
        appLogs("Data Up --> $i ${dataUp[i].delivered}");
        appLogs("Data Up --> $i ${dataUp[i].returned}");
        appLogs("Data Up --> $i ${dataUp[i].qty}");
        appLogs("Data Up --> $i ${dataUp[i].returned}");
      }
      list.setAllDeliveryItem(dataUp);
    }
    String prefsDataDeliverOrder = VariableUtilities.preferences.getString(
            "${LocalCacheKey.deliverDeliverOrdersList}${widget.salesOrderId}") ??
        '';

    if (prefsDataDeliverOrder != '') {
      deliverOrdersList = List<sales.ItemList>.from(
          jsonDecode(prefsDataDeliverOrder)
              .map((x) => sales.ItemList.fromJson(x)));
    }
    String prefsDeliveredStore = VariableUtilities.preferences.getString(
            "${LocalCacheKey.deliveredOrderStore}${widget.salesOrderId}") ??
        '';
    if (prefsDeliveredStore != '') {
      store = sales.Store.fromJson(jsonDecode(prefsDeliveredStore));
    }
    setState(() {});
  }

  Future<void> _initialize() async {
    try {
      setState(() {
        isLoading = true;
      });
      _prefs = await SharedPreferences.getInstance();
      driverId = (_prefs.getString('userID') ?? '');
      // _canCompleteTrip =
      //     (_prefs.getBool('CanCompleteTrip-${widget.id}') ?? false);
      // setState(() {});

      _salesOrdersDb = FirebaseDatabase.instance
          .ref("driverLogs")
          .child(driverId)
          .child(DateFormat("yyyy-MM-dd").format(DateTime.now().toUtc()));
      _driversDb = FirebaseDatabase.instance.ref("drivers").child(driverId);
      await getSalesorderbyID(context);
      // await startTrip();
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _pushLocationUpdate(
      BuildContext context, Position position) async {
    final time = DateTime.now().toUtc();
    final _currentTime = time.millisecondsSinceEpoch;
    final shouldUpdate =
        (Duration(milliseconds: _currentTime - _lastUpdateTime).inSeconds >=
                10) ||
            (position.latitude != _lastPosition?.latitude) ||
            (position.longitude != _lastPosition?.longitude);

    // appLogs("shouldUpdate: $shouldUpdate");
    if (!shouldUpdate) {
      return;
    }
    _lastUpdateTime = time.millisecondsSinceEpoch;
    try {
      appLogs('Firebase called ----------------------------------------');
      /*appLogs(
          "---------------dbRef: ${_firebaseDb.path}\t\t${_firebaseDb.key}\t\t${_firebaseDb.root.path}");*/
      final locationEntry = {
        "lat": position.latitude,
        "lon": position.longitude,
        "heading": position.heading,
        "timestamp": time.toString(),
      };
      await Future.wait([
        // _sendLocationUpdateToBackend(position),
        _salesOrdersDb.push().set(locationEntry),
        _driversDb.set({
          ...locationEntry,
          "status": _STATUS_ACTIVE,
        }),
      ]);
    } catch (e) {
      appLogs(
          "---------------- firebase db update error: -----------------------------");
      appLogs(e);
    }
  }

  Future<void> _updateLocationStatus(String status) async =>
      _driversDb.update({"status": status});

  Future getSalesorderbyID(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    appLogs("GetSalesorderbyID ----------------------------------------------");
    final preference = await SharedPreferences.getInstance();
    return await API.GetSalesorderbyID(
      context,
      showNoInternet: true,
      Authtoken: preference.getString("token").toString(),
      ID: widget.id,
    ).then(
      (sales.SalesOrderBYID_Model? response) async {
        setState(() {
          isLoading = false;
        });
        appLogs('response-->' + response.toString());
        if (response != null) {
          VariableUtilities.preferences.setString(
              "${LocalCacheKey.salesOrderBySalesOrderId}${widget.salesOrderId}",
              jsonEncode(response));
          salesOrder = response;
          deliverOrdersList.addAll(response.data!.itemList!);
          if (response.data!.itemList != null) {
            for (int i = 0; i < response.data!.itemList!.length; i++) {
              appLogs('Updated Reason --> ${response.data!.itemList![i].qty}');
            }
          }
          VariableUtilities.preferences.setString(
              "${LocalCacheKey.deliverDeliverOrdersList}${widget.salesOrderId}",
              jsonEncode(deliverOrdersList));
          dataList.addAll(response.data!.itemList!);
          // dataList.addAll(response.data!.itemList!);
          VariableUtilities.preferences.setString(
              "${LocalCacheKey.deliveredOrderDataList}${widget.salesOrderId}",
              jsonEncode(dataList));
          store = response.data!.store!;
          // store = response.data!.store!;
          VariableUtilities.preferences.setString(
              "${LocalCacheKey.deliveredOrderStore}${widget.salesOrderId}",
              jsonEncode(store));
          var list = Provider.of<DeliveryController>(context, listen: false);
          list.dpItemList.clear();
          response.data!.itemList!
              .map((e) => dataUp.add(uploads.ItemList(
                  productCode: e.productCode,
                  qty: e.qty,
                  returnReason: "Reason 1",
                  returned: e.returned,
                  delivered: e.qty - e.returned)))
              .toList();
          VariableUtilities.preferences.setString(
              "${LocalCacheKey.deliveredOrderDataUp}${widget.salesOrderId}",
              jsonEncode(dataUp));
          list.setAllDeliveryItem(dataUp);

          // appLogs("list  --> ${dataUp.}");
          await _startLocationUpdates();
          // for (int i = 0; i < dataUp.length; i++) {}
          setState(() {});
        } else {
          AppHelper.showSnackBar(context, AppStrings.strSomethingWentWrong);
        }
      },
    ).onError((error, stackTrace) {
      appLogs("error: $error");
      setState(() {
        isLoading = false;
      });
    });
  }

  Future<void> _startLocationUpdates() async {
    appLogs("_startLocationUpdates");
    setState(() {});
    _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    // appLogs("initialPosition: $_currentPosition");
    try {
      _updateCanCompleteTrip(_currentPosition!);
      // _pushLocationUpdate(context, _currentPosition!);
      // final locationSettings = AndroidSettings(
      //   accuracy: LocationAccuracy.high,
      //   distanceFilter: 50,
      //   foregroundNotificationConfig: const ForegroundNotificationConfig(
      //     notificationText:
      //         "Parsel will continue to receive your location even when you aren't using it",
      //     notificationTitle: "Running in Background",
      //     enableWakeLock: true,
      //   ),
      // );

      // _locationStreamSub =
      //     Geolocator.getPositionStream(locationSettings: locationSettings)
      //         .listen(_onPositionUpdate);
      // _updateTimer = Timer.periodic(
      //     const Duration(seconds: 10, milliseconds: 50), (timer) async {
      //   if (_currentPosition != null) {
      //     await _pushLocationUpdate(context, _currentPosition!);
      //   }
      // });
    } catch (e) {
      appLogs(e);
    }
  }

  Future<void> _onPositionUpdate(Position position) async {
    appLogs(" _onPositionUpdate: $position");

    _lastPosition = _currentPosition;
    _currentPosition = position;
    (position);
    if (_canCompleteTrip) {
      await _pushLocationUpdate(context, _currentPosition!);
    }
  }

  void _updateCanCompleteTrip(Position position) async {
    final distance = Geolocator.distanceBetween(deliveryCordinates.lat!,
        deliveryCordinates.long!, position.latitude, position.longitude);
    setState(() {
      _canCompleteTrip = distance <= 500;
    });
    _prefs.setBool("CanCompleteTrip-${widget.id}", _canCompleteTrip);
  }

  @override
  void dispose() {
    _stopLocationStream();
    super.dispose();
  }

  void _stopLocationStream() {
    _updateTimer?.cancel();
    _updateTimer = null;
    _locationStreamSub?.cancel();
    _locationStreamSub = null;
  }

  Future cancelTrip(BuildContext context) async {
    _stopLocationStream();
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
        if (prefsJson['parameters']['ID'] == widget.salesOrderId.toString()) {
          if (prefsJson['function_name'] == 'cancelTripFunction') {
            Map<String, dynamic> cancelTripFunction = {
              "function_name": "cancelTripFunction",
              'parameters': {
                'showNoInternet': true,
                'executionStatus': 'IN_GROUP',
                'ID': widget.salesOrderId
              }
            };

            prefsList.insert(i, cancelTripFunction);
            prefsList.removeWhere((element) {
              Map<String, dynamic> elementJson = {};

              if (element.runtimeType == String) {
                elementJson = jsonDecode(element);
              } else {
                elementJson = jsonDecode(jsonEncode(element));
              }
              return elementJson['function_name'] ==
                      prefsJson['function_name'] &&
                  prefsJson['parameters']['ID'] ==
                      widget.salesOrderId.toString();
            });

            AppHelper.showSnackBar(
                context, "Your Request is already submitted");
            VariableUtilities.preferences.setString(
                LocalCacheKey.paymentApiInQue, jsonEncode(prefsList));
            Navigator.pop(context);
            return;
          }
        }
      }

      Map<String, dynamic> cancelTripFunction = {
        "function_name": "cancelTripFunction",
        'parameters': {
          'showNoInternet': true,
          'executionStatus': 'IN_GROUP',
          'ID': widget.salesOrderId
        }
      };
      List<dynamic> updatedPrefsList = [];
      if (prefsQueApi.isNotEmpty) {
        updatedPrefsList = List<dynamic>.from(
            jsonDecode(prefsQueApi).map((x) => jsonDecode(jsonEncode(x))));
        updatedPrefsList.add(jsonEncode(cancelTripFunction));
      } else {
        updatedPrefsList.add(jsonEncode(cancelTripFunction));
      }

      VariableUtilities.preferences.setString(
          LocalCacheKey.paymentApiInQue, jsonEncode(updatedPrefsList));
      AppHelper.showSnackBar(context, "Your Request is Submitted!");
      Navigator.pop(context);

      return;
    }
    if (ConnectivityHandler.connectivityResult
            .contains(ConnectivityResult.mobile) ||
        ConnectivityHandler.connectivityResult
            .contains(ConnectivityResult.wifi)) {
      try {
        await _updateLocationStatus(_STATUS_PAUSED);
        return await API
            .startTrip(context,
                showNoInternet: true,
                executionStatus: 'IN_GROUP',
                ID: widget.salesOrderId)
            .then(
          (StartTripModal? response) async {
            if (response == null) {
              AppHelper.showSnackBar(context, AppStrings.strSomethingWentWrong);
            }
            Navigator.pop(context);
          },
        ).onError((error, stackTrace) {
          appLogs(error);
        });
      } catch (e) {
        Navigator.pop(context);
      }
    }
  }

  Future<void> updateStoreLocation() async {
    appLogs("Update location");
    if (ConnectivityHandler.connectivityResult
        .contains(ConnectivityResult.none)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Failed: Please, Connect with Internet.")));
    } else {
      try {
        final dio = Dio()
          ..interceptors
              .add(LogInterceptor(responseBody: true, requestBody: true));

        final updateResponse = await dio.put(
            //new 164.52.221.54:8000 org  35.184.107.215:8001
            "${isProd ? "http://35.184.107.215:8001" : "https://backend.parsel.in/firebasecall"}/updateaddress/${widget._routeDataList.store?.id}/$driverId/${_currentPosition?.latitude}/${_currentPosition?.longitude}/${widget.salesOrderId}/");
        appLogs(updateResponse.data);
        final status = updateResponse.data['status'] ?? false;
        if (!status) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Failed: ${updateResponse.data['message']}")));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content:
                  Text("Store location updated to your current location")));
          widget._routeDataList.deliveryAddressCoordinates.lat =
              _currentPosition!.latitude;
          widget._routeDataList.deliveryAddressCoordinates.long =
              _currentPosition!.longitude;
          _updateCanCompleteTrip(_currentPosition!);
        }
      } catch (e) {
        widget._routeDataList.deliveryAddressCoordinates.lat =
            _currentPosition!.latitude;
        widget._routeDataList.deliveryAddressCoordinates.long =
            _currentPosition!.longitude;
        _updateCanCompleteTrip(_currentPosition!);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Store location updated to your current location")));
      }
    }
  }

  // Future startTrip() async {
  //   return await API
  //       .startTrip(context,
  //           showNoInternet: true,
  //           executionStatus: 'ON_GOING',
  //           ID: widget._routeDataList.salesOrderId!)
  //       .then(
  //     (StartTripModal? response) async {
  //       if (response != null) {
  //       } else {
  //         AppHelper.showSnackBar(context, AppStrings.strSomethingWentWrong);
  //       }
  //     },
  //   );
  // }

  Future<void> _sendLocationUpdateToBackend(Position currentPosition) async {
    final preference = await SharedPreferences.getInstance();
    API.LocationCreate(context,
            USERID: preference.getString('userID').toString(),
            Authtoken: preference.getString('token').toString(),
            LATITUDE: currentPosition!.latitude.toString(),
            LONGITUDE: currentPosition!.longitude.toString(),
            SALESORDERID: widget.salesOrderId)
        .then(
      (LocationCreate_model? response) async {
        //  appLogs('response-->' + response.toString());
        if (response == null) {
          AppHelper.showSnackBar(context, AppStrings.strSomethingWentWrong);
        }
      },
    ).onError((error, stackTrace) {
      AppHelper.showSnackBar(context, AppStrings.strSomethingWentWrong);
    });
  }

  Future updateDistanceTravel() async {
    try {
      await API.updateDistanceTravel(context);
    } catch (e) {
      appLogs("updateDistanceTravel error --> $e");
    }
  }

  Future updateSalesorderbyID1(
      BuildContext context,
      //  List<uplds.ItemList> itm
      int id) async {
    try {
      await Future.wait([
        // _sendLocationUpdateToBackend(_currentPosition!),
        _updateLocationStatus(_STATUS_COMPLETED)
      ]);
    } catch (e) {
      appLogs("Error while  update locatiin --> $e");
    }
    return await API
        .updateSalesorderbyID1InProgress(context,
            showNoInternet: true,
            // itemList: itm,
            executionStatus: 'ARRIVED',
            ID: widget.salesOrderId)
        .then(
      (BaseModel? response) async {
        // appLogs('Invoice no here-->' + widget.salesOrderId.toString());
        if (response != null) {
          print("response.status --> ${response.status}");
          if (response.status) {
            VariableUtilities.preferences.setString(
                "${LocalCacheKey.deliverOrderArrivedByInvoice}Arrived${widget.salesOrderId}",
                "Arrived");
          }
        } else {
          AppHelper.showSnackBar(context, AppStrings.strSomethingWentWrong);
        }
      },
    ).onError((error, stackTrace) {
      appLogs(error);
    });
  }

  DeliveryAddressCoordinates get deliveryCordinates =>
      widget._routeDataList.deliveryAddressCoordinates;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Form(
            key: _formKey,
            child: Scaffold(
              floatingActionButton: FloatingActionButton(
                  child: SvgPicture.asset('assets/attempt.svg',
                      color: Colors.white),
                  backgroundColor: _currentPosition == null
                      ? Colors.red
                      : AppColors.blueColor,
                  onPressed:
                      _currentPosition != null ? updateStoreLocation : null),
              appBar: PreferredSize(
                preferredSize:
                    const Size.fromHeight(80.0), // here the desired height
                child: AppBar(
                  backgroundColor: Colors.black,
                  title: Container(
                    padding: const EdgeInsets.only(top: 20),
                    margin:
                        const EdgeInsets.only(top: 38, left: 34, bottom: 19),
                    child: Text('DELIVER ORDER',
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
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const DashBoardScreen()));
                          },
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back_ios),
                            iconSize: 20.0,
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const DashBoardScreen()));
                            },
                          ),
                        ),
                      ),
                    ),
                    onTap: () {},
                  ),
                  actions: [
                    InkWell(
                      onTap: () {
                        MapUtils.openMap(
                            deliveryCordinates.lat, deliveryCordinates.long);
                      },
                      child: Container(
                        // padding: const EdgeInsets.only(top: 30),
                        margin: const EdgeInsets.only(top: 30),
                        child: Image.asset(
                          AppIcons.icLocationPin,
                          height: 18,
                          // width: 18,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 35,
                    ),
                  ],
                ),
              ),
              body: WillPopScope(
                onWillPop: () async => false,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(
                          left: 35, right: 0, top: 16, bottom: 16),
                      color: AppColors.lightBlueColor,
                      child: Row(
                        children: [
                          //Invoice
                          Column(
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
                                '${widget.salesOrderId}',
                                style: const TextStyle(
                                    fontFamily: appFontFamily,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12,
                                    color: AppColors.black2Color),
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 60,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'CUSTOMER',
                                style: TextStyle(
                                    fontFamily: appFontFamily,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: AppColors.black2Color),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Column(
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.45,
                                    child: Text(
                                      widget._routeDataList.store!.storeName
                                          .toString(),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: false,
                                      style: const TextStyle(
                                          fontFamily: appFontFamily,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12,
                                          color: AppColors.black2Color),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ), //Cost
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        color: Colors.grey,
                      ),
                    )
                  ],
                ),
              ),
              bottomNavigationBar: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    decoration: const BoxDecoration(
                      color: AppColors.blueColor,
                      // borderRadius: BorderRadius.only(
                      //     topLeft: Radius.circular(10.0),
                      //     topRight: Radius.circular(10.0)),
                    ),
                    child: MaterialButton(
                      height: 60.0,
                      onPressed: () async {
                        final confirmation = await showConfirmationDialog(
                            context: context,
                            title: "Confirm Cancel",
                            content: "Are you sure to cancel trip?",
                            positiveButtonLabel: "Yes",
                            negativeButtonLabel: "No");
                        if (confirmation == true) {
                          cancelTrip(context);
                        }
                      },
                      child: const Text(
                        'CANCEL',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: appFontFamily,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            letterSpacing: 1),
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.49,
                    decoration: BoxDecoration(
                      color: _canCompleteTrip || arrived != ''
                          ? AppColors.blueColor
                          : Colors.red,
                      // borderRadius: BorderRadius.only(
                      //     topLeft: Radius.circular(10.0),
                      //     topRight: Radius.circular(10.0)),
                    ),
                    child: MaterialButton(
                      height: 60.0,
                      onPressed: _canCompleteTrip || arrived != ''
                          ? () {
                              showAlert(context, false, widget._routeDataList);
                              // : AppHelper.showSnackBar(
                              //     context, 'Please start trip again');
                            }
                          : null,
                      child: const Text(
                        'ARRIVED',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: appFontFamily,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            letterSpacing: 1),
                      ),
                    ),
                  ),
                ],
              ),
            )),
        Visibility(
            visible: isLoading,
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: Colors.black.withOpacity(.2),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                ],
              ),
            ))
      ],
    );
  }

  //Adding static data to list - Srini
  // void launchGoogleMap(String address) async {
  //   String query = Uri.encodeComponent(address);
  //   String googleUrl = "https://www.google.com/maps/search/?api=1&query=$query";

  //   if (await canLaunchUrl(Uri.parse(googleUrl))) {
  //     await launchUrl(Uri.parse(googleUrl));
  //   }
  // }

  //Show dialog for confirmation
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
                    child: SizedBox(
                        width: 40,
                        height: 40,
                        child: SvgPicture.asset("assets/logo.svg",
                            semanticsLabel: 'Acme Logo'))),
                Padding(
                  padding: const EdgeInsets.only(top: 15.0, bottom: 2.0),
                  child: Text(
                    showMapLink ? 'DELIVERY ADDRESS' : "ARRIVED",
                    style: const TextStyle(
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
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 32.0),
                    child: Text(
                        // showMapLink
                        //     ? "${store!.storeAddress.toString()}\n \n Arrived to customer location. Please click on 'OK' to continue"
                        //     :
                        "CONFIRM  DELIVERY\n \nPlease click on 'OK' to continue",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 13,
                            fontFamily: appFontFamily,
                            fontWeight: FontWeight.w400,
                            letterSpacing: -1)),
                  ),
                  Visibility(
                    visible: showMapLink,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 22.0),
                      child: InkWell(
                        onTap: () {
                          //launchGoogleMap(store!.storeAddress.toString());
                        },
                        child: const Text('FIND ON MAP',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: appFontFamily,
                              fontSize: 15,
                              decoration: TextDecoration.underline,
                            )),
                      ),
                    ),
                  )
                ],
              ),
            ),
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
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
                                showMapLink ? 'GO BACK' : 'CANCEL',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12,
                                    letterSpacing: 1),
                              ))),
                    ),
                    Visibility(
                      visible: !showMapLink,
                      child: const SizedBox(
                        width: 15.0,
                      ),
                    ),
                    Visibility(
                      visible: !showMapLink,
                      child: Expanded(
                        child: InkWell(
                            onTap: () async {
                              _stopLocationStream();
                              Navigator.of(context).pop();

                              // String textToSend = textFieldController.text;

                              String arrived = VariableUtilities.preferences
                                      .getString(
                                          "${LocalCacheKey.deliverOrderArrivedByInvoice}Arrived${widget.salesOrderId}") ??
                                  '';
                              if (arrived != '' &&
                                  ConnectivityHandler.connectivityResult
                                      .contains(ConnectivityResult.none)) {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => DeliverOrdersPage(
                                              salesOrder: salesOrder,
                                              dataList: dataList,
                                              dataUp: dataUp,
                                              store: store,
                                              deliverOrdersList:
                                                  deliverOrdersList,
                                              diff: '',
                                              salesOrderId: widget.salesOrderId
                                                  .toString(),
                                              id: resultList.id.toString(),
                                            )));
                                return;
                              }
                              // updateDistanceTravel();

                              updateSalesorderbyID1(context, resultList.id
                                  //  Ddata.uploadparticularListitem
                                  );
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => DeliverOrdersPage(
                                            salesOrder: salesOrder,
                                            dataList: dataList,
                                            dataUp: dataUp,
                                            store: store,
                                            deliverOrdersList:
                                                deliverOrdersList,
                                            diff: '',
                                            salesOrderId:
                                                widget.salesOrderId.toString(),
                                            id: resultList.id.toString(),
                                          )
                                      // DeliverySummaryPage(
                                      //   id: widget.id,
                                      //   salesOrderid: widget.salesOrderid,
                                      //   diff: textToSend,
                                      //)
                                      ));
                              appLogs('Customer here-->' +
                                  resultList.id.toString());
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
                                  showMapLink ? 'CLOSE' : 'OK',
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
