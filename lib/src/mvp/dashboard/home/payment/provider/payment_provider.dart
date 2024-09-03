import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:parsel_flutter/src/mvp/dashboard/home/in_progress/model/get_sales_order_list_by_status_model.dart';
import 'package:parsel_flutter/src/mvp/dashboard/home/order_review/provider/order_review_provider.dart';
import 'package:parsel_flutter/src/mvp/dashboard/home/payment/api/payment_api.dart';
import 'package:parsel_flutter/src/mvp/dashboard/home/payment/api/update_sales_order_api.dart';
import 'package:parsel_flutter/src/mvp/dashboard/home/payment/model/create_payment_mode_model.dart';
import 'package:parsel_flutter/src/mvp/dashboard/home/payment/model/payment_model.dart';
import 'package:parsel_flutter/src/mvp/dashboard/home/proof_of_delivery/provider/proof_of_delivery_provider.dart';
import 'package:parsel_flutter/src/mvp/dashboard/home/select_pending_orders/model/parsel_base_model.dart';
import 'package:parsel_flutter/utils/utils.dart';
import 'package:provider/provider.dart';

class PaymentProvider extends ChangeNotifier {
  int _swipeListLength = 0;
  int get swipeListLength => _swipeListLength;
  set swipeListLength(int val) {
    _swipeListLength = val;
    notifyListeners();
  }

  int _currentPage = 0;
  int get currentPage => _currentPage;
  set currentPage(int val) {
    _currentPage = val;
    notifyListeners();
  }

  List<PaymentModel> paymentModelList = [
    PaymentModel(
      paymentType: PaymentType.cod,
      imageUrl: AssetUtils.codIconImage,
      title: LocaleKeys.cod.tr(),
    ),
    PaymentModel(
      paymentType: PaymentType.credit,
      imageUrl: AssetUtils.creditIconImage,
      title: LocaleKeys.credit.tr(),
    ),
    PaymentModel(
      paymentType: PaymentType.cheque,
      imageUrl: AssetUtils.chequeIconImage,
      title: LocaleKeys.cheque.tr(),
    ),
    PaymentModel(
      paymentType: PaymentType.online,
      imageUrl: AssetUtils.onlineIconImage,
      title: LocaleKeys.online.tr(),
    ),
  ];

  PaymentModel _currentPaymentMode = PaymentModel(
    paymentType: PaymentType.cod,
    imageUrl: AssetUtils.codIconImage,
    title: LocaleKeys.cod.tr(),
  );
  PaymentModel get currentPaymentMode => _currentPaymentMode;
  set currentPaymentMode(PaymentModel mode) {
    _currentPaymentMode = mode;
    notifyListeners();
  }

  // List<PaymentModel> _currentPaymentModeList = [
  //   PaymentModel(
  //     paymentType: PaymentType.cod,
  //     imageUrl: AssetUtils.codIconImage,
  //     title: LocaleKeys.cod.tr(),
  //   )
  // ];
  // List<PaymentModel> get currentPaymentModeList => _currentPaymentModeList;
  // set currentPaymentModeList(List<PaymentModel> mode) {
  //   _currentPaymentModeList = mode;
  //   notifyListeners();
  // }

