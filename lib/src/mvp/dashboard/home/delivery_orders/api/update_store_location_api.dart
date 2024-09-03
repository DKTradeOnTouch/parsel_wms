import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:parsel_flutter/src/mvp/dashboard/home/delivery_orders/model/update_store_location_model.dart';

import 'package:parsel_flutter/utils/utils.dart';

Future<Either<UpdateStoreLocationModel, Exception>> updateStoreLocationApi(
    BuildContext context,
    {required int storeId,
    required String salesOrderId,
    required Position position}) async {
  String driverId =
      VariableUtilities.preferences.getString(LocalCacheKey.userId) ?? '';

  // ${widget._routeDataList.store?.id}/$driverId/${_currentPosition?.latitude}/${_currentPosition?.longitude}/${widget.Salesorderid}/
  Either<dynamic, Exception> updateStoreLocationApiResponse =
      await APIManager.callAPI(context,
          url:
              '${APIUtilities.updateAddress}$storeId/$driverId/${position.latitude}/${position.longitude}/$salesOrderId/',
          type: APIType.tPut);

  debugPrint(
      'updateStoreLocationApiResponse --> $updateStoreLocationApiResponse');

  if (updateStoreLocationApiResponse.isLeft) {
    try {
      return Left(UpdateStoreLocationModel.fromJson(
          updateStoreLocationApiResponse.left));
    } catch (e) {
      return Right(DataToModelConversionException());
    }
  } else {
    return Right(updateStoreLocationApiResponse.right);
  }
}
