import 'package:easy_localization/easy_localization.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:parsel_flutter/screens/AUth/prominent_Disclosure.dart';
import 'package:parsel_flutter/screens/in_progress/location_service.dart';
import 'package:parsel_flutter/src/mvp/dashboard/home/delivery_orders/args/delivery_orders_args.dart';
import 'package:parsel_flutter/src/mvp/dashboard/home/delivery_orders/provider/delivery_orders_provider.dart';
import 'package:parsel_flutter/src/mvp/dashboard/home/delivery_orders_summary/provider/delivery_orders_summary_provider.dart';
import 'package:parsel_flutter/src/mvp/dashboard/home/in_progress/model/get_sales_order_list_by_status_model.dart';
import 'package:parsel_flutter/src/mvp/dashboard/home/order_review/provider/order_review_provider.dart';
import 'package:parsel_flutter/src/mvp/dashboard/home/payment/provider/payment_provider.dart';
import 'package:parsel_flutter/src/mvp/dashboard/home/proof_of_delivery/provider/proof_of_delivery_provider.dart';
import 'package:parsel_flutter/src/widget/widget.dart';
import 'package:parsel_flutter/utils/utils.dart';
import 'package:provider/provider.dart';

class DeliveryOrdersScreen extends StatefulWidget {
  const DeliveryOrdersScreen({Key? key, required this.deliveryOrdersArgs})
      : super(key: key);
  final DeliveryOrdersArgs deliveryOrdersArgs;
  @override
  State<DeliveryOrdersScreen> createState() => _DeliveryOrdersScreenState();
}

