import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:either_dart/either.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:parsel_flutter/models/firebase_location_lat_lng_model.dart';
import 'package:parsel_flutter/src/mvp/dashboard/home/dispatch_summary/api/dispatch_summary_api.dart';
import 'package:parsel_flutter/src/mvp/dashboard/home/in_progress/args/in_progress_args.dart';
import 'package:parsel_flutter/src/mvp/dashboard/home/select_pending_orders/model/get_sku_group_by_user_id_model.dart';
import 'package:parsel_flutter/src/mvp/dashboard/home/select_pending_orders/model/parsel_base_model.dart';
import 'package:parsel_flutter/utils/utils.dart';

class DispatchSummaryProvider extends ChangeNotifier {
  String _filePath = '';
  String get filePath => _filePath;
  set filePath(String val) {
    _filePath = val;
    notifyListeners();
  }

  Either<ParselBaseModel, Exception> _startTripResponse =
      Right(StaticException());
  Either<ParselBaseModel, Exception> get startTripResponse =>
      _startTripResponse;
  set startTripResponse(Either<ParselBaseModel, Exception> val) {
    _startTripResponse = val;
    notifyListeners();
  }

  Future<void> startTrip(
    BuildContext context, {
    bool isRedirectToScreen = true,
    required String grpId,
    required Map<String, String> body,
  }) async {
    print("Start Trip Function is called");
    if (ConnectivityHandler.connectivityResult
        .contains(ConnectivityResult.none)) {
      final storedPendingRequests = VariableUtilities.preferences
              .getStringList(LocalCacheKey.storedPendingRequests) ??
          [];
      for (int i = 0; i < storedPendingRequests.length; i++) {
        Map<String, dynamic> requests = jsonDecode(storedPendingRequests[i]);
        if (requests['function_name'] == 'start_trip') {
          if (requests['group_id'] == grpId) {
            Fluttertoast.showToast(
                msg: LocaleKeys.your_request_is_already_submitted.tr());
            await updateCountsForHomeScreen(context);
            VariableUtilities.preferences
                .remove(LocalCacheKey.selectedWarehousesDetail);
            VariableUtilities.preferences
                .remove(LocalCacheKey.getSkuGroupByUserIdResponse);

            return;
          }
        }
      }
      Map<String, dynamic> offlineApi = {
        'function_name': 'start_trip',
        'group_id': grpId,
        'body': body
      };
      storedPendingRequests.add(jsonEncode(offlineApi));
      Fluttertoast.showToast(msg: LocaleKeys.your_request_is_submitted.tr());
      VariableUtilities.preferences
          .remove(LocalCacheKey.selectedWarehousesDetail);
      VariableUtilities.preferences
          .remove(LocalCacheKey.getSkuGroupByUserIdResponse);

      await VariableUtilities.preferences.setStringList(
          LocalCacheKey.storedPendingRequests, storedPendingRequests);
      await updateCountsForHomeScreen(context);
      return;
    }
    startTripResponse = Right(NoDataFoundException());

    Either<ParselBaseModel, Exception> apiResponse =
        await startTripApi(context, apiType: 'PUT', groupId: grpId, body: body);

    startTripResponse = apiResponse;
    print(apiResponse);
    if (startTripResponse.isLeft) {
      if (startTripResponse.left.status) {
        VariableUtilities.preferences
            .remove(LocalCacheKey.selectedWarehousesDetail);
        VariableUtilities.preferences
            .remove(LocalCacheKey.getSkuGroupByUserIdResponse);

        if (isRedirectToScreen) {
          MixpanelManager.trackEvent(
              eventName: 'ScreenView',
              properties: {'Screen': 'InProgressScreen'});
          Navigator.pushNamedAndRemoveUntil(
              context, RouteUtilities.inProgressScreen, (route) => false,
              arguments: InProgressArgs(
                  navigateFrom: RouteUtilities.dispatchSummaryScreen));
        } else {
          final storedPendingRequests = VariableUtilities.preferences
                  .getStringList(LocalCacheKey.storedPendingRequests) ??
              [];
          for (int i = 0; i < storedPendingRequests.length; i++) {
            Map<String, dynamic> requests =
                jsonDecode(storedPendingRequests[i]);
            if (requests['function_name'] == 'start_trip') {
              if (requests['group_id'] == grpId) {
                storedPendingRequests.removeWhere((element) {
                  Map<String, dynamic> requests =
                      jsonDecode(storedPendingRequests[i]);
                  return requests['group_id'] == grpId;
                });
                break;
              }
            }
          }
          print("storedPendingRequests sss--> $storedPendingRequests");
          VariableUtilities.preferences.setStringList(
              LocalCacheKey.storedPendingRequests, storedPendingRequests);
        }
      }
    } else {
      print(startTripResponse.right);
    }
  }

  ///Update Counts in home screen
  Future<void> updateCountsForHomeScreen(BuildContext context) async {
    int pendingOrderCount =
        VariableUtilities.preferences.getInt(LocalCacheKey.pendingOrderCount) ??
            0;
    int inProgressOrderCount = VariableUtilities.preferences
            .getInt(LocalCacheKey.inProgressOrderCount) ??
        0;
    inProgressOrderCount = pendingOrderCount + inProgressOrderCount;
    VariableUtilities.preferences
        .setInt(LocalCacheKey.inProgressOrderCount, inProgressOrderCount);
    VariableUtilities.preferences.setInt(LocalCacheKey.pendingOrderCount, 0);

    MixpanelManager.mixpanel
        .track('ScreenView', properties: {'Screen': 'DashboardScreen'});
    Navigator.pushNamedAndRemoveUntil(
        context, RouteUtilities.dashboardScreen, (route) => false);
  }

  ///Check the api is exists or not in local storage
  Future<bool> checkApiExistsOrNot() async {
    final storedPendingRequests = VariableUtilities.preferences
            .getStringList(LocalCacheKey.storedPendingRequests) ??
        [];

    await VariableUtilities.preferences.setStringList(
        LocalCacheKey.storedPendingRequests, storedPendingRequests);
    return false;
  }

  ///Update User's Current Location after start the trip
  startUpdateLatLngToFirebase(BuildContext context) async {
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
      String driverId =
          (VariableUtilities.preferences.getString('userID') ?? '');

      VariableUtilities.preferences
          .setBool('${LocalCacheKey.isDriverStartedTrip}-$driverId', true);

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
