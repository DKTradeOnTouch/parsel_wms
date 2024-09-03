import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:parsel_flutter/src/mvp/dashboard/home/pending_orders/model/warehouse_location_model.dart';
import 'package:parsel_flutter/utils/utils.dart';

Future<Either<WarehouseLocationModel, Exception>> fetchPendingOrdersLocationApi(
    BuildContext context) async {
  String userId =
      VariableUtilities.preferences.getString(LocalCacheKey.userId) ?? '';

  Either<dynamic, Exception> pendingOrdersLocationApi =
      await APIManager.callAPI(
    context,
    url: '${APIUtilities.getUserById}/$userId',
    type: APIType.tGet,
  );

  if (pendingOrdersLocationApi.isLeft) {
    try {
      return Left(
          WarehouseLocationModel.fromJson(pendingOrdersLocationApi.left));
    } catch (e) {
      return Right(DataToModelConversionException());
    }
  } else {
    return Right(pendingOrdersLocationApi.right);
  }
}
