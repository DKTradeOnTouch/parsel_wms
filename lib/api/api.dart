import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:parsel_flutter/api/endpoints.dart';
import 'package:parsel_flutter/models/ExecuteStorage_model.dart';
import 'package:parsel_flutter/models/GetGroupByUserID.dart';
import 'package:parsel_flutter/models/ReturnSOData_model.dart';
import 'package:parsel_flutter/models/SkuList_model.dart';
import 'package:parsel_flutter/models/Storage_model.dart';
import 'package:parsel_flutter/models/base_moel.dart';
import 'package:parsel_flutter/models/inward_perform_action_model.dart';
import 'package:parsel_flutter/models/locationDropdown_model.dart';
import 'package:parsel_flutter/models/login_model.dart';
import 'package:parsel_flutter/models/packing_list_model.dart';
import 'package:parsel_flutter/models/picking_list_data_model.dart';
import 'package:parsel_flutter/models/purchase_order_list_model.dart';
import 'package:parsel_flutter/models/sku_classification_model.dart' as sku;
import 'package:parsel_flutter/models/startTrip_modal.dart';
import 'package:parsel_flutter/models/storage_list_data_model.dart';
import 'package:parsel_flutter/models/update_distance_travel_model.dart';
import 'package:parsel_flutter/models/uploaddoc_model.dart';
import 'package:parsel_flutter/models/user_configuration_model.dart';
import 'package:parsel_flutter/resource/app_logs.dart';
import 'package:parsel_flutter/src/mvp/dashboard/home/select_pending_orders/model/parsel_base_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/AddPaymet_model.dart';
import '../models/BinMaster_modal.dart';
import '../models/COUNT_MODAL.dart';
import '../models/CreatePayment_model.dart';
import '../models/DeliverySummary_model.dart';
import '../models/GetuserbyID_model.dart';
import '../models/InvoiceList_model.dart';
import '../models/InvoideDeliverd_model.dart';
import '../models/InwardList_model.dart';
import '../models/LocationCreate_model.dart';
import '../models/PickingList.dart';
import '../models/SalesOrderBYID_Model.dart';
import '../models/UpdateSalesOrder_model.dart';
import '../models/performActionPICKPACK_modal.dart';
import '../models/pickupQ_Model.dart';
import '../models/routeCordinate.dart';
import '../models/routeOptimised_modal.dart';
import '../models/skuSubCategory.dart';
import '../models/uploadsalesorder_model.dart' as upldsale;

class API {
  static void showLog(String message) {
    appLogs(message.toString());
  }

  static String strNoInternet = 'No Internet Connection';

  static void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  static Future<String> getToken() async {
    String? token = '';
    final preference = await SharedPreferences.getInstance();
    bool isExists = preference.containsKey('token');
    if (isExists) {
      token = preference.getString('token');
      appLogs('token-->' + token.toString());
    }
    return token!;
  }

  static Future<String> getdomain() async {
    String? domain = '';
    String domainfinal = '';
    final preference = await SharedPreferences.getInstance();
    bool isExists = preference.containsKey('email');
    if (isExists) {
      domain = preference.getString('email');
      String str = domain.toString();
      const start = "@";
      const end = ".";
      final startIndex = str.indexOf(start);
      final endIndex = str.indexOf(end, startIndex + start.length);
      domainfinal = str.substring(startIndex + start.length, endIndex);
      appLogs('domain_final-->' + domainfinal.toString());
    }
    return domainfinal;
  }

  static Future<LogInModel?> forgotpassword(BuildContext context, String email,
      {bool showNoInternet = false}) async {
    const String TAG = 'forgotpassword';
    LogInModel? data;

    var url = Uri.parse(EndPoints.FORGOTPASSWORD);
    showLog('${TAG}_URL: ' + url.toString());
    var body = {
      "email": email,
    };
    String domain = await getdomain();

    Map<String, String> header = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'X-TenantID': domain
    };
    showLog('${TAG}_body: ' + body.toString());
    showLog('${TAG}_header: ' + header.toString());
    try {
      final response =
          await http.post(url, body: jsonEncode(body), headers: header);
      var decodedResult = jsonDecode(response.body);
      showLog('${TAG}_response: ' + decodedResult.toString());
      appLogs('response code-->' + response.statusCode.toString());
      data = LogInModel.fromJson(decodedResult);
      return data;
      // return data;
    } on SocketException {
      showLog('${TAG}_error: $strNoInternet');
      if (showNoInternet) {
        showSnackBar(context, strNoInternet);
      }
      return null;
    } catch (error) {
      showLog('${TAG}_error: $error');
      return null;
    }
  }

  //Login
  static Future<LogInModel?> login(BuildContext context, String email,
      String password, String phone, String tenentID,
      {bool showNoInternet = false}) async {
    const String TAG = 'newlogin';
    LogInModel? data;

    var url = Uri.parse(EndPoints.LOGIN);
    showLog('${TAG}_URL: ' + url.toString());

    var body = {
      "phoneNumber": phone,
      "email": email,
      "password": password,
    };

    // String domain = await getdomain();

    Map<String, String> header = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'X-TenantID': tenentID
    };

    showLog('${TAG}_body: ' + body.toString());
    showLog('${TAG}_header: ' + header.toString());
    try {
      final response =
          await http.post(url, body: jsonEncode(body), headers: header);
      var decodedResult = jsonDecode(response.body);
      showLog('${TAG}_response: ' + decodedResult.toString());
      appLogs('response code-->' + response.statusCode.toString());
      data = LogInModel.fromJson(decodedResult);
      return data;
      // return data;
    } catch (error) {
      showLog('${TAG}_error: $error');
      return null;
    }
  }

  static Future<GetuserbyID_model?> getUserById(BuildContext context,
      {bool showNoInternet = false,
      required String USERID,
      required String Authtoken}) async {
    const String TAG = 'get_user_by_id_order';
    GetuserbyID_model data;

    var url = Uri.parse("${EndPoints.GetUserById}$USERID");
    showLog('${TAG}_URL: ' + url.toString());
    String domain = await getdomain();

    try {
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $Authtoken',
        'X-TenantID': domain
      });
      var decodedResult = jsonDecode(response.body);
      showLog('${TAG}_response: ' + decodedResult.toString());

      data = GetuserbyID_model.fromJson(decodedResult);
      return data;
    } on SocketException {
      showLog('${TAG}_error: $strNoInternet');
      if (showNoInternet) {
        showSnackBar(context, strNoInternet);
      }
      return null;
    } catch (error) {
      showLog('${TAG}_error: $error');
      return null;
    }
  }

//GETUSERBYID
  static Future<LocationCreate_model?> LocationCreate(BuildContext context,
      {bool showNoInternet = false,
      required String USERID,
      required String SALESORDERID,
      required String LATITUDE,
      required String LONGITUDE,
      required String Authtoken}) async {
    const String TAG = 'LocationCreate-->';
    LocationCreate_model data;

    var url = Uri.parse(EndPoints.locationcreate);
    showLog('${TAG}_URL: ' + url.toString());
    Map<String, dynamic> map = {
      "salesOrderId": SALESORDERID,
      "deliveryDriverId": USERID,
      "latitude": LATITUDE,
      "longitude": LONGITUDE
    };
    String domain = await getdomain();

    try {
      final response = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $Authtoken',
            'X-TenantID': domain
          },
          body: jsonEncode(map));
      var decodedResult = jsonDecode(response.body);
      showLog('${TAG}_body: ' + map.toString());
      showLog('${TAG}_response: ' + decodedResult.toString());
      data = LocationCreate_model.fromJson(decodedResult);
      return data;
    } on SocketException {
      showLog('${TAG}_error: $strNoInternet');
      if (showNoInternet) {
        showSnackBar(context, strNoInternet);
      }
      return null;
    } catch (error) {
      showLog('${TAG}_error: $error');
      return null;
    }
  }

  static Future<RouteCoordinate?> routeCoordinate(BuildContext context,
      {bool showNoInternet = false,
      required String USERID,
      required String routeID,
      required String LATITUDE,
      required String LONGITUDE,
      required String Authtoken}) async {
    const String TAG = 'routeCoordinate-->';
    RouteCoordinate data;

    var url = Uri.parse(EndPoints.routeCordinate);
    showLog('${TAG}_URL: ' + url.toString());
    Map<String, dynamic> map = {
      "routeId": routeID,
      "deliveryDriverId": USERID,
      "latitude": LATITUDE,
      "longitude": LONGITUDE
    };
    String domain = await getdomain();
    try {
      final response = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $Authtoken',
            'X-TenantID': domain
          },
          body: jsonEncode(map));
      var decodedResult = jsonDecode(response.body);
      showLog('${TAG}_response: ' + decodedResult.toString());
      data = RouteCoordinate.fromJson(decodedResult);
      return data;
    } on SocketException {
      showLog('${TAG}_error: $strNoInternet');
      if (showNoInternet) {
        showSnackBar(context, strNoInternet);
      }
      return null;
    } catch (error) {
      showLog('${TAG}_error: $error');
      return null;
    }
  }

