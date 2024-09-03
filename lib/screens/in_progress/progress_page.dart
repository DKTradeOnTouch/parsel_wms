import 'dart:convert';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:parsel_flutter/api/endpoints.dart';
import 'package:parsel_flutter/models/UpdateSalesOrder_model.dart';
import 'package:parsel_flutter/models/base_moel.dart';
import 'package:parsel_flutter/models/progress_route_data.dart';
import 'package:parsel_flutter/models/routeOptimised_modal.dart' as ro;
import 'package:parsel_flutter/resource/app_colors.dart';
import 'package:parsel_flutter/resource/app_logs.dart';
import 'package:parsel_flutter/screens/dashboard.dart';
import 'package:parsel_flutter/screens/deliver_orders/deliver_order_First.dart';
import 'package:parsel_flutter/screens/in_progress/progress_route_list.dart';
import 'package:parsel_flutter/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Provider/Invoice_Controller.dart';
import '../../api/api.dart';
import '../../models/InvoiceList_model.dart';
import '../AUth/prominent_Disclosure.dart';
import 'google_map/google2.dart';
import 'location_service.dart';

DeliveryPointModel deliveryPointModelFromJson(String str) =>
    DeliveryPointModel.fromJson(json.decode(str));

String deliveryPointModelToJson(DeliveryPointModel data) =>
    json.encode(data.toJson());

class DeliveryPointModel {
  final num storeId;
  final double lat;
  final double lon;
  final String address;
  final ResultList main;

  DeliveryPointModel({
    required this.storeId,
    required this.lat,
    required this.lon,
    required this.address,
    required this.main,
  });

  factory DeliveryPointModel.fromJson(Map<String, dynamic> json) =>
      DeliveryPointModel(
        storeId: json["storeId"],
        lat: json["lat"],
        lon: json["lon"],
        address: json["address"],
        main: ResultList.fromJson(json["main"]),
      );

  Map<String, dynamic> toJson() => {
        "storeId": storeId,
        "lat": lat,
        "lon": lon,
        "address": address,
        "main": main.toJson()
      };
}

class InProgressPage extends StatefulWidget {
  // final String? salesOrderId;

  const InProgressPage({Key? key}) : super(key: key);

  @override
  State<InProgressPage> createState() => _InProgressPage();
}

