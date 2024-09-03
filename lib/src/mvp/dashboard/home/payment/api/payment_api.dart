import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:parsel_flutter/src/mvp/dashboard/home/payment/model/create_payment_mode_model.dart';
import 'package:parsel_flutter/src/mvp/dashboard/home/select_pending_orders/model/parsel_base_model.dart';
import 'package:parsel_flutter/utils/utils.dart';

Future<Either<ParselBaseModel, Exception>> createPaymentForCustomerApi(
    BuildContext context,
    {required String salesOrderId,
    required String id,
    required List<CreatePaymentsList> payments}) async {
  print("createPaymentForCustomerApi $salesOrderId");
  // CreatePaymentsList createPayments = payments[0];

  if (payments.isEmpty) {
    payments = [
      CreatePaymentsList(
        paymentMode: 'cod',
        value: 0,
        paymentDate:
            DateFormat('yyyy-MM-dd').format((DateTime.now())).toString(),
        paymentRemark: 'COD Payment',
        paymentTypes: "CASH_ON_DELIVERY",
        chequePaymentTypes: "NONE",
      )
    ];
  }
  Either<dynamic, Exception> createPaymentForCustomerApi =
      await APIManager.callAPI(
    context,
    url: '${APIUtilities.salesOrder}$id/createPayment/',
    type: APIType.tPost,
    body: [
      for (int i = 0; i < payments.length; i++)
        {
          "payment_type": payments[i].paymentMode,
          "remark": payments[i].paymentRemark,
          "value": payments[i].value,
          "payment_date": payments[i].paymentDate
        }
    ],
  );
  print('createPaymentForCustomerApi --> $createPaymentForCustomerApi');
  if (createPaymentForCustomerApi.isLeft) {
    // try {
    print(
        'createPaymentForCustomerApi --> ${createPaymentForCustomerApi.left}');

    return Left(ParselBaseModel.fromJson(createPaymentForCustomerApi.left));
    // } catch (e) {
    //   return Right(DataToModelConversionException());
    // }
  } else {
    print('createPaymentForCustomerApi ${createPaymentForCustomerApi.right}');
    return Right(createPaymentForCustomerApi.right);
  }
}
