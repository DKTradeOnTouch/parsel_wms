import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parsel_flutter/screens/AUth/prominent_Disclosure.dart';
import 'package:parsel_flutter/screens/in_progress/location_service.dart';
import 'package:parsel_flutter/src/mvp/dashboard/home/dispatch_summary/provider/dispatch_summary_provider.dart';
import 'package:parsel_flutter/src/mvp/dashboard/home/select_pending_orders/model/get_sku_group_by_user_id_model.dart';
import 'package:parsel_flutter/src/mvp/dashboard/home/select_pending_orders/provider/select_pending_orders_provider.dart';
import 'package:parsel_flutter/src/widget/widget.dart';
import 'package:parsel_flutter/utils/utils.dart';
import 'package:provider/provider.dart';

class DispatchSummaryScreen extends StatefulWidget {
  const DispatchSummaryScreen({Key? key, required this.getSkuGroupData})
      : super(key: key);
  final GetSkuGroupData getSkuGroupData;

  @override
  State<DispatchSummaryScreen> createState() => _DispatchSummaryScreenState();
}

class _DispatchSummaryScreenState extends State<DispatchSummaryScreen> {
  TextEditingController driverNameController = TextEditingController();
  TextEditingController driverTimeController = TextEditingController();
  TextEditingController driverSkuCountController = TextEditingController();
  TextEditingController driverSkuQtyCountController = TextEditingController();
  TextEditingController driverDeliveryPointController = TextEditingController();
  TextEditingController driverNoOfBoxesController = TextEditingController();
  TextEditingController driverTempController = TextEditingController();
  TextEditingController driverDockTimeController = TextEditingController();
  int totalSkuQty = 0;

