import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:parsel_flutter/src/mvp/dashboard/home/in_progress/api/fetch_in_progress_sku_api.dart';
import 'package:parsel_flutter/src/mvp/dashboard/home/in_progress/model/get_sales_order_list_by_status_model.dart';
import 'package:parsel_flutter/src/mvp/dashboard/home/payment/api/update_sales_order_api.dart';
import 'package:parsel_flutter/src/mvp/dashboard/home/select_pending_orders/model/parsel_base_model.dart';
import 'package:parsel_flutter/utils/utils.dart';

class InProgressItemProvider extends ChangeNotifier {
  List<ResultList> _searchInProgressItemsList = [];
  List<ResultList> get searchInProgressItemsList => _searchInProgressItemsList;
  set searchInProgressItemsList(List<ResultList> val) {
    _searchInProgressItemsList = val;
    notifyListeners();
  }

  Either<ParselBaseModel, Exception> _onGoingStatusResponse =
      Right(StaticException());
  Either<ParselBaseModel, Exception> get onGoingStatusResponse =>
      _onGoingStatusResponse;
  set onGoingStatusResponse(Either<ParselBaseModel, Exception> val) {
    _onGoingStatusResponse = val;
    notifyListeners();
  }

  Either<GetSalesOrderListByStatusModel, Exception>
      _getSalesOrderListByStatusResponse = Right(StaticException());
  Either<GetSalesOrderListByStatusModel, Exception>
      get getSalesOrderListByStatusResponse =>
          _getSalesOrderListByStatusResponse;
  set getSalesOrderListByStatusResponse(
      Either<GetSalesOrderListByStatusModel, Exception> val) {
    _getSalesOrderListByStatusResponse = val;
    notifyListeners();
  }

  List<ResultList> _inProgressItemsList = [];
  List<ResultList> get inProgressItemsList => _inProgressItemsList;
  set inProgressItemsList(List<ResultList> val) {
    _inProgressItemsList = val;
    notifyListeners();
  }

  List<ResultList> _modifiedInProgressItemsList = [];
  List<ResultList> get modifiedInProgressItemsList =>
      _modifiedInProgressItemsList;
  set modifiedInProgressItemsList(List<ResultList> val) {
    _modifiedInProgressItemsList = val;
    notifyListeners();
  }

  Future<void> fetchInProgressSku(BuildContext context) async {
    modifiedInProgressItemsList = [];
    inProgressItemsList = [];
    if (ConnectivityHandler.connectivityResult
        .contains(ConnectivityResult.none)) {
      String inProgressItemsListString = VariableUtilities.preferences
              .getString(LocalCacheKey.inProgressItemsList) ??
          '';
      print("inProgressItemsListString --> $inProgressItemsListString");
      String getSalesOrderListByStatusResponseString = VariableUtilities
              .preferences
              .getString(LocalCacheKey.getSalesOrderListByStatusResponse) ??
          '';
      if (inProgressItemsListString.isNotEmpty) {
        inProgressItemsList = List<ResultList>.from(
            jsonDecode(inProgressItemsListString)
                .map((json) => ResultList.fromJson(json)));
        List<ResultList> inProgressItemsListCopy =
            List.from(inProgressItemsList);
        for (int i = 0; i < inProgressItemsListCopy.length; i++) {
          await isListContainResultListElement(
              element: inProgressItemsListCopy[i]);
          if (inProgressItemsListCopy.length - 1 == i) {
            updateDeliveryAddressLatLong(inProgressItemsListCopy);
          }
        }
      }
      if (getSalesOrderListByStatusResponseString.isNotEmpty) {
        getSalesOrderListByStatusResponse = Left(
            GetSalesOrderListByStatusModel.fromJson(
                jsonDecode(getSalesOrderListByStatusResponseString)));
      }

      return;
    }
    getSalesOrderListByStatusResponse = Right(NoDataFoundException());
    Either<GetSalesOrderListByStatusModel, Exception> apiResponse =
        await fetchInProgressSkuApi(context);
    getSalesOrderListByStatusResponse = apiResponse;
    // getSalesOrderListByStatusResponse = Left(createResponse());
    if (getSalesOrderListByStatusResponse.isLeft) {
      if (getSalesOrderListByStatusResponse.left.status) {
        inProgressItemsList =
            getSalesOrderListByStatusResponse.left.body.data.resultList;
        List<ResultList> inProgressItemsListCopy =
            List.from(inProgressItemsList);
        VariableUtilities.preferences.setString(
            LocalCacheKey.getSalesOrderListByStatusResponse,
            jsonEncode(getSalesOrderListByStatusResponse.left));

        VariableUtilities.preferences.setString(
            LocalCacheKey.inProgressItemsList,
            jsonEncode(inProgressItemsListCopy));

        for (int i = 0; i < inProgressItemsListCopy.length; i++) {
          await isListContainResultListElement(
              element: inProgressItemsListCopy[i]);
          if (inProgressItemsListCopy.length - 1 == i) {
            updateDeliveryAddressLatLong(inProgressItemsListCopy);
          }
        }
      }
    } else {
      // Fluttertoast.showToast(msg: LocaleKeys.something_went_wrong.tr());
    }
  }

