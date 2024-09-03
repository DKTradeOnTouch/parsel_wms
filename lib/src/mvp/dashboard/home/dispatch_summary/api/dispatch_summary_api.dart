import 'dart:convert';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:parsel_flutter/src/mvp/dashboard/home/select_pending_orders/model/parsel_base_model.dart';
import 'package:parsel_flutter/utils/utils.dart';

Future<Either<ParselBaseModel, Exception>> startTripApi(BuildContext context,
    {String? imageUrl,
    String? imageKey,
    required String groupId,
    required String apiType,
    required Map<String, String> body}) async {
  List<ConnectivityResult> connectivityResult =
      await Connectivity().checkConnectivity();
  if (connectivityResult.contains(ConnectivityResult.mobile) ||
      connectivityResult.contains(ConnectivityResult.wifi)) {
    try {
      String token =
          VariableUtilities.preferences.getString(LocalCacheKey.userToken) ??
              '';
      String domain = await APIManager.getDomain();

      final request = http.MultipartRequest(
        'PUT',
        Uri.parse('${APIUtilities.updateGroupIdDetails}$groupId/'),
      )
        ..fields.addAll({'status': 'ON_GOING'})
        ..headers.addAll({
          'Content-type': 'application/json',
          'X-TenantID': domain,
          'Authorization': 'Bearer ' + token,
        });
      if (imageUrl != null) {
        request.files
            .add(await http.MultipartFile.fromPath(imageKey!, imageUrl));
      }

      var res = await request.send();
      if (res.statusCode == 200) {
        var apiResponse = await res.stream.bytesToString();
        log('apiResponse --> $apiResponse');
        return Left(ParselBaseModel.fromJson(jsonDecode(apiResponse)));
      } else {
        return Right(FetchingDataException());
      }
    } catch (e) {
      return Right(GeneralAPIException());
    }
  } else {
    return Right(NoInternetException());
  }
}
