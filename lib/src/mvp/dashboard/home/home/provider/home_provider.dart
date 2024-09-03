import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:either_dart/either.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:parsel_flutter/models/firebase_location_lat_lng_model.dart';
import 'package:parsel_flutter/resource/app_logs.dart';
import 'package:parsel_flutter/screens/AUth/prominent_Disclosure.dart';
import 'package:parsel_flutter/screens/in_progress/location_service.dart';
import 'package:parsel_flutter/src/mvp/dashboard/home/delivery_orders/provider/delivery_orders_provider.dart';
import 'package:parsel_flutter/src/mvp/dashboard/home/dispatch_summary/provider/dispatch_summary_provider.dart';
import 'package:parsel_flutter/src/mvp/dashboard/home/home/api/get_orders_count_api.dart';
import 'package:parsel_flutter/src/mvp/dashboard/home/home/model/get_orders_count_model.dart';
import 'package:parsel_flutter/src/mvp/dashboard/home/in_progress/provider/in_progress_item_provider.dart';
import 'package:parsel_flutter/src/mvp/dashboard/home/payment/model/create_payment_mode_model.dart';
import 'package:parsel_flutter/src/mvp/dashboard/home/payment/provider/payment_provider.dart';
import 'package:parsel_flutter/src/mvp/dashboard/home/proof_of_delivery/provider/proof_of_delivery_provider.dart';
import 'package:parsel_flutter/utils/utils.dart';
import 'package:provider/provider.dart';

class HomeProvider extends ChangeNotifier {
  bool _isAppUpdateAvailable = false;
  bool get isAppUpdateAvailable => _isAppUpdateAvailable;
  set isAppUpdateAvailable(bool val) {
    _isAppUpdateAvailable = val;
    notifyListeners();
  }

  bool _isPendingApisCalling = false;
  bool get isPendingApisCalling => _isPendingApisCalling;
  set isPendingApisCalling(bool val) {
    _isPendingApisCalling = val;
    notifyListeners();
  }

  int _pendingOrdersCount = 0;
  int get pendingOrdersCount => _pendingOrdersCount;
  set pendingOrdersCount(int val) {
    _pendingOrdersCount = val;
    notifyListeners();
  }

  int _inProgressOrdersCount = 0;
  int get inProgressOrdersCount => _inProgressOrdersCount;
  set inProgressOrdersCount(int val) {
    _inProgressOrdersCount = val;
    notifyListeners();
  }

  int _deliveredOrdersCount = 0;
  int get deliveredOrdersCount => _deliveredOrdersCount;
  set deliveredOrdersCount(int val) {
    _deliveredOrdersCount = val;
    notifyListeners();
  }

  Either<GetOrdersCountModel, Exception> _getOrdersCountResponse =
      Right(StaticException());
  Either<GetOrdersCountModel, Exception> get getOrdersCountResponse =>
      _getOrdersCountResponse;
  set getOrdersCountResponse(Either<GetOrdersCountModel, Exception> val) {
    _getOrdersCountResponse = val;
    notifyListeners();
  }

  getOrdersCount(BuildContext context, {required String calledFrom}) async {
    print("getOrdersCount api called, $calledFrom");
    if (ConnectivityHandler.connectivityResult
        .contains(ConnectivityResult.none)) {
      await callFunctionWhileUserOffline();
      return;
    }
    getOrdersCountResponse = Right(FetchingDataException());
    Either<GetOrdersCountModel, Exception> apiResponse =
        await getOrdersCountApi(context);
    appLogs("apiResponse --> $apiResponse");
    getOrdersCountResponse = apiResponse;
    if (getOrdersCountResponse.isLeft) {
      print(
          'getOrdersCountResponse --> ${getOrdersCountResponse.left.count.toJson()}');
      if (getOrdersCountResponse.left.status) {
        pendingOrdersCount = getOrdersCountResponse.left.count.inGroup;
        inProgressOrdersCount = getOrdersCountResponse.left.count.onGoing;
        deliveredOrdersCount = getOrdersCountResponse.left.count.delivered;
        VariableUtilities.preferences
            .setInt(LocalCacheKey.pendingOrderCount, pendingOrdersCount);
        VariableUtilities.preferences
            .setInt(LocalCacheKey.inProgressOrderCount, inProgressOrdersCount);
        VariableUtilities.preferences
            .setInt(LocalCacheKey.deliveredOrderCount, deliveredOrdersCount);
      }
    } else {
      getOrdersCountResponse = apiResponse;
    }
    notifyListeners();
  }

