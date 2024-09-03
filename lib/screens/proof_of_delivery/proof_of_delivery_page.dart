// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parsel_flutter/models/uploaddoc_model.dart';
import 'package:parsel_flutter/resource/app_colors.dart';
import 'package:parsel_flutter/resource/app_fonts.dart';
import 'package:parsel_flutter/resource/app_helper.dart';
import 'package:parsel_flutter/resource/app_icons.dart';
import 'package:parsel_flutter/resource/app_logs.dart';
import 'package:parsel_flutter/resource/app_strings.dart';
import 'package:parsel_flutter/resource/app_styles.dart';
import 'package:parsel_flutter/screens/confirm_back_widget.dart';
import 'package:parsel_flutter/screens/payment/payment_page.dart';
import 'package:parsel_flutter/screens/proof_of_delivery/signature_screen_page.dart';
import 'package:parsel_flutter/utils/utils.dart';

import '../../api/api.dart';
import '../../models/SalesOrderBYID_Model.dart' as SALES;
import '../../models/uploadsalesorder_model.dart' as uplds;

class ProofOfDeliveryPage extends StatefulWidget {
  final String Id;
  final String SalesOrderID;

  final List<SALES.ItemList> deliverOrdersList;
  final List<SALES.ItemList> dataList;
  final List<uplds.ItemList> dataup;
  final SALES.SalesOrderBYID_Model salesOrder;
  const ProofOfDeliveryPage(
      {Key? key,
      required this.Id,
      required this.SalesOrderID,
      required this.deliverOrdersList,
      required this.dataList,
      required this.dataup,
      required this.salesOrder})
      : super(key: key);
  @override
  State<ProofOfDeliveryPage> createState() => _ProofOfDeliveryPageState();
}

class _ProofOfDeliveryPageState extends State<ProofOfDeliveryPage> {
  File? photoFile;
  File? signatureFile;
  File? documentFile;
  File? scanDocumentFile;
  bool _isLoading = true;

  String? photoFilePathString = '';
  String? signatureFileString = '';
  String? documentFileString = '';
  String? scanDocumentString = '';

  String? signatureName = '';

  File? signImage;

  bool isAnyFileUploaded(
      {required String documentFile,
      required String photoFile,
      required String scanDocumentFile,
      required String signatureFile,
      required String signatureName}) {
    bool isFileUploaded = false;
    // if(){}
    return isFileUploaded;
  }