//CREATE PAYMENT
  static Future<CreatePayment_Model?> createPayment(
    BuildContext context, {
    bool showNoInternet = false,
    // required String id,
    required List<PaymentsList> payment,
    required String salesOrderId,
  }) async {
    const String TAG = 'createPayment';
    CreatePayment_Model data;
    var url =
        Uri.parse("${EndPoints.createPayment}$salesOrderId/createPayment/");
    showLog('${TAG}_URL: ' + url.toString());

    var bodyStr = jsonEncode(AddPaymet_model(paymentsList: payment));
    String domain = await getdomain();

    try {
      final response = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'X-TenantID': domain,
          },
          body: bodyStr);
      showLog('${TAG}_body: ' + bodyStr.toString());
      var decodedResult = jsonDecode(response.body);
      showLog('${TAG}_response: ' + decodedResult.toString());
      data = CreatePayment_Model.fromJson(decodedResult);
      return data;
    } on SocketException {
      showLog('${TAG}_error: $strNoInternet');
      if (showNoInternet) {
        showSnackBar(context, strNoInternet);
      }
      return null;
    } catch (error) {
      showLog('${TAG}_error: $error');
      return null;
    }
  }

//CREATE PAYMENT
  static Future<BaseModel?> createPaymentInProgress(
    BuildContext context, {
    bool showNoInternet = false,
    // required String id,
    required List<PaymentsList> payment,
    required String salesOrderId,
    String paymentMode = '',
  }) async {
    const String TAG = 'createPayment';
    BaseModel data;
    final preference = await SharedPreferences.getInstance();

    var url =
        Uri.parse("${EndPoints.createPayment}$salesOrderId/createPayment/");
    showLog('${TAG}_URL: ' + url.toString());
    showLog('${TAG}_AUTH: ' + preference.getString("token").toString());
    PaymentsList paymentsList = payment[0];
    var bodyStr = jsonEncode([
      {
        "payment_type":
            paymentMode.isEmpty ? paymentsList.paymentMode : paymentMode,
        "remark": paymentsList.paymentRemark,
        "value": paymentsList.value,
        "payment_date": paymentsList.paymentDate
      }
    ]);
    String domain = await getdomain();

    Map<String, String> header = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'X-TenantID': domain,
      'Authorization': 'Bearer ${preference.getString("token").toString()}',
    };

    try {
      final response = await http.post(url, headers: header, body: bodyStr);
      showLog('${TAG}_body: ' + bodyStr.toString());
      var decodedResult = jsonDecode(response.body);
      showLog('${TAG}_response: ' + decodedResult.toString());
      data = BaseModel.fromJson(decodedResult);
      return data;
    } on SocketException {
      showLog('${TAG}_error: $strNoInternet');
      if (showNoInternet) {
        showSnackBar(context, strNoInternet);
      }
      return null;
    } catch (error) {
      showLog('${TAG}_error: $error');
      return null;
    }
  }

// STORAGE LIST
  static Future<StorageModal?> getSTORAGEOrderList(
      BuildContext context, String status, String itemStatusList, String userId,
      {bool showNoInternet = false}) async {
    const String TAG = 'STORAGE LIST';
    StorageModal data;
    String apiUrl = EndPoints.INWARD_ORDER_LIST +
        '?status=' +
        status +
        '&itemStatusList=' +
        itemStatusList +
        '&userId=' +
        userId;

    var url = Uri.parse(apiUrl);
    String token = 'Bearer ' + await getToken();

    String domain = await getdomain();

    Map<String, String> header = {
      'Authorization': token,
      'Accept': 'application/json',
      'X-TenantID': domain
    };
    showLog('${TAG}_URL: ' + url.toString());

    try {
      final response = await http.get(url, headers: header);
      var decodedResult = jsonDecode(response.body);
      showLog('${TAG}_response: ' + decodedResult.toString());

      data = StorageModal.fromJson(decodedResult);
      return data;
    } on SocketException {
      showLog('${TAG}_error: $strNoInternet');
      if (showNoInternet) {
        showSnackBar(context, strNoInternet);
      }
      return null;
    } catch (error) {
      showLog('${TAG}_error: $error');
      return null;
    }
  }

  ///Fetch AI based Storage list

  static Future<StorageListData?> fetchStorageListData(
      BuildContext context, String status, String itemStatusList, String userId,
      {bool showNoInternet = false}) async {
    const String TAG = 'STORAGE LIST';
    StorageListData data;
    // String apiUrl = EndPoints.INWARD_ORDER_LIST +
    //     '?status=' +
    //     status +
    //     '&itemStatusList=' +
    //     itemStatusList +
    //     '&userId=' +
    //     userId;
    String apiUrl =
        'https://web.parsel.in/firebasecall/storage-list/?user_id=$userId';
    var url = Uri.parse(apiUrl);
    String token = 'Bearer ' + await getToken();

    String domain = await getdomain();

    Map<String, String> header = {
      'Authorization': token,
      'Accept': 'application/json',
      'X-TenantID': domain
    };
    showLog('${TAG}_URL: ' + url.toString());

    try {
      final response = await http.get(url, headers: header);
      var decodedResult = jsonDecode(response.body);
      showLog('${TAG}_response: ' + decodedResult.toString());
      if (response.statusCode == 200) {
        data = StorageListData.fromJson(decodedResult);
        if (data.status) {
          return data;
        } else {
          return null;
        }
      } else {
        return null;
      }
    } on SocketException {
      showLog('${TAG}_error: $strNoInternet');
      if (showNoInternet) {
        showSnackBar(context, strNoInternet);
      }
      return null;
    } catch (error) {
      showLog('${TAG}_error: $error');
      return null;
    }
  }

  static Future<PickingListDataModel?> fetchPickingListData(
      BuildContext context, String status, String itemStatusList, String userId,
      {bool showNoInternet = false}) async {
    const String TAG = 'STORAGE LIST';
    PickingListDataModel data;
    // String apiUrl = EndPoints.INWARD_ORDER_LIST +
    //     '?status=' +
    //     status +
    //     '&itemStatusList=' +
    //     itemStatusList +
    //     '&userId=' +
    //     userId;
    String apiUrl =
        'https://web.parsel.in/firebasecall/pick-list/?user_id=$userId';
    var url = Uri.parse(apiUrl);
    String token = 'Bearer ' + await getToken();

    String domain = await getdomain();

    Map<String, String> header = {
      'Authorization': token,
      'Accept': 'application/json',
      'X-TenantID': domain
    };
    showLog('${TAG}_URL: ' + url.toString());

    try {
      final response = await http.get(url, headers: header);
      var decodedResult = jsonDecode(response.body);
      showLog('${TAG}_response: ' + decodedResult.toString());
      if (response.statusCode == 200) {
        data = PickingListDataModel.fromJson(decodedResult);
        if (data.status) {
          return data;
        } else {
          return null;
        }
      } else {
        return null;
      }
    } on SocketException {
      showLog('${TAG}_error: $strNoInternet');
      if (showNoInternet) {
        showSnackBar(context, strNoInternet);
      }
      return null;
    } catch (error) {
      showLog('${TAG}_error: $error');
      return null;
    }
  }

  static Future<InwardListModal?> getInwardList(
      BuildContext context, String status, String itemStatusList, String userId,
      {bool showNoInternet = false}) async {
    const String TAG = 'Inward LIST';
    InwardListModal data;
    String apiUrl = EndPoints.INWARD_ORDER_LIST +
        '?status=' +
        status +
        '&itemStatusList=' +
        itemStatusList +
        '&userId=' +
        userId;
    var url = Uri.parse(apiUrl);
    String token = 'Bearer ' + await getToken();
    String domain = await getdomain();

    Map<String, String> header = {
      'Authorization': token,
      'Accept': 'application/json',
      'X-TenantID': domain
    };
    showLog('${TAG}_URL: ' + url.toString());

    try {
      final response = await http.get(url, headers: header);
      var decodedResult = jsonDecode(response.body);
      showLog('${TAG}_response: ' + decodedResult.toString());

      data = InwardListModal.fromJson(decodedResult);
      return data;
    } on SocketException {
      showLog('${TAG}_error: $strNoInternet');
      if (showNoInternet) {
        showSnackBar(context, strNoInternet);
      }
      return null;
    } catch (error) {
      showLog('${TAG}_error: $error');
      return null;
    }
  }

  //Purchase Order List
  static Future<PurchaseOrderModel?> getPurchaseOrderList(
      BuildContext context, String status, String itemStatusList, String userId,
      {bool showNoInternet = false}) async {
    const String TAG = 'purchase order';
    PurchaseOrderModel data;

    var url = Uri.parse(EndPoints.PURCHASE_ORDER);

    String domain = await getdomain();

    Map<String, String> header = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'X-TenantID': domain
    };
    showLog('${TAG}_URL: ' + url.toString());

    try {
      String apiUrl = EndPoints.INWARD_ORDER_LIST +
          '?status=' +
          status +
          '&itemStatusList=' +
          itemStatusList +
          '&userId=' +
          userId;
      var url = Uri.parse(apiUrl);
      final response = await http.get(url, headers: header);
      var decodedResult = jsonDecode(response.body);
      showLog('${TAG}_response: ' + decodedResult.toString());

      data = PurchaseOrderModel.fromJson(decodedResult);
      return data;
    } on SocketException {
      showLog('${TAG}_error: $strNoInternet');
      if (showNoInternet) {
        showSnackBar(context, strNoInternet);
      }
      return null;
    } catch (error) {
      showLog('${TAG}_error: $error');
      return null;
    }
  }

  //GET INWARD ORDER LIST
  static Future<PurchaseOrderModel?> getInwardOrderList(
      BuildContext context, String status, String itemStatusList, String userId,
      {bool showNoInternet = false}) async {
    const String TAG = 'inward order';
    PurchaseOrderModel data;
    String apiUrl = EndPoints.INWARD_ORDER_LIST +
        '?status=' +
        status +
        '&itemStatusList=' +
        itemStatusList +
        '&userId=' +
        userId;
    var url = Uri.parse(apiUrl);
    String token = 'Bearer ' + await getToken();
    String domain = await getdomain();

    Map<String, String> header = {
      'Authorization': token,
      'Accept': 'application/json',
      'X-TenantID': domain
    };
    showLog('${TAG}_URL: ' + url.toString());
    showLog('${TAG}_HEADER: ' + header.toString());

    try {
      final response = await http.get(url, headers: header);
      var decodedResult = jsonDecode(response.body);
      showLog('${TAG}_response: ' + decodedResult.toString());

      data = PurchaseOrderModel.fromJson(decodedResult);
      return data;
    } on SocketException {
      showLog('${TAG}_error: $strNoInternet');
      if (showNoInternet) {
        showSnackBar(context, strNoInternet);
      }
      return null;
    } catch (error) {
      showLog('${TAG}_error: $error');
      return null;
    }
  }