  Future updateDeliveryAddressLatLong(
      List<ResultList> inProgressItemsListCopy) async {
    for (int i = 0; i < modifiedInProgressItemsList.length; i++) {
      DeliveryAddressCoordinates coordinates =
          modifiedInProgressItemsList[i].deliveryAddressCoordinates;
      List<AddressList> addressList =
          modifiedInProgressItemsList[i].store.addressList;
      if ((coordinates.lat == 0 || coordinates.long == 0.0) ||
          (coordinates.lat == 0.0 || coordinates.long == 0.0)) {
        for (int j = 0; j < addressList.length; j++) {
          AddressList address = addressList[j];

          if (address.address ==
              modifiedInProgressItemsList[i].deliveryAddress) {
            modifiedInProgressItemsList[i].deliveryAddressCoordinates.lat =
                address.latitude;
            modifiedInProgressItemsList[i].deliveryAddressCoordinates.long =
                address.longitude;

            break;
          }
        }
      }
    }
    notifyListeners();
  }

  Future<bool> isListContainResultListElement(
      {required ResultList element}) async {
    bool isListContains = false;
    if (modifiedInProgressItemsList.isEmpty) {
      element.subResultList = [element];
      modifiedInProgressItemsList.add(element);
    } else {
      for (int i = 0; i < modifiedInProgressItemsList.length; i++) {
        if ((modifiedInProgressItemsList[i].storeName == element.storeName) &&
            (modifiedInProgressItemsList[i].deliveryAddress ==
                element.deliveryAddress)) {
          if (modifiedInProgressItemsList[i].subResultList.isEmpty) {
            modifiedInProgressItemsList[i].subResultList = [
              modifiedInProgressItemsList[i],
              element,
            ];
          } else {
            List<ResultList> list =
                modifiedInProgressItemsList[i].subResultList;
            list.add(element);
            modifiedInProgressItemsList[i].subResultList = List.from(list);
          }

          isListContains = true;
          break;
        }
      }

      if (!isListContains) {
        element.subResultList = [element];
        modifiedInProgressItemsList.add(element);

        notifyListeners();
      }
    }
    return isListContains;
  }

