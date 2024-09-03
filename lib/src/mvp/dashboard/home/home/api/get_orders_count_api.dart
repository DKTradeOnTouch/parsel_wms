import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:parsel_flutter/src/mvp/dashboard/home/home/model/get_orders_count_model.dart';
import 'package:parsel_flutter/utils/utils.dart';

Future<Either<GetOrdersCountModel, Exception>> getOrdersCountApi(
    BuildContext context) async {
  String userId =
      VariableUtilities.preferences.getString(LocalCacheKey.userId) ?? '';
  Map<String, dynamic> parameters = {
    'userId': userId,
    'date': DateFormat('yyyy-MM-dd').format(DateTime.now()),
  };

  Either<dynamic, Exception> getOrdersCountResponse = await APIManager.callAPI(
      context,
      url: APIUtilities.getOrdersCount,
      type: APIType.tGet,
      parameters: parameters);

  if (getOrdersCountResponse.isLeft) {
    try {
      return Left(GetOrdersCountModel.fromJson(getOrdersCountResponse.left));
    } catch (e) {
      return Right(DataToModelConversionException());
    }
  } else {
    return Right(getOrdersCountResponse.right);
  }
}
