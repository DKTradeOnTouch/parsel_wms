import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:parsel_flutter/src/mvp/dashboard/home/select_pending_orders/api/get_sku_group_by_user_id_api.dart';
import 'package:parsel_flutter/src/mvp/dashboard/home/select_pending_orders/api/loaded_truck_api.dart';
import 'package:parsel_flutter/src/mvp/dashboard/home/select_pending_orders/model/get_sku_group_by_user_id_model.dart';
import 'package:parsel_flutter/src/mvp/dashboard/home/select_pending_orders/model/loaded_truck_model.dart';
import 'package:parsel_flutter/utils/utils.dart';

class SelectPendingOrdersProvider extends ChangeNotifier {
  bool _isAllOrdersSelected = false;
  bool get isAllOrdersSelected => _isAllOrdersSelected;
  set isAllOrdersSelected(bool val) {
    _isAllOrdersSelected = val;
    notifyListeners();
  }

  List<SkuDetail> _pendingOrderList = [];
  List<SkuDetail> get pendingOrderList => _pendingOrderList;

  set pendingOrderList(List<SkuDetail> val) {
    _pendingOrderList = val;
    notifyListeners();
  }

  List<SkuDetail> _searchPendingOrderList = [];

  List<SkuDetail> get searchPendingOrderList => _searchPendingOrderList;

  set searchPendingOrderList(List<SkuDetail> val) {
    _searchPendingOrderList = val;
    notifyListeners();
  }

  List<SkuDetail> _selectedPendingOrderList = [];

  List<SkuDetail> get selectedPendingOrderList => _selectedPendingOrderList;

  set selectedPendingOrderList(List<SkuDetail> val) {
    _selectedPendingOrderList = val;
    notifyListeners();
  }

  void selectItem({required String skuName, bool? selectedValue}) async {
    for (int i = 0; i < pendingOrderList.length; i++) {
      if (pendingOrderList[i].skuName == skuName) {
        if (selectedValue != null) {
          pendingOrderList[i].isItemSelected = selectedValue;

          break;
        }
        if (pendingOrderList[i].isItemSelected) {
          pendingOrderList[i].isItemSelected = false;
        } else {
          pendingOrderList[i].isItemSelected = true;
        }
        break;
      }
    }
    bool selectedItem = await isAllItemSelected();
    if (selectedItem) {
      isAllOrdersSelected = true;
    } else {
      isAllOrdersSelected = false;
      notifyListeners();
      return;
    }
    notifyListeners();
  }

  void selectSearchItem(String skuName) async {
    for (int i = 0; i < searchPendingOrderList.length; i++) {
      if (searchPendingOrderList[i].skuName == skuName) {
        if (searchPendingOrderList[i].isItemSelected) {
          searchPendingOrderList[i].isItemSelected = false;
        } else {
          searchPendingOrderList[i].isItemSelected = true;
        }
        selectItem(
            skuName: skuName,
            selectedValue: searchPendingOrderList[i].isItemSelected);

        break;
      }
    }
    notifyListeners();
  }

  Future<bool> isAllItemSelected() async {
    List<SkuDetail> ordersList = [];
    for (int i = 0; i < pendingOrderList.length; i++) {
      if (pendingOrderList[i].isItemSelected == true) {
        ordersList.add(pendingOrderList[i]);
      }
    }
    selectedPendingOrderList = ordersList;
    for (int i = 0; i < pendingOrderList.length; i++) {
      if (pendingOrderList[i].isItemSelected == false) {
        return false;
      }
    }
    return true;
  }

  void selectAllItem() async {
    bool selectedItem = await isAllItemSelected();
    if (selectedItem) {
      for (int i = 0; i < pendingOrderList.length; i++) {
        pendingOrderList[i].isItemSelected = false;
      }
      isAllOrdersSelected = false;
    } else {
      for (int i = 0; i < pendingOrderList.length; i++) {
        pendingOrderList[i].isItemSelected = true;
      }
      isAllOrdersSelected = true;
    }

    List<SkuDetail> ordersList = [];
    for (int i = 0; i < pendingOrderList.length; i++) {
      if (pendingOrderList[i].isItemSelected == true) {
        ordersList.add(pendingOrderList[i]);
      }
    }
    selectedPendingOrderList = ordersList;
    notifyListeners();
  }

