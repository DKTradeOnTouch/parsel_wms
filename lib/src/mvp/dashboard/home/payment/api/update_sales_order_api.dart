import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:parsel_flutter/src/mvp/dashboard/home/payment/model/update_sales_order_item_list.dart';
import 'package:parsel_flutter/src/mvp/dashboard/home/select_pending_orders/model/parsel_base_model.dart';
import 'package:parsel_flutter/utils/utils.dart';

Future<Either<ParselBaseModel, Exception>> updateSalesOrderApi(
  BuildContext context, {
  required String salesOrderId,
  required List<UpdateSalesOrderItemResponse> updateSalesOrderItemList,
  required String deliveryStatus,
  required int timestamp,
  required bool isCallFromOffline,
}) async {
  List<Map<String, dynamic>> list = [];
  for (int i = 0; i < updateSalesOrderItemList.length; i++) {
    Map<String, dynamic> map = {};
    map['delivered'] = updateSalesOrderItemList[i].delivered;
    map['product_code'] = updateSalesOrderItemList[i].productCode;
    map['return_reason'] = updateSalesOrderItemList[i].returnReason;
    map['returned'] = updateSalesOrderItemList[i].returned;
    map['qty'] = updateSalesOrderItemList[i].qty;
    list.add(map);
  }
  Map<String, dynamic> body = {};
  String driverId = (VariableUtilities.preferences.getString('userID') ?? '');

  if (isCallFromOffline) {
    body = {
      "assignment_timestamp": DateFormat('dd-MM-yyyy HH:mm:ss.SSS')
          .format(DateTime.fromMillisecondsSinceEpoch(timestamp)),

      // DateTime.fromMillisecondsSinceEpoch(timestamp).toIso8601String(),
      "assignment_execution_status": deliveryStatus
    };
  } else {
    body = {
      "execution_status": deliveryStatus,
    };
  }
  if (list.isNotEmpty) {
    body.addAll({
      "item_list": list,
    });
  }
  log('Update Sales Order Body --> $body');
  Either<dynamic, Exception> updateSalesOrderApi = await APIManager.callAPI(
    context,
    url: '${APIUtilities.updateSalesOrder}/$salesOrderId/',
    type: APIType.tPut,
    body: body,
  );

  if (updateSalesOrderApi.isLeft) {
    try {
      return Left(ParselBaseModel.fromJson(updateSalesOrderApi.left));
    } catch (e) {
      print(e);
      return Right(DataToModelConversionException());
    }
  } else {
    return Right(updateSalesOrderApi.right);
  }
}