//ReturnSOData
  static Future<ReturnSODataModel?> returnSOData(
      BuildContext context, String salesOrderId,
      {bool showNoInternet = false}) async {
    const String TAG = 'inward order';
    ReturnSODataModel data;
    String apiUrl = EndPoints.returnSoData + '?salesOrderID=' + salesOrderId;
    var url = Uri.parse(apiUrl);

    String domain = await getdomain();

    Map<String, String> header = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'X-TenantID': domain
    };
    showLog('${TAG}_URL: ' + url.toString());
    showLog('${TAG}_HEADER: ' + header.toString());

    try {
      final response = await http.get(url, headers: header);
      var decodedResult = jsonDecode(response.body);
      showLog('${TAG}_response: ' + decodedResult.toString());

      data = ReturnSODataModel.fromJson(decodedResult);
      return data;
    } on SocketException {
      showLog('${TAG}_error: $strNoInternet');
      if (showNoInternet) {
        showSnackBar(context, strNoInternet);
      }
      return null;
    } catch (error) {
      showLog('${TAG}_error: $error');
      return null;
    }
  }

  //Location DropDown LIST
  static Future<LocationDropDownModel?> getLocationDropDownList(
      BuildContext context,
      {bool showNoInternet = false}) async {
    const String TAG = 'Location DropDown';
    LocationDropDownModel data;

    var url = Uri.parse(EndPoints.LocationDropDown);
    String domain = await getdomain();

    Map<String, String> header = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'X-TenantID': domain
    };
    showLog('${TAG}_URL: ' + url.toString());
    showLog('${TAG}_HEADER: ' + header.toString());

    try {
      final response = await http.get(url, headers: header);
      var decodedResult = jsonDecode(response.body);
      showLog('${TAG}_response: ' + decodedResult.toString());

      data = LocationDropDownModel.fromJson(decodedResult);
      return data;
    } on SocketException {
      showLog('${TAG}_error: $strNoInternet');
      if (showNoInternet) {
        showSnackBar(context, strNoInternet);
      }
      return null;
    } catch (error) {
      showLog('${TAG}_error: $error');
      return null;
    }
  }

  //SKU Classification List
  static Future<sku.SkuClassificationModel?> getSkuClassificationList(
    BuildContext context,
    String poId,
    String productCode,
    String category, {
    bool showNoInternet = false,
    //  List<SubList>? subList,
  }) async {
    const String TAG = 'sku classification';
    sku.SkuClassificationModel data;

    var url = Uri.parse(EndPoints.SKU_CLASSIFICATION);
    String domain = await getdomain();

    Map<String, String> header = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'X-TenantID': domain
    };
    showLog('${TAG}_URL: ' + url.toString());
    // var bodysub = jsonEncode(SkuSubCategory(subListList: subList));

    var body = {
      "poId": poId,
      "productClassification": [
        {
          "productCode": productCode,
          "category": category,
          // "classifications": bodysub
        }
      ]
    };
    String jsonStr = jsonEncode(body);
    // showLog('${TAG}_body: ' + body.toString());
    try {
      final response = await http.put(url, body: jsonStr, headers: header);
      var decodedResult = jsonDecode(response.body);
      showLog('${TAG}_response: ' + decodedResult.toString());

      data = sku.SkuClassificationModel.fromJson(decodedResult);
      return data;
    } on SocketException {
      showLog('${TAG}_error: $strNoInternet');
      if (showNoInternet) {
        showSnackBar(context, strNoInternet);
      }
      return null;
    } catch (error) {
      showLog('${TAG}_error: $error');
      return null;
    }
  }

  static Future<sku.SkuClassificationModel?> getSkuClassificationListFinished(
    BuildContext context,
    String poId,
    String productCode,
    String category, {
    bool showNoInternet = false,
    List<Classifications>? subList,
  }) async {
    const String TAG = 'sku_classification_Finished';
    sku.SkuClassificationModel data;

    var url = Uri.parse(EndPoints.SKU_CLASSIFICATION);
    String domain = await getdomain();

    Map<String, String> header = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'X-TenantID': domain
    };
    showLog('${TAG}_URL: ' + url.toString());
    // var bodysub = (SubListModel(poId: poId, productClassification: subList));
    // var bodysub = jsonEncode(ClassSUB(classifications: subList));

    var body = {
      "poId": poId,
      "productClassification": [
        {
          "productCode": productCode,
          "category": category,
          "classifications": subList
          // [
          //   {"catId": 73878, "qty": 8},
          //     {"catId": 73879, "qty": 7},
          //       {"catId": 77613, "qty": 9}
          // ]
        }
      ]
    };
    String jsonStr = jsonEncode(body);
    showLog('${TAG}_body: ' + body.toString());
    try {
      final response = await http.put(url, body: jsonStr, headers: header);
      var decodedResult = jsonDecode(response.body);
      showLog('${TAG}_response: ' + decodedResult.toString());

      data = sku.SkuClassificationModel.fromJson(decodedResult);
      return data;
    } on SocketException {
      showLog('${TAG}_error: $strNoInternet');
      if (showNoInternet) {
        showSnackBar(context, strNoInternet);
      }
      return null;
    } catch (error) {
      showLog('${TAG}_error: $error');
      return null;
    }
  }

  // PICKING LIST
  //Location DropDown LIST
  static Future<PickingListModal?> getPICKINGList(
    BuildContext context,
    String itemStatusList,
    String status,
    String userId, {
    bool showNoInternet = false,
    required String Authtoken,
  }) async {
    const String TAG = 'PICKINGList';
    PickingListModal data;
    var url = Uri.parse(
        "https://web.parsel.in/firebasecall/sales-order/getSalesOrderListByStatus/?driverId=$userId&date=${DateFormat('yyyy-MM-dd').format((DateTime.now()))}&status=$status&itemStatusList=$itemStatusList");
    // "https://web.parsel.in/firebasecall/sales-order/getSalesOrderListByStatus/?driverId=0140da7b-dfce-4e89-9626-d5024ac4101c&date=2024-01-15&status=ON_GOING");
    // "https://web.parsel.in/firebasecall/sales-order/getSalesOrderListByStatus/?driverId=$userId&status=$status&itemStatusList=$itemStatusList&date=${DateFormat('yyyy-MM-dd').format((DateTime.now()))}");

    String domain = await getdomain();

    Map<String, String> header = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $Authtoken',
      'X-TenantID': domain
    };

    showLog('${TAG}_URL: ' + url.toString());

    try {
      final response = await http.get(url, headers: header);
      var decodedResult = jsonDecode(response.body);
      showLog('${TAG}_response: ' + decodedResult.toString());
      data = PickingListModal.fromJson(decodedResult);
      return data;
    } on SocketException {
      showLog('${TAG}_error: $strNoInternet');
      if (showNoInternet) {
        showSnackBar(context, strNoInternet);
      }
      return null;
    } catch (error) {
      showLog('${TAG}_error: $error');
      return null;
    }
  }

  // PICKING LIST
  //Location DropDown LIST
  static Future<PackingListModel?> getPACKINGList(
    BuildContext context,
    String itemStatusList,
    String status,
    String userId, {
    bool showNoInternet = false,
    required String Authtoken,
  }) async {
    const String TAG = 'PACKINGList';
    PackingListModel data;
    var url = Uri.parse(
        "https://web.parsel.in/firebasecall/sales-order/getSalesOrderListByStatus/?driverId=$userId&date=${DateFormat('yyyy-MM-dd').format((DateTime.now()))}&status=$status&itemStatusList=$itemStatusList");
    // "https://web.parsel.in/firebasecall/sales-order/getSalesOrderListByStatus/?driverId=0140da7b-dfce-4e89-9626-d5024ac4101c&date=2024-01-15&status=ON_GOING");
    // "https://web.parsel.in/firebasecall/sales-order/getSalesOrderListByStatus/?driverId=$userId&status=$status&itemStatusList=$itemStatusList&date=${DateFormat('yyyy-MM-dd').format((DateTime.now()))}");

    String domain = await getdomain();

    Map<String, String> header = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $Authtoken',
      'X-TenantID': domain
    };

    showLog('${TAG}_URL: ' + url.toString());

    try {
      final response = await http.get(url, headers: header);
      var decodedResult = jsonDecode(response.body);
      showLog('${TAG}_response: ' + decodedResult.toString());
      data = PackingListModel.fromJson(decodedResult);
      return data;
    } on SocketException {
      showLog('${TAG}_error: $strNoInternet');
      if (showNoInternet) {
        showSnackBar(context, strNoInternet);
      }
      return null;
    } catch (error) {
      showLog('${TAG}_error: $error');
      return null;
    }
  }

  //PERFORM ACTION ON SALES ORDER(PICKING AND PACKING)
  static Future<PickPackPerformActionModal?> performActionOnPICKPACK(
    BuildContext context,
    String salesOrderId,
    String boxName,
    String status, {
    bool showNoInternet = false,
    required String Authtoken,
  }) async {
    const String TAG = 'PICKING_PACKING';
    PickPackPerformActionModal? data;
    var url = Uri.parse(
        "${EndPoints.performActionOnSalesOrder}?salesOrderId=$salesOrderId&status=$status&boxname=$boxName");
    showLog('${TAG}_URL: ' + url.toString());
    String domain = await getdomain();

    Map<String, String> header = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $Authtoken',
      'X-TenantID': domain
    };

    try {
      final response = await http.put(url, headers: header);
      var decodedResult = jsonDecode(response.body);
      showLog('${TAG}_url: ' + url.toString());
      showLog('${TAG}_response: ' + decodedResult.toString());
      data = PickPackPerformActionModal.fromJson(decodedResult);
      return data;
      // return data;
    } catch (error) {
      showLog('${TAG}_error: $error');
      return null;
    }
  }

  //PERFORM aCTION
  static Future<InwardPerformActionModel?> performAction(
      BuildContext context,
      String poId,
      String productCode,
      String status,
      String binid,
      String type,
      String batch,
      String date,
      {bool showNoInternet = false}) async {
    const String TAG = 'performAction';
    InwardPerformActionModel? data;

    var url = Uri.parse(EndPoints.PERFORM_ACTION);
    showLog('${TAG}_URL: ' + url.toString());
    String domain = await getdomain();

    Map<String, String> header = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'X-TenantID': domain
    };

    var body = {
      "action": status,
      "poId": poId,
      "itemDetails": [
        {
          "productCode": productCode,
          "binLocationId": binid,
          "skuType": type,
          "batch": batch,
          "aging": date
        }
      ]
    };

    String jsonStr = jsonEncode(body);
    showLog('${TAG}_body: ' + jsonStr.toString());
    try {
      final response = await http.put(url, body: jsonStr, headers: header);
      var decodedResult = jsonDecode(response.body);
      showLog('${TAG}_response: ' + decodedResult.toString());
      data = InwardPerformActionModel.fromJson(decodedResult);
      return data;
      // return data;
    } catch (error) {
      showLog('${TAG}_error: $error');
      return null;
    }
  }

