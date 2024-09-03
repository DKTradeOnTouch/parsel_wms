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
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:parsel_flutter/models/AddPaymet_model.dart';
import 'package:parsel_flutter/models/base_moel.dart';
import 'package:parsel_flutter/models/firebase_location_lat_lng_model.dart';
import 'package:parsel_flutter/models/startTrip_modal.dart';
import 'package:parsel_flutter/models/uploadsalesorder_model.dart' as upldsale;
import 'package:parsel_flutter/resource/app_colors.dart';
import 'package:parsel_flutter/resource/app_helper.dart';
import 'package:parsel_flutter/resource/app_logs.dart';
import 'package:parsel_flutter/resource/app_styles.dart';
import 'package:parsel_flutter/screens/AUth/prominent_Disclosure.dart';
import 'package:parsel_flutter/screens/InventoryMenu/InventoryDashboard.dart';
import 'package:parsel_flutter/screens/in_progress/location_service.dart';
import 'package:parsel_flutter/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:upgrader/upgrader.dart';

import '../../models/CreatePayment_model.dart' as create_payment;
import '../../models/UpdateSalesOrder_model.dart' as up;
import '../Provider/Invoice_Controller.dart';
import '../api/api.dart';
import '../models/COUNT_MODAL.dart';
import '../models/InvoiceList_model.dart';
import '../resource/app_strings.dart';
import 'AUth/drawer.dart';
import 'Pending/PendingfirstScreen.dart';
import 'in_progress/progress_page.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({Key? key}) : super(key: key);

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

String? index;
int isSelected = 1;
int totalCount = 0;

List<String> dashBoardMenu = [
  'PENDING',
  'IN PROGRESS',
  'DELIVERED',
  'ATTEMPTED',
  'RETURNED',
];
List<String> dashBoardText = [
  '0',
  '0',
  '0',
  '0',
  '0',
];

class _DashBoardScreenState extends State<DashBoardScreen> {
  int delivered = 0;
  int pending = 0;
  int inProcess = 0;

  String? salesORDERID;
  bool _isLoading = false;
  // bool isWorkingOnPreviousRequest = false;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  @override
  void initState() {
    // tabvalue = widget.tabSelection;
    super.initState();
    initConnectivity();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    listenDashboardPrefsData();
    appLogs('WidgetsBinding.instance.addPostFrameCallback');

    updateDriverLocation();
    if (ConnectivityHandler.connectivityResult
            .contains(ConnectivityResult.mobile) ||
        ConnectivityHandler.connectivityResult
            .contains(ConnectivityResult.wifi)) {
      updateOfflineLocation();
    }
  }

  Future<void> initConnectivity() async {
    late List<ConnectivityResult> result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    result = await _connectivity.checkConnectivity();

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> event) async {
    appLogs('Update Connectivity Status -------------------------> $event');
    if (event.contains(ConnectivityResult.mobile) ||
        event.contains(ConnectivityResult.wifi)) {
      // isWorkingOnPreviousRequest = true;
      setState(() {});
      await apiInQueue();
      await paymentApiInQueue();
      // await _loadAllData();
      if (GlobalVariablesUtils.globalUpdateTimer != null) {
        GlobalVariablesUtils.globalUpdateTimer!.cancel();
      }
      GlobalVariablesUtils.globalUpdateTimer = null;
      updateDriverLocation();
      updateOfflineLocation();
      setState(() {});
    }
    if (event.contains(ConnectivityResult.none)) {
      if (GlobalVariablesUtils.globalUpdateTimer != null) {
        GlobalVariablesUtils.globalUpdateTimer!.cancel();
      }
      GlobalVariablesUtils.globalUpdateTimer = null;
      updateCountForOrderTask();
      updateDriverLocation();
    }
  }