  Future uploadDocs(
      BuildContext context,
      String documentFile,
      String photoFile,
      String scanDocumentFile,
      String signatureFile,
      String signatureName) async {
    // appLogs('photoFileString-->' + photoFilePathString.toString());
    // appLogs('in upload doc');
    // appLogs('docfilStringe-->' + documentFileString.toString());

    // appLogs('scandocfile-->' + scanDocumentFile);
    // appLogs('signaturename-->' + signatureName);

    if (ConnectivityHandler.connectivityResult
        .contains(ConnectivityResult.none)) {
      if (photoFile.isNotEmpty) {
        VariableUtilities.preferences.setString(
            "${LocalCacheKey.deliverySummaryPhotoProof}${widget.SalesOrderID}",
            photoFilePathString!);
      }
      if (scanDocumentFile.isNotEmpty) {
        VariableUtilities.preferences.setString(
            "${LocalCacheKey.deliverySummaryScanDocProof}${widget.SalesOrderID}",
            scanDocumentString!);
      }
      if (documentFile.isNotEmpty) {
        VariableUtilities.preferences.setString(
            "${LocalCacheKey.deliverySummaryUploadDocProof}${widget.SalesOrderID}",
            documentFileString!);
      }
      VariableUtilities.preferences.setString(
          "${LocalCacheKey.deliverySummarySignatureProofName}${widget.SalesOrderID}",
          signatureName ?? '');

      VariableUtilities.preferences.setString(
          "${LocalCacheKey.deliverySummarySignatureProof}${widget.SalesOrderID}",
          signatureFile ?? '');
      AppHelper.changeScreen(
          context,
          PaymentPage(
            id: widget.Id,
            Salesorderid: widget.SalesOrderID,
            dataList: widget.dataList,
            dataup: widget.dataup,
            salesOrder: widget.salesOrder,
            deliverOrdersList: widget.deliverOrdersList,
          ));

      return;
    }
    setState(() {
      _isLoading = true;
    });
    return await API
        .uploadDocs(context,
            signatureFile: signatureFile,
            photoFile: photoFile,
            signatureName: signatureName,
            documentFile: documentFile,
            scanDocumentFile: scanDocumentFile,
            salesOrderID: widget.Id)
        .then(
      (UploadDocModel? response) async {
        // appLogs('in upload doc');
        setState(() {
          _isLoading = false;
        });
        appLogs('rsponse-->' + response.toString());
        // SkuListModel sk= SkuListModel.fromJson(json)

        if (response != null) {
          // response.body!.data!.skuDetails!.map((e) => skuList.add(e)).toList();
          AppHelper.showSnackBar(
              context, 'success ' + response.message.toString());
          if (response.status == true) {
            AppHelper.changeScreen(
                context,
                PaymentPage(
                  id: widget.Id,
                  Salesorderid: widget.SalesOrderID,
                  dataList: widget.dataList,
                  dataup: widget.dataup,
                  salesOrder: widget.salesOrder,
                  deliverOrdersList: widget.deliverOrdersList,
                ));
          } else {
            AppHelper.showSnackBar(context, AppStrings.strSomethingWentWrong);
          }
        } else {
          AppHelper.showSnackBar(context, AppStrings.strSomethingWentWrong);
        }
      },
    ).onError((error, stackTrace) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  void initState() {
    appLogs('salesOrderId-->' + widget.SalesOrderID);

    super.initState();
  }

  Future<void> _showSelectPhotoDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              "Choose option",
              style: TextStyle(color: Colors.blue),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  const Divider(
                    height: 1,
                    color: Colors.blue,
                  ),
                  ListTile(
                    onTap: () {
                      _openSelectPhotoGallery(context);
                    },
                    title: Text(AppStrings.strGallery),
                    leading: const Icon(
                      Icons.account_box,
                      color: Colors.blue,
                    ),
                  ),
                  const Divider(
                    height: 1,
                    color: Colors.blue,
                  ),
                  ListTile(
                    onTap: () {
                      _openSelectPhotoCamera(context);
                    },
                    title: Text(AppStrings.strCamera),
                    leading: const Icon(
                      Icons.camera,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future<void> _showScanDocumentChoiceDialog(
    BuildContext context,
  ) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              "Choose option",
              style: TextStyle(color: Colors.blue),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  const Divider(
                    height: 1,
                    color: Colors.blue,
                  ),
                  ListTile(
                    onTap: () {
                      _scannedDocumentOpenGallery(context);
                    },
                    title: Text(AppStrings.strGallery),
                    leading: const Icon(
                      Icons.account_box,
                      color: Colors.blue,
                    ),
                  ),
                  const Divider(
                    height: 1,
                    color: Colors.blue,
                  ),
                  ListTile(
                    onTap: () {
                      openCameraScanDocument(context);
                    },
                    title: Text(AppStrings.strCamera),
                    leading: const Icon(
                      Icons.camera,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  void _openDocument(BuildContext context) async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'pdf', 'doc'],
    );
    setState(() {
      documentFile = File(result!.files.first.path!);
      // appLogs('document file path : ' + documentFile.path.toString());
    });
  }

  void _openGallery(BuildContext context, File? photoFile) async {
    // appLogs('in open gallery');
    // XFile? pickedFile = (await ImagePicker.platform.pickImage(
    //   source: ImageSource.gallery,
    // )) as XFile?;

    // appLogs('pickedfile-->' + pickedFile!.path.toString());

    // if (fileType == scanDocumentFile) {
    //   _cropImage(pickedFile.path.toString(), fileType);
    // } else {
    //   setState(() {
    //     // fileType = File(pickedFile!.path);
    //     appLogs('img gallery-->' + pickedFile.path.toString());
    //     // fileType = pickedFile as PickedFile?;
    //     // appLogs('image path : ' + fileType!.path.toString());
    //     photoFile=File(pickedFile.path);
    //     appLogs('photoFile-->' + photoFile!.path.toString());
    //   });
    // }

    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        photoFile = File(pickedFile.path);
        appLogs('img gallery-->' + photoFile!.path.toString());
      });
    }

    Navigator.maybePop(context);
  }