  PaymentModel initCurrentPaymentModeList() {
    return PaymentModel(
      paymentType: PaymentType.cod,
      imageUrl: AssetUtils.codIconImage,
      title: LocaleKeys.cod.tr(),
    );
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

  Either<ParselBaseModel, Exception> _createdPaymentResponse =
      Right(StaticException());
  Either<ParselBaseModel, Exception> get createdPaymentResponse =>
      _createdPaymentResponse;
  set createdPaymentResponse(Either<ParselBaseModel, Exception> val) {
    _createdPaymentResponse = val;
    notifyListeners();
  }

  Future<bool> updateSalesOrder(BuildContext context,
      {required String salesOrderId,
      required String id,
      required List<CreatePaymentsList> payments,
      required bool isLastIndex,
      required String deliveryStatus,
      bool isCallWithUpDoc = false,
      required int arrivedTimestamp,
      required int deliveredTimestamp,
      required bool isCallFromOffline}) async {
    print("arrivedTimestamp --> $arrivedTimestamp");
    print("deliveredTimestamp --> $deliveredTimestamp");

    ProofOfDeliveryProvider proofOfDeliveryProvider =
        Provider.of(context, listen: false);
    print(
        'deliveryStatus --> $deliveryStatus  ${ConnectivityHandler.connectivityResult}');

    if (ConnectivityHandler.connectivityResult
        .contains(ConnectivityResult.none)) {
      final storedPaymentRequests = VariableUtilities.preferences
              .getStringList(LocalCacheKey.storedPaymentRequests) ??
          [];
      for (int i = 0; i < storedPaymentRequests.length; i++) {
        Map<String, dynamic> requests = jsonDecode(storedPaymentRequests[i]);
        if (requests['function_name'] == 'create_payment') {
          if (requests['sales_order_id'] == salesOrderId) {
            if (isLastIndex) {
              Fluttertoast.showToast(
                  msg: LocaleKeys.your_request_is_already_submitted.tr());
            }
            await removeItemBySalesOrderId(salesOrderId: salesOrderId);
            return true;
          }
        }
      }
      Map<String, dynamic> offlineApi = {
        'function_name': 'create_payment',
        'sales_order_id': salesOrderId,
        'id': id,
        'payments': payments,
        'arrived_time': DateTime.now().millisecondsSinceEpoch,
        'delivered_time': DateTime.now().millisecondsSinceEpoch
      };
      storedPaymentRequests.add(jsonEncode(offlineApi));
      if (isLastIndex) {
        Fluttertoast.showToast(msg: LocaleKeys.your_request_is_submitted.tr());
      }
      print("Check storedPaymentRequests --> $storedPaymentRequests");
      await VariableUtilities.preferences.setStringList(
          LocalCacheKey.storedPaymentRequests, storedPaymentRequests);
      await removeItemBySalesOrderId(salesOrderId: salesOrderId);

      return true;
    }
    getSalesOrderListByStatusResponse = Right(NoDataFoundException());
    OrderReviewProvider deliveryOrdersDetailsProvider =
        Provider.of(context, listen: false);
    if (isCallWithUpDoc) {
      proofOfDeliveryProvider.isVisible = true;
    }
    getSalesOrderListByStatusResponse = await updateSalesOrderApi(context,
        timestamp: deliveryStatus == 'DELIVERED'
            ? deliveredTimestamp
            : arrivedTimestamp,
        deliveryStatus: 'DELIVERED',
        isCallFromOffline: isCallFromOffline,
        salesOrderId: salesOrderId,
        updateSalesOrderItemList:
            deliveryOrdersDetailsProvider.salesOrderItemList);
    print(
        'getSalesOrderListByStatusResponse $getSalesOrderListByStatusResponse');
    if (getSalesOrderListByStatusResponse.isLeft) {
      if (getSalesOrderListByStatusResponse.left.status ||
          (getSalesOrderListByStatusResponse.left.status == false &&
              getSalesOrderListByStatusResponse.left.message ==
                  "No Fields to update. Data same as previous")) {
        // if (deliveryStatus == 'DELIVERED') {
        if (isLastIndex) {
          Fluttertoast.showToast(
              msg: LocaleKeys.orders_delivered_successfully.tr());
        }
        final storedPaymentRequests = VariableUtilities.preferences
                .getStringList(LocalCacheKey.storedPaymentRequests) ??
            [];

        for (int i = 0; i < storedPaymentRequests.length; i++) {
          Map<String, dynamic> requests = jsonDecode(storedPaymentRequests[i]);
          if (requests['function_name'] == 'create_payment') {
            print(
                "requests['sales_order_id'] --> ${requests['sales_order_id']}  salesOrderId --> $salesOrderId");
            if (requests['sales_order_id'] == salesOrderId) {
              storedPaymentRequests.removeWhere((element) {
                Map<String, dynamic> requests =
                    jsonDecode(storedPaymentRequests[i]);
                return requests['sales_order_id'] == salesOrderId;
              });
            }
          }
        }
        print("storedPaymentRequests sss--> $storedPaymentRequests");
        VariableUtilities.preferences.setStringList(
            LocalCacheKey.storedPaymentRequests, storedPaymentRequests);

        if (isCallWithUpDoc) {
          proofOfDeliveryProvider.isVisible = false;
        }
        // return true;
        // }
        if (isLastIndex) {
          Fluttertoast.showToast(
              msg: LocaleKeys.order_records_updated_successfully.tr());
        }
        bool isCreatedSuccessfully = await createPaymentForCustomer(context,
            arrivedTimestamp: arrivedTimestamp,
            deliveredTimestamp: deliveredTimestamp,
            isLastIndex: isLastIndex,
            id: id,
            salesOrderId: salesOrderId,
            payments: payments,
            isCallWithUpDoc: isCallWithUpDoc);

        if (isCallWithUpDoc) {
          proofOfDeliveryProvider.isVisible = false;
        }
        return isCreatedSuccessfully;
      } else {
        if (isLastIndex) {
          Fluttertoast.showToast(msg: LocaleKeys.something_went_wrong.tr());
        }
        return false;
      }
    } else {
      if (isCallWithUpDoc) {
        proofOfDeliveryProvider.isVisible = false;
      }
      return false;
    }
  }

  Future<void> removeItemBySalesOrderId({required String salesOrderId}) async {
    String inProgressItemsListString = VariableUtilities.preferences
            .getString(LocalCacheKey.inProgressItemsList) ??
        '';
    if (inProgressItemsListString.isNotEmpty) {
      List<ResultList> inProgressItemsList = List<ResultList>.from(
          jsonDecode(inProgressItemsListString)
              .map((json) => ResultList.fromJson(json)));
      inProgressItemsList
          .removeWhere((element) => element.salesOrderId == salesOrderId);
      VariableUtilities.preferences.setString(
          LocalCacheKey.inProgressItemsList, jsonEncode(inProgressItemsList));
    }
  }

  Future<bool> createPaymentForCustomer(BuildContext context,
      {required String salesOrderId,
      required String id,
      required List<CreatePaymentsList> payments,
      required int deliveredTimestamp,
      required int arrivedTimestamp,
      required bool isLastIndex,
      bool isCallWithUpDoc = false}) async {
    ProofOfDeliveryProvider proofOfDeliveryProvider =
        Provider.of(context, listen: false);
    if (isCallWithUpDoc) {
      proofOfDeliveryProvider.isVisible = true;
    }
    createdPaymentResponse = Right(NoDataFoundException());

    createdPaymentResponse = createdPaymentResponse =
        await createPaymentForCustomerApi(context,
            id: id, salesOrderId: salesOrderId, payments: payments);
    if (createdPaymentResponse.isLeft) {
      if (createdPaymentResponse.left.status == false &&
          createdPaymentResponse.left.message ==
              "Sales Order Payments exists") {
        // bool isProductUpdated = await updateSalesOrder(context,
        //     arrivedTimestamp: arrivedTimestamp,
        //     deliveredTimestamp: deliveredTimestamp,
        //     id: id,
        //     isLastIndex: isLastIndex,
        //     isCallWithUpDoc: isCallWithUpDoc,
        //     salesOrderId: salesOrderId,
        //     deliveryStatus: 'DELIVERED',
        //     payments: payments);

        if (isCallWithUpDoc) {
          proofOfDeliveryProvider.isVisible = false;
        }
        return true;
      }
      if (createdPaymentResponse.left.status) {
        // bool isProductUpdated = await updateSalesOrder(context,
        //     isLastIndex: isLastIndex,
        //     arrivedTimestamp: arrivedTimestamp,
        //     deliveredTimestamp: deliveredTimestamp,
        //     isCallWithUpDoc: isCallWithUpDoc,
        //     id: id,
        //     salesOrderId: salesOrderId,
        //     deliveryStatus: 'DELIVERED',
        //     payments: payments);

        if (isCallWithUpDoc) {
          proofOfDeliveryProvider.isVisible = false;
        }
        return true;
      } else {
        if (isLastIndex) {
          Fluttertoast.showToast(msg: LocaleKeys.something_went_wrong.tr());
        }
      }
    }
    if (isCallWithUpDoc) {
      proofOfDeliveryProvider.isVisible = false;
    }
    return false;
  }
}