  void searchOrdersFunction({required String val}) {
    val = val.trim();

    if (val.isEmpty) {
      searchInProgressItemsList = [];
      return;
    }

    searchInProgressItemsList = [];

    List<String> keywords = val.toLowerCase().split(' ');

    // for (var item in modifiedInProgressItemsList) {
    //   if (keywords.any((keyword) =>
    //       item.deliveryAddress.toLowerCase().contains(keyword) ||
    //       item.id.toString().contains(keyword) ||
    //       item.storeName.toLowerCase().contains(keyword))) {
    //     searchInProgressItemsList.add(item);
    //   }
    // }
    for (var item in modifiedInProgressItemsList) {
      if (keywords.any((keyword) =>
          item.subResultList.any((e) => e.id.toString().contains(keyword)) ||
          item.subResultList
              .any((e) => e.deliveryAddress.toLowerCase().contains(keyword)) ||
          item.subResultList.any((e) => e.id.toString().contains(keyword)) ||
          item.subResultList
              .any((e) => e.storeName.toLowerCase().contains(keyword)))) {
        searchInProgressItemsList.add(item);
      }
    }
  }

  Future<void> updateSalesOrders(
      {required String salesOrderId,
      required bool isLastIndex,
      required int timestamp,
      required bool isCallFromOffline,
      required BuildContext context}) async {
    if (ConnectivityHandler.connectivityResult
        .contains(ConnectivityResult.none)) {
      final storedUpdateOnGoingOrdersRequests = VariableUtilities.preferences
              .getStringList(LocalCacheKey.storedUpdateOnGoingOrdersRequests) ??
          [];

      for (int i = 0; i < storedUpdateOnGoingOrdersRequests.length; i++) {
        Map<String, dynamic> requests =
            jsonDecode(storedUpdateOnGoingOrdersRequests[i]);
        if (requests['function_name'] == 'update_on_going_status') {
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
        'function_name': 'update_on_going_status',
        'sales_order_id': salesOrderId,
        'on_going_timestamp': DateTime.now().millisecondsSinceEpoch
      };
      storedUpdateOnGoingOrdersRequests.add(jsonEncode(offlineApi));
      if (isLastIndex) {
        Fluttertoast.showToast(msg: LocaleKeys.your_request_is_submitted.tr());
      }
      print(
          'Check storedUpdateOnGoingOrdersRequests --> $storedUpdateOnGoingOrdersRequests');

      await VariableUtilities.preferences.setStringList(
          LocalCacheKey.storedUpdateOnGoingOrdersRequests,
          storedUpdateOnGoingOrdersRequests);
      return;
    }
    onGoingStatusResponse = Right(NoDataFoundException());
    print("onGoingStatusResponse Before --> $onGoingStatusResponse");
    onGoingStatusResponse = await updateSalesOrderApi(context,
        isCallFromOffline: isCallFromOffline,
        timestamp: timestamp,
        deliveryStatus: 'ON_GOING',
        salesOrderId: salesOrderId,
        updateSalesOrderItemList: []);
    print("onGoingStatusResponse After --> $onGoingStatusResponse");

    if (onGoingStatusResponse.isLeft) {
      if (onGoingStatusResponse.left.status ||
          (onGoingStatusResponse.left.status == false &&
              onGoingStatusResponse.left.message ==
                  "No Fields to update. Data same as previous")) {
        if (isLastIndex) {
          Fluttertoast.showToast(msg: onGoingStatusResponse.left.message);
        }
        final storedUpdateOnGoingOrdersRequests = VariableUtilities.preferences
                .getStringList(
                    LocalCacheKey.storedUpdateOnGoingOrdersRequests) ??
            [];

        for (int i = 0; i < storedUpdateOnGoingOrdersRequests.length; i++) {
          Map<String, dynamic> requests =
              jsonDecode(storedUpdateOnGoingOrdersRequests[i]);
          if (requests['function_name'] == 'update_on_going_status') {
            if (requests['sales_order_id'] == salesOrderId) {
              storedUpdateOnGoingOrdersRequests.removeWhere((element) {
                Map<String, dynamic> requests =
                    jsonDecode(storedUpdateOnGoingOrdersRequests[i]);
                return requests['sales_order_id'] == salesOrderId;
              });
            }
          }
        }

        VariableUtilities.preferences.setStringList(
            LocalCacheKey.storedUpdateOnGoingOrdersRequests,
            storedUpdateOnGoingOrdersRequests);
      }
    }
  }
}