// EXECUTE STORAGE
  static Future<ExecuteStorageModal?> executeStorage(
      BuildContext context, String poId, String productCode, String binId,
      {bool showNoInternet = false}) async {
    const String TAG = 'Execute_Storage';
    ExecuteStorageModal? data;

    var url = Uri.parse(EndPoints.executeStorage);
    showLog('${TAG}_URL: ' + url.toString());
    String domain = await getdomain();

    Map<String, String> header = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'X-TenantID': domain
    };

    var body = {
      "poId": poId,
      "itemDetails": [
        {"productCode": productCode, "newBinId": binId}
      ]
    };
    String jsonStr = jsonEncode(body);
    showLog('${TAG}_body: ' + jsonStr.toString());

    try {
      final response = await http.put(url, body: jsonStr, headers: header);
      var decodedResult = jsonDecode(response.body);
      showLog('${TAG}_response: ' + decodedResult.toString());
      data = ExecuteStorageModal.fromJson(decodedResult);
      return data;
      // return data;
    } catch (error) {
      showLog('${TAG}_error: $error');
      return null;
    }
  }

// EXECUTE STORAGE
  static Future<ParselBaseModel?> submitStorageData(
      BuildContext context, String poId, String userId,
      {bool showNoInternet = false}) async {
    const String TAG = 'Execute_Storage';
    ParselBaseModel data;

    var url = Uri.parse(
        'https://web.parsel.in/firebasecall/update_status/?user_id=$userId&po_id=$poId');
    showLog('${TAG}_URL: ' + url.toString());
    String domain = await getdomain();
    SharedPreferences sp = await SharedPreferences.getInstance();
    String authToken = sp.getString('token') ?? '';

    Map<String, String> header = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'X-TenantID': domain,
      'Authorization': 'Bearer $authToken',
    };

    var body = {'po_id': poId, 'user_id': userId};
    // String jsonStr = jsonEncode(body);
    showLog('${TAG}_body: $body');

    try {
      final response =
          await http.post(url, body: jsonEncode(body), headers: header);
      var decodedResult = jsonDecode(response.body);
      if (response.statusCode == 200) {
        showLog('${TAG}_response: ' + decodedResult.toString());
        data = ParselBaseModel.fromJson(decodedResult);

        return data;
      } else {
        return null;
      }
    } catch (error) {
      showLog('${TAG}_error: $error');
      return null;
    }
  }

// EXECUTE STORAGE
  static Future<String?> updateWorkerApi(
    BuildContext context, {
    bool showNoInternet = false,
    required String userId,
    required String type,
  }) async {
    const String TAG = 'updateWorkerApi';
    Map<String, dynamic> data;

    var url = Uri.parse('https://111.118.176.12/supervisor/staff_status_api');
    showLog('${TAG}_URL: ' + url.toString());
    String domain = await getdomain();
    SharedPreferences sp = await SharedPreferences.getInstance();
    String authToken = sp.getString('token') ?? '';

    Map<String, String> header = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'X-TenantID': domain,
      'Authorization': 'Bearer $authToken',
    };

    var body = {'user_id': userId, 'type': type, 'status': "completed"};
    // String jsonStr = jsonEncode(body);
    showLog('${TAG}_body: $body');

    try {
      final response =
          await http.post(url, body: jsonEncode(body), headers: header);
      var decodedResult = jsonDecode(response.body);
      if (response.statusCode == 200) {
        showLog('${TAG}_response: ' + decodedResult.toString());
        data = decodedResult;
        String successResponse = data['data'];
        return successResponse;
      } else {
        return null;
      }
    } catch (error) {
      showLog('${TAG}_error: $error');
      return null;
    }
  }

// EXECUTE STORAGE
  static Future<ParselBaseModel?> submitPickingListData(
      BuildContext context, String poId, String userId,
      {bool showNoInternet = false}) async {
    const String TAG = 'Execute_Storage';
    ParselBaseModel data;

    var url = Uri.parse(
        'https://web.parsel.in/firebasecall/update_status/?user_id=$userId&so_id=$poId');
    showLog('${TAG}_URL: ' + url.toString());
    String domain = await getdomain();
    SharedPreferences sp = await SharedPreferences.getInstance();
    String authToken = sp.getString('token') ?? '';

    Map<String, String> header = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'X-TenantID': domain,
      'Authorization': 'Bearer $authToken',
    };

    var body = {'so_id': poId, 'user_id': userId};
    // String jsonStr = jsonEncode(body);
    showLog('${TAG}_body: $body');

    try {
      final response =
          await http.post(url, body: jsonEncode(body), headers: header);
      var decodedResult = jsonDecode(response.body);
      showLog('${TAG}_response: ' + decodedResult.toString());
      if (response.statusCode == 200) {
        showLog('${TAG}_response: ' + decodedResult.toString());
        data = ParselBaseModel.fromJson(decodedResult);

        return data;
      } else {
        return null;
      }
    } catch (error) {
      showLog('${TAG}_error: $error');
      return null;
    }
  }

  static Future<bool> updateGroupIdDetails(BuildContext context,
      {bool showNoInternet = false,
      required String GROUPID,
      required String STATUS,
      required int noOfBoxes,
      required File Ifile,
      required double temperature,
      required String Authtoken}) async {
    const String TAG = 'updateGroupIdDetails';

    var url = Uri.parse("${EndPoints.updateGroupIdDetails}/$GROUPID/");
    String domain = await getdomain();
    Map<String, String> header1 = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $Authtoken',
      'X-TenantID': domain
    };
    showLog('${TAG}_URL: ' + url.toString());
    // showLog('${TAG}_domain: ' + domain.toString());
    try {
      final req = http.MultipartRequest(
        'PUT',
        url,
      );
      req.fields.addAll({'status': STATUS});
      req.headers.addAll(header1);
      // ..fields['groupIdDetails'] =
      //     jsonEncode({"status": STATUS, "noOfBoxes": 2, "temperature": 102})
      /*  req.files.add(new http.MultipartFile.fromBytes('images',
          await File(Ifile.path).readAsBytes(),filename: "images.jpg",
          contentType:  MediaType('image', 'jpeg')));*/
      /* req.files.add(new http.MultipartFile.fromBytes('files',
          await File(Ifile.path).readAsBytes(),
          contentType:  MediaType('image', 'jpeg')));*/

      var response = await req.send();
      appLogs("response.statusCode --> ${response.statusCode}");

      if (response.statusCode == 200) {
        appLogs("Uploaded!");

        String stream = await response.stream.bytesToString();
        appLogs("stream --> $stream");
        var decodedResult = jsonDecode(stream);
        print("decodedResult['status'] --> ${decodedResult['status']}");

        return decodedResult['status'];
      } else {
        return false;
      }
    } on SocketException {
      showLog('${TAG}_error: $strNoInternet');
      if (showNoInternet) {
        showSnackBar(context, strNoInternet);
      }
      return false;
    } catch (error) {
      showLog('${TAG}_error: $error');
      return false;
    }
  }