  void _openSelectPhotoGallery(BuildContext context) async {
    // appLogs('in select open gallery');

    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        photoFile = File(pickedFile.path);
        // appLogs('photoFile gallery-->' + photoFile!.path.toString());
      });
    }
    Navigator.maybePop(context);
  }

  void _openSelectPhotoCamera(BuildContext context) async {
    // appLogs('in select photo camera');
    final XFile? pickedFile = await ImagePicker.platform.getImage(
      source: ImageSource.camera,
    );
    if (pickedFile != null) {
      setState(() {
        photoFile = File(pickedFile.path);
        appLogs('image path : ' + photoFile!.path.toString());
      });
    } else
      return null;

    Navigator.maybePop(context);
  }

  void _scannedDocumentOpenGallery(BuildContext context) async {
    // appLogs('in open gallery');
    XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    appLogs('pickedfile-->' + pickedFile!.path.toString());
// _cropImage(pickedFile.path.toString(), scanDocumentFile);

    CroppedFile? croppedImage =
        await ImageCropper.platform.cropImage(sourcePath: pickedFile.path);

    if (croppedImage != null) {
      scanDocumentFile = File(croppedImage.path);
      setState(() {});
      Navigator.maybePop(context);
    }
  }

  // _getFromGallery() async {
  //   XFile? pickedFile = await ImagePicker().pickImage(
  //     source: ImageSource.gallery,
  //     maxWidth: 1800,
  //     maxHeight: 1800,
  //   );
  //   if (pickedFile != null) {
  //     setState(() {
  //       imageFile = File(pickedFile.path);
  //       appLogs('img gallery-->' + imageFile!.path.toString());
  //       isProfileChanged = true;
  //     });
  //   }
  // }

  // void _openCamera(BuildContext context, File? fileType) async {
  //   appLogs('in camera');
  //   appLogs('fileTypeName-->' + fileType.toString());
  //   final XFile? pickedFile = await ImagePicker.platform.getImage(
  //     source: ImageSource.camera,
  //   );
  //   if (fileType == scanDocumentFile) {
  //     appLogs('in if');
  //     _cropImage(pickedFile!.path, fileType);
  //     setState(() {});
  //   } else {
  //     setState(() {
  //       fileType = File(pickedFile!.path);
  //       appLogs('image path : ' + fileType!.path.toString());
  //     });
  //   }

  //   Navigator.maybePop(context);
  // }

  void openCameraScanDocument(BuildContext context) async {
    // appLogs('in camera');
    final XFile? pickedFile = await ImagePicker.platform.getImage(
      source: ImageSource.camera,
    );
    // _cropImage(pickedFile!.path,scanDocumentFile);
    CroppedFile? croppedImage =
        await ImageCropper.platform.cropImage(sourcePath: pickedFile!.path);

    if (croppedImage != null) {
      scanDocumentFile = File(croppedImage.path);
      setState(() {});
      Navigator.maybePop(context);
    }
  }

  cardWidget(String icon, String title) {
    return Card(
      shadowColor: AppColors.blackColor.withOpacity(0.6),
      elevation: 1.5,
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Colors.white70, width: 1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Container(
        width: double.infinity,
        child: Column(
          children: [
            const SizedBox(
              height: 16,
            ),
            Image.asset(
              icon,
              height: 25,
            ),
            const SizedBox(
              height: 22,
            ),
            Text(
              title,
              style: TextStyle(
                  fontFamily: appFontFamily,
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                  color: AppColors.black2Color.withOpacity(0.6)),
            ),
            const SizedBox(
              height: 22,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ConfirmBackWrapperWidget(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80.0), // here the desired height
          child: AppBar(
            backgroundColor: Colors.black,
            title: Container(
              padding: const EdgeInsets.only(top: 15),
              margin: const EdgeInsets.only(top: 40, left: 14, bottom: 22),
              child: Text(AppStrings.strProofOfDelivery,
                  style: AppStyles.appBarTitleStyle),
            ),
            leading: GestureDetector(
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Container(
                  padding: const EdgeInsets.only(top: 30),
                  height: 15,
                  width: 15,
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).maybePop();
                    },
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios),
                      iconSize: 20.0,
                      onPressed: () {
                        Navigator.maybePop(context);
                      },
                    ),
                  ),
                ),
              ),
              onTap: () {},
            ),
            actions: [
              Container(
                // padding: const EdgeInsets.only(top: 30),
                margin: const EdgeInsets.only(top: 40),
                child: Image.asset(
                  AppIcons.icQuestionRound,
                  // height: 18,
                  // width: 18,
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              InkWell(
                onTap: () {
                  AppHelper.changeScreen(
                      context,
                      PaymentPage(
                        id: widget.Id,
                        Salesorderid: widget.SalesOrderID,
                        dataList: widget.dataList,
                        dataup: widget.dataup,
                        salesOrder: widget.salesOrder,
                        deliverOrdersList: widget.deliverOrdersList,
                      ));
                },
                child: Container(
                  // padding: const EdgeInsets.only(top: 30),
                  margin: const EdgeInsets.only(top: 40),
                  child: Text(
                    AppStrings.strSkip,
                    style: AppStyles.buttonSkipTextStyle,
                  ),
                ),
              ),
              const SizedBox(
                width: 15,
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 35),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 16,
                      ),
                      InkWell(
                          onTap: (() {
                            // _showChoiceDialog(context, photoFile);
                            _showSelectPhotoDialog(context);
                          }),
                          child: cardWidget(
                              AppIcons.icCameraBlue, AppStrings.strTakePhoto)),
                      const SizedBox(
                        height: 16,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return SignatureScreenPage(
                              dataList: widget.dataList,
                              dataup: widget.dataup,
                              deliverOrdersList: widget.deliverOrdersList,
                              salesOrder: widget.salesOrder,
                              Id: widget.Id,
                              SalesOrderID: widget.SalesOrderID,
                            );
                          })).then((value) {
                            if (value != null) {
                              signatureFile = File(value['file_path']);
                              signatureName = value['sign_name'];
                            }
                            print("Value --> $value");
                          });
                          // _showChoiceDialog(context, signatureFile);
                        },
                        child: cardWidget(AppIcons.icSignatureBlue,
                            AppStrings.strGetSignature),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      InkWell(
                        onTap: () {
                          _openDocument(context);
                        },
                        child: cardWidget(AppIcons.icDocumentBlue,
                            AppStrings.strUploadDocument),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      InkWell(
                        onTap: () {
                          _showScanDocumentChoiceDialog(context);
                        },
                        child: cardWidget(AppIcons.icBarCodeBlue,
                            AppStrings.strScanDocuments),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: (() {
//               appLogs('confirm click');
                if (photoFile != null) {
                  appLogs('photo file-->' + photoFile!.path.toString());
                  photoFilePathString = photoFile!.path;

                  VariableUtilities.preferences.setString(
                      "${LocalCacheKey.deliverySummaryPhotoProof}${widget.SalesOrderID}",
                      photoFilePathString!);
                }
                if (scanDocumentFile != null) {
                  appLogs(
                      'Scandoc file-->' + scanDocumentFile!.path.toString());
                  scanDocumentString = scanDocumentFile!.path;
                  VariableUtilities.preferences.setString(
                      "${LocalCacheKey.deliverySummaryScanDocProof}${widget.SalesOrderID}",
                      scanDocumentString!);
                }
                if (documentFile != null) {
                  appLogs('doc file-->' + documentFile!.path.toString());
                  documentFileString = documentFile!.path;
                  VariableUtilities.preferences.setString(
                      "${LocalCacheKey.deliverySummaryUploadDocProof}${widget.SalesOrderID}",
                      documentFileString!);
                }
                if (signatureFile != null) {
                  VariableUtilities.preferences.setString(
                      "${LocalCacheKey.deliverySummarySignatureProofName}${widget.SalesOrderID}",
                      signatureName ?? '');
                  VariableUtilities.preferences.setString(
                      "${LocalCacheKey.deliverySummarySignatureProof}${widget.SalesOrderID}",
                      signatureFile!.path);
                }

                // appLogs('signature file-->' + signatureFile!.path.toString());
                // appLogs('signatureName-->' + signatureName!);

                if (documentFileString!.isNotEmpty ||
                    photoFilePathString!.isNotEmpty ||
                    scanDocumentString!.isNotEmpty ||
                    signatureFile != null ||
                    signatureName!.isNotEmpty) {
                  uploadDocs(
                      context,
                      documentFileString ?? '',
                      photoFilePathString ?? '',
                      scanDocumentString ?? '',
                      signatureFile!.path,
                      signatureName ?? '');
                } else {
                  AppHelper.changeScreen(
                      context,
                      PaymentPage(
                        id: widget.Id,
                        Salesorderid: widget.SalesOrderID,
                        dataList: widget.dataList,
                        dataup: widget.dataup,
                        salesOrder: widget.salesOrder,
                        deliverOrdersList: widget.deliverOrdersList,
                      ));
                }
              }),
              child: Container(
                height: 60,
                decoration: const BoxDecoration(
                  color: AppColors.blueColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      topRight: Radius.circular(10.0)),
                ),
                width: double.infinity,
                child: Center(
                  child: Text(
                    AppStrings.strConfirm,
                    style: AppStyles.buttonTextStyle,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  // Future<void> _showChoiceDialog(BuildContext context, File? fileType) {
  //   appLogs('showDialog file-->' + fileType.toString());
  //   return showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           title: Text(
  //             "Choose option",
  //             style: TextStyle(color: Colors.blue),
  //           ),
  //           content: SingleChildScrollView(
  //             child: ListBody(
  //               children: [
  //                 Divider(
  //                   height: 1,
  //                   color: Colors.blue,
  //                 ),
  //                 ListTile(
  //                   onTap: () {
  //                     _openGallery(context, photoFile);
  //                   },
  //                   title: Text(AppStrings.strGallery),
  //                   leading: Icon(
  //                     Icons.account_box,
  //                     color: Colors.blue,
  //                   ),
  //                 ),
  //                 Divider(
  //                   height: 1,
  //                   color: Colors.blue,
  //                 ),
  //                 ListTile(
  //                   onTap: () {
  //                     _openCamera(context, fileType);
  //                   },
  //                   title: Text(AppStrings.strCamera),
  //                   leading: Icon(
  //                     Icons.camera,
  //                     color: Colors.blue,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         );
  //       });
  // }
}