  ///Call the Function while internet is not available
  Future<void> callFunctionWhileUserOffline() async {
    pendingOrdersCount =
        VariableUtilities.preferences.getInt(LocalCacheKey.pendingOrderCount) ??
            0;
    inProgressOrdersCount = VariableUtilities.preferences
            .getInt(LocalCacheKey.inProgressOrderCount) ??
        0;
    deliveredOrdersCount = VariableUtilities.preferences
            .getInt(LocalCacheKey.deliveredOrderCount) ??
        0;
  }

  ///Call Pending Api While User Retrieve Internet
  Future<void> callPendingApiWhileUserRetrieveInternet(
      {required BuildContext context}) async {
    try {
      isPendingApisCalling = true;

      final storedPendingRequests = VariableUtilities.preferences
              .getStringList(LocalCacheKey.storedPendingRequests) ??
          [];
      print('storedPendingRequests --> $storedPendingRequests');

      if (storedPendingRequests.isNotEmpty) {
        for (int i = 0; i < storedPendingRequests.length; i++) {
          Map<String, dynamic> requests = jsonDecode(storedPendingRequests[i]);
          if (requests['function_name'] == 'start_trip') {
            DispatchSummaryProvider dispatchSummaryProvider =
                Provider.of(context, listen: false);
            Map<String, String> body =
                Map<String, String>.from(requests['body']);
            await dispatchSummaryProvider.startTrip(context,
                grpId: requests['group_id'],
                body: body,
                isRedirectToScreen: false);
          }
        }
      }
      isPendingApisCalling = false;
    } catch (e) {
      isPendingApisCalling = false;
    }
    // await getOrdersCount(context);
  }

  Future<void> callArrivedLocationApiWhileUserRetrieveInternet(
      {required BuildContext context}) async {
    try {
      isPendingApisCalling = true;
      final storedArrivedLocationRequests = VariableUtilities.preferences
              .getStringList(LocalCacheKey.storedArrivedLocationRequests) ??
          [];
      print('storedArrivedLocationRequests --> $storedArrivedLocationRequests');

      if (storedArrivedLocationRequests.isNotEmpty) {
        for (int i = 0; i < storedArrivedLocationRequests.length; i++) {
          Map<String, dynamic> requests =
              jsonDecode(storedArrivedLocationRequests[i]);
          if (requests['function_name'] == 'arrived_location') {
            DeliveryOrdersProvider deliveryOrdersProvider =
                Provider.of(context, listen: false);

            Position position = Position.fromMap(requests['current_location']);
            int id = requests['id'];
            int storeId = requests['store_id'];
            String salesOrderId = requests['sales_order_id'];
            await deliveryOrdersProvider.updateStoreLocation(context,
                id: id,
                salesOrderId: salesOrderId,
                storeId: storeId,
                prefsPosition: position);
          }
        }
      }
      isPendingApisCalling = false;
    } catch (e) {
      isPendingApisCalling = false;
    }
    // await getOrdersCount(context);
  }