//Sales order
//Purchase Order List
  static Future<SkuListModel?> getSalesOrderListByStatus(BuildContext context,
      {bool showNoInternet = false,
      required String TODAYDATE,
      required String STATUS,
      required String DEIVERID,
      required String Authtoken}) async {
    const String TAG = 'getSalesOrderListByStatus';
    SkuListModel data;

    var url = Uri.parse(
        "${EndPoints.getSalesOrderListByStatus}?status=$STATUS&driverId=$DEIVERID&date=$TODAYDATE");
    String domain = await getdomain();

    Map<String, String> header = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $Authtoken',
      'X-TenantID': domain
    };

    showLog('${TAG}_URL: ' + url.toString());

    try {
      final response = await http.get(
        url,
        headers: header,
      );
      var decodedResult = jsonDecode(response.body);
      showLog('${TAG}_response: ' + decodedResult.toString());
      data = SkuListModel.fromJson(decodedResult);
      return data;
    } on SocketException {
      showLog('${TAG}_error: $strNoInternet');
      if (showNoInternet) {
        showSnackBar(context, strNoInternet);
      }
      return null;
    } catch (error) {
      showLog('${TAG}_error: $error');
      return null;
    }
  }

  // BIN MASTER API
  static Future<BinMasterModal?> getBinMAster(
    BuildContext context, {
    bool showNoInternet = false,
  }) async {
    const String TAG = 'BinMAster';
    BinMasterModal data;

    var url = Uri.parse(EndPoints.binMaster);
    String domain = await getdomain();

    Map<String, String> header = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'X-TenantID': domain
    };

    showLog(TAG + '_url:' + url.toString());
    try {
      final response = await http.get(
        url,
        headers: header,
      );
      var decodedResult = jsonDecode(response.body);
      showLog('${TAG}_response: ' + decodedResult.toString());
      data = BinMasterModal.fromJson(decodedResult);
      return data;
    } on SocketException {
      showLog('${TAG}_error: $strNoInternet');
      if (showNoInternet) {
        showSnackBar(context, strNoInternet);
      }
      return null;
    } catch (error) {
      showLog('${TAG}_error: $error');
      return null;
    }
  }

  //GET COUNT API
  static Future<CountApiModalNew?> getCountApiNew(BuildContext context,
      {bool showNoInternet = false,
      required String TODAYDATE,
      required String userId,
      required String Authtoken}) async {
    const String TAG = 'getCountApiNew';
    CountApiModalNew data;

    var url =
        Uri.parse("${EndPoints.countAPINEW}?userId=$userId&date=$TODAYDATE");

    String domain = await getdomain();

    Map<String, String> header = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $Authtoken',
      'X-TenantID': domain
    };
    showLog(TAG + '_url:' + url.toString());
    try {
      final response = await http.get(
        url,
        headers: header,
      );
      var decodedResult = jsonDecode(response.body);
      showLog('${TAG}_response: ' + decodedResult.toString());
      data = CountApiModalNew.fromJson(decodedResult);
      return data;
    } on SocketException {
      showLog('${TAG}_error: $strNoInternet');
      if (showNoInternet) {
        showSnackBar(context, strNoInternet);
      }
      return null;
    } catch (error) {
      showLog('${TAG}_error: $error');
      return null;
    }
  }

// GET ROUTE OPTIMIZED LIST
  static Future<RouteOptimizedModal?> getRouteOptimisedSalesOrder(
    BuildContext context, {
    bool showNoInternet = false,
    // required List<String> salesOrderID,
  }) async {
    const String TAG = 'getRouteOptimized';
    RouteOptimizedModal data;

    var url = Uri.parse(
        "${EndPoints.getRouteOptimisedSalesOrder}?salesOrderId=46648, 46649, 47250");

    String domain = await getdomain();

    Map<String, String> header = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'X-TenantID': domain
    };
    showLog(TAG + '_url:' + url.toString());
    try {
      final response = await http.get(
        url,
        headers: header,
      );
      var decodedResult = jsonDecode(response.body);
      showLog('${TAG}_response: ' + decodedResult.toString());
      data = RouteOptimizedModal.fromJson(decodedResult);
      return data;
    } on SocketException {
      showLog('${TAG}_error: $strNoInternet');
      if (showNoInternet) {
        showSnackBar(context, strNoInternet);
      }
      return null;
    } catch (error) {
      showLog('${TAG}_error: $error');
      return null;
    }
  }

//Get Invoice List by Status
  static Future<InvoiceListModel?> getSalesOrderListByStatusInvoiceList(
      BuildContext context,
      {bool showNoInternet = false,
      String? TODAYDATE,
      required String STATUS,
      required String DEIVERID,
      required String Authtoken}) async {
    const String TAG = 'getSalesOrderListByStatus_dashboard1';
    InvoiceListModel data;
// sales-order/getSalesOrderListByStatus?status=ON_GOING&userId=
    var url = Uri.parse(
        "${EndPoints.getSalesOrderListByStatus}?status=$STATUS&driverId=$DEIVERID&date=$TODAYDATE");

    showLog(TAG + '_url:' + url.toString());

    String domain = await getdomain();

    Map<String, String> header = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $Authtoken',
      'X-TenantID': domain
    };
    // try {
    final response = await http.get(
      url,
      headers: header,
    );
    var decodedResult = jsonDecode(response.body);
    showLog('${TAG}_apiPage_response: ' + decodedResult.toString());
    data = InvoiceListModel.fromJson(decodedResult);
    return data;
    // } on SocketException {
    //   showLog('${TAG}_error: $strNoInternet');
    //   if (showNoInternet) {
    //     showSnackBar(context, strNoInternet);
    //   }
    //   return null;
    // } catch (error) {
    //   showLog('${TAG}_error: $error');
    //   return null;
    // }
  }

  static Future<InvoiceListModel1?> getSalesOrderListByStatusInvoiceList1(
      BuildContext context,
      {bool showNoInternet = false,
      required String TODAYDATE,
      required String STATUS,
      required String DEIVERID,
      required String Authtoken}) async {
    const String TAG = 'getSalesOrderListByStatusINVOICELIST1';
    InvoiceListModel1 data;

    var url = Uri.parse(
        "${EndPoints.getSalesOrderListByStatus}?status=$STATUS&driverId=$DEIVERID&date=$TODAYDATE");

    String domain = await getdomain();

    Map<String, String> header = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $Authtoken',
      'X-TenantID': domain
    };
    showLog('${TAG}_URL: ' + url.toString());

    try {
      final response = await http.get(
        url,
        headers: header,
      );
      var decodedResult = jsonDecode(response.body);
      showLog('${TAG}_response: ' + decodedResult.toString());
      data = InvoiceListModel1.fromJson(decodedResult);
      return data;
    } on SocketException {
      showLog('${TAG}_error: $strNoInternet');
      if (showNoInternet) {
        showSnackBar(context, strNoInternet);
      }
      return null;
    } catch (error) {
      showLog('${TAG}_error: $error');
      return null;
    }
  }