class _InProgressPage extends State<InProgressPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int selectedTab = 0;
  List<ResultList> invoiceResultList = [];
  List<DeliveryPointModel> _deliveryPoints = [];
  List<ro.Data> dataList = [];
  InvoiceListModel? response;

  List<InProgressRouteData> routeDetailList = [];

  int inProcess = 0;

  num? id;

  LatLng? _currentPosition;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabSelection);
    // addDataToList();
    // routeOptimisedAPI(context);
    if (ConnectivityHandler.connectivityResult
        .contains(ConnectivityResult.none)) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        String invoiceInProgressList = VariableUtilities.preferences.getString(
              LocalCacheKey.invoiceInProgressList,
            ) ??
            '';
        String inProgressDeliveryPoints =
            VariableUtilities.preferences.getString(
                  LocalCacheKey.inProgressDeliveryPoints,
                ) ??
                '';
        if (invoiceInProgressList.isNotEmpty) {
          List<ResultList> _prefsInvoiceResultList = List<ResultList>.from(
              jsonDecode(invoiceInProgressList)
                  .map((x) => ResultList.fromJson(x)));
          setState(() {
            invoiceResultList = _prefsInvoiceResultList;
          });
        }

        if (inProgressDeliveryPoints.isNotEmpty) {
          List<DeliveryPointModel> _prefsDeliveryPoints =
              List<DeliveryPointModel>.from(jsonDecode(inProgressDeliveryPoints)
                  .map((x) => DeliveryPointModel.fromJson(x)));
          setState(() {
            _deliveryPoints = _prefsDeliveryPoints;
          });
        }

        String prefsCurrentPosition = VariableUtilities.preferences
                .getString(LocalCacheKey.inProgressCurrentLocation) ??
            '';
        if (prefsCurrentPosition.isNotEmpty) {
          appLogs("prefsCurrentPosition ==> $prefsCurrentPosition");
          LatLng? latLng = LatLng.fromJson(jsonDecode(prefsCurrentPosition));

          if (latLng != null) {
            setState(() {});
            _currentPosition = LatLng(latLng.latitude, latLng.longitude);
            appLogs(
                "_currentPosition --> ${latLng.latitude}  ${latLng.longitude}");
          }
        }
      });
    } else {
      appLogs('-------------------->Load All Data ');
      _loadAllData();
    }
  }

  Future<void> _ensureLocationActive() async {
    if (!await LocationService.instance.isPermissionGranted() ||
        !await LocationService.instance.checkServiceEnabled()) {
      if (!await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const ProminentDisclosure()))) {
        Navigator.pop(context);
        return;
      }
    }
    final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    _currentPosition = LatLng(position.latitude, position.longitude);
    if (_currentPosition != null) {
      VariableUtilities.preferences.setString(
          LocalCacheKey.inProgressCurrentLocation,
          jsonEncode(_currentPosition));
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  //Handle tab selection
  void _handleTabSelection() {
    setState(() {
      selectedTab = _tabController.index;
    });
  }

  Future<bool> iNpGetSalesOrderListByStatusInvoiceList(
      BuildContext context) async {
    try {
      final preference = await SharedPreferences.getInstance();
      invoiceResultList.clear();
      setState(() {
        isLoading = true;
      });
      response = await API.getSalesOrderListByStatusInvoiceList(context,
          showNoInternet: true,
          Authtoken: preference.getString("token").toString(),
          DEIVERID: preference.getString("userID").toString(),
          STATUS: 'ON_GOING',
          TODAYDATE: DateFormat('yyyy-MM-dd').format((DateTime.now())));
      if (response != null) {
        if (!response!.status) {
          String invoiceInProgressList =
              VariableUtilities.preferences.getString(
                    LocalCacheKey.invoiceInProgressList,
                  ) ??
                  '';
          if (invoiceInProgressList.isNotEmpty) {
            List<ResultList> _prefsInvoiceResultList = List<ResultList>.from(
                jsonDecode(invoiceInProgressList)
                    .map((x) => ResultList.fromJson(x)));
            setState(() {
              invoiceResultList = _prefsInvoiceResultList;
            });
          }
        }

        if (response!.body.data.resultList.isNotEmpty) {
          for (var element in response!.body.data.resultList) {
            invoiceResultList.add(element);
          }
        }

        if (invoiceResultList.isNotEmpty) {
          VariableUtilities.preferences.setString(
              LocalCacheKey.invoiceInProgressList,
              jsonEncode(invoiceResultList));
        }
        setState(() {
          isLoading = false;
        });
        // response!.body!.data!.resultList!.map((e) => )
      }
    } catch (e) {
      setState(() {
        String invoiceInProgressList = VariableUtilities.preferences.getString(
              LocalCacheKey.invoiceInProgressList,
            ) ??
            '';
        if (invoiceInProgressList.isNotEmpty) {
          List<ResultList> _prefsInvoiceResultList = List<ResultList>.from(
              jsonDecode(invoiceInProgressList)
                  .map((x) => ResultList.fromJson(x)));

          invoiceResultList = _prefsInvoiceResultList;
        }
        isLoading = false;
      });
    }
    return response != null;
  }

  Future<void> _optimizeWaypoints(InvoiceListModel response) async {
    try {
      setState(() {
        isLoading = true;
      });
      appLogs('-------------------->Load All Data 1');

      if (response.status) {
        final List<Map<String, dynamic>> requestBody =
            response.body.data.resultList
                .map((e) => {
                      "storeId": e.salesOrderId.toString(),
                      "lat": e.deliveryAddressCoordinates.lat,
                      "lon": e.deliveryAddressCoordinates.long,
                    })
                .toList();
        final dio = Dio()
          ..interceptors
              .add(LogInterceptor(responseBody: true, requestBody: true));
        final optimisedResponse = await dio.post<Map<String, dynamic>>(
          //164.52.221.54:8000 35.184.107.215:8001
          "${isProd ? "http://35.184.107.215:8001" : "https://backend.parsel.in/firebasecall"}/optimize/${_currentPosition!.latitude}/${_currentPosition!.longitude}/",
          data: {"latlons": requestBody},
        );
        if (optimisedResponse.data?["status"]) {
          final List<dynamic> waypoints = optimisedResponse.data?["waypoints"];
          appLogs("optimisedResponse --> ${optimisedResponse.toString()}");
          for (var waypoint in waypoints) {
            final result = response.body.data.resultList.singleWhere(
                (element) =>
                    element.salesOrderId.toString() == waypoint["storeId"]);
            _deliveryPoints.add(DeliveryPointModel(
              storeId: result.store.id,
              lat: result.deliveryAddressCoordinates.lat,
              lon: result.deliveryAddressCoordinates.long,
              address: result.deliveryAddress,
              main: result,
            ));
            // _InvoiceResultList.add(result);
          }
          appLogs("_InvoiceResultList --> $invoiceResultList");

          if (_deliveryPoints.isNotEmpty) {
            VariableUtilities.preferences.setString(
                LocalCacheKey.inProgressDeliveryPoints,
                jsonEncode(_deliveryPoints));
          }
        }
        isLoading = false;
        setState(() {});
        appLogs('-------------------->Load All Data 2');
      }
    } catch (e) {
      appLogs("('--------------------> $e");
      isLoading = false;
      setState(() {});
    }
  }

  Future<void> _loadAllData() async {
    try {
      await Future.wait([
        _ensureLocationActive(),
        iNpGetSalesOrderListByStatusInvoiceList(context),
      ]);
      if (response != null) {
        setState(() {
          inProcess = response?.body.data.totalCount.toInt() ?? 0;
        });
        if (!response!.status) {
          setState(() {
            isLoading = false;
          });
          return;
        }
        _optimizeWaypoints(response!);
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<InvoiceController>(
        builder: (context, invoiceController, child) {
      return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              iconSize: 100,
              icon: const Icon(
                Icons.arrow_back_ios,
                size: 20,
              ),
              // the method which is called
              // when button is pressed
              onPressed: () {
                appLogs('id-->' + id.toString());

                setState(
                  () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const DashBoardScreen()));
                  },
                );
              },
            ),
            title: Text(
              "IN PROGRESS(${inProcess.toString()})",
              style: const TextStyle(fontSize: 14),
            ),
            actions: [
              IconButton(
                  onPressed: _loadAllData, icon: const Icon(Icons.refresh)),
            ],
          ),
          body: Stack(
            children: [
              Column(
                children: [
                  Container(
                    height: 65,
                    decoration: const BoxDecoration(
                      color: AppColors.topBarGrey,
                    ),
                    child: TabBar(
                      controller: _tabController,
                      indicator: BoxDecoration(
                        color: ColorUtils.kBottomButtonColor,
                      ),
                      labelColor: Colors.white,
                      unselectedLabelColor: AppColors.topBarUnselectedFontColor,
                      tabs: [
                        const Tab(
                          text: 'ROUTE',
                        ),
                        const Tab(
                          text: 'ALL',
                        ),
                        Tab(
                          icon: SvgPicture.asset(
                            'assets/filter.svg',
                            color: selectedTab == 2
                                ? Colors.white
                                : AppColors.topBarUnselectedFontColor,
                            height: 20.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      constraints: const BoxConstraints.expand(),
                      child: ProgressRouteList(
                        routeDataList: invoiceResultList,
                        startTrip: _startTrip,
                      ),
                    ),
                  ),
                ],
              ),
              Visibility(
                visible: isLoading,
                child: Container(
                  color: Colors.white,
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                    ],
                  ),
                ),
              )
            ],
          ),
          floatingActionButton:
              Column(mainAxisAlignment: MainAxisAlignment.end, children: [
            FloatingActionButton(
              backgroundColor: ColorUtils.kBottomButtonColor,
              child: SvgPicture.asset(
                'assets/distance.svg',
                color: Colors.white,
                height: 20.0,
              ),
              onPressed: () {
                setState(
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => GoogleMap2(
                          currentLocation: _currentPosition!,
                          deliveryPoints: _deliveryPoints,
                          startTrip: _startTrip,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ]));
    });
  }
  //{lat: 19.0759837, long: 72.8776559}
  // longitude: 72.8851747, latitude: 21.2376227

  Future<void> _startTrip(ResultList order) async {
    log("order.salesOrderId ${order.salesOrderId}");
    log("order.id ${order.id}");
    log("order.groupId ${order.groupId}");
    log(order.toJson().toString());

    final preference = await SharedPreferences.getInstance();

    return await API
        .updateSalesorderbyIDInProgress(context,
            showNoInternet: true,
            Authtoken: preference.getString("token").toString(),
            temperature: 200,
            executionStatus: 'ON_GOING',
            ID: order.salesOrderId.toString())
        .then(
      (BaseModel? response) async {
        appLogs('response-->' + response.toString());
        if (response != null) {
          if (response.status == true ||
              response.message ==
                  "No Fields to update. Data same as previous") {
            await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => DeliveredOrderFirstPage(
                          diff: '',
                          salesOrderId: order.salesOrderId.toString(),
                          id: order.id.toString(),
                          routeDataList: order,
                        )));
            if (ConnectivityHandler.connectivityResult
                .contains(ConnectivityResult.none)) {
              String invoiceInProgressList =
                  VariableUtilities.preferences.getString(
                        LocalCacheKey.invoiceInProgressList,
                      ) ??
                      '';
              String inProgressDeliveryPoints =
                  VariableUtilities.preferences.getString(
                        LocalCacheKey.inProgressDeliveryPoints,
                      ) ??
                      '';
              if (invoiceInProgressList.isNotEmpty) {
                if (invoiceInProgressList.isNotEmpty) {
                  List<ResultList> _prefsInvoiceResultList =
                      List<ResultList>.from(jsonDecode(invoiceInProgressList)
                          .map((x) => ResultList.fromJson(x)));
                  setState(() {
                    invoiceResultList = _prefsInvoiceResultList;
                  });
                }
              }
              if (inProgressDeliveryPoints.isNotEmpty) {
                if (inProgressDeliveryPoints.isNotEmpty) {
                  List<DeliveryPointModel> _prefsDeliveryPoints =
                      List<DeliveryPointModel>.from(
                          jsonDecode(inProgressDeliveryPoints)
                              .map((x) => DeliveryPointModel.fromJson(x)));
                  setState(() {
                    _deliveryPoints = _prefsDeliveryPoints;
                  });
                }
              }
              String prefsCurrentPosition = VariableUtilities.preferences
                      .getString(LocalCacheKey.inProgressCurrentLocation) ??
                  '';
              if (prefsCurrentPosition.isNotEmpty) {
                LatLng? latLng =
                    LatLng.fromJson(jsonDecode(prefsCurrentPosition));

                if (latLng != null) {
                  setState(() {});
                  _currentPosition = LatLng(latLng.latitude, latLng.longitude);
                }
              }
            } else {
              // _loadAllData();
            }
          }
        }
        // else {
        //   AppHelper.showSnackBar(context, AppStrings.strSomethingWentWrong);
        // }
      },
    ).onError((error, stackTrace) {
      setState(() {});
    });
    // log("Order ---> ${order.toJson()}");
  }
}