class _DeliveryOrdersScreenState extends State<DeliveryOrdersScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      DeliveryOrdersProvider deliveryOrdersProvider =
          Provider.of(context, listen: false);
      deliveryOrdersProvider.updateStoreLocationModelResponse =
          Right(StaticException());
      deliveryOrdersProvider.updateDistanceTravelModel =
          Right(StaticException());
      deliveryOrdersProvider.getSalesOrderListByStatusResponse =
          Right(StaticException());
      deliveryOrdersProvider.isDriverArrived = false;
      bool isDriverArrived = VariableUtilities.preferences.getBool(
              "${LocalCacheKey.isDriverArrivedToLocation}Arrived${widget.deliveryOrdersArgs.resultList.salesOrderId}") ??
          false;
      if (isDriverArrived) {
        deliveryOrdersProvider.isDriverArrived = isDriverArrived;
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
        builder: (context, DeliveryOrdersProvider deliveryOrdersProvider, __) {
      return Stack(
        children: [
          Scaffold(
            body: Container(
              color: ColorUtils.primaryColor,
              child: SafeArea(
                child: Column(
                  children: [
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
                            LocaleKeys.delivery_orders.tr(),
                            style: FontUtilities.h20(
                                fontColor: ColorUtils.whiteColor),
                          ),
                          const Spacer(),
                          (widget.deliveryOrdersArgs.resultList
                                              .deliveryAddressCoordinates.lat !=
                                          0.0 ||
                                      widget
                                              .deliveryOrdersArgs
                                              .resultList
                                              .deliveryAddressCoordinates
                                              .long !=
                                          0.0) &&
                                  deliveryOrdersProvider.isDriverArrived
                              ? IconButton(
                                  icon: Image.asset(AssetUtils.mapIconImage,
                                      height: 25),
                                  onPressed: () {
                                    launchMap(
                                        lat: widget
                                            .deliveryOrdersArgs
                                            .resultList
                                            .deliveryAddressCoordinates
                                            .lat,
                                        long: widget
                                            .deliveryOrdersArgs
                                            .resultList
                                            .deliveryAddressCoordinates
                                            .long);
                                    // MixpanelManager.trackEvent(
                                    //     eventName: 'ScreenView',
                                    //     properties: {'Screen': 'MapScreen'});
                                    // Navigator.pushNamed(
                                    //     context, RouteUtilities.mapScreen);
                                  },
                                )
                              : const SizedBox()
                        ]),
                      ),
                    ),
                    Expanded(
                        child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          height: VariableUtilities.screenSize.height,
                          width: VariableUtilities.screenSize.width,
                          decoration: const BoxDecoration(
                              color: ColorUtils.colorEDF1FF,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              )),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 125,
                                width: VariableUtilities.screenSize.width,
                                decoration: const BoxDecoration(
                                    color: ColorUtils.colorF7F9FF,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                    )),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 15.0,
                                      left: 15.0,
                                      right: 15.0,
                                      top: 15.0),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const SizedBox(height: 5),
                                        widget.deliveryOrdersArgs.resultList
                                                    .subResultList.length <=
                                                1
                                            ? Column(
                                                children: [
                                                  const SizedBox(height: 10),
                                                  Text(
                                                    'INV #${widget.deliveryOrdersArgs.resultList.id}',
                                                    maxLines: 2,
                                                    style: FontUtilities.h20(
                                                      fontColor: ColorUtils
                                                          .color3F3E3E,
                                                      fontWeight: FWT.semiBold,
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : const SizedBox(),
                                        Expanded(
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              capitalizeFirstLetter(widget
                                                  .deliveryOrdersArgs
                                                  .resultList
                                                  .store
                                                  .storeName),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                              style: FontUtilities.h16(
                                                fontWeight: FWT.semiBold,
                                                fontColor: ColorUtils
                                                    .color3F3E3E
                                                    .withOpacity(0.5),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ]),
                                ),
                              ),
                              widget.deliveryOrdersArgs.resultList.subResultList
                                          .length <=
                                      1
                                  ? const SizedBox()
                                  : Container(
                                      width: VariableUtilities.screenSize.width,
                                      color: ColorUtils.colorDDE4FE,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20.0, vertical: 5),
                                        child: Text(
                                            LocaleKeys.this_delivery_contains
                                                .plural(widget
                                                    .deliveryOrdersArgs
                                                    .resultList
                                                    .subResultList
                                                    .length),
                                            maxLines: 2,
                                            style: FontUtilities.h15(
                                                fontColor:
                                                    ColorUtils.color828282)),
                                      ),
                                    ),
                              const SizedBox(height: 15),
                              Expanded(
                                child: SingleChildScrollView(
                                  physics: const BouncingScrollPhysics(),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 25.0),
                                        child: Text(
                                          LocaleKeys.items.tr(),
                                          style: FontUtilities.h20(
                                            fontColor: ColorUtils.colorAAAAAA,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 18.0, vertical: 10.0),
                                        child: ListView.builder(
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount: widget
                                                .deliveryOrdersArgs
                                                .resultList
                                                .subResultList
                                                .length,
                                            itemBuilder: (context, index) {
                                              return Padding(
                                                padding: EdgeInsets.only(
                                                    top: index == 0
                                                        ? 5.0
                                                        : 25.0),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      color:
                                                          ColorUtils.whiteColor,
                                                      boxShadow: [
                                                        BoxShadow(
                                                            color: const Color(
                                                                    0XFF979FAE)
                                                                .withOpacity(
                                                                    .10),
                                                            blurRadius: 8,
                                                            spreadRadius: 0,
                                                            offset:
                                                                const Offset(
                                                                    0, 0))
                                                      ],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 15.0,
                                                        vertical: 20.0),
                                                    child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          widget
                                                                      .deliveryOrdersArgs
                                                                      .resultList
                                                                      .subResultList
                                                                      .length <=
                                                                  1
                                                              ? const SizedBox()
                                                              : Column(
                                                                  children: [
                                                                    Text(
                                                                        '${LocaleKeys.invoice.tr()} #${widget.deliveryOrdersArgs.resultList.subResultList[index].id}',
                                                                        style: FontUtilities.h20(
                                                                            fontColor:
                                                                                ColorUtils.primaryColor,
                                                                            fontWeight: FWT.semiBold)),
                                                                    const SizedBox(
                                                                        height:
                                                                            15),
                                                                  ],
                                                                ),
                                                          ListView.builder(
                                                              physics:
                                                                  const NeverScrollableScrollPhysics(),
                                                              shrinkWrap: true,
                                                              itemCount: widget
                                                                  .deliveryOrdersArgs
                                                                  .resultList
                                                                  .subResultList[
                                                                      index]
                                                                  .itemList
                                                                  .length,
                                                              itemBuilder: (context,
                                                                  insideIndex) {
                                                                return Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Column(
                                                                        children: [
                                                                          Row(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.start,
                                                                            children: [
                                                                              Expanded(
                                                                                child: Text(
                                                                                  capitalizeFirstLetter(widget.deliveryOrdersArgs.resultList.subResultList[index].itemList[insideIndex].productName),
                                                                                  maxLines: 2,
                                                                                  overflow: TextOverflow.ellipsis,
                                                                                  style: FontUtilities.h18(
                                                                                    fontColor: ColorUtils.color3F3E3E,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              const SizedBox(width: 10),
                                                                              Text(
                                                                                '${LocaleKeys.qty.tr()} - ${widget.deliveryOrdersArgs.resultList.subResultList[index].itemList[insideIndex].qty} ',
                                                                                style: FontUtilities.h18(
                                                                                  fontColor: ColorUtils.colorAAAAAA,
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          widget.deliveryOrdersArgs.resultList.subResultList[index].itemList.length - 1 == insideIndex
                                                                              ? const SizedBox()
                                                                              : Column(
                                                                                  children: [
                                                                                    const SizedBox(height: 15),
                                                                                    Container(
                                                                                      height: 1,
                                                                                      color: ColorUtils.colorC8D3E7,
                                                                                    ),
                                                                                    const SizedBox(height: 15),
                                                                                  ],
                                                                                )
                                                                        ]),
                                                                  ],
                                                                );
                                                              }),
                                                        ]),
                                                  ),
                                                ),
                                              );
                                            }),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          right: 0,
                          left: 0,
                          top: -28,
                          child: CircleAvatar(
                            radius: 30,
                            backgroundColor: ColorUtils.colorEDF1FF,
                            child: Image.asset(
                              AssetUtils.arrivedIconImage,
                              color: ColorUtils.color0439FE,
                              height: 26,
                            ),
                          ),
                        )
                      ],
                    ))
                  ],
                ),
              ),
            ),
            floatingActionButton: (widget.deliveryOrdersArgs.resultList
                            .deliveryAddressCoordinates.lat ==
                        0.0 &&
                    widget.deliveryOrdersArgs.resultList
                            .deliveryAddressCoordinates.long ==
                        0.0)
                ? FloatingActionButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
                    onPressed: () async {
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
                          return;
                        }
                      }
                      if (deliveryOrdersProvider.isDriverArrived) {
                        Fluttertoast.showToast(
                            msg: LocaleKeys
                                .your_current_location_is_already_updated
                                .tr());
                        return;
                      }
                      List<ResultList> subResultList =
                          widget.deliveryOrdersArgs.resultList.subResultList;

                      for (int i = 0; i < subResultList.length; i++) {
                        // widget.deliveryOrdersArgs.resultList =
                        await deliveryOrdersProvider.updateStoreLocation(
                          context,
                          id: subResultList[i].id,
                          salesOrderId: subResultList[i].salesOrderId,
                          storeId: subResultList[i].store.id,
                        );
                      }
                    },
                    elevation: 0,
                    backgroundColor: ColorUtils.primaryColor,
                    child: Image.asset(AssetUtils.syncLocationIconImage,
                        height: 22),
                  )
                : const SizedBox(),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(children: [
                Expanded(
                  child: PrimaryButton(
                      width: VariableUtilities.screenSize.width / 2,
                      onTap: () {
                        Navigator.pop(context);
                      },
                      title: LocaleKeys.cancel.tr()),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: PrimaryButton(
                      borderColor: ColorUtils.color0D1F3D,
                      titleColor: ColorUtils.color0D1F3D,
                      textStyle: (deliveryOrdersProvider.isDriverArrived == false &&
                              (widget.deliveryOrdersArgs.resultList.deliveryAddressCoordinates.lat ==
                                      0.0 &&
                                  widget.deliveryOrdersArgs.resultList
                                          .deliveryAddressCoordinates.long ==
                                      0.0))
                          ? FontUtilities.h18(
                              fontColor: ColorUtils.whiteColor,
                              fontWeight: FWT.semiBold)
                          : FontUtilities.h18(
                              fontColor: ColorUtils.color0D1F3D,
                              fontWeight: FWT.semiBold),
                      color: (deliveryOrdersProvider.isDriverArrived == false &&
                              (widget.deliveryOrdersArgs.resultList
                                          .deliveryAddressCoordinates.lat ==
                                      0.0 &&
                                  widget.deliveryOrdersArgs.resultList
                                          .deliveryAddressCoordinates.long ==
                                      0.0))
                          ? ColorUtils.colorC52828
                          : Colors.transparent,
                      width: VariableUtilities.screenSize.width / 2,
                      onTap: () async {
                        if (deliveryOrdersProvider.isDriverArrived ||
                            (widget.deliveryOrdersArgs.resultList
                                        .deliveryAddressCoordinates.lat !=
                                    0.0 &&
                                widget.deliveryOrdersArgs.resultList
                                        .deliveryAddressCoordinates.long !=
                                    0.0)) {
                          List<ResultList> subResultList = widget
                              .deliveryOrdersArgs.resultList.subResultList;
                          print(
                              "subResultList.length --> ${subResultList.length}");
                          for (int i = 0; i < subResultList.length; i++) {
                            await deliveryOrdersProvider.updateDistanceTravel(
                                context,
                                widget.deliveryOrdersArgs.resultList
                                    .salesOrderId);
                          }

                          for (int i = 0; i < subResultList.length; i++) {
                            await deliveryOrdersProvider.updateSalesOrders(
                              timestamp: DateTime.now().millisecondsSinceEpoch,
                              isCallFromOffline: false,
                              context: context,
                              isLastIndex: i == subResultList.length - 1,
                              salesOrderId: subResultList[i].salesOrderId,
                            );
                          }

                          OrderReviewProvider orderReviewProvider =
                              Provider.of(context, listen: false);
                          orderReviewProvider.currentPage = 0;
                          DeliveryOrdersSummaryProvider
                              deliveryOrdersSummaryProvider =
                              Provider.of(context, listen: false);
                          deliveryOrdersSummaryProvider.currentPage = 0;
                          ProofOfDeliveryProvider proofOfDeliveryProvider =
                              Provider.of(context, listen: false);
                          proofOfDeliveryProvider.currentPage = 0;
                          PaymentProvider paymentProvider =
                              Provider.of(context, listen: false);
                          paymentProvider.currentPage = 0;

                          MixpanelManager.trackEvent(
                              eventName: 'ScreenView',
                              properties: {
                                'Screen': 'DeliveryOrdersDetailsScreen'
                              });
                          Navigator.pushNamed(context,
                              RouteUtilities.deliveryOrdersDetailsScreen,
                              arguments: DeliveryOrdersArgs(
                                  timestamp:
                                      DateTime.now().millisecondsSinceEpoch,
                                  noOfItems:
                                      widget.deliveryOrdersArgs.noOfItems,
                                  resultList:
                                      widget.deliveryOrdersArgs.resultList));
                          return;
                        } else {
                          Fluttertoast.showToast(
                              msg: LocaleKeys
                                  .you_are_not_at_your_destination_location
                                  .tr());
                        }
                      },
                      title: LocaleKeys.arrived.tr()),
                )
              ]),
            ),
          ),
          Visibility(
              visible: (deliveryOrdersProvider
                          .getSalesOrderListByStatusResponse.isRight &&
                      deliveryOrdersProvider.getSalesOrderListByStatusResponse
                          .right is NoDataFoundException) ||
                  (deliveryOrdersProvider
                          .updateStoreLocationModelResponse.isRight &&
                      deliveryOrdersProvider.updateStoreLocationModelResponse
                          .right is NoDataFoundException) ||
                  (deliveryOrdersProvider.updateDistanceTravelModel.isRight &&
                      deliveryOrdersProvider.updateDistanceTravelModel.right
                          is NoDataFoundException),
              child: CustomCircularProgressIndicator()),
        ],
      );
    });
  }
}