//
  //Get SKU LIST BY STAT=
  static Future<SkuListModel?> getSalesOrderSKUList(BuildContext context,
      {bool showNoInternet = false,
      required String DEIVERID,
      required String Authtoken}) async {
    const String TAG = 'getSalesOrderSKUList';
    SkuListModel data;

    var url = Uri.parse("${EndPoints.getSalesOrderSKUList}/?userId=$DEIVERID");

    String domain = await getdomain();

    Map<String, String> header = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $Authtoken',
      'X-TenantID': domain
    };
    showLog('${TAG}_URL: ' + url.toString());

    try {
      final response = await http.get(
        url,
        headers: header,
      );
      var decodedResult = jsonDecode(response.body);
      showLog('${TAG}_response: ' + decodedResult.toString());
      data = SkuListModel.fromJson(decodedResult);
      return data;
    } on SocketException {
      showLog('${TAG}_error: $strNoInternet');
      if (showNoInternet) {
        showSnackBar(context, strNoInternet);
      }
      return null;
    } catch (error) {
      showLog('${TAG}_error: $error');
      return null;
    }
  }

  //GET GROUP BY USER ID
  static Future<GetGroupByUserIDModel?> getGroupByUserID(BuildContext context,
      {bool showNoInternet = false,
      required String DEIVERID,
      required String Authtoken}) async {
    const String TAG = 'getGroupByUserID';
    GetGroupByUserIDModel data;

    var url = Uri.parse(
        "${EndPoints.getGroupByUserId}/?userId=$DEIVERID&status=pending");

    String domain = await getdomain();

    Map<String, String> header = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $Authtoken',
      'X-TenantID': domain
    };

    showLog('${TAG}_URL: ' + url.toString());

    try {
      final response = await http.get(
        url,
        headers: header,
      );
      var decodedResult = jsonDecode(response.body);
      showLog('${TAG}_response: ' + decodedResult.toString());
      data = GetGroupByUserIDModel.fromJson(decodedResult);
      return data;
    } on SocketException {
      showLog('${TAG}_error: $strNoInternet');
      if (showNoInternet) {
        showSnackBar(context, strNoInternet);
      }
      return null;
    } catch (error) {
      showLog('${TAG}_error: $error');
      return null;
    }
  }

  //Get SKU LIST BY STAT=
  static Future<SkuListModel?> getSalesOrderListByStatusSKUList(
      BuildContext context,
      {bool showNoInternet = false,
      required String TODAYDATE,
      required String STATUS,
      required String DEIVERID,
      required String Authtoken}) async {
    const String TAG = 'getSalesOrderListByStatusSKULIST';
    SkuListModel data;

    var url = Uri.parse(
        "${EndPoints.getSalesOrderListByStatus}?status=$STATUS&driverId=$DEIVERID&date=$TODAYDATE");
    String domain = await getdomain();

    Map<String, String> header = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $Authtoken',
      'X-TenantID': domain
    };

    showLog('${TAG}_URL: ' + url.toString());

    try {
      final response = await http.get(
        url,
        headers: header,
      );
      var decodedResult = jsonDecode(response.body);
      showLog('${TAG}_response: ' + decodedResult.toString());
      data = SkuListModel.fromJson(decodedResult);
      return data;
    } on SocketException {
      showLog('${TAG}_error: $strNoInternet');
      if (showNoInternet) {
        showSnackBar(context, strNoInternet);
      }
      return null;
    } catch (error) {
      showLog('${TAG}_error: $error');
      return null;
    }
  }

//GetOrderedQuantityToDeliverDriver
  static Future<SkuListModel?> getOrderedQuantityToDeliveryDriver(
      BuildContext context,
      {bool showNoInternet = false,
      required String TODAYDATE,
      required String DRIVERID,
      required String Authtoken}) async {
    const String TAG = 'getOrderedQuantityToDeliveryDriver';
    SkuListModel data;

    var url = Uri.parse(
        "${EndPoints.getOrderedQuantityToDeliveryDriver}?creationTime=$TODAYDATE&deliveryDriverId=$DRIVERID");
    String domain = await getdomain();

    Map<String, String> header = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $Authtoken',
      'X-TenantID': domain
    };

    showLog('${TAG}_URL: ' + url.toString());

    try {
      final response = await http.get(
        url,
        headers: header,
      );
      var decodedResult = jsonDecode(response.body);
      showLog('${TAG}_response: ' + decodedResult.toString());

      data = SkuListModel.fromJson(decodedResult);
      return data;
    } on SocketException {
      showLog('${TAG}_error: $strNoInternet');
      if (showNoInternet) {
        showSnackBar(context, strNoInternet);
      }
      return null;
    } catch (error) {
      showLog('${TAG}_error: $error');
      return null;
    }
  }

  static Future<DeliverySummary_model?> getDispatchSummary(BuildContext context,
      {bool showNoInternet = false,
      required String salesOrderID,
      required String driverid,
      required String Authtoken}) async {
    const String TAG = 'dispatchsummary';
    DeliverySummary_model data;
    var url = Uri.parse(
        "${EndPoints.dispatchsummary}?driverid$driverid&orderId$salesOrderID");

    String domain = await getdomain();

    Map<String, String> header = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $Authtoken',
      'X-TenantID': domain
    };

    showLog('${TAG}_URL: ' + url.toString());

    try {
      final response = await http.get(
        url,
        headers: header,
      );
      var decodedResult = jsonDecode(response.body);
      showLog('${TAG}_response: ' + decodedResult.toString());

      data = DeliverySummary_model.fromJson(decodedResult);
      return data;
    } on SocketException {
      showLog('${TAG}_error: $strNoInternet');
      if (showNoInternet) {
        showSnackBar(context, strNoInternet);
      }
      return null;
    } catch (error) {
      showLog('${TAG}_error: $error');
      return null;
    }
  }

//134 update
//open
  static Future<pickupQ_Model?> pickedUpQuantity(BuildContext context,
      {bool showNoInternet = false,
      required Map<String, dynamic> body,
      required String Authtoken}) async {
    const String TAG = 'pickedUpQuantity';
    pickupQ_Model data;

    var url = Uri.parse(EndPoints.pickedUpQuantity);
    String domain = await getdomain();

    Map<String, String> header = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $Authtoken',
      'X-TenantID': domain
    };

    showLog('${TAG}_URL: ' + url.toString());

    try {
      final response =
          await http.put(url, headers: header, body: jsonEncode(body));
      var decodedResult = jsonDecode(response.body);
      showLog('${TAG}_response: ' + decodedResult.toString());

      data = pickupQ_Model.fromJson(decodedResult);
      return data;
    } on SocketException {
      showLog('${TAG}_error: $strNoInternet');
      if (showNoInternet) {
        showSnackBar(context, strNoInternet);
      }
      return null;
    } catch (error) {
      showLog('${TAG}_error: $error');
      return null;
    }
  }

  static Future<UploadDocModel?> uploadDocs(BuildContext context,
      {required String signatureName,
      required String salesOrderID,
      required String signatureFile,
      required String documentFile,
      required String photoFile,
      required String scanDocumentFile,
      bool showNoInternet = false}) async {
    const String TAG = 'UploadDocs';
    UploadDocModel data;
    String uploadDocUrl = "${EndPoints.uploadDocs}/";
    var url = Uri.parse(uploadDocUrl);
    String domain = await getdomain();

    final preference = await SharedPreferences.getInstance();

    Map<String, String> header1 = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'X-TenantID': domain,
      'Authorization': 'Bearer ${preference.getString("token").toString()}',
    };

    showLog('${TAG}_URL: ' + url.toString());

    try {
      final request = http.MultipartRequest('POST', Uri.parse(url.toString()));
      request.headers.addAll(header1);

      if (photoFile.isNotEmpty) {
        // appLogs('in photoFile');
        request.files
            .add(await http.MultipartFile.fromPath('images', photoFile));

        // req.files.add(new http.MultipartFile.fromBytes(
        //   'images', await File(photoFile.path).readAsBytes(),
        //   filename: "images.jpg", contentType: MediaType('image', 'jpeg')));
      }

      if (signatureFile.isNotEmpty) {
        // appLogs('in signature');
        request.files.add(await http.MultipartFile.fromPath(
            'signature_image', signatureFile));
        if (signatureName.isNotEmpty) {
          request.fields.addAll({'signature_name': signatureName});
        }

// req.files.add(new http.MultipartFile.fromBytes(
//           'signatureImage', await File(signatureFile.path).readAsBytes(),
//           filename: "SingatureImage.jpg",
//           contentType: MediaType('image', 'jpeg')));
      }
      if (documentFile.isNotEmpty) {
        appLogs('in doc');
        request.files
            .add(await http.MultipartFile.fromPath('pdf', documentFile));

// req.files.add(new http.MultipartFile.fromBytes(
//           'pdf', await File(documentFile.path).readAsBytes(),
//           filename: "pdf.pdf", contentType: MediaType('image', 'jpeg')));
      }

      if (scanDocumentFile.isNotEmpty) {
        appLogs('in scandoc');
        request.files
            .add(await http.MultipartFile.fromPath('images', scanDocumentFile));

        //  req.files.add(new http.MultipartFile.fromBytes(
        //         'images', await File(scanDocumentFile.path).readAsBytes(),
        //         filename: "images1.jpg", contentType: MediaType('image', 'jpeg')));
      }
      request.fields.addAll({'sales_order_id': salesOrderID});
      print("request.fields --> ${request.fields}");
      print("request.files --> ${request.files}");

      http.Response response = await http.Response.fromStream(
        await request.send(),
      );
      var decodedResult = jsonDecode(response.body);
      showLog('${TAG}_response: ' + decodedResult.toString());
      data = UploadDocModel.fromJson(decodedResult);
      return data;
    } on SocketException {
      showLog('${TAG}_error: Image Size is Bigger than Empty');
      if (showNoInternet) {
        showSnackBar(context, strNoInternet);
      }
      return null;
    } catch (error) {
      showLog('${TAG}_error: $error');
      return null;
    }
  }

  //UPLOAD DOCS
//   static Future<UploadDocs?> uploadDocs(
//     BuildContext context, {
//     bool showNoInternet = false,
//     required String signatureName,
//     required String salesOrderID,
//     required String signatureFile,
//     required String documentFile,
//     required String photoFile,
//     required String scanDocumentFile,
//   }) async {
//     const String TAG = 'uploadDocs';
//     UploadDocs data;
//     //http://backend.parsel.in:9091/sales-order/uploadDocs?salesOrderId=50715
//     String uploadDocUrl =
//         EndPoints.uploadDocs + '?salesOrderId=' + salesOrderID;
//     var url = Uri.parse(uploadDocUrl);

