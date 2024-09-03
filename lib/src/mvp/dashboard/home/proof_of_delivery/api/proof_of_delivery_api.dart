import 'dart:convert';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:parsel_flutter/src/mvp/dashboard/home/select_pending_orders/model/parsel_base_model.dart';
import 'package:parsel_flutter/utils/utils.dart';

Future<bool> uploadDocsApi({
  required String salesOrderId,
  required String signatureImage,
  required String pdf,
  required String takePhoto,
  required String scannedPhoto,
  required bool isToastShow,
}) async {
  if (signatureImage.isEmpty &&
      pdf.isEmpty &&
      takePhoto.isEmpty &&
      scannedPhoto.isEmpty) {
    return false;
  }
  try {
    String token =
        VariableUtilities.preferences.getString(LocalCacheKey.userToken) ?? '';
    var headers = {'Authorization': 'Bearer $token'};
    var request =
        http.MultipartRequest('POST', Uri.parse(APIUtilities.uploadDocs));

    request.fields.addAll({
      'sales_order_id': salesOrderId,
    });
    if (signatureImage.isNotEmpty) {
      String userName =
          VariableUtilities.preferences.getString(LocalCacheKey.userEmail) ??
              '';
      userName = userName.split("@")[0];
      print('userName $userName');
      request.fields.addAll({'signature_name': userName});
      request.files.add(await http.MultipartFile.fromPath(
        'signature_image',
        signatureImage,
      ));
    }
    if (pdf.isNotEmpty) {
      request.files.add(await http.MultipartFile.fromPath('pdf', pdf));
    }
    if (takePhoto.isNotEmpty) {
      request.files.add(await http.MultipartFile.fromPath('images', takePhoto));
    }
    if (scannedPhoto.isNotEmpty) {
      request.files
          .add(await http.MultipartFile.fromPath('images', scannedPhoto));
    }
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    print(request.fields);
    print(request.files);
    print(response.statusCode);
    if (response.statusCode == 200) {
      String res = await response.stream.bytesToString();
      print(res);
      ParselBaseModel parselBaseModel =
          ParselBaseModel.fromJson(jsonDecode(res));
      if (isToastShow) {
        Fluttertoast.showToast(msg: parselBaseModel.message);
      }

      return true;
    } else {
      if (response.statusCode == 413) {
        if (isToastShow) {
          Fluttertoast.showToast(msg: 'File Size must be smaller than 1 mb');
        }
      } else {
        if (isToastShow) {
          Fluttertoast.showToast(msg: 'Failed to upload doc');
        }
      }

      return false;
    }
  } catch (e) {
    return false;
  }
}
