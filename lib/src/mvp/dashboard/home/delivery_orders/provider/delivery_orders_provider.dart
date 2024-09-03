import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:parsel_flutter/src/mvp/dashboard/home/delivery_orders/api/update_distance_travel_api.dart';
import 'package:parsel_flutter/src/mvp/dashboard/home/delivery_orders/api/update_store_location_api.dart';
import 'package:parsel_flutter/src/mvp/dashboard/home/delivery_orders/model/update_distance_travel_model.dart';
import 'package:parsel_flutter/src/mvp/dashboard/home/delivery_orders/model/update_store_location_model.dart';
import 'package:parsel_flutter/src/mvp/dashboard/home/payment/api/update_sales_order_api.dart';
import 'package:parsel_flutter/src/mvp/dashboard/home/select_pending_orders/model/parsel_base_model.dart';
import 'package:parsel_flutter/utils/utils.dart';

class DeliveryOrdersProvider extends ChangeNotifier {
  bool _isDriverArrived = false;
  bool get isDriverArrived => _isDriverArrived;
  set isDriverArrived(bool val) {
    _isDriverArrived = val;
    notifyListeners();
  }

  Either<ParselBaseModel, Exception> _getSalesOrderListByStatusResponse =
      Right(StaticException());
  Either<ParselBaseModel, Exception> get getSalesOrderListByStatusResponse =>
      _getSalesOrderListByStatusResponse;
  set getSalesOrderListByStatusResponse(
      Either<ParselBaseModel, Exception> val) {
    _getSalesOrderListByStatusResponse = val;
    notifyListeners();
  }

  Either<UpdateStoreLocationModel, Exception>
      _updateStoreLocationModelResponse = Right(StaticException());
  Either<UpdateStoreLocationModel, Exception>
      get updateStoreLocationModelResponse => _updateStoreLocationModelResponse;
  set updateStoreLocationModelResponse(
      Either<UpdateStoreLocationModel, Exception> val) {
    _updateStoreLocationModelResponse = val;
    notifyListeners();
  }

  Either<UpdateDistanceTravelModel, Exception> _updateDistanceTravelModel =
      Right(StaticException());
  Either<UpdateDistanceTravelModel, Exception> get updateDistanceTravelModel =>
      _updateDistanceTravelModel;
  set updateDistanceTravelModel(
      Either<UpdateDistanceTravelModel, Exception> val) {
    _updateDistanceTravelModel = val;
    notifyListeners();
  }

  Future<void> updateSalesOrders(
      {required String salesOrderId,
      required bool isLastIndex,
      required bool isCallFromOffline,
      required int timestamp,
      required BuildContext context}) async {
    if (ConnectivityHandler.connectivityResult .contains( ConnectivityResult.none)) {
      final storedUpdateArrivedOrdersRequests = VariableUtilities.preferences
              .getStringList(LocalCacheKey.storedUpdateArrivedOrdersRequests) ??
          [];

      for (int i = 0; i < storedUpdateArrivedOrdersRequests.length; i++) {
        Map<String, dynamic> requests =
            jsonDecode(storedUpdateArrivedOrdersRequests[i]);
        if (requests['function_name'] == 'update_arrived_status') {
          if (requests['sales_order_id'] == salesOrderId) {
            if (isLastIndex) {
              Fluttertoast.showToast(
                  msg: LocaleKeys.your_request_is_already_submitted.tr());
            }

            return;
          }
        }
      }
      Map<String, dynamic> offlineApi = {
        'function_name': 'update_arrived_status',
        'sales_order_id': salesOrderId,
        'arrived_timestamp': DateTime.now().millisecondsSinceEpoch
      };
      storedUpdateArrivedOrdersRequests.add(jsonEncode(offlineApi));
      if (isLastIndex) {
        Fluttertoast.showToast(msg: LocaleKeys.your_request_is_submitted.tr());
      }
      print(
          'Check storedUpdateArrivedOrdersRequests --> $storedUpdateArrivedOrdersRequests');

      await VariableUtilities.preferences.setStringList(
          LocalCacheKey.storedUpdateArrivedOrdersRequests,
          storedUpdateArrivedOrdersRequests);
      return;
    }
    getSalesOrderListByStatusResponse = Right(NoDataFoundException());
    getSalesOrderListByStatusResponse = await updateSalesOrderApi(context,
        isCallFromOffline: isCallFromOffline,
        timestamp: timestamp,
        deliveryStatus: 'ARRIVED',
        salesOrderId: salesOrderId,
        updateSalesOrderItemList: []);
    if (getSalesOrderListByStatusResponse.isLeft) {
      if (getSalesOrderListByStatusResponse.left.status ||
          (getSalesOrderListByStatusResponse.left.status == false &&
              getSalesOrderListByStatusResponse.left.message ==
                  "No Fields to update. Data same as previous")) {
        if (isLastIndex) {
          Fluttertoast.showToast(
              msg: getSalesOrderListByStatusResponse.left.message);
        }
        final storedUpdateArrivedOrdersRequests = VariableUtilities.preferences
                .getStringList(
                    LocalCacheKey.storedUpdateArrivedOrdersRequests) ??
            [];

        for (int i = 0; i < storedUpdateArrivedOrdersRequests.length; i++) {
          Map<String, dynamic> requests =
              jsonDecode(storedUpdateArrivedOrdersRequests[i]);
          if (requests['function_name'] == 'update_arrived_status') {
            if (requests['sales_order_id'] == salesOrderId) {
              storedUpdateArrivedOrdersRequests.removeWhere((element) {
                Map<String, dynamic> requests =
                    jsonDecode(storedUpdateArrivedOrdersRequests[i]);
                return requests['sales_order_id'] == salesOrderId;
              });
            }
          }
        }

        VariableUtilities.preferences.setStringList(
            LocalCacheKey.storedUpdateArrivedOrdersRequests,
            storedUpdateArrivedOrdersRequests);
      }
    }
  }