//     appLogs('api url-->' + url.toString());
//     try {
//       final req = http.MultipartRequest(
//         'POST',
//         url,
//       );

//       appLogs('reqq-->' + req.method);

//       if (photoFile != null && photoFile.isNotEmpty) {
//         appLogs('in photoFile');
//         req.files.add(await http.MultipartFile.fromPath('images', photoFile));

//         // req.files.add(new http.MultipartFile.fromBytes(
//         //   'images', await File(photoFile.path).readAsBytes(),
//         //   filename: "images.jpg", contentType: MediaType('image', 'jpeg')));
//       }

//       if (signatureFile != null && signatureFile.isNotEmpty) {
//         appLogs('in signature');
//         req.files.add(
//             await http.MultipartFile.fromPath('signatureImage', signatureFile));

// // req.files.add(new http.MultipartFile.fromBytes(
// //           'signatureImage', await File(signatureFile.path).readAsBytes(),
// //           filename: "SingatureImage.jpg",
// //           contentType: MediaType('image', 'jpeg')));
//       }
//       if (documentFile != null && documentFile.isNotEmpty) {
//         appLogs('in doc');
//         req.files.add(await http.MultipartFile.fromPath('pdf', documentFile));

// // req.files.add(new http.MultipartFile.fromBytes(
// //           'pdf', await File(documentFile.path).readAsBytes(),
// //           filename: "pdf.pdf", contentType: MediaType('image', 'jpeg')));

//       }

//       if (scanDocumentFile != null && scanDocumentFile.isNotEmpty) {
//         appLogs('in scandoc');
//         req.files
//             .add(await http.MultipartFile.fromPath('images', scanDocumentFile));

//         //  req.files.add(new http.MultipartFile.fromBytes(
//         //         'images', await File(scanDocumentFile.path).readAsBytes(),
//         //         filename: "images1.jpg", contentType: MediaType('image', 'jpeg')));

//       }

//       http.Response response = await http.Response.fromStream(
//         await request.send(),
//       );
//       var decodedResult = jsonDecode(response.body);
//       showLog('${TAG}_response: ' + decodedResult.toString());

//       http.StreamedResponse response = await req.send();
//       showLog('${TAG}_REQ: ' + req.files.toString());
//       showLog('${TAG}_URL: ' + url.toString());

//       var decodedResult = jsonDecode(response.stream.toString());
//       showLog('${TAG}_response: ' + decodedResult.toString());
//       data = UploadDocs.fromJson(decodedResult);
//       return data;
//     } on SocketException {
//       showLog('${TAG}_error: $strNoInternet');
//       if (showNoInternet) {
//         showSnackBar(context, strNoInternet);
//       }
//       return null;
//     } catch (error) {
//       showLog('${TAG}_error: $error');
//       return null;
//     }
//   }

  static Future<SkuListModel?> confirmGroupOrder(BuildContext context,
      {bool showNoInternet = false,
      required String ID,
      required String Authtoken}) async {
    const String TAG = 'confirmGroupOrder';
    SkuListModel data;

    var url = Uri.parse("${EndPoints.confirmGroupOrder}/$ID");
    String domain = await getdomain();

    Map<String, String> header = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $Authtoken',
      'X-TenantID': domain
    };

    showLog('${TAG}_URL: ' + url.toString());

    try {
      final response = await http.put(
        url,
        headers: header,
      );
      var decodedResult = jsonDecode(response.body);
      showLog('${TAG}_response: ' + decodedResult.toString());

      data = SkuListModel.fromJson(decodedResult);
      return data;
    } on SocketException {
      showLog('${TAG}_error: $strNoInternet');
      if (showNoInternet) {
        showSnackBar(context, strNoInternet);
      }
      return null;
    } catch (error) {
      showLog('${TAG}_error: $error');
      return null;
    }
  }

//opening Balance
  static Future<SkuListModel?> saveOpeningBalanceOrder(BuildContext context,
      {bool showNoInternet = false,
      required Map<String, dynamic> body,
      required String Authtoken}) async {
    const String TAG = 'saveOpeningBalanceOrder';
    SkuListModel data;

    var url = Uri.parse(EndPoints.saveOpeningBalanceOrder);
    String domain = await getdomain();

    Map<String, String> header = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $Authtoken',
      'X-TenantID': domain
    };

    showLog('${TAG}_URL: ' + url.toString());

    try {
      final response =
          await http.post(url, headers: header, body: jsonEncode(body));
      var decodedResult = jsonDecode(response.body);
      showLog('${TAG}_response: ' + decodedResult.toString());

      data = SkuListModel.fromJson(decodedResult);
      return data;
    } on SocketException {
      showLog('${TAG}_error: $strNoInternet');
      if (showNoInternet) {
        showSnackBar(context, strNoInternet);
      }
      return null;
    } catch (error) {
      showLog('${TAG}_error: $error');
      return null;
    }
  }

  //134 get
  static Future<DeliverySummary_model?> getDeliverySummary(BuildContext context,
      {bool showNoInternet = false,
      required String salesOrderID,
      required String creationTime,
      required String Authtoken}) async {
    const String TAG = 'getDeliverySummary';
    DeliverySummary_model data;
    var url = Uri.parse(EndPoints.getDeliverySummary);

    String domain = await getdomain();

    Map<String, String> header = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $Authtoken',
      'X-TenantID': domain
    };

    showLog('${TAG}_URL: ' + url.toString());

    try {
      final response = await http.get(
        url,
        headers: header,
      );
      var decodedResult = jsonDecode(response.body);
      showLog('${TAG}_response: ' + decodedResult.toString());

      data = DeliverySummary_model.fromJson(decodedResult);
      return data;
    } on SocketException {
      showLog('${TAG}_error: $strNoInternet');
      if (showNoInternet) {
        showSnackBar(context, strNoInternet);
      }
      return null;
    } catch (error) {
      showLog('${TAG}_error: $error');
      return null;
    }
  }