  Future<void> callUploadDocsApiWhileUserRetrieveInternet(
      {required BuildContext context}) async {
    try {
      isPendingApisCalling = true;
      final storedProofOfDeliveryRequests = VariableUtilities.preferences
              .getStringList(LocalCacheKey.storedProofOfDeliveryRequests) ??
          [];
      print('storedProofOfDeliveryRequests --> $storedProofOfDeliveryRequests');

      if (storedProofOfDeliveryRequests.isNotEmpty) {
        for (int i = 0; i < storedProofOfDeliveryRequests.length; i++) {
          Map<String, dynamic> requests =
              jsonDecode(storedProofOfDeliveryRequests[i]);
          if (requests['function_name'] == 'upload_docs') {
            ProofOfDeliveryProvider proofOfDeliveryProvider =
                Provider.of(context, listen: false);

            await proofOfDeliveryProvider.uploadDocs(
                isToastShow: false,
                pdf: requests['pdf'],
                scannedPhoto: requests['scanned_photo'],
                signatureImage: requests['signature_image'],
                takePhoto: requests['take_photo'],
                context: context,
                salesOrderId: requests['sales_order_id']);
          }
        }
      }
      isPendingApisCalling = false;
    } catch (e) {
      isPendingApisCalling = false;
    }
    // await getOrdersCount(context);
  }

  Future<void> callUpdateDistanceTravelApiWhileUserRetrieveInternet(
      {required BuildContext context}) async {
    try {
      isPendingApisCalling = true;
      final storedUpdateDistanceRequests = VariableUtilities.preferences
              .getStringList(LocalCacheKey.storedUpdateDistanceRequests) ??
          [];
      print('storedUpdateDistanceRequests --> $storedUpdateDistanceRequests');
      if (storedUpdateDistanceRequests.isNotEmpty) {
        for (int i = 0; i < storedUpdateDistanceRequests.length; i++) {
          Map<String, dynamic> requests =
              jsonDecode(storedUpdateDistanceRequests[i]);
          if (requests['function_name'] == 'update_distance') {
            DeliveryOrdersProvider deliveryOrdersProvider =
                Provider.of(context, listen: false);

            await deliveryOrdersProvider.updateDistanceTravel(
                context, requests['sales_order_id']);
          }
        }
      }
      isPendingApisCalling = false;
    } catch (e) {
      isPendingApisCalling = false;
    }
    // await getOrdersCount(context);
  }

  Future<void> callCreatePaymentApiWhileUserRetrieveInternet(
      {required BuildContext context}) async {
    try {
      isPendingApisCalling = true;
      final storedPaymentRequests = VariableUtilities.preferences
              .getStringList(LocalCacheKey.storedPaymentRequests) ??
          [];
      if (storedPaymentRequests.isNotEmpty) {
        for (int i = 0; i < storedPaymentRequests.length; i++) {
          Map<String, dynamic> requests = jsonDecode(storedPaymentRequests[i]);
          if (requests['function_name'] == 'create_payment') {
            PaymentProvider paymentProvider =
                Provider.of(context, listen: false);

            List<CreatePaymentsList> payments =
                List<CreatePaymentsList>.from(requests['payments'].map((x) {
              return CreatePaymentsList.fromJson(x);
            }));
            await paymentProvider.updateSalesOrder(context,
                isCallFromOffline: true,
                isLastIndex: false,
                id: requests['id'],
                deliveryStatus: 'ARRIVED',
                arrivedTimestamp: requests['arrived_time'],
                deliveredTimestamp: requests['delivered_time'],
                payments: payments,
                salesOrderId: requests['sales_order_id']);
          }
        }
      }
      isPendingApisCalling = false;
    } catch (e) {
      isPendingApisCalling = false;
    }
    // await getOrdersCount(context);
  }

