import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:parsel_flutter/src/mvp/dashboard/home/pending_orders/api/pending_orders_location_api.dart';
import 'package:parsel_flutter/src/mvp/dashboard/home/pending_orders/model/warehouse_location_model.dart';
import 'package:parsel_flutter/utils/utils.dart';

class PendingOrdersProvider extends ChangeNotifier {
  String _selectedLocation = '';
  String get selectedLocation => _selectedLocation;
  set selectedLocation(String val) {
    _selectedLocation = val;
    notifyListeners();
  }

  List<SelectedWarehousesDetail> _searchSelectedWarehousesDetailList = [];
  List<SelectedWarehousesDetail> get searchSelectedWarehousesDetailList =>
      _searchSelectedWarehousesDetailList;
  set searchSelectedWarehousesDetailList(List<SelectedWarehousesDetail> val) {
    _searchSelectedWarehousesDetailList = val;
    notifyListeners();
  }

  List<SelectedWarehousesDetail> _selectedWarehousesDetailList = [];
  List<SelectedWarehousesDetail> get selectedWarehousesDetailList =>
      _selectedWarehousesDetailList;
  set selectedWarehousesDetailList(List<SelectedWarehousesDetail> val) {
    _selectedWarehousesDetailList = val;
    notifyListeners();
  }

  Either<WarehouseLocationModel, Exception> _pendingOrdersLocationResponse =
      Right(FetchingDataException());
  Either<WarehouseLocationModel, Exception> get pendingOrdersLocationResponse =>
      _pendingOrdersLocationResponse;
  set pendingOrdersLocationResponse(
      Either<WarehouseLocationModel, Exception> val) {
    _pendingOrdersLocationResponse = val;
    notifyListeners();
  }

  fetchPendingOrdersLocation(BuildContext context) async {
    if (ConnectivityHandler.connectivityResult
        .contains(ConnectivityResult.none)) {
      String selectedWarehousesDetailString = VariableUtilities.preferences
              .getString(LocalCacheKey.selectedWarehousesDetail) ??
          '';
      if (selectedWarehousesDetailString.isNotEmpty) {
        selectedWarehousesDetailList = List<SelectedWarehousesDetail>.from(
            jsonDecode(selectedWarehousesDetailString)
                .map((json) => SelectedWarehousesDetail.fromJson(json)));
      }
      return;
    }
    pendingOrdersLocationResponse = Right(NoDataFoundException());
    Either<WarehouseLocationModel, Exception> apiResponse =
        await fetchPendingOrdersLocationApi(context);
    pendingOrdersLocationResponse = apiResponse;
    if (pendingOrdersLocationResponse.isLeft) {
      selectedWarehousesDetailList = pendingOrdersLocationResponse
          .left.body.userDetails.selectedWarehousesDetail;
      VariableUtilities.preferences.setString(
          LocalCacheKey.selectedWarehousesDetail,
          jsonEncode(selectedWarehousesDetailList));
    } else {
      if (pendingOrdersLocationResponse.right is FetchingDataException) {
        pendingOrdersLocationResponse = Right(BadRequestException());
      }
    }
  }
}