  updateDriverLocation() async {
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
    //
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
      // if (!kDebugMode) {
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
      // }
    } catch (e) {
      appLogs('$e');
    }
  }

  Future<void> _onPositionUpdate(Position position) async {
    appLogs('Listening position --> $position ');
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
      appLogs(
          "---------------- firebase db update error: -----------------------------");
      appLogs('$e');
    }
  }

  updateOfflineLocation() async {
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

  Future<void> apiInQueue() async {
    String updatedPrefsQueApi =
        VariableUtilities.preferences.getString(LocalCacheKey.apiInQue) ?? '';
    List<dynamic> updatedPrefsList = [];
    if (updatedPrefsQueApi.isNotEmpty) {
      updatedPrefsList = List<dynamic>.from(
          jsonDecode(updatedPrefsQueApi).map((x) => jsonDecode(jsonEncode(x))));
    }
    appLogs("updatedPrefsList --> ${updatedPrefsList.length}");
    setState(() {
      // isWorkingOnPreviousRequest = true;
    });
    for (int i = 0; i < updatedPrefsList.length; i++) {
      Map<String, dynamic> jsonMap = {};
      if (jsonDecode(jsonEncode(updatedPrefsList[i])).runtimeType == String) {
        jsonMap = jsonDecode(updatedPrefsList[i]);
      } else {
        jsonMap = jsonDecode(jsonEncode(updatedPrefsList[i]));
      }
      if (jsonMap['parameters']['GROUPID'] != null ||
          jsonMap['parameters']['GROUPID'] != '') {
        await callQueueApiUsingFunctionName(jsonMap);
      }
    }
    setState(() {
      // isWorkingOnPreviousRequest = false;
    });
  }

  Future<void> paymentApiInQueue() async {
    String updatedPrefsQueApi = VariableUtilities.preferences
            .getString(LocalCacheKey.paymentApiInQue) ??
        '';
    List<dynamic> updatedPrefsList = [];
    if (updatedPrefsQueApi.isNotEmpty) {
      updatedPrefsList = List<dynamic>.from(
          jsonDecode(updatedPrefsQueApi).map((x) => jsonDecode(jsonEncode(x))));
    }
    appLogs("updatedPrefsList --> $updatedPrefsList");
    setState(() {
      // isWorkingOnPreviousRequest = true;
    });
    for (int i = 0; i < updatedPrefsList.length; i++) {
      appLogs(
          "updatedPrefsList[i] --> ${updatedPrefsList[i]} ${jsonDecode(jsonEncode(updatedPrefsList[i])).runtimeType}");
      Map<String, dynamic> jsonMap = {};
      if (jsonDecode(jsonEncode(updatedPrefsList[i])).runtimeType == String) {
        jsonMap = jsonDecode(updatedPrefsList[i]);
      } else {
        jsonMap = jsonDecode(jsonEncode(updatedPrefsList[i]));
      }
      await callQueueApiUsingFunctionName(jsonMap);
    }
    setState(() {
      // isWorkingOnPreviousRequest = false;
    });
  }

  Future<void> removeApiInQueue({required String groupId}) async {
    String updatedPrefsQueApi =
        VariableUtilities.preferences.getString(LocalCacheKey.apiInQue) ?? '';
    List<dynamic> updatedPrefsList = [];
    if (updatedPrefsQueApi.isNotEmpty) {
      updatedPrefsList = List<dynamic>.from(
          jsonDecode(updatedPrefsQueApi).map((x) => jsonDecode(jsonEncode(x))));
    }
    List<dynamic> storeUpdatedPrefs = [];
    for (int i = 0; i < updatedPrefsList.length; i++) {
      Map<String, dynamic> jsonData = {};
      if (jsonDecode(jsonEncode(updatedPrefsList[i])).runtimeType == String) {
        jsonData = jsonDecode(updatedPrefsList[i]);
      } else {
        jsonData = jsonDecode(jsonEncode(updatedPrefsList[i]));
      }

      if (jsonData['parameters']['GROUPID'] != groupId) {
        storeUpdatedPrefs.add(jsonData);
      }
    }
    String storeUpdatedPrefsString = jsonEncode(storeUpdatedPrefs);

    VariableUtilities.preferences
        .setString(LocalCacheKey.apiInQue, storeUpdatedPrefsString);
    appLogs("updatedPrefsList --> Removed  ${storeUpdatedPrefs.length}");
  }

  Future<void> removePaymentApiInQueue({required String salesOrderID}) async {
    // StorageUtils.preferences.remove(StorageUtils.paymentApiInQue);
    appLogs("updatedPrefsQueApi --> ");

    String updatedPrefsQueApi = VariableUtilities.preferences
            .getString(LocalCacheKey.paymentApiInQue) ??
        '';
    appLogs("updatedPrefsQueApi --> $updatedPrefsQueApi");
    List<dynamic> updatedPrefsList = [];
    if (updatedPrefsQueApi.isNotEmpty) {
      updatedPrefsList = List<dynamic>.from(
          jsonDecode(updatedPrefsQueApi).map((x) => jsonDecode(jsonEncode(x))));
    }

    appLogs('updatedPrefsList --> count --${updatedPrefsList.length}');
    for (int i = 0; i < updatedPrefsList.length; i++) {
      Map<String, dynamic> jsonData = {};
      if (updatedPrefsList[i].runtimeType == String) {
        jsonData = jsonDecode(updatedPrefsList[i]);
      } else {
        jsonData = jsonDecode(jsonEncode(updatedPrefsList[i]));
      }

      if (jsonData['parameters']['salesOrderId'] == salesOrderID ||
          jsonData['parameters']['ID'] == salesOrderID) {
        updatedPrefsList.removeWhere((element) {
          appLogs("element--> $element");
          Map<String, dynamic> jsonData = {};
          if (element.runtimeType == String) {
            jsonData = jsonDecode(element);
          } else {
            jsonData = jsonDecode(jsonEncode(element));
          }

          return jsonData['parameters']['salesOrderId'] == salesOrderID ||
              jsonData['parameters']['ID'] == salesOrderID;
        });
      }
    }
    String storeUpdatedPrefsString = jsonEncode(updatedPrefsList);

    VariableUtilities.preferences
        .setString(LocalCacheKey.paymentApiInQue, storeUpdatedPrefsString);
    appLogs("updatedPrefsList --> Removed  ${updatedPrefsList.length}");
  }

  Future callQueueApiUsingFunctionName(Map<String, dynamic> jsonData) async {
    String functionName = jsonData['function_name'];
    Map<String, dynamic> parameters = jsonData['parameters'];

    switch (functionName) {
      case "updateGroupIdDetails":
        updateGroupIdDetails(context, jsonData['parameters']);
        break;
      case 'updateSalesorderbyID1':
        updateSalesorderbyID1(jsonMap: jsonData['parameters']);
        break;
      case 'cancelTripFunction':
        cancelTrip(jsonMap: jsonData['parameters']);
        break;
      case 'updateSalesorderbyID1OnGoing':
        updateSalesorderbyID1OnGoing(jsonMap: jsonData['parameters']);
        break;
      case "createPayMentFunction":
        List<PaymentsList> list = List<PaymentsList>.from(
            jsonDecode(jsonEncode(parameters['payment']))
                .map((x) => PaymentsList.fromJson(x)));

        List<upldsale.ItemList> items = List<upldsale.ItemList>.from(
            jsonDecode(jsonEncode(parameters['itemList']))
                .map((x) => upldsale.ItemList.fromJson(x)));

        createPayments(context, jsonData['parameters'], list, items);
        break;
    }
  }

  Future cancelTrip({required Map<String, dynamic> jsonMap}) async {
    // try {
    String salesOrderID = jsonMap['salesOrderId'] == null
        ? jsonMap['ID']
        : jsonMap['salesOrderId'] ?? '';
    String driverId = (VariableUtilities.preferences.getString('userID') ?? '');
    GlobalVariablesUtils.globalSalesOrdersDb = FirebaseDatabase.instance
        .ref("driverLogs")
        .child(driverId)
        .child(DateFormat("yyyy-MM-dd").format(DateTime.now().toUtc()));
    GlobalVariablesUtils.globalDriversDb =
        FirebaseDatabase.instance.ref("drivers").child(driverId);

    await _updateLocationStatus('paused');
    return await API
        .startTrip(context,
            showNoInternet: true, executionStatus: 'IN_GROUP', ID: salesOrderID)
        .then(
      (StartTripModal? response) async {
        appLogs("Response  -- > ${response!.body}");
        if (response == null) {
          // AppHelper.showSnackBar(context, AppStrings.strSomethingWentWrong);
        } else {
          removePaymentApiInQueue(salesOrderID: salesOrderID);
        }
        // Navigator.pop(context);
      },
    ).onError((error, stackTrace) {
      appLogs(error);
    });
    // } catch (e) {
    // Navigator.pop(context);
    // }
  }

  Future<void> _updateLocationStatus(String status) async =>
      GlobalVariablesUtils.globalDriversDb.update({"status": status});

  Future createPayments(BuildContext context, Map<String, dynamic> jsonMap,
      List<PaymentsList> payt, List<upldsale.ItemList> itemList) async {
    appLogs("jsonMap --> $jsonMap");
    setState(() {
      _isLoading = true;
    });
    String salesOrderID = jsonMap['salesOrderId'] == null
        ? jsonMap['ID']
        : jsonMap['salesOrderId'] ?? '';
    try {
      String deliverySummaryPhotoProof = VariableUtilities.preferences
              .getString(
                  "${LocalCacheKey.deliverySummaryPhotoProof}$salesOrderID") ??
          '';
      String deliverySummaryScanDocProof = VariableUtilities.preferences
              .getString(
                  "${LocalCacheKey.deliverySummaryScanDocProof}$salesOrderID") ??
          '';
      String deliverySummaryUploadDocProof = VariableUtilities.preferences
              .getString(
                  "${LocalCacheKey.deliverySummaryUploadDocProof}$salesOrderID") ??
          '';

      String deliverySummarySignatureProof = VariableUtilities.preferences
              .getString(
                  "${LocalCacheKey.deliverySummarySignatureProof}$salesOrderID") ??
          '';
      if (deliverySummaryPhotoProof != '' ||
          deliverySummaryScanDocProof != '' ||
          deliverySummaryUploadDocProof != '' ||
          deliverySummarySignatureProof != '') {
        await API
            .uploadDocs(context,
                signatureFile: deliverySummarySignatureProof,
                photoFile: deliverySummaryPhotoProof,
                signatureName: deliverySummarySignatureProof,
                documentFile: deliverySummaryUploadDocProof,
                scanDocumentFile: deliverySummaryScanDocProof,
                salesOrderID: salesOrderID)
            .then((response) {
          if (response != null) {
            VariableUtilities.preferences.setString(
                "${LocalCacheKey.deliverySummaryPhotoProof}$salesOrderID", '');
            VariableUtilities.preferences.setString(
                "${LocalCacheKey.deliverySummaryScanDocProof}$salesOrderID",
                '');
            VariableUtilities.preferences.setString(
                "${LocalCacheKey.deliverySummaryUploadDocProof}$salesOrderID",
                '');
            VariableUtilities.preferences.setString(
                "${LocalCacheKey.deliverySummarySignatureProof}$salesOrderID",
                '');
          }
        });
      }
    } catch (e) {
      appLogs(e);
    }

    return await API
        .createPaymentInProgress(context,
            paymentMode: jsonMap['paymentMode'],
            salesOrderId: jsonMap['id'],
            payment: payt)
        .then(
      (BaseModel? response) async {
        setState(() {
          _isLoading = false;
        });
        appLogs('create payment response-->' + response.toString());
        if (response != null) {
          // AppHelper.showSnackBar(context, response.message.toString());
          // Navigator.push(
          //     context, MaterialPageRoute(builder: (_) => DashBoardScreen()));
          updateSalesorderbyID(
              context, jsonMap['deliverId'].toString(), itemList);
          // response.body!.data!.map((e) => createPayment.add(e)).toList();
        } else {
          // AppHelper.showSnackBar(context, AppStrings.strSomethingWentWrong);
        }
      },
    ).onError((error, stackTrace) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  Future updateSalesorderbyID(BuildContext context, String salesOrderId,
      List<upldsale.ItemList> itemList) async {
    appLogs("jsonData --> $salesOrderId");
    final preference = await SharedPreferences.getInstance();
    setState(() {
      _isLoading = true;
    });
    return await API
        .updateSalesorderbyID1InProgress(context,
            showNoInternet: true,
            itemList: itemList,
            executionStatus: 'DELIVERED',
            ID: salesOrderId)
        .then(
      (BaseModel? response) async {
        setState(() {
          _isLoading = false;
          removePaymentApiInQueue(salesOrderID: salesOrderId);
          _loadAllData();
        });

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

  Future updateGroupIdDetails(
      BuildContext context, Map<String, dynamic> jsonData) async {
    setState(() {
      // isWorkingOnPreviousRequest = true;
    });
    final preference = await SharedPreferences.getInstance();

    return await API
        .updateGroupIdDetails(
      context,
      showNoInternet: jsonData['showNoInternet'],
      Authtoken: preference.getString("token").toString(),
      STATUS: jsonData['STATUS'],
      GROUPID: jsonData['GROUPID'],
      noOfBoxes: jsonData['noOfBoxes'],
      temperature: jsonData['temperature'],
      Ifile: File(jsonData['Ifile']),
    )
        .then(
      (bool response) async {
        appLogs("Response Sku List--> $response");
        removeApiInQueue(groupId: jsonData['GROUPID']);

        VariableUtilities.preferences.remove("PendingOrderCount");
        VariableUtilities.preferences.remove("InProgressOrderCount");
        VariableUtilities.preferences.remove("DeliveredOrderCount");
        VariableUtilities.preferences.remove("PickUpPointCityList");
        VariableUtilities.preferences.remove("DispatchDetails");
        VariableUtilities.preferences.remove("GroupIdForDisplayOrder");
        pending = 0;
        VariableUtilities.preferences
            .setInt(LocalCacheKey.pendingOrderCount, 0);
        setState(() {
          // isWorkingOnPreviousRequest = false;
        });
      },
    ).onError((error, stackTrace) {
      appLogs("Error -->onError  $error");
      setState(() {
        // isWorkingOnPreviousRequest = false;
      });
    });
  }

  void listenDashboardPrefsData() {
    if (ConnectivityHandler.connectivityResult
        .contains(ConnectivityResult.none)) {
      updateCountForOrderTask();
    } else {
      _loadAllData();
    }
  }

  Future updateCountForOrderTask() async {
    pending =
        VariableUtilities.preferences.getInt(LocalCacheKey.pendingOrderCount) ??
            0;
    appLogs('pending --.> $pending');
    inProcess = VariableUtilities.preferences
            .getInt(LocalCacheKey.inProgressOrderCount) ??
        0;
    delivered = VariableUtilities.preferences
            .getInt(LocalCacheKey.deliveredOrderCount) ??
        0;
    setState(() {});
  }

  Future<void> _loadAllData() async {
    appLogs('getCountAPINew -----------------------------------------------');
    // await updateCountForOrderTask();
    await getCountAPINew(context);
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
        if (response != null) {
          salesORDERID = response.body.data.resultList[0].salesOrderId;
        } else {
          // AppHelper.showSnackBar(context, AppStrings.strSomethingWentWrong);
        }
      },
    ).onError((error, stackTrace) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  Future getCountAPINew(BuildContext context) async {
    final preference = await SharedPreferences.getInstance();
    String token = preference.getString('token').toString();
    String userID = preference.getString('userID').toString();

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
        print("CountApiModalNew $response");
        setState(() {
          _isLoading = false;
        });
        if (response != null) {
          if (response.status == true) {
            pending = response.body.inGroup;
            inProcess = response.body.onGoing;
            delivered = response.body.delivered;
            preference.setInt(LocalCacheKey.pendingOrderCount, pending);
            preference.setInt(LocalCacheKey.inProgressOrderCount, inProcess);
            preference.setInt(LocalCacheKey.deliveredOrderCount, delivered);
            setState(() {});
          }
        } else {
          // AppHelper.showSnackBar(context, AppStrings.strSomethingWentWrong);
        }
      },
    ).onError((error, stackTrace) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  Future updateSalesorderbyID1({required Map<String, dynamic> jsonMap}) async {
    // try {

    // try{
    String salesOrderID = jsonMap['salesOrderId'] == null
        ? jsonMap['ID']
        : jsonMap['salesOrderId'] ?? '';
    appLogs('jsonMap --->${jsonMap['itemList'].runtimeType}');

    List<upldsale.ItemList> items = List<upldsale.ItemList>.from(
        jsonDecode(jsonEncode(jsonMap['itemList']))
            .map((x) => upldsale.ItemList.fromJson(x)));

    return await API
        .updateSalesorderbyID1(context,
            showNoInternet: true,
            itemList: items,
            executionStatus: 'ARRIVED',
            ID: salesOrderID)
        .then(
      (up.UpdateSalesOrder_model? response) async {
        setState(() {
          _isLoading = false;
        });
        appLogs('response-->' + response.toString());
        if (response != null) {
        } else {
          // AppHelper.showSnackBar(context, AppStrings.strSomethingWentWrong);
        }
      },
    );
    // } catch (e) {}
  }

  updateSalesorderbyID1OnGoing({required Map<String, dynamic> jsonMap}) async {
    String salesOrderID = jsonMap['salesOrderId'] == null
        ? jsonMap['ID']
        : jsonMap['salesOrderId'] ?? '';
    final preference = await SharedPreferences.getInstance();
    setState(() {
      _isLoading = true;
    });
    return await API
        .updateSalesorderbyIDInProgress(context,
            showNoInternet: true,
            Authtoken: preference.getString("token").toString(),
            temperature: 200,
            executionStatus: 'ON_GOING',
            ID: salesOrderID)
        .then(
      (BaseModel? response) async {
        setState(() {
          _isLoading = false;
        });
        appLogs('Response-->' + response.toString());
        if (response != null) {
        } else {
          // AppHelper.showSnackBar(context, AppStrings.strSomethingWentWrong);
        }
      },
    ).onError((error, stackTrace) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  void dispose() {
    print("czxcxz");

    _connectivitySubscription.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return UpgradeAlert(
      child: Stack(
        children: [
          Scaffold(
            // drawer: DrawerScreen(),
            backgroundColor: AppColors.whiteColor,
            appBar: AppHelper.dashboardAppBar(
              context,
              'DASHBOARD',
              DrawerScreen(onLogoutTap: () {}),
              Icons.menu,
              callBack: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DrawerScreen(
                              onLogoutTap: () {
                                print("On Logout Tap");
                                _connectivitySubscription.cancel();
                              },
                            )));
              },
              actions: [
                IconButton(
                    onPressed: _loadAllData, icon: const Icon(Icons.refresh)),
              ],
            ),

            body: RefreshIndicator(
              onRefresh: _loadAllData,
              backgroundColor: Colors.purple,
              color: Colors.white,
              child: Consumer<InvoiceController>(
                  builder: (context, invoiceController, child) {
                return PopScope(
                  onPopInvoked: (val) async => false,
                  child: SafeArea(
                    child: SingleChildScrollView(
                      child: Center(
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 32,
                            ),
                            InkWell(
                                onTap: () {
                                  _connectivitySubscription.cancel();
                                  setState(() {
                                    isSelected = 1;
                                  });
                                  Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                  const PendingfirstScreen()))
                                      .then((value) {
                                    updateCountForOrderTask();
                                    _loadAllData();
                                    _connectivitySubscription = _connectivity
                                        .onConnectivityChanged
                                        .listen(_updateConnectionStatus);
                                  });
                                },
                                child: isSelected == 1
                                    ? Container(
                                        height: 56,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: AppColors.whiteColor,
                                          boxShadow: const [
                                            BoxShadow(
                                              color: AppColors
                                                  .dashBoardCardBackground,
                                              //color of shadow
                                              spreadRadius: 1,
                                              //spread radius
                                              blurRadius: 1, // blur radius
                                            ),
                                            //you can set more BoxShadow() here
                                          ],
                                        ),
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 35, vertical: 8),
                                        child: Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.transparent,
                                                  width: 1.0),
                                              borderRadius: const BorderRadius
                                                  .all(Radius.circular(
                                                      5.0) //                 <--- border radius here
                                                  ),
                                              gradient: LinearGradient(
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                                colors: [
                                                  HexColor('#0137FF'),
                                                  HexColor('#002BCA')
                                                ],
                                              ),
                                            ),
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: ListTile(
                                                leading: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: SvgPicture.asset(
                                                    "assets/pending.svg",
                                                    semanticsLabel: 'Acme Logo',
                                                    color: Colors.yellow,
                                                  ),
                                                ),
                                                title: Text(
                                                  dashBoardMenu[0],
                                                  style: AppStyles
                                                      .dashBoardWhiteTextStyle,
                                                ),
                                                trailing: Text(
                                                  pending.toString(),
                                                  style: AppStyles
                                                      .dashBoardYellowTextStyle,
                                                ))),
                                      )
                                    : Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: AppColors.whiteColor,
                                          boxShadow: const [
                                            BoxShadow(
                                              color: AppColors
                                                  .dashBoardCardBackground,
                                              //color of shadow
                                              spreadRadius: 1,
                                              //spread radius
                                              blurRadius: 1, // blur radius
                                            ),
                                            //you can set more BoxShadow() here
                                          ],
                                        ),
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 35, vertical: 8),
                                        child: ListTile(
                                            leading: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: SvgPicture.asset(
                                                  "assets/pending.svg",
                                                  color: AppColors.blueColor,
                                                  semanticsLabel: 'Acme Logo'),
                                            ),
                                            title: Text(
                                              dashBoardMenu[0],
                                              style:
                                                  AppStyles.dashBoardTextStyle,
                                            ),
                                            trailing: Text(pending.toString(),
                                                style: AppStyles
                                                    .dashBoardNumberStyle)))),
                            InkWell(
                                onTap: () {
                                  setState(() {
                                    isSelected = 2;
                                  });

                                  _connectivitySubscription.cancel();
                                  Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                  const InProgressPage()))
                                      .then((value) {
                                    _connectivitySubscription = _connectivity
                                        .onConnectivityChanged
                                        .listen(_updateConnectionStatus);
                                  });
                                },
                                child: isSelected == 2
                                    ? Container(
                                        height: 56,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: AppColors.whiteColor,
                                          boxShadow: const [
                                            BoxShadow(
                                              color: AppColors
                                                  .dashBoardCardBackground,
                                              //color of shadow
                                              spreadRadius: 1,
                                              //spread radius
                                              blurRadius: 1, // blur radius
                                            ),
                                            //you can set more BoxShadow() here
                                          ],
                                        ),
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 35, vertical: 8),
                                        child: Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.transparent,
                                                  width: 1.0),
                                              borderRadius: const BorderRadius
                                                  .all(Radius.circular(
                                                      5.0) //                 <--- border radius here
                                                  ),
                                              gradient: LinearGradient(
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                                colors: [
                                                  HexColor('#0137FF'),
                                                  HexColor('#002BCA')
                                                ],
                                              ),
                                            ),
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: ListTile(
                                                leading: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: SvgPicture.asset(
                                                    "assets/inprogress.svg",
                                                    semanticsLabel: 'Acme Logo',
                                                    color: Colors.yellow,
                                                  ),
                                                ),
                                                title: Text(
                                                  dashBoardMenu[1],
                                                  style: AppStyles
                                                      .dashBoardWhiteTextStyle,
                                                ),
                                                trailing: Text(
                                                  inProcess.toString(),
                                                  style: AppStyles
                                                      .dashBoardYellowTextStyle,
                                                ))))
                                    : Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: AppColors.whiteColor,
                                          boxShadow: const [
                                            BoxShadow(
                                              color: AppColors
                                                  .dashBoardCardBackground,
                                              //color of shadow
                                              spreadRadius: 1,
                                              //spread radius
                                              blurRadius: 1, // blur radius
                                            ),
                                            //you can set more BoxShadow() here
                                          ],
                                        ),
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 35, vertical: 8),
                                        child: ListTile(
                                            leading: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: SvgPicture.asset(
                                                  "assets/inprogress.svg",
                                                  semanticsLabel: 'Acme Logo'),
                                            ),
                                            title: Text(
                                              dashBoardMenu[1],
                                              style:
                                                  AppStyles.dashBoardTextStyle,
                                            ),
                                            trailing: Text(
                                              inProcess.toString(),
                                              style: AppStyles
                                                  .dashBoardNumberStyle,
                                            )))),
                            InkWell(
                                onTap: () {
                                  setState(() {
                                    isSelected = 3;
                                  });
                                  // AppHelper.changeScreen(context, DrawerScreen());
                                },
                                child: isSelected == 3
                                    ? Card(
                                        shadowColor:
                                            AppColors.dashBoardCardBackground,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        elevation: 5,
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 35, vertical: 8),
                                        child: Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.transparent,
                                                  width: 1.0),
                                              borderRadius: const BorderRadius
                                                  .all(Radius.circular(
                                                      5.0) //                 <--- border radius here
                                                  ),
                                              gradient: LinearGradient(
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                                colors: [
                                                  HexColor('#0137FF'),
                                                  HexColor('#002BCA')
                                                ],
                                              ),
                                            ),
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: ListTile(
                                                leading: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: SvgPicture.asset(
                                                    "assets/deliverd.svg",
                                                    semanticsLabel: 'Acme Logo',
                                                    color: Colors.yellow,
                                                  ),
                                                ),
                                                title: Text(
                                                  dashBoardMenu[2],
                                                  style: AppStyles
                                                      .dashBoardWhiteTextStyle,
                                                ),
                                                trailing: Text(
                                                  delivered.toString(),
                                                  style: AppStyles
                                                      .dashBoardYellowTextStyle,
                                                ))))
                                    : Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: AppColors.whiteColor,
                                          boxShadow: const [
                                            BoxShadow(
                                              color: AppColors
                                                  .dashBoardCardBackground,
                                              //color of shadow
                                              spreadRadius: 1,
                                              //spread radius
                                              blurRadius: 1, // blur radius
                                            ),
                                            //you can set more BoxShadow() here
                                          ],
                                        ),
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 35, vertical: 8),
                                        child: ListTile(
                                            leading: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: SvgPicture.asset(
                                                  "assets/deliverd.svg",
                                                  semanticsLabel: 'Acme Logo'),
                                            ),
                                            title: Text(
                                              dashBoardMenu[2],
                                              style:
                                                  AppStyles.dashBoardTextStyle,
                                            ),
                                            trailing: Text(
                                              delivered.toString(),
                                              style: AppStyles
                                                  .dashBoardNumberStyle,
                                            )))),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
            bottomNavigationBar: GlobalVariablesUtils.hasEnabledWms
                ? Padding(
                    padding: const EdgeInsets.all(10),
                    child: FloatingActionButton.extended(
                      onPressed: () {
                        _connectivitySubscription.cancel();
                        Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => InventoryDashboardScreen()))
                            .then((value) {
                          _connectivitySubscription = _connectivity
                              .onConnectivityChanged
                              .listen(_updateConnectionStatus);
                        });
                      },
                      label: const Text('INVENTORY'),
                    ),
                  )
                : const SizedBox(),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          ),
        ],
      ),
    );
  }
}