  Future<void> callUpdateArrivedApiWhileUserRetrieveInternet(
      {required BuildContext context}) async {
    try {
      isPendingApisCalling = true;
      final storedUpdateArrivedOrdersRequests = VariableUtilities.preferences
              .getStringList(LocalCacheKey.storedUpdateArrivedOrdersRequests) ??
          [];
      if (storedUpdateArrivedOrdersRequests.isNotEmpty) {
        for (int i = 0; i < storedUpdateArrivedOrdersRequests.length; i++) {
          Map<String, dynamic> requests =
              jsonDecode(storedUpdateArrivedOrdersRequests[i]);
          if (requests['function_name'] == 'update_arrived_status') {
            DeliveryOrdersProvider deliveryOrdersProvider =
                Provider.of(context, listen: false);

            await deliveryOrdersProvider.updateSalesOrders(
                timestamp: requests['arrived_timestamp'],
                isCallFromOffline: true,
                context: context,
                isLastIndex: false,
                salesOrderId: requests['sales_order_id']);
          }
        }
      }
      isPendingApisCalling = false;
    } catch (e) {
      isPendingApisCalling = false;
    }
    // await getOrdersCount(context);
  }

  Future<void> callUpdateOnGoingApiWhileUserRetrieveInternet(
      {required BuildContext context}) async {
    print("callUpdateOnGoingApiWhileUserRetrieveInternet");
    try {
      isPendingApisCalling = true;
      final storedUpdateOnGoingOrdersRequests = VariableUtilities.preferences
              .getStringList(LocalCacheKey.storedUpdateOnGoingOrdersRequests) ??
          [];
      print(
          "storedUpdateOnGoingOrdersRequests ss--> ${storedUpdateOnGoingOrdersRequests}");
      if (storedUpdateOnGoingOrdersRequests.isNotEmpty) {
        for (int i = 0; i < storedUpdateOnGoingOrdersRequests.length; i++) {
          Map<String, dynamic> requests =
              jsonDecode(storedUpdateOnGoingOrdersRequests[i]);
          if (requests['function_name'] == 'update_on_going_status') {
            InProgressItemProvider inProgressItemProvider =
                Provider.of(context, listen: false);
            print('requests ${requests['on_going_timestamp']}');
            await inProgressItemProvider.updateSalesOrders(
                timestamp: requests['on_going_timestamp'],
                isCallFromOffline: true,
                context: context,
                isLastIndex: false,
                salesOrderId: requests['sales_order_id']);
          }
        }
      }
      isPendingApisCalling = false;
    } catch (e) {
      isPendingApisCalling = false;
    }
    // await getOrdersCount(context);
  }

  Future<void> updateOfflineLocation() async {
    String prefsLatLongList = VariableUtilities.preferences
            .getString(LocalCacheKey.latLongOfDriver) ??
        '';
    if (prefsLatLongList.isNotEmpty) {
      List<FirebaseLocationLatLngModel> latLngList =
          List<FirebaseLocationLatLngModel>.from(jsonDecode(prefsLatLongList)
              .map((x) => FirebaseLocationLatLngModel.fromJson(x)));
      List<FirebaseLocationLatLngModel> prefs = [];
      for (int i = 0; i < latLngList.length; i++) {
        prefs.add(latLngList[i]);
      }
      appLogs(latLngList.length);
      for (int i = 0; i < latLngList.length; i++) {
        // print('object')
        // Timer(Duration(milliseconds: 100), () {
        appLogs('Removed -->>$i ${prefs.length}');

        await updateLocationWhileUserGetBackToOnlineInFirebase(
            latLngList[i].toJson());
        prefs.removeWhere(
            (element) => element.timestamp == latLngList[i].timestamp);
        // });
      }

      latLngList = prefs;
      VariableUtilities.preferences
          .setString(LocalCacheKey.latLongOfDriver, jsonEncode(latLngList));
    }
  }

