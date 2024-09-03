import 'dart:developer';

import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:parsel_flutter/src/mvp/dashboard/home/in_progress/model/get_sales_order_list_by_status_model.dart';
import 'package:parsel_flutter/utils/utils.dart';

Future<Either<GetSalesOrderListByStatusModel, Exception>> fetchDeliveredSkuApi(
    BuildContext context) async {
  String userId =
      VariableUtilities.preferences.getString(LocalCacheKey.userId) ?? '';

  Either<dynamic, Exception> getSalesOrderListByStatusApi =
      await APIManager.callAPI(
    context,

    url:
        '${APIUtilities.getSalesOrderListByStatus}/?status=DELIVERED&driverId=$userId&date=${DateFormat('yyyy-MM-dd').format((DateTime.now()))}',
    //"http://139.5.189.63:8000/sales-order/getSalesOrderListByStatus/?status=IN_GROUP&date=2023-12-18&pageNo=1&pageSize=10",
    type: APIType.tGet,
  );
  print('pendingOrdersLocationApi-> $getSalesOrderListByStatusApi');

  // try {
  if (getSalesOrderListByStatusApi.isLeft) {
    return Left(GetSalesOrderListByStatusModel.fromJson(
        getSalesOrderListByStatusApi.left));
  } else {
    return Right(getSalesOrderListByStatusApi.right);
  }
  // } catch (e) {
  //   return Right(DataToModelConversionException());
  // }
}
