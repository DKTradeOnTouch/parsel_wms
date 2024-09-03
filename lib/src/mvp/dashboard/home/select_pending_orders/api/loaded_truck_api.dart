import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:parsel_flutter/src/mvp/dashboard/home/select_pending_orders/model/loaded_truck_model.dart';
import 'package:parsel_flutter/utils/utils.dart';

Future<Either<LoadedTruckModel, Exception>> loadedTruckApi(
    BuildContext context) async {
  String userId =
      VariableUtilities.preferences.getString(LocalCacheKey.userId) ?? '';

  Either<dynamic, Exception> loadedTruckApi = await APIManager.callAPI(
    context,
    url: '${APIUtilities.truckLoad}$userId/',
    type: APIType.tGet,
  );

  if (loadedTruckApi.isLeft) {
    try {
      return Left(LoadedTruckModel.fromJson(loadedTruckApi.left));
    } catch (e) {
      return Right(DataToModelConversionException());
    }
  } else {
    return Right(loadedTruckApi.right);
  }
}