  updateLocationWhileUserGetBackToOnlineInFirebase(
      Map<String, dynamic> locationEntry) async {
    try {
      /*print(
          "---------------dbRef: ${_firebaseDb.path}\t\t${_firebaseDb.key}\t\t${_firebaseDb.root.path}");*/

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

  ///Update location To firebase
  Future<void> startUpdateLatLngToFirebase(BuildContext context) async {
    print("startUpdateLatLngToFirebase function call");
    String driverId = (VariableUtilities.preferences.getString('userID') ?? '');
    bool isDriverStartedTrip = VariableUtilities.preferences
            .getBool('${LocalCacheKey.isDriverStartedTrip}-$driverId') ??
        false;
    if (!isDriverStartedTrip) {
      return;
    }

    if (!await LocationService.instance.isPermissionGranted() ||
        !await LocationService.instance.checkServiceEnabled()) {
      if (!await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const ProminentDisclosure()))) {
        // Navigator.pop(context);
        return;
      }
    }
    final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
    try {
      final locationSettings = AndroidSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 50,
        foregroundNotificationConfig: const ForegroundNotificationConfig(
          notificationText:
              "Parsel will continue to receive your location even when you aren't using it",
          notificationTitle: "Running in Background",
          enableWakeLock: true,
        ),
      );
      GlobalVariablesUtils.globalCurrentPosition = await _geolocatorPlatform
          .getCurrentPosition(locationSettings: locationSettings);
      _pushLocationUpdate(GlobalVariablesUtils.globalCurrentPosition!);
      if (GlobalVariablesUtils.globalLocationStreamSub != null) {
        // if (_locationStreamSub.isPaused) {}
        GlobalVariablesUtils.globalLocationStreamSub!.cancel();
        GlobalVariablesUtils.globalLocationStreamSub = null;
      }
      if (GlobalVariablesUtils.globalUpdateTimer != null) {
        GlobalVariablesUtils.globalUpdateTimer!.cancel();
      }
      GlobalVariablesUtils.globalUpdateTimer = null;
      GlobalVariablesUtils.globalLocationStreamSub = _geolocatorPlatform
          .getPositionStream(locationSettings: locationSettings)
          .listen(_onPositionUpdate);
    } catch (e) {
      print(e);
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

    // print("shouldUpdate: $shouldUpdate");
    if (!shouldUpdate) {
      return;
    }
    GlobalVariablesUtils.globalLastUpdateTime = time.millisecondsSinceEpoch;
    try {
      /*print(
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
      print(
          "---------------- firebase db update error: -----------------------------");
      print(e);
    }
  }

  Future<void> _onPositionUpdate(Position position) async {
    print('Listening position --> $position ');
    if (ConnectivityHandler.connectivityResult
        .contains(ConnectivityResult.none)) {
      List<FirebaseLocationLatLngModel> latLongList = [];
      if (GlobalVariablesUtils.globalUpdateTimer == null) {
        GlobalVariablesUtils.globalUpdateTimer =
            Timer.periodic(const Duration(seconds: 10), (timer) async {
          log('timer if offline-->> ${timer.tick}');
          if (ConnectivityHandler.connectivityResult
              .contains(ConnectivityResult.none)) {
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
          if (ConnectivityHandler.connectivityResult
              .contains(ConnectivityResult.none)) {
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
    if (ConnectivityHandler.connectivityResult
            .contains(ConnectivityResult.mobile) ||
        ConnectivityHandler.connectivityResult
            .contains(ConnectivityResult.wifi)) {
      GlobalVariablesUtils.globalLastPosition =
          GlobalVariablesUtils.globalCurrentPosition;
      GlobalVariablesUtils.globalCurrentPosition = position;
      if (GlobalVariablesUtils.globalUpdateTimer == null) {
        // await _pushLocationUpdate(GlobalVariablesUtils.globalCurrentPosition!);
        GlobalVariablesUtils.globalUpdateTimer =
            Timer.periodic(const Duration(seconds: 10), (timer) async {
          log('timer if -->> online ${timer.tick}');
          if (ConnectivityHandler.connectivityResult
                  .contains(ConnectivityResult.wifi) ||
              ConnectivityHandler.connectivityResult
                  .contains(ConnectivityResult.mobile)) {
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
          if (ConnectivityHandler.connectivityResult
                  .contains(ConnectivityResult.wifi) ||
              ConnectivityHandler.connectivityResult
                  .contains(ConnectivityResult.mobile)) {
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
}
