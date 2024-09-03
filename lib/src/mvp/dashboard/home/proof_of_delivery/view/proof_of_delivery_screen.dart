import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parsel_flutter/utils/plugins/pdf_viewer/pdfviewer.dart';

import 'package:parsel_flutter/src/mvp/dashboard/home/delivery_orders/args/delivery_orders_args.dart';
import 'package:parsel_flutter/src/mvp/dashboard/home/in_progress/args/in_progress_args.dart';
import 'package:parsel_flutter/src/mvp/dashboard/home/in_progress/model/get_sales_order_list_by_status_model.dart';
import 'package:parsel_flutter/src/mvp/dashboard/home/payment/model/create_payment_mode_model.dart';
import 'package:parsel_flutter/src/mvp/dashboard/home/payment/provider/payment_provider.dart';
import 'package:parsel_flutter/src/mvp/dashboard/home/proof_of_delivery/provider/proof_of_delivery_provider.dart';
import 'package:parsel_flutter/src/widget/widget.dart';
import 'package:parsel_flutter/utils/utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:signature/signature.dart';

import 'package:widget_zoom/widget_zoom.dart';

class ProofOfDeliveryScreen extends StatefulWidget {
  const ProofOfDeliveryScreen({Key? key, required this.deliveryOrdersArgs})
      : super(key: key);
  final DeliveryOrdersArgs deliveryOrdersArgs;

  @override
  State<ProofOfDeliveryScreen> createState() => _ProofOfStateDeliveryScreen();
}

class _ProofOfStateDeliveryScreen extends State<ProofOfDeliveryScreen> {
  final PageController _pageController = PageController();
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  SignatureController _controller = SignatureController(
    penStrokeWidth: 1,
    penColor: ColorUtils.color0D1F3D,
    exportBackgroundColor: ColorUtils.colorF7F9FF,
    exportPenColor: ColorUtils.color0D1F3D,
    onDrawStart: () => print('onDrawStart called!'),
    onDrawEnd: () => print('onDrawEnd called!'),
  );
  late AutoScrollController controller;

