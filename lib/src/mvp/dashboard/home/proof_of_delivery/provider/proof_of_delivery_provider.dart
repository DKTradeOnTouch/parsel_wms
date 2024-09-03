import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:parsel_flutter/src/mvp/dashboard/home/proof_of_delivery/api/proof_of_delivery_api.dart';
import 'package:parsel_flutter/utils/utils.dart';

class ProofOfDeliveryProvider extends ChangeNotifier {
  // String _takePhotoFilePath = '';
  // String get takePhotoFilePath => _takePhotoFilePath;
  // set takePhotoFilePath(String val) {
  //   _takePhotoFilePath = val;
  //   notifyListeners();
  // }

  // String _signatureFilePath = '';
  // String get signatureFilePath => _signatureFilePath;
  // set signatureFilePath(String val) {
  //   _signatureFilePath = val;
  //   notifyListeners();
  // }

  // String _signatureName = '';
  // String get signatureName => _signatureName;
  // set signatureName(String val) {
  //   _signatureName = val;
  //   notifyListeners();
  // }

  // String _uploadDocFilePath = '';
  // String get uploadDocFilePath => _uploadDocFilePath;
  // set uploadDocFilePath(String val) {
  //   _uploadDocFilePath = val;
  //   notifyListeners();
  // }

  // String _scannedDocFilePath = '';
  // String get scannedDocFilePath => _scannedDocFilePath;
  // set scannedDocFilePath(String val) {
  //   _scannedDocFilePath = val;
  //   notifyListeners();
  // }

  bool _isVisible = false;
  bool get isVisible => _isVisible;
  set isVisible(bool val) {
    _isVisible = val;
    notifyListeners();
  }

  int _currentPage = 0;
  int get currentPage => _currentPage;
  set currentPage(int val) {
    _currentPage = val;
    notifyListeners();
  }

  Future<bool> uploadDocs({
    required String salesOrderId,
    required BuildContext context,
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
    isVisible = true;
    if (ConnectivityHandler.connectivityResult
        .contains(ConnectivityResult.none)) {
      isVisible = false;
      final storedProofOfDeliveryRequests = VariableUtilities.preferences
              .getStringList(LocalCacheKey.storedProofOfDeliveryRequests) ??
          [];
      for (int i = 0; i < storedProofOfDeliveryRequests.length; i++) {
        Map<String, dynamic> requests =
            jsonDecode(storedProofOfDeliveryRequests[i]);
        if (requests['function_name'] == 'upload_docs') {
          if (requests['sales_order_id'] == salesOrderId) {
            Map<String, dynamic> offlineApi = {
              'function_name': 'upload_docs',
              'sales_order_id': salesOrderId,
              'signature_image': signatureImage,
              'pdf': pdf,
              'take_photo': takePhoto,
              'scanned_photo': scannedPhoto
            };
            storedProofOfDeliveryRequests.removeWhere((element) {
              Map<String, dynamic> requests =
                  jsonDecode(storedProofOfDeliveryRequests[i]);
              return requests['sales_order_id'] == salesOrderId;
            });
            storedProofOfDeliveryRequests.add(jsonEncode(offlineApi));
            VariableUtilities.preferences.setStringList(
                LocalCacheKey.storedProofOfDeliveryRequests,
                storedProofOfDeliveryRequests);

            Fluttertoast.showToast(
                msg: LocaleKeys.your_request_is_already_submitted.tr());
            return true;
          }
        }
      }
      Map<String, dynamic> offlineApi = {
        'function_name': 'upload_docs',
        'sales_order_id': salesOrderId,
        'signature_image': signatureImage,
        'pdf': pdf,
        'take_photo': takePhoto,
        'scanned_photo': scannedPhoto
      };
      storedProofOfDeliveryRequests.add(jsonEncode(offlineApi));
      Fluttertoast.showToast(msg: LocaleKeys.your_request_is_submitted.tr());
      VariableUtilities.preferences.setStringList(
          LocalCacheKey.storedProofOfDeliveryRequests,
          storedProofOfDeliveryRequests);
      return true;
    }

    try {
      return await uploadDocsApi(
              isToastShow: isToastShow,
              salesOrderId: salesOrderId,
              signatureImage: signatureImage,
              pdf: pdf,
              takePhoto: takePhoto,
              scannedPhoto: scannedPhoto)
          .then((value) {
        if (value) {
          final storedProofOfDeliveryRequests = VariableUtilities.preferences
                  .getStringList(LocalCacheKey.storedProofOfDeliveryRequests) ??
              [];

          for (int i = 0; i < storedProofOfDeliveryRequests.length; i++) {
            Map<String, dynamic> requests =
                jsonDecode(storedProofOfDeliveryRequests[i]);
            if (requests['function_name'] == 'upload_docs') {
              if (requests['sales_order_id'] == salesOrderId) {
                storedProofOfDeliveryRequests.removeWhere((element) {
                  Map<String, dynamic> requests =
                      jsonDecode(storedProofOfDeliveryRequests[i]);
                  return requests['sales_order_id'] == salesOrderId;
                });
              }
            }
          }
          print(
              "storedProofOfDeliveryRequests sss--> $storedProofOfDeliveryRequests");
          VariableUtilities.preferences.setStringList(
              LocalCacheKey.storedProofOfDeliveryRequests,
              storedProofOfDeliveryRequests);
        }
        isVisible = false;
        return value;
      });
    } catch (e) {
      isVisible = false;
      return true;
    }
  }
}