  void increaseItemQty(String skuName) {
    for (int i = 0; i < pendingOrderList.length; i++) {
      if (pendingOrderList[i].skuName == skuName) {
        pendingOrderList[i].qty++;
        notifyListeners();
        break;
      }
    }
  }

  void increaseSearchItemQty(String skuName) {
    for (int i = 0; i < searchPendingOrderList.length; i++) {
      if (searchPendingOrderList[i].skuName == skuName) {
        searchPendingOrderList[i].qty++;
        notifyListeners();
        break;
      }
    }
    increaseItemQty(skuName);
  }

  void decreaseItemQty(String skuName) {
    for (int i = 0; i < pendingOrderList.length; i++) {
      if (pendingOrderList[i].skuName == skuName) {
        if (pendingOrderList[i].qty > 0) {
          pendingOrderList[i].qty--;

          notifyListeners();
        }
        break;
      }
    }
  }

  void decreaseSearchItemQty(String skuName) {
    for (int i = 0; i < searchPendingOrderList.length; i++) {
      if (searchPendingOrderList[i].skuName == skuName) {
        if (searchPendingOrderList[i].qty > 0) {
          searchPendingOrderList[i].qty--;
          notifyListeners();
        }
        break;
      }
    }
    decreaseItemQty(skuName);
  }

  Either<GetSkuGroupByUserIdModel, Exception> _getSkuGroupByUserIdResponse =
      Right(NoDataFoundException());
  Either<GetSkuGroupByUserIdModel, Exception> get getSkuGroupByUserIdResponse =>
      _getSkuGroupByUserIdResponse;
  set getSkuGroupByUserIdResponse(
      Either<GetSkuGroupByUserIdModel, Exception> val) {
    _getSkuGroupByUserIdResponse = val;
    notifyListeners();
  }

  Either<LoadedTruckModel, Exception> _loadedTruckResponse =
      Right(NoDataFoundException());
  Either<LoadedTruckModel, Exception> get loadedTruckResponse =>
      _loadedTruckResponse;
  set loadedTruckResponse(Either<LoadedTruckModel, Exception> val) {
    _loadedTruckResponse = val;
    notifyListeners();
  }

  Future getSkuGroupByUserId(BuildContext context) async {
    if (ConnectivityHandler.connectivityResult
        .contains(ConnectivityResult.none)) {
      String getSkuGroupByUserIdResponseString = VariableUtilities.preferences
              .getString(LocalCacheKey.getSkuGroupByUserIdResponse) ??
          '';
      if (getSkuGroupByUserIdResponseString.isNotEmpty) {
        getSkuGroupByUserIdResponse = Left(GetSkuGroupByUserIdModel.fromJson(
            jsonDecode(getSkuGroupByUserIdResponseString)));
        pendingOrderList =
            getSkuGroupByUserIdResponse.left.body.data.skuDetails;
      }
      return;
    }
    getSkuGroupByUserIdResponse = Right(NoDataFoundException());
    Either<GetSkuGroupByUserIdModel, Exception> apiResponse =
        await getSkuGroupByUserIdApi(context);
    print("apiResponse --> $apiResponse");
    getSkuGroupByUserIdResponse = apiResponse;
    if (getSkuGroupByUserIdResponse.isLeft) {
      if (getSkuGroupByUserIdResponse.left.status) {
        pendingOrderList =
            getSkuGroupByUserIdResponse.left.body.data.skuDetails;
        VariableUtilities.preferences.setString(
            LocalCacheKey.getSkuGroupByUserIdResponse,
            jsonEncode(getSkuGroupByUserIdResponse.left));
        print(
            'VariableUtilities.preferences --> ${VariableUtilities.preferences.getString(LocalCacheKey.selectedWarehousesDetail)}');
      }
    } else {}
  }

  Future callLoadedTruckApi(BuildContext context) async {
    loadedTruckResponse = Right(NoDataFoundException());
    Either<LoadedTruckModel, Exception> apiResponse =
        await loadedTruckApi(context);
    print("apiResponse --> $apiResponse");
    loadedTruckResponse = apiResponse;
    if (loadedTruckResponse.isLeft) {
      if (loadedTruckResponse.left.status) {
        print("");
      }
    } else {}
  }
}