  @override
  void initState() {
    controller = AutoScrollController(axis: Axis.horizontal);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ProofOfDeliveryProvider provider = Provider.of(context, listen: false);
      provider.isVisible = false;
      provider.currentPage = 0;

      // for(int i = 0;i<widget.deliveryOrdersArgs.resultList.subResultList.length;i++){
      //   widget.deliveryOrdersArgs.resultList.subResultList
      // }
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder:
        (context, ProofOfDeliveryProvider proofOfDeliveryProvider, __) {
      return Stack(
        children: [
          Scaffold(
            body: Container(
              color: ColorUtils.primaryColor,
              child: SafeArea(
                child: Column(
                  children: [
                    // Container(
                    //   height: 300,
                    //   child: SfPdfViewer.network(
                    //     'https://cdn.syncfusion.com/content/PDFViewer/flutter-succinctly.pdf',
                    //     key: _pdfViewerKey,
                    //   ),
                    // ),
                    Container(
                      width: double.infinity,
                      height: 100,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(AssetUtils.authBgImage),
                              fit: BoxFit.cover)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(children: [
                          IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(
                                Icons.arrow_back_ios_new,
                                color: ColorUtils.whiteColor,
                              )),
                          const SizedBox(width: 10),
                          Text(
                            LocaleKeys.proof_of_delivery.tr(),
                            style: FontUtilities.h20(
                                fontColor: ColorUtils.whiteColor),
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: () async {
                              if (widget.deliveryOrdersArgs.resultList
                                          .subResultList.length -
                                      1 !=
                                  _pageController.page!.toInt()) {
                                await _pageController.nextPage(
                                    duration: const Duration(milliseconds: 400),
                                    curve: Curves.easeIn);

                                proofOfDeliveryProvider.currentPage = int.parse(
                                    '${_pageController.page!.toInt()}');

                                await controller.scrollToIndex(
                                    proofOfDeliveryProvider.currentPage,
                                    preferPosition: AutoScrollPosition.middle);

                                return;
                              }
                              for (int i = 0;
                                  i <
                                      widget.deliveryOrdersArgs.resultList
                                          .subResultList.length;
                                  i++) {
                                ResultList subResult = widget.deliveryOrdersArgs
                                    .resultList.subResultList[i];
                                await proofOfDeliveryProvider.uploadDocs(
                                  isToastShow: true,
                                  context: context,
                                  pdf: subResult.uploadDocFilePath,
                                  scannedPhoto: subResult.scannedDocFilePath,
                                  signatureImage: subResult.signatureFilePath,
                                  takePhoto: subResult.takePhotoFilePath,
                                  salesOrderId: '${subResult.id}',
                                );
                              }
                              if (checkAllOrdersWithFullReturn()) {
                                await generatePayment();
                                return;
                              }

                              MixpanelManager.trackEvent(
                                  eventName: 'ScreenView',
                                  properties: {'Screen': 'PaymentScreen'});
                              Navigator.pushNamed(
                                  context, RouteUtilities.paymentScreen,
                                  arguments: DeliveryOrdersArgs(
                                      timestamp:
                                          widget.deliveryOrdersArgs.timestamp,
                                      noOfItems:
                                          widget.deliveryOrdersArgs.noOfItems,
                                      resultList: widget
                                          .deliveryOrdersArgs.resultList));
                            },
                            child: Text(
                              LocaleKeys.skip.tr(),
                              style: FontUtilities.h16(
                                  fontColor: ColorUtils.whiteColor),
                            ),
                          )
                        ]),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: VariableUtilities.screenSize.height,
                        width: VariableUtilities.screenSize.width,
                        decoration: const BoxDecoration(
                            color: ColorUtils.colorF7F9FF,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            )),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 20),
                            widget.deliveryOrdersArgs.resultList.subResultList
                                        .length <=
                                    1
                                ? const SizedBox()
                                : Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 25.0, vertical: 10.0),
                                    child: SizedBox(
                                      height: 46,
                                      child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: widget.deliveryOrdersArgs
                                              .resultList.subResultList.length,
                                          shrinkWrap: true,
                                          controller: controller,
                                          itemBuilder: (context, index) {
                                            return AutoScrollTag(
                                              controller: controller,
                                              index: index,
                                              key: ValueKey(index),
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 10.0),
                                                child: InkWell(
                                                  onTap: () {
                                                    proofOfDeliveryProvider
                                                        .currentPage = index;
                                                    _pageController
                                                        .animateToPage(index,
                                                            curve:
                                                                Curves.linear,
                                                            duration:
                                                                const Duration(
                                                                    milliseconds:
                                                                        300));
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        color:
                                                            proofOfDeliveryProvider
                                                                        .currentPage ==
                                                                    index
                                                                ? ColorUtils
                                                                    .whiteColor
                                                                : ColorUtils
                                                                    .colorE7E7E7,
                                                        border: Border.all(
                                                            color: proofOfDeliveryProvider
                                                                        .currentPage ==
                                                                    index
                                                                ? ColorUtils
                                                                    .primaryColor
                                                                : Colors
                                                                    .transparent),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5)),
                                                    constraints:
                                                        const BoxConstraints(
                                                            minWidth: 145,
                                                            minHeight: 46),
                                                    child: Center(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal:
                                                                    15.0,
                                                                vertical: 5.0),
                                                        child: Text(
                                                          'INV #${widget.deliveryOrdersArgs.resultList.subResultList[index].id}',
                                                          style: FontUtilities.h20(
                                                              fontColor: ColorUtils
                                                                  .color3F3E3E,
                                                              fontWeight:
                                                                  FWT.semiBold),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          }),
                                    )),
                            Expanded(
                              child: PageView.builder(
                                  controller: _pageController,
                                  physics: const NeverScrollableScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  itemCount: widget.deliveryOrdersArgs
                                      .resultList.subResultList.length,
                                  itemBuilder: (context, index) {
                                    ResultList resultList = widget
                                        .deliveryOrdersArgs
                                        .resultList
                                        .subResultList[index];
                                    return (resultList.takePhotoFilePath.isNotEmpty ||
                                            resultList
                                                .signatureFilePath.isNotEmpty ||
                                            resultList
                                                .uploadDocFilePath.isNotEmpty ||
                                            resultList
                                                .scannedDocFilePath.isNotEmpty)
                                        ? showImageOrPdfView(resultList)
                                        : SingleChildScrollView(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(15.0),
                                              child: Column(children: [
                                                Row(
                                                  children: [
                                                    _takeProofWidget(
                                                        imageUrl: AssetUtils
                                                            .takePhotoIconImage,
                                                        title: LocaleKeys
                                                            .take_photo
                                                            .tr(),
                                                        onTap: () {
                                                          _showSelectPhotoDialog(
                                                              context,
                                                              proofOfDeliveryProvider,
                                                              index);
                                                        }),
                                                    _takeProofWidget(
                                                        imageUrl: AssetUtils
                                                            .signatureIconImage,
                                                        title: LocaleKeys
                                                            .get_signature
                                                            .tr(),
                                                        onTap: () {
                                                          _controller =
                                                              SignatureController(
                                                            penStrokeWidth: 1,
                                                            penColor: ColorUtils
                                                                .color0D1F3D,
                                                            exportBackgroundColor:
                                                                ColorUtils
                                                                    .colorF7F9FF,
                                                            exportPenColor:
                                                                ColorUtils
                                                                    .color0D1F3D,
                                                          );
                                                          MixpanelManager
                                                              .trackEvent(
                                                                  eventName:
                                                                      'OpenBottomSheet',
                                                                  properties: {
                                                                'BottomSheet':
                                                                    'UserSignatureSheet'
                                                              });
                                                          showModalBottomSheet(
                                                              backgroundColor:
                                                                  ColorUtils
                                                                      .whiteColor,
                                                              context: context,
                                                              shape: const RoundedRectangleBorder(
                                                                  borderRadius: BorderRadius.only(
                                                                      topLeft: Radius
                                                                          .circular(
                                                                              15),
                                                                      topRight:
                                                                          Radius.circular(
                                                                              15))),
                                                              builder:
                                                                  (context) {
                                                                return Theme(
                                                                  data: ThemeData(
                                                                      useMaterial3:
                                                                          false),
                                                                  child:
                                                                      SizedBox(
                                                                    height: 250,
                                                                    width: VariableUtilities
                                                                        .screenSize
                                                                        .width,
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                          .all(
                                                                          12.0),
                                                                      child:
                                                                          Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                            LocaleKeys.user_signature.tr(),
                                                                            style:
                                                                                FontUtilities.h18(fontColor: ColorUtils.color3F3E3E),
                                                                          ),
                                                                          const SizedBox(
                                                                              height: 10),
                                                                          Container(
                                                                            decoration:
                                                                                BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: ColorUtils.colorAAAAAA)),
                                                                            height:
                                                                                120,
                                                                            child:
                                                                                ClipRRect(
                                                                              borderRadius: BorderRadius.circular(5),
                                                                              child: Signature(
                                                                                controller: _controller,
                                                                                height: 120,
                                                                                backgroundColor: ColorUtils.colorF7F9FF,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          const SizedBox(
                                                                              height: 10),
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.all(8.0),
                                                                            child:
                                                                                Row(children: [
                                                                              const Spacer(),
                                                                              Expanded(
                                                                                child: PrimaryButton(
                                                                                    height: 40,
                                                                                    width: VariableUtilities.screenSize.width / 2,
                                                                                    onTap: () {
                                                                                      Navigator.pop(context);
                                                                                    },
                                                                                    title: LocaleKeys.cancel.tr()),
                                                                              ),
                                                                              const SizedBox(width: 10),
                                                                              Expanded(
                                                                                child: PrimaryButton(
                                                                                    height: 40,
                                                                                    borderColor: ColorUtils.color0D1F3D,
                                                                                    titleColor: ColorUtils.color0D1F3D,
                                                                                    textStyle: FontUtilities.h18(fontColor: ColorUtils.color0D1F3D, fontWeight: FWT.semiBold),
                                                                                    color: Colors.transparent,
                                                                                    width: VariableUtilities.screenSize.width / 2,
                                                                                    onTap: () async {
                                                                                      String salesOrderId = widget.deliveryOrdersArgs.resultList.subResultList[index].salesOrderId;
                                                                                      Uint8List? uint8list = await _controller.toPngBytes();
                                                                                      if (uint8list != null) {
                                                                                        ui.Image image = await decodeImageFromList(uint8list);
                                                                                        ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
                                                                                        Uint8List fileImageBytes = byteData!.buffer.asUint8List();
                                                                                        Directory fileDir = await getTemporaryDirectory();

                                                                                        String filePath = '${fileDir.path}/${salesOrderId}_signature.png';

                                                                                        // Write the file

                                                                                        await File(filePath).writeAsBytes(fileImageBytes);
                                                                                        widget.deliveryOrdersArgs.resultList.subResultList[index].signatureFilePath = filePath;
                                                                                        setState(() {});
                                                                                      }
                                                                                      Navigator.pop(context);
                                                                                    },
                                                                                    title: LocaleKeys.confirm.tr()),
                                                                              )
                                                                            ]),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                );
                                                              }).then((value) {
                                                            MixpanelManager
                                                                .trackEvent(
                                                                    eventName:
                                                                        'CloseBottomSheet',
                                                                    properties: {
                                                                  'BottomSheet':
                                                                      'UserSignatureSheet'
                                                                });
                                                          });
                                                        }),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    _takeProofWidget(
                                                        imageUrl: AssetUtils
                                                            .uploadIconImage,
                                                        title: LocaleKeys
                                                            .upload_document
                                                            .tr(),
                                                        onTap: () async {
                                                          widget
                                                                  .deliveryOrdersArgs
                                                                  .resultList
                                                                  .subResultList[
                                                                      index]
                                                                  .uploadDocFilePath =
                                                              await _openDocument(
                                                                  context,
                                                                  proofOfDeliveryProvider);
                                                        }),
                                                    _takeProofWidget(
                                                        imageUrl: AssetUtils
                                                            .scanningIconImage,
                                                        title: LocaleKeys
                                                            .scan_documents
                                                            .tr(),
                                                        onTap: () async {
                                                          MixpanelManager
                                                              .trackEvent(
                                                                  eventName:
                                                                      'ScreenView',
                                                                  properties: {
                                                                'Screen':
                                                                    'BarcodeScannerWithController'
                                                              });
                                                          // _showScanDocumentChoiceDialog(context);
                                                          // Navigator.push(context,
                                                          //     MaterialPageRoute(
                                                          //         builder: (_) {
                                                          //   return const BarcodeScannerWithController();
                                                          // })).then((value) {
                                                          //   print("Value");
                                                          // });

                                                          final imagesPath =
                                                              await CunningDocumentScanner
                                                                  .getPictures(
                                                                      noOfPages:
                                                                          1,
                                                                      isGalleryImportAllowed:
                                                                          true);

                                                          if (imagesPath !=
                                                                  null &&
                                                              imagesPath
                                                                  .isNotEmpty) {
                                                            widget
                                                                    .deliveryOrdersArgs
                                                                    .resultList
                                                                    .subResultList[
                                                                        index]
                                                                    .scannedDocFilePath =
                                                                imagesPath
                                                                    .first;
                                                            setState(() {});
                                                          }
                                                        }),
                                                  ],
                                                )
                                              ]),
                                            ),
                                          );
                                  }),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            bottomNavigationBar: Padding(
                padding: const EdgeInsets.all(8.0),
                child: PrimaryButton(
                    visibilityColor:
                        isSubmitButtonEnable(proofOfDeliveryProvider)
                            ? null
                            : ColorUtils.blackColor.withOpacity(0.4),
                    width: VariableUtilities.screenSize.width,
                    onTap: () async {
                      if (widget.deliveryOrdersArgs.resultList.subResultList
                                  .length -
                              1 !=
                          _pageController.page!.toInt()) {
                        await _pageController.nextPage(
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeIn);

                        proofOfDeliveryProvider.currentPage =
                            int.parse('${_pageController.page!.toInt()}');

                        await controller.scrollToIndex(
                            proofOfDeliveryProvider.currentPage,
                            preferPosition: AutoScrollPosition.middle);

                        return;
                      }
                      for (int i = 0;
                          i <
                              widget.deliveryOrdersArgs.resultList.subResultList
                                  .length;
                          i++) {
                        ResultList subResult = widget
                            .deliveryOrdersArgs.resultList.subResultList[i];
                        await proofOfDeliveryProvider
                            .uploadDocs(
                          isToastShow: true,
                          context: context,
                          pdf: subResult.uploadDocFilePath,
                          scannedPhoto: subResult.scannedDocFilePath,
                          signatureImage: subResult.signatureFilePath,
                          takePhoto: subResult.takePhotoFilePath,
                          salesOrderId: '${subResult.id}',
                        )
                            .then((value) async {
                          // }
                          if (value &&
                              widget.deliveryOrdersArgs.resultList.subResultList
                                          .length -
                                      1 ==
                                  i) {
                            await generatePayment();
                          }
                        });
                      }
                    },
                    title: widget.deliveryOrdersArgs.resultList.subResultList
                                    .length -
                                1 ==
                            proofOfDeliveryProvider.currentPage
                        ? LocaleKeys.submit.tr()
                        : LocaleKeys.next.tr())),
          ),
          Visibility(
              visible: proofOfDeliveryProvider.isVisible,
              child: CustomCircularProgressIndicator())
        ],
      );
    });
  }

  bool isSubmitButtonEnable(ProofOfDeliveryProvider proofOfDeliveryProvider) {
    ResultList resultList = widget.deliveryOrdersArgs.resultList
        .subResultList[proofOfDeliveryProvider.currentPage];
    return (resultList.takePhotoFilePath.isNotEmpty ||
        resultList.signatureFilePath.isNotEmpty ||
        resultList.uploadDocFilePath.isNotEmpty ||
        resultList.scannedDocFilePath.isNotEmpty);
  }

  Future generatePayment() async {
    bool isAllOrdersWithFullReturn = checkAllOrdersWithFullReturn();
    PaymentProvider paymentProvider = Provider.of(context, listen: false);
    if (isAllOrdersWithFullReturn) {
      for (int i = 0;
          i < widget.deliveryOrdersArgs.resultList.subResultList.length;
          i++) {
        ResultList resultList =
            widget.deliveryOrdersArgs.resultList.subResultList[i];
        await paymentProvider
            .updateSalesOrder(context,
                isCallFromOffline: false,
                arrivedTimestamp: widget.deliveryOrdersArgs.timestamp,
                deliveredTimestamp: DateTime.now().millisecondsSinceEpoch,
                isLastIndex:
                    widget.deliveryOrdersArgs.resultList.subResultList.length -
                            1 ==
                        i,
                isCallWithUpDoc: true,
                id: '${resultList.id}',
                payments: [
                  CreatePaymentsList(
                    paymentMode: 'cod',
                    value: 0,
                    paymentDate: DateFormat('yyyy-MM-dd')
                        .format((DateTime.now()))
                        .toString(),
                    paymentRemark: 'Payment Done',
                    paymentTypes: "CASH_ON_DELIVERY",
                    chequePaymentTypes: "NONE",
                  )
                ],
                salesOrderId: resultList.salesOrderId,
                deliveryStatus: 'DELIVERED')
            .then((value) {
          if (value) {
            if (widget.deliveryOrdersArgs.resultList.subResultList.length - 1 ==
                    i &&
                value) {
              MixpanelManager.trackEvent(
                  eventName: 'OpenDialog',
                  properties: {'Dialog': 'PaymentDoneDialog'});
              showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (_) {
                    return PopScope(
                      canPop: false,
                      child: StartTripDialog(
                        isPaymentDialog: true,
                        imageUrl: AssetUtils.paymentDoneIconIconImage,
                        title: LocaleKeys.customer_payment_is_successfully.tr(),
                        subTitle: LocaleKeys.you_can_start_your_next_trip.tr(),
                        submitTitle: LocaleKeys.continue_trip.tr(),
                        submitOnTap: () {
                          MixpanelManager.trackEvent(
                              eventName: 'ScreenView',
                              properties: {'Screen': 'InProgressScreen'});
                          Navigator.pushNamedAndRemoveUntil(context,
                              RouteUtilities.inProgressScreen, (route) => false,
                              arguments: InProgressArgs(
                                  navigateFrom: RouteUtilities.paymentScreen));
                        },
                      ),
                    );
                  }).then((value) {
                MixpanelManager.trackEvent(
                    eventName: 'CloseDialog',
                    properties: {'Dialog': 'PaymentDoneDialog'});
              });
            }
          }
        });
      }
    } else {
      MixpanelManager.trackEvent(
          eventName: 'ScreenView', properties: {'Screen': 'PaymentScreen'});
      Navigator.pushNamed(context, RouteUtilities.paymentScreen,
          arguments: DeliveryOrdersArgs(
              timestamp: widget.deliveryOrdersArgs.timestamp,
              noOfItems: widget.deliveryOrdersArgs.noOfItems,
              resultList: widget.deliveryOrdersArgs.resultList));
    }
  }

  bool checkAllOrdersWithFullReturn() {
    bool checkOrders = true;
    for (int i = 0;
        i < widget.deliveryOrdersArgs.resultList.subResultList.length;
        i++) {
      ResultList resultList =
          widget.deliveryOrdersArgs.resultList.subResultList[i];
      if (resultList.returnItemsList.length != resultList.itemList.length) {
        checkOrders = false;
        break;
      }
    }
    return checkOrders;
  }

  Future<void> _showScanDocumentChoiceDialog(
      BuildContext context, ProofOfDeliveryProvider proofOfDeliveryProvider) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Theme(
            data: ThemeData(useMaterial3: false),
            child: AlertDialog(
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
                        _scannedDocumentOpenGallery(
                            context, proofOfDeliveryProvider);
                      },
                      title: const Text('Gallery'),
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
                        openCameraScanDocument(
                            context, proofOfDeliveryProvider);
                      },
                      title: const Text('Camera'),
                      leading: const Icon(
                        Icons.camera,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Widget showImageOrPdfView(ResultList resultList) {
    // return Container();

    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Stack(
        children: [
          Container(
            width: VariableUtilities.screenSize.width,
            decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.5),
                borderRadius: BorderRadius.circular(10)),
            child: (resultList.uploadDocFilePath.isNotEmpty &&
                    resultList.uploadDocFilePath.contains('.pdf'))
                ? Container(
                    // height: 300,
                    child: SfPdfViewer.file(
                      File(resultList.uploadDocFilePath),
                      key: _pdfViewerKey,
                    ),
                  )
                : Container(
                    height: 300,
                    child: WidgetZoom(
                      heroAnimationTag: 'tag',
                      zoomWidget: Image.file(
                        resultList.takePhotoFilePath.isNotEmpty
                            ? File(resultList.takePhotoFilePath)
                            : resultList.signatureFilePath.isNotEmpty
                                ? File(
                                    resultList.signatureFilePath,
                                  )
                                : resultList.uploadDocFilePath.isNotEmpty
                                    ? File(
                                        resultList.uploadDocFilePath,
                                      )
                                    : resultList.scannedDocFilePath.isNotEmpty
                                        ? File(
                                            resultList.scannedDocFilePath,
                                          )
                                        : File(''),
                        width: VariableUtilities.screenSize.width,
                        height: 300,
                      ),
                    ),
                  ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
                onPressed: () {
                  resultList.takePhotoFilePath = '';
                  resultList.uploadDocFilePath = '';
                  resultList.scannedDocFilePath = '';
                  resultList.signatureFilePath = '';
                  setState(() {});
                },
                icon: const Icon(
                  Icons.delete,
                  color: ColorUtils.redColor,
                )),
          )
        ],
      ),
    );
  }

  void _scannedDocumentOpenGallery(BuildContext context,
      ProofOfDeliveryProvider proofOfDeliveryProvider) async {
    // print('in open gallery');

    MixpanelManager.trackEvent(
        eventName: 'OpenDialog',
        properties: {'Dialog': 'ProofScannedDocumentDialog'});
    XFile? pickedFile = await ImagePicker()
        .pickImage(source: ImageSource.gallery)
        .then((value) {
      if (value != null) {}
      MixpanelManager.trackEvent(
          eventName: 'CloseDialog',
          properties: {'Dialog': 'ProofScannedDocumentDialog'});
      return value;
    });

    print('picked file-->' + pickedFile!.path.toString());
// _cropImage(pickedFile.path.toString(), scanDocumentFile);
    MixpanelManager.trackEvent(
        eventName: 'OpenDialog',
        properties: {'Dialog': 'ProofCropScannedDocumentDialog'});

    CroppedFile? croppedImage = await ImageCropper.platform
        .cropImage(sourcePath: pickedFile.path)
        .then((value) {
      MixpanelManager.trackEvent(
          eventName: 'CloseDialog',
          properties: {'Dialog': 'ProofCropScannedDocumentDialog'});
      return value;
    });

    if (croppedImage != null) {
      Navigator.maybePop(context);
    }
  }

  void openCameraScanDocument(BuildContext context,
      ProofOfDeliveryProvider proofOfDeliveryProvider) async {
    MixpanelManager.trackEvent(
        eventName: 'OpenDialog',
        properties: {'Dialog': 'ProofCameraScanDocumentDialog'});

    // print('in camera');
    final XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera).then((value) {
      MixpanelManager.trackEvent(
          eventName: 'CloseDialog',
          properties: {'Dialog': 'ProofCameraScanDocumentDialog'});
    });
    // _cropImage(pickedFile!.path,scanDocumentFile);
    MixpanelManager.trackEvent(
        eventName: 'OpenDialog',
        properties: {'Dialog': 'ProofCropCameraScanDocumentDialog'});
    CroppedFile? croppedImage = await ImageCropper.platform
        .cropImage(sourcePath: pickedFile!.path)
        .then((value) {
      MixpanelManager.trackEvent(
          eventName: 'OpenDialog',
          properties: {'Dialog': 'ProofCropCameraScanDocumentDialog'});
    });

    if (croppedImage != null) {
      Navigator.maybePop(context);
    }
  }

  Future<String> _openDocument(BuildContext context,
      ProofOfDeliveryProvider proofOfDeliveryProvider) async {
    MixpanelManager.trackEvent(
        eventName: 'OpenDialog',
        properties: {'Dialog': 'ProofOpenDocumentDialogInProofScreen'});
    String filePath = '';
    await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'pdf', 'jpeg'],
    ).then((value) {
      if (value != null) {
        filePath = value.files.first.path ?? '';
        setState(() {});
      } else {
        filePath = '';
        setState(() {});
      }

      MixpanelManager.trackEvent(
          eventName: 'CloseDialog',
          properties: {'Dialog': 'ProofOpenDocumentDialogInProofScreen'});
    });
    return filePath;
  }

  Future<void> _showSelectPhotoDialog(BuildContext context,
      ProofOfDeliveryProvider proofOfDeliveryProvider, int index) {
    MixpanelManager.trackEvent(
        eventName: 'OpenDialog',
        properties: {'Dialog': 'ShowSelectPhotoDialog'});
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Theme(
            data: ThemeData(useMaterial3: false),
            child: AlertDialog(
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
                      onTap: () async {
                        widget.deliveryOrdersArgs.resultList
                                .subResultList[index].takePhotoFilePath =
                            await _openSelectPhotoGallery(
                                context, proofOfDeliveryProvider);
                      },
                      title: const Text('Gallery'),
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
                      onTap: () async {
                        widget.deliveryOrdersArgs.resultList
                                .subResultList[index].takePhotoFilePath =
                            await _openSelectPhotoCamera(
                                widget.deliveryOrdersArgs.resultList
                                    .subResultList[index].salesOrderId,
                                context,
                                proofOfDeliveryProvider);
                      },
                      title: const Text('Camera'),
                      leading: const Icon(
                        Icons.camera,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).then((value) {
      MixpanelManager.trackEvent(
          eventName: 'CloseDialog',
          properties: {'Dialog': 'ShowSelectPhotoDialog'});
    });
  }

  Future<String> _openSelectPhotoGallery(BuildContext context,
      ProofOfDeliveryProvider proofOfDeliveryProvider) async {
    // print('in select open gallery');
    MixpanelManager.trackEvent(
        eventName: 'OpenDialog',
        properties: {'Dialog': 'SelectProofPhotoGallery'});
    String filePath = '';
    await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 50)
        .then((value) async {
      if (value != null) {
        // Get the file size in bytes
        File file = File(value.path);
        int fileSizeInBytes = file.lengthSync();

        // Convert bytes to kilobytes
        double fileSizeInKB = fileSizeInBytes / 1024;

        // Convert bytes to megabytes
        double fileSizeInMB = fileSizeInKB / 1024;

        print('Image Size:');
        print('Bytes: $fileSizeInBytes');
        print('KB: $fileSizeInKB');
        print('MB: $fileSizeInMB');
        filePath = value.path;

        setState(() {});
      } else {
        filePath = '';
        setState(() {});
      }
      MixpanelManager.trackEvent(
          eventName: 'CloseDialog',
          properties: {'Dialog': 'SelectProofPhotoGallery'});
    });

    Navigator.maybePop(context);
    return filePath;
  }

  Future<String> _openSelectPhotoCamera(
      String salesOrderId,
      BuildContext context,
      ProofOfDeliveryProvider proofOfDeliveryProvider) async {
    // print('in select open gallery');
    MixpanelManager.trackEvent(
        eventName: 'OpenDialog',
        properties: {'Dialog': 'SelectProofPhotoCamera'});
    String filePath = '';

    await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 50)
        .then((value) async {
      if (value != null) {
        File file = File(value.path);
        int fileSizeInBytes = file.lengthSync();

        // Convert bytes to kilobytes
        double fileSizeInKB = fileSizeInBytes / 1024;

        // Convert bytes to megabytes
        double fileSizeInMB = fileSizeInKB / 1024;
        print('valueImage Size:');
        print('valueBytes: $fileSizeInBytes');
        print('valueKB: $fileSizeInKB');
        print('valueMB: $fileSizeInMB');
        print('value.path ${value.path}');

        filePath = value.path;
        setState(() {});
      } else {
        filePath = '';
        setState(() {});
      }
      MixpanelManager.trackEvent(
          eventName: 'CloseDialog',
          properties: {'Dialog': 'SelectProofPhotoCamera'});
    });

    Navigator.maybePop(context);
    return filePath;
  }

  Widget _takeProofWidget(
      {required VoidCallback onTap,
      required String imageUrl,
      required String title}) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Container(
            padding: const EdgeInsets.all(4.0),
            height: 150,
            decoration: BoxDecoration(
                color: ColorUtils.whiteColor,
                border: Border.all(color: ColorUtils.colorC8D3E7),
                borderRadius: BorderRadius.circular(10)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  imageUrl,
                  height: 35,
                  width: 35,
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(
                          title,
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          style: FontUtilities.h18(
                              fontColor: ColorUtils.color3F3E3E),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