//134 update
  static Future<DeliverySummary_model?> updateDeliverySummaryStatus(
      BuildContext context,
      {bool showNoInternet = false,
      required Map<String, dynamic> body,
      required String Authtoken}) async {
    const String TAG = 'updateDeliverySummaryStatus';
    DeliverySummary_model data;

    var url = Uri.parse(EndPoints.updateDeliverySummaryStatus);
    String domain = await getdomain();

    Map<String, String> header = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $Authtoken',
      'X-TenantID': domain
    };

    showLog('${TAG}_URL: ' + url.toString());

    try {
      final response =
          await http.put(url, headers: header, body: jsonEncode(body));
      var decodedResult = jsonDecode(response.body);
      showLog('${TAG}_response: ' + decodedResult.toString());

      data = DeliverySummary_model.fromJson(decodedResult);
      return data;
    } on SocketException {
      showLog('${TAG}_error: $strNoInternet');
      if (showNoInternet) {
        showSnackBar(context, strNoInternet);
      }
      return null;
    } catch (error) {
      showLog('${TAG}_error: $error');
      return null;
    }
  }

  static Future<http.Response?> Payment(BuildContext context,
      {bool showNoInternet = false,
      required int ID,
      required String Authtoken,
      required List<PaymentsList> payment}) async {
    const String TAG = 'Payment';
    http.Response data;

    var url = Uri.parse("${EndPoints.payments}/$ID/payments");

    String domain = await getdomain();

    Map<String, String> header = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'X-TenantID': domain
    };

    showLog('${TAG}_URL: ' + url.toString());

    var bodyStr = jsonEncode(AddPaymet_model(paymentsList: payment));

    try {
      final response = await http.put(url, headers: header, body: bodyStr);
      showLog('${TAG}_body: ' + bodyStr.toString());
      var decodedResult = jsonDecode(response.body);
      showLog('${TAG}_response: ' + decodedResult.toString());

      data = decodedResult;
      return data;
    } on SocketException {
      showLog('${TAG}_error: $strNoInternet');
      if (showNoInternet) {
        showSnackBar(context, strNoInternet);
      }
      return null;
    } catch (error) {
      showLog('${TAG}_error: $error');
      return null;
    }
  }

  static Future<SalesOrderBYID_Model?> GetSalesorderbyID(BuildContext context,
      {bool showNoInternet = false,
      required String ID,
      required String Authtoken}) async {
    const String TAG = 'GetSalesorderbyID';
    SalesOrderBYID_Model data;

    var url = Uri.parse("${EndPoints.GetSalesorderbyID}?id=$ID");
    String domain = await getdomain();

    Map<String, String> header = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $Authtoken',
      'X-TenantID': domain
    };

    showLog('${TAG}_URL: ' + url.toString());

    try {
      final response = await http.get(
        url,
        headers: header,
      );
      var decodedResult = jsonDecode(response.body);
      showLog('${TAG}_response: ' + decodedResult.toString());

      data = SalesOrderBYID_Model.fromJson(decodedResult);
      return data;
    } on SocketException {
      showLog('${TAG}_error: $strNoInternet');
      if (showNoInternet) {
        showSnackBar(context, strNoInternet);
      }
      return null;
    } catch (error) {
      showLog('${TAG}_error: $error');
      return null;
    }
  }

  static Future<StartTripModal?> startTrip(
    BuildContext context, {
    bool showNoInternet = false,
    required String ID,
    required String executionStatus,
  }) async {
    const String TAG = 'StartTrip';
    StartTripModal data;

    var url = Uri.parse("${EndPoints.startTrip}/$ID");

    String domain = await getdomain();

    Map<String, String> header = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'X-TenantID': domain
    };

    showLog('${TAG}_URL: ' + url.toString());
    try {
      final response = await http.put(url,
          headers: header,
          body: jsonEncode({
            "execution_status": executionStatus,
          }));

      var decodedResult = jsonDecode(response.body);

      showLog('${TAG}_response: ' + decodedResult.toString());

      data = StartTripModal.fromJson(decodedResult);
      return data;
    } on SocketException {
      showLog('${TAG}_error: $strNoInternet');
      if (showNoInternet) {
        showSnackBar(context, strNoInternet);
      }
      return null;
    } catch (error) {
      showLog('${TAG}_error: $error');
      return null;
    }
  }

  static Future<UpdateSalesOrder_model?> updateSalesorderbyID(
      BuildContext context,
      {bool showNoInternet = false,
      required String ID,
      required String executionStatus,
      required double temperature,
      required String Authtoken}) async {
    const String TAG = 'updateSalesorderbyID_';
    UpdateSalesOrder_model data;

    var url = Uri.parse("${EndPoints.updateSalesorderbyID}/$ID/");
    String domain = await getdomain();

    Map<String, String> header = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $Authtoken',
      'X-TenantID': domain
    };

    showLog('${TAG}_URL: ' + url.toString());
    Map<String, dynamic> body = {};

    if (executionStatus == '') {
      body = {"temperature": temperature};
    } else {
      body = {"execution_status": executionStatus, "temperature": temperature};
    }

    showLog('${TAG}_URL: ' + url.toString());
    showLog('${TAG}_body: ' + body.toString());
    try {
      final response =
          await http.put(url, headers: header, body: jsonEncode(body));
      var decodedResult = jsonDecode(response.body);
      log("decodedResult --> $decodedResult");
      showLog('${TAG}_response: ' + decodedResult.toString());

      data = UpdateSalesOrder_model.fromJson(decodedResult);
      return data;
    } on SocketException {
      showLog('${TAG}_error: $strNoInternet');
      if (showNoInternet) {
        showSnackBar(context, strNoInternet);
      }
      return null;
    } catch (error) {
      showLog('${TAG}_error: $error');
      return null;
    }
  }

  static Future<BaseModel?> updateSalesorderbyIDInProgress(BuildContext context,
      {bool showNoInternet = false,
      required String ID,
      required String executionStatus,
      required double temperature,
      required String Authtoken}) async {
    const String TAG = 'updateSalesorderbyID_';
    BaseModel data;

    var url = Uri.parse("${EndPoints.updateSalesorderbyID}/$ID/");
    String domain = await getdomain();

    Map<String, String> header = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $Authtoken',
      'X-TenantID': domain
    };

    showLog('${TAG}_URL: ' + url.toString());
    Map<String, dynamic> body = {};

    if (executionStatus == '') {
      body = {"temperature": temperature};
    } else {
      body = {"execution_status": executionStatus, "temperature": temperature};
    }

    showLog('${TAG}_URL: ' + url.toString());
    showLog('${TAG}_body: ' + body.toString());
    try {
      final response =
          await http.put(url, headers: header, body: jsonEncode(body));
      var decodedResult = jsonDecode(response.body);
      log("decodedResult --> $decodedResult");
      showLog('${TAG}_response: ' + decodedResult.toString());

      data = BaseModel.fromJson(decodedResult);
      return data;
    } on SocketException {
      showLog('${TAG}_error: $strNoInternet');
      if (showNoInternet) {
        showSnackBar(context, strNoInternet);
      }
      return null;
    } catch (error) {
      showLog('${TAG}_error: $error');
      return null;
    }
  }

  static Future<UpdateSalesOrder_model?> updateSalesorderbyID1(
    BuildContext context, {
    bool showNoInternet = false,
    List<upldsale.ItemList>? itemList,
    String? ID = '',
    required String executionStatus,
  }) async {
    const String TAG = 'updateSalesorderbyID';
    UpdateSalesOrder_model body;
    var url = Uri.parse("${EndPoints.updateSalesorderbyID}/$ID");
    String domain = await getdomain();

    Map<String, String> header = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'X-TenantID': domain
    };

    log('${TAG}_URL: ' + url.toString());

    var body1 = jsonEncode({
      "itemList": itemList,
      "execution_status": executionStatus,
    });

    log('${TAG}_body: ' + body1.toString());

    try {
      final response = await http.put(url, headers: header, body: body1);
      var decodedResult = jsonDecode(response.body);
      log('${TAG}_response: ' + decodedResult.toString());

      body = UpdateSalesOrder_model.fromJson(decodedResult);
      return body;
    } on SocketException {
      showLog('${TAG}_error: $strNoInternet');
      if (showNoInternet) {
        showSnackBar(context, strNoInternet);
      }
      return null;
    } catch (error) {
      showLog('${TAG}_error: $error');
      return null;
    }
  }

  static Future<BaseModel?> updateSalesorderbyID1InProgress(
    BuildContext context, {
    bool showNoInternet = false,
    List<upldsale.ItemList>? itemList,
    String? ID = '',
    required String executionStatus,
  }) async {
    const String TAG = 'updateSalesorderbyID';
    BaseModel data;
    var url = Uri.parse("${EndPoints.updateSalesorderbyID}/$ID/");
    String domain = await getdomain();
    final preference = await SharedPreferences.getInstance();

    Map<String, String> header = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'X-TenantID': domain,
      'Authorization': 'Bearer ${preference.getString("token").toString()}',
    };

    log('${TAG}_URL: ' + url.toString());
    var body1 = '';
    if (itemList != null) {
      List<Map<String, dynamic>> list = [];
      for (int i = 0; i < itemList.length; i++) {
        Map<String, dynamic> map = {};
        map['delivered'] = itemList[i].delivered;
        map['product_code'] = itemList[i].productCode;
        map['return_reason'] = itemList[i].returnReason;
        map['returned'] = itemList[i].returned;
        map['qty'] = itemList[i].qty;
        list.add(map);
      }
      body1 = jsonEncode({
        "item_list": list,
        "execution_status": executionStatus,
      });
    } else {
      body1 = jsonEncode({
        "execution_status": executionStatus,
      });
    }

    log('${TAG}_body: ' + body1.toString());

    try {
      final response = await http.put(url, headers: header, body: body1);
      var decodedResult = jsonDecode(response.body);
      log('${TAG}_response: ' + decodedResult.toString());

      data = BaseModel.fromJson(decodedResult);
      return data;
    } on SocketException {
      showLog('${TAG}_error: $strNoInternet');
      if (showNoInternet) {
        showSnackBar(context, strNoInternet);
      }
      return null;
    } catch (error) {
      showLog('${TAG}_error: $error');
      return null;
    }
  }

  static Future<UserConfigurationModel?> fetchUserConfiguration(
      BuildContext context) async {
    const String TAG = 'fetchUserConfiguration';
    UserConfigurationModel userConfigurationModel;
    var url = Uri.parse(EndPoints.clientConfiguration);
    String domain = await getdomain();
    final preference = await SharedPreferences.getInstance();

    Map<String, String> header = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'X-TenantID': domain,
      'Authorization': 'Bearer ${preference.getString("token").toString()}',
    };

    log('${TAG}_URL: ' + url.toString());

    try {
      final response = await http.get(url, headers: header);
      var decodedResult = jsonDecode(response.body);
      log('${TAG}_response: ' + decodedResult.toString());

      userConfigurationModel = UserConfigurationModel.fromJson(decodedResult);
      return userConfigurationModel;
    } on SocketException {
      showLog('${TAG}_error: $strNoInternet');
      return null;
    } catch (error) {
      showLog('${TAG}_error: $error');
      return null;
    }
  }

  static Future updateDistanceTravel(BuildContext context) async {
    const String TAG = 'updateDistanceTravel';
    UpdateDistanceTravelModel body;
    //164.52.221.54:8000
    //web.parsel.in
    SharedPreferences sp = await SharedPreferences.getInstance();

    String userId = sp.getString('userID').toString();

    var url = Uri.parse(
        "https://web.parsel.in/firebasecall/updatedisttravel/$userId/");
    String domain = await getdomain();

    Map<String, String> header = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'X-TenantID': domain
    };

    log('${TAG}_URL: ' + url.toString());

    try {
      final response = await http.get(url, headers: header);
      var decodedResult = jsonDecode(response.body);
      log('${TAG}_response: ' + decodedResult.toString());

      body = UpdateDistanceTravelModel.fromJson(decodedResult);
      return body;
    } on SocketException {
      showLog('${TAG}_error: $strNoInternet');
      return null;
    } catch (error) {
      showLog('${TAG}_error: $error');
      return null;
    }
  }
}
