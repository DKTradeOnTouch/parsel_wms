import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:parsel_flutter/src/mvp/dashboard/home/delivery_orders/model/update_distance_travel_model.dart';
import 'package:parsel_flutter/utils/utils.dart';

Future<Either<UpdateDistanceTravelModel, Exception>> updateDistanceTravelApi(
    BuildContext context) async {
  String driverId =
      VariableUtilities.preferences.getString(LocalCacheKey.userId) ?? '';

  Either<dynamic, Exception> updateDistanceTravelRes = await APIManager.callAPI(
      context,
      url: '${APIUtilities.updateDistanceTravel}$driverId/',
      type: APIType.tGet);

  if (updateDistanceTravelRes.isLeft) {
    print("updateDistanceTravelRes --> ${updateDistanceTravelRes.left}");
    try {
      return Left(
          UpdateDistanceTravelModel.fromJson(updateDistanceTravelRes.left));
    } catch (e) {
      return Right(DataToModelConversionException());
    }
  } else {
    return Right(updateDistanceTravelRes.right);
  }
}