  Future<void> updateDistanceTravel(
      BuildContext context, String salesOrderId) async {
    updateDistanceTravelModel = Right(NoDataFoundException());
    try {
      if (ConnectivityHandler.connectivityResult .contains( ConnectivityResult.none)) {
        updateDistanceTravelModel = Right(StaticException());
        final storedUpdateDistanceRequests = VariableUtilities.preferences
                .getStringList(LocalCacheKey.storedUpdateDistanceRequests) ??
            [];
        print(
            "storedUpdateDistanceRequests Before --> $storedUpdateDistanceRequests");
        for (int i = 0; i < storedUpdateDistanceRequests.length; i++) {
          Map<String, dynamic> requests =
              jsonDecode(storedUpdateDistanceRequests[i]);
          if (requests['function_name'] == 'update_distance') {
            if (requests['sales_order_id'] == salesOrderId) {
              Fluttertoast.showToast(
                  msg: LocaleKeys.your_request_is_already_submitted.tr());
              return;
            }
          }
        }
        Map<String, dynamic> offlineApi = {
          'function_name': 'update_distance',
          'sales_order_id': salesOrderId
        };
        storedUpdateDistanceRequests.add(jsonEncode(offlineApi));
        print(
            'Check StoredUpdateDistanceRequests --> $storedUpdateDistanceRequests');
        Fluttertoast.showToast(msg: LocaleKeys.your_request_is_submitted.tr());
        VariableUtilities.preferences.setStringList(
            LocalCacheKey.storedUpdateDistanceRequests,
            storedUpdateDistanceRequests);
      } else {
        updateDistanceTravelModel = await updateDistanceTravelApi(context);
        if (updateDistanceTravelModel.isLeft) {
          if (updateDistanceTravelModel.left.status) {
            final storedUpdateDistanceRequests = VariableUtilities.preferences
                    .getStringList(
                        LocalCacheKey.storedUpdateDistanceRequests) ??
                [];

            for (int i = 0; i < storedUpdateDistanceRequests.length; i++) {
              Map<String, dynamic> requests =
                  jsonDecode(storedUpdateDistanceRequests[i]);
              if (requests['function_name'] == 'update_distance') {
                if (requests['sales_order_id'] == salesOrderId) {
                  storedUpdateDistanceRequests.removeWhere((element) {
                    Map<String, dynamic> requests =
                        jsonDecode(storedUpdateDistanceRequests[i]);
                    return requests['sales_order_id'] == salesOrderId;
                  });
                }
              }
            }
            print(
                "storedUpdateDistanceRequests sss--> $storedUpdateDistanceRequests");
            VariableUtilities.preferences.setStringList(
                LocalCacheKey.storedUpdateDistanceRequests,
                storedUpdateDistanceRequests);
          }
        }
      }
    } catch (e) {
      debugPrint('$e');
    }
  }