  @override
  void initState() {
    SelectPendingOrdersProvider selectPendingOrdersProvider =
        Provider.of(context, listen: false);
    List<SkuDetail> selectedPendingOrderList =
        List.from(selectPendingOrdersProvider.selectedPendingOrderList);

    for (int i = 0; i < selectedPendingOrderList.length; i++) {
      totalSkuQty = totalSkuQty + selectedPendingOrderList[i].qty;
    }
    driverNameController = TextEditingController(
        text: widget.getSkuGroupData.userDetails.username);
    driverTimeController =
        TextEditingController(text: '${widget.getSkuGroupData.createdTime}');
    driverSkuCountController =
        TextEditingController(text: '${selectedPendingOrderList.length}');
    driverSkuQtyCountController = TextEditingController(text: '$totalSkuQty');
    driverDeliveryPointController = TextEditingController(
        text: '${widget.getSkuGroupData.extraInfo.salesOrderCount}');
    driverNoOfBoxesController =
        TextEditingController(text: '${widget.getSkuGroupData.noOfBoxes}');
    driverTempController =
        TextEditingController(text: '${widget.getSkuGroupData.temperature}');
    driverDockTimeController =
        TextEditingController(text: '${widget.getSkuGroupData.createdTime}');

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder:
        (context, DispatchSummaryProvider dispatchSummaryProvider, __) {
      return Stack(
        children: [
          Scaffold(
            body: Container(
              color: ColorUtils.primaryColor,
              child: SafeArea(
                child: Column(children: [
                  Container(
                    width: double.infinity,
                    height: 100,
                    decoration: const BoxDecoration(
                        // color: ColorUtils.blueColor,
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
                          LocaleKeys.dispatch_summary.tr(),
                          style: FontUtilities.h20(
                              fontColor: ColorUtils.whiteColor),
                        )
                      ]),
                    ),
                  ),
                  Expanded(
                      child: Container(
                    padding: const EdgeInsets.only(top: 20),
                    height: VariableUtilities.screenSize.height,
                    width: VariableUtilities.screenSize.width,
                    decoration: const BoxDecoration(
                        color: ColorUtils.whiteColor,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        )),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Column(children: [
                          InputField(
                              readOnly: true,
                              controller: driverNameController,
                              label: LocaleKeys.driver_name.tr(),
                              hintText: LocaleKeys.enter_driver_name.tr()),
                          InputField(
                              readOnly: true,
                              controller: driverTimeController,
                              label: LocaleKeys.driver_time.tr(),
                              hintText: LocaleKeys.enter_driver_time.tr()),
                          InputField(
                              readOnly: true,
                              controller: driverSkuCountController,
                              label: LocaleKeys.sku_count.tr(),
                              hintText: LocaleKeys.enter_sku_count.tr()),
                          InputField(
                              readOnly: true,
                              controller: driverSkuQtyCountController,
                              label: LocaleKeys.sku_qty_count.tr(),
                              hintText: LocaleKeys.enter_sku_qty_count.tr()),
                          InputField(
                              readOnly: true,
                              controller: driverDeliveryPointController,
                              label: LocaleKeys.delivery_point.tr(),
                              hintText: LocaleKeys.enter_delivery_point.tr()),
                          InputField(
                              readOnly: true,
                              controller: driverNoOfBoxesController,
                              label: LocaleKeys.no_of_boxes.tr(),
                              hintText: LocaleKeys.enter_no_of_boxes.tr()),
                          InputField(
                              readOnly: true,
                              controller: driverTempController,
                              label: LocaleKeys.temperature.tr(),
                              hintText: LocaleKeys.enter_temperature.tr()),
                          InputField(
                              readOnly: true,
                              controller: driverDockTimeController,
                              label: LocaleKeys.dock_time.tr(),
                              hintText: LocaleKeys.enter_dock_time.tr()),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                LocaleKeys.photo.tr(),
                                style: FontUtilities.h16(
                                    fontColor: ColorUtils.colorA4A9B0),
                              ),
                              const SizedBox(height: 10),
                              GestureDetector(
                                onTap: () {
                                  if (dispatchSummaryProvider
                                      .filePath.isNotEmpty) {
                                    return;
                                  }
                                  MixpanelManager.trackEvent(
                                      eventName: 'OpenBottomSheet',
                                      properties: {
                                        'BottomSheet':
                                            'PickImageInDispatchSummary'
                                      });

                                  showModalBottomSheet(
                                      context: context,
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(15),
                                        topRight: Radius.circular(15),
                                      )),
                                      builder: (context) {
                                        return Theme(
                                          data: ThemeData(useMaterial3: false),
                                          child: SizedBox(
                                            height: 180,
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () async {
                                                          final image = await ImagePicker()
                                                              .pickImage(
                                                                  source:
                                                                      ImageSource
                                                                          .camera)
                                                              .then(
                                                                  (clickedImage) {
                                                            if (clickedImage !=
                                                                null) {
                                                              Navigator.pop(
                                                                  context);
                                                              dispatchSummaryProvider
                                                                      .filePath =
                                                                  clickedImage
                                                                      .path;
                                                            } else {
                                                              Fluttertoast.showToast(
                                                                  msg: LocaleKeys
                                                                      .failed_to_click_photo
                                                                      .tr());
                                                            }
                                                          });
                                                        },
                                                        child: Container(
                                                          height: 100,
                                                          width: 150,
                                                          decoration:
                                                              BoxDecoration(
                                                            border: Border.all(
                                                                color: ColorUtils
                                                                    .blackColor,
                                                                style:
                                                                    BorderStyle
                                                                        .solid),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                          ),
                                                          child: const Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Icon(
                                                                Icons
                                                                    .camera_alt_outlined,
                                                                size: 35,
                                                                color: ColorUtils
                                                                    .blackColor,
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      Text(
                                                        'Camera',
                                                        style: FontUtilities.h16(
                                                            fontColor: ColorUtils
                                                                .blackColor),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () async {
                                                          await ImagePicker()
                                                              .pickImage(
                                                                  source:
                                                                      ImageSource
                                                                          .gallery)
                                                              .then(
                                                                  (clickedImage) {
                                                            if (clickedImage !=
                                                                null) {
                                                              Navigator.pop(
                                                                  context);
                                                              dispatchSummaryProvider
                                                                      .filePath =
                                                                  clickedImage
                                                                      .path;
                                                            } else {
                                                              Fluttertoast.showToast(
                                                                  msg: LocaleKeys
                                                                      .failed_to_pick_photo
                                                                      .tr());
                                                            }
                                                          });
                                                        },
                                                        child: Container(
                                                          height: 100,
                                                          width: 150,
                                                          decoration:
                                                              BoxDecoration(
                                                            border: Border.all(
                                                                color: ColorUtils
                                                                    .blackColor,
                                                                style:
                                                                    BorderStyle
                                                                        .solid),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                          ),
                                                          child: const Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Icon(
                                                                Icons.photo,
                                                                size: 35,
                                                                color: ColorUtils
                                                                    .blackColor,
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      Text(
                                                        'Gallery',
                                                        style: FontUtilities.h16(
                                                            fontColor: ColorUtils
                                                                .blackColor),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }).then((value) {
                                    MixpanelManager.trackEvent(
                                        eventName: 'CloseBottomSheet',
                                        properties: {
                                          'BottomSheet':
                                              'PickImageInDispatchSummary'
                                        });
                                  });
                                },
                                child: Container(
                                  height: 200,
                                  width: VariableUtilities.screenSize.width,
                                  decoration: BoxDecoration(
                                    color: ColorUtils.colorEBECF0,
                                    border: Border.all(
                                        color: ColorUtils.colorC8D3E7,
                                        style: BorderStyle.solid),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      dispatchSummaryProvider.filePath.isEmpty
                                          ? Image.asset(
                                              AssetUtils.galleryIconImage,
                                              height: 40,
                                              width: 40,
                                            )
                                          : Expanded(
                                              child: Stack(
                                                children: [
                                                  Container(
                                                    color: Colors.transparent,
                                                    width: VariableUtilities
                                                        .screenSize.width,
                                                    child: Image.file(
                                                      File(
                                                          dispatchSummaryProvider
                                                              .filePath),
                                                      fit: BoxFit.contain,
                                                      width: VariableUtilities
                                                          .screenSize.width,
                                                    ),
                                                  ),
                                                  Align(
                                                    alignment:
                                                        Alignment.topRight,
                                                    child: IconButton(
                                                        onPressed: () {
                                                          dispatchSummaryProvider
                                                              .filePath = '';
                                                        },
                                                        icon: const Icon(
                                                          Icons.delete_outline,
                                                          color: ColorUtils
                                                              .redColor,
                                                        )),
                                                  )
                                                ],
                                              ),
                                            ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20)
                        ]),
                      ),
                    ),
                  ))
                ]),
              ),
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.all(8.0),
              child: PrimaryButton(
                  width: VariableUtilities.screenSize.width,
                  onTap: () {
                    MixpanelManager.trackEvent(
                        eventName: 'OpenDialog',
                        properties: {
                          'Dialog': 'DispatchSummaryStartTripDialog'
                        });
                    showDialog(
                        context: context,
                        builder: (_) {
                          return StartTripDialog(
                              imageUrl: AssetUtils.startTripContainerIconImage,
                              title: LocaleKeys.start_trip.tr(),
                              subTitle: LocaleKeys.start_trip_title.tr(),
                              submitTitle: LocaleKeys.start_trip.tr(),
                              submitOnTap: () async {
                                if (!await LocationService.instance
                                        .isPermissionGranted() ||
                                    !await LocationService.instance
                                        .checkServiceEnabled()) {
                                  if (!await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const ProminentDisclosure()))) {
                                    // Navigator.pop(context);
                                    print("Logout from current screen");

                                    Navigator.pop(context);

                                    await dispatchSummaryProvider
                                        .startUpdateLatLngToFirebase(context);

                                    await dispatchSummaryProvider.startTrip(
                                        context,
                                        grpId: '${widget.getSkuGroupData.id}',
                                        body: {"status": 'ON_GOING'});
                                    return;
                                  }
                                }

                                print(
                                    'widget.getSkuGroupData.id--> ${widget.getSkuGroupData.id}');

                                Navigator.pop(context);

                                await dispatchSummaryProvider
                                    .startUpdateLatLngToFirebase(context);

                                await dispatchSummaryProvider.startTrip(context,
                                    grpId: '${widget.getSkuGroupData.id}',
                                    body: {"status": 'ON_GOING'});
                              });
                        }).then((value) {
                      MixpanelManager.trackEvent(
                          eventName: 'CloseDialog',
                          properties: {
                            'Dialog': 'DispatchSummaryStartTripDialog'
                          });
                    });
                  },
                  title: LocaleKeys.start_trip.tr()),
            ),
          ),
          Visibility(
              visible: dispatchSummaryProvider.startTripResponse.isRight &&
                  dispatchSummaryProvider.startTripResponse.right
                      is NoDataFoundException,
              child: CustomCircularProgressIndicator()),
        ],
      );
    });
  }
}
