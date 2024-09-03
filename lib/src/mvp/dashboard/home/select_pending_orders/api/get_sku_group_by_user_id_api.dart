import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:parsel_flutter/src/mvp/dashboard/home/select_pending_orders/model/get_sku_group_by_user_id_model.dart';
import 'package:parsel_flutter/utils/utils.dart';

Future<Either<GetSkuGroupByUserIdModel, Exception>> getSkuGroupByUserIdApi(
    BuildContext context) async {
  String userId =
      VariableUtilities.preferences.getString(LocalCacheKey.userId) ?? '';

  Either<dynamic, Exception> getSkuGroupByUserIdApi = await APIManager.callAPI(
    context,
    url: APIUtilities.getGroupByUserId,
    parameters: {'userId': userId},
    type: APIType.tGet,
  );

  if (getSkuGroupByUserIdApi.isLeft) {
    try {
      return Left(
          GetSkuGroupByUserIdModel.fromJson(getSkuGroupByUserIdApi.left));
    } catch (e) {
      return Right(DataToModelConversionException());
    }
  } else {
    return Right(getSkuGroupByUserIdApi.right);
  }
}