  Future<void> updateStoreLocation(BuildContext context,
      {Position? prefsPosition,
      required String salesOrderId,
      required int id,
      required int storeId}) async {
    // return resultList;

    if (ConnectivityHandler.connectivityResult .contains( ConnectivityResult.none)) {
      late Position _currentPosition;
      final storedArrivedLocationRequests = VariableUtilities.preferences
              .getStringList(LocalCacheKey.storedArrivedLocationRequests) ??
          [];

      for (int i = 0; i < storedArrivedLocationRequests.length; i++) {
        Map<String, dynamic> requests =
            jsonDecode(storedArrivedLocationRequests[i]);
        String storedSalesId = requests['sales_order_id'];
        if (storedSalesId == salesOrderId) {
          Fluttertoast.showToast(
              msg: LocaleKeys.your_request_is_already_submitted.tr());

          return;
        }
      }
      try {
        _currentPosition = await Geolocator.getCurrentPosition();
      } catch (e) {
        print(e);
        updateStoreLocationModelResponse = Right(StaticException());
        return;
      }

      Map<String, dynamic> offlineApi = {
        'function_name': 'arrived_location',
        'current_location': _currentPosition,
        'sales_order_id': salesOrderId,
        'id': id,
        'store_id': storeId
      };
      storedArrivedLocationRequests.add(jsonEncode(offlineApi));
      Fluttertoast.showToast(msg: LocaleKeys.your_request_is_submitted.tr());

      await VariableUtilities.preferences.setStringList(
          LocalCacheKey.storedArrivedLocationRequests,
          storedArrivedLocationRequests);
      // _currentPosition = await Geolocator.getCurrentPosition();
      isDriverArrived = true;
      // resultList.deliveryAddressCoordinates.lat = _currentPosition.latitude;
      // resultList.deliveryAddressCoordinates.long = _currentPosition.longitude;
      _updateCanCompleteTrip(
          currentPosition: _currentPosition,
          latLng: LatLng(_currentPosition.latitude, _currentPosition.longitude),
          salesOrderId: salesOrderId);
      // print(_currentPosition);
      return;
    }

    updateStoreLocationModelResponse = Right(NoDataFoundException());
    late Position _currentPosition;
    try {
      _currentPosition = await Geolocator.getCurrentPosition();
    } catch (e) {
      updateStoreLocationModelResponse = Right(StaticException());

      return;
    }

    updateStoreLocationModelResponse = await updateStoreLocationApi(context,
        salesOrderId: salesOrderId,
        storeId: storeId,
        position: _currentPosition);
    if (updateStoreLocationModelResponse.isLeft) {
      if (updateStoreLocationModelResponse.left.status) {
        if (prefsPosition == null) {
          Fluttertoast.showToast(
              msg: updateStoreLocationModelResponse.left.message);
          isDriverArrived = true;
          // resultList.deliveryAddressCoordinates.lat = _currentPosition.latitude;
          // resultList.deliveryAddressCoordinates.long =
          //     _currentPosition.longitude;
          _updateCanCompleteTrip(
              currentPosition: _currentPosition,
              latLng:
                  LatLng(_currentPosition.latitude, _currentPosition.longitude),
              salesOrderId: salesOrderId);
        } else {
          final storedArrivedLocationRequests = VariableUtilities.preferences
                  .getStringList(LocalCacheKey.storedArrivedLocationRequests) ??
              [];
          for (int i = 0; i < storedArrivedLocationRequests.length; i++) {
            Map<String, dynamic> requests =
                jsonDecode(storedArrivedLocationRequests[i]);

            if (requests['function_name'] == 'arrived_location') {
              if (requests['id'] == id) {
                storedArrivedLocationRequests.removeWhere((element) {
                  return requests['id'] == id;
                });
                break;
              }
            }
          }

          VariableUtilities.preferences.setStringList(
              LocalCacheKey.storedArrivedLocationRequests,
              storedArrivedLocationRequests);
        }
        return;
      } else {
        Fluttertoast.showToast(
            msg: updateStoreLocationModelResponse.left.message);
      }
    }
    return;
  }

  void _updateCanCompleteTrip(
      {required Position currentPosition,
      required LatLng latLng,
      required String salesOrderId}) async {
    final distance = Geolocator.distanceBetween(latLng.latitude,
        latLng.longitude, currentPosition.latitude, currentPosition.longitude);

    isDriverArrived = distance <= 500;
    if (isDriverArrived) {
      VariableUtilities.preferences.setBool(
          "${LocalCacheKey.isDriverArrivedToLocation}Arrived$salesOrderId",
          isDriverArrived);
    }
  }
}
