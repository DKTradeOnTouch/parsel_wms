import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:parsel_flutter/src/mvp/dashboard/home/delivery_orders/args/delivery_orders_args.dart';
import 'package:parsel_flutter/src/mvp/dashboard/home/delivery_orders_summary/args/delivery_summary_args.dart';
import 'package:parsel_flutter/src/mvp/dashboard/home/order_review/provider/order_review_provider.dart';
import 'package:parsel_flutter/src/mvp/dashboard/home/return_orders/args/return_order_args.dart';
import 'package:parsel_flutter/src/widget/widget.dart';
import 'package:parsel_flutter/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class OrderReviewScreen extends StatefulWidget {
  const OrderReviewScreen({Key? key, required this.deliveryOrdersArgs})
      : super(key: key);
  final DeliveryOrdersArgs deliveryOrdersArgs;

  @override
  State<OrderReviewScreen> createState() => _OrderReviewScreenState();
}

class _OrderReviewScreenState extends State<OrderReviewScreen> {
  final PageController _pageController = PageController();
  // final ScrollController _scrollController = ScrollController();
  TextEditingController itemNameController =
      TextEditingController(text: 'Baskin robins vania Icecream');
  TextEditingController returnQtyController = TextEditingController(text: '5');
  TextEditingController totalQtyController = TextEditingController(text: '10');

  late AutoScrollController controller;

  List<String> returnReasonsList = [
    "Select Reason for Return",
    "Invoice canceled",
    "Damaged",
    "Melted",
    "Double Billing",
    "Expired Stock",
    "Late Delivery",
    "Loading Mistake",
    "Near Expiry",
    "No Ackw/No GRN",
    "No Cash",
    "No Delivery Attempt",
    "No Loading",
    "No Order By Party",
    "No Space",
    "No Stock",
    "Old Return",
    "Rate Diff",
    "Route Cancelled",
    "Vehicle Salesman Mistake",
    "Sample",
    "Shop Closed",
    "Short Received",
    "Stock Rtn To Co",
    "Wrong Order",
    "Wrong Billing",
    "Wrong Route",
    "Wrong Address"
  ];

  BoxConstraints? boxConstraints;
  @override
  void initState() {
    controller = AutoScrollController(axis: Axis.horizontal);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      OrderReviewProvider orderReviewProvider =
          Provider.of(context, listen: false);
      orderReviewProvider.updateResultList(
          list: widget.deliveryOrdersArgs.resultList);
      orderReviewProvider.isDriverArrived = false;
      orderReviewProvider.currentPage = 0;
      bool isDriverArrived = VariableUtilities.preferences.getBool(
              "${LocalCacheKey.isDriverArrivedToLocation}Arrived${widget.deliveryOrdersArgs.resultList.salesOrderId}") ??
          false;
      if (isDriverArrived) {
        orderReviewProvider.isDriverArrived = isDriverArrived;
      }
    });
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Consumer(builder:
        (context, OrderReviewProvider deliveryOrdersDetailsProvider, __) {
      return Form(
        key: _formKey,
        child: Scaffold(
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
                          LocaleKeys.order_review.tr(),
                          style: FontUtilities.h20(
                              fontColor: ColorUtils.whiteColor),
                        ),
                        const Spacer(),
                        (widget.deliveryOrdersArgs.resultList
                                            .deliveryAddressCoordinates.lat !=
                                        0.0 ||
                                    widget.deliveryOrdersArgs.resultList
                                            .deliveryAddressCoordinates.long !=
                                        0.0) &&
                                deliveryOrdersDetailsProvider.isDriverArrived
                            ? IconButton(
                                icon: Image.asset(AssetUtils.mapIconImage,
                                    height: 25),
                                onPressed: () {
                                  launchMap(
                                      lat: widget.deliveryOrdersArgs.resultList
                                          .deliveryAddressCoordinates.lat,
                                      long: widget.deliveryOrdersArgs.resultList
                                          .deliveryAddressCoordinates.long);
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
                              height: 120,
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
                                                    fontColor:
                                                        ColorUtils.color3F3E3E,
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
                                            maxLines: 5,
                                            style: FontUtilities.h16(
                                              fontWeight: FWT.semiBold,
                                              fontColor: ColorUtils.color3F3E3E
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
                            // const SizedBox(height: 10),
                            deliveryOrdersDetailsProvider.resultList.isLeft
                                ? deliveryOrdersDetailsProvider.resultList.left
                                            .subResultList.length <=
                                        1
                                    ? const SizedBox()
                                    : Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 25.0, vertical: 15.0),
                                        child: SizedBox(
                                          height: 46,
                                          child: ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              controller: controller,
                                              itemCount:
                                                  deliveryOrdersDetailsProvider
                                                      .resultList
                                                      .left
                                                      .subResultList
                                                      .length,
                                              shrinkWrap: true,
                                              itemBuilder: (context, index) {
                                                return AutoScrollTag(
                                                  controller: controller,
                                                  index: index,
                                                  key: ValueKey(index),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 10.0),
                                                    child: InkWell(
                                                      onTap: () {
                                                        deliveryOrdersDetailsProvider
                                                                .currentPage =
                                                            index;
                                                        _pageController.animateToPage(
                                                            index,
                                                            curve:
                                                                Curves.linear,
                                                            duration:
                                                                const Duration(
                                                                    milliseconds:
                                                                        300));
                                                      },
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                            color: deliveryOrdersDetailsProvider.currentPage ==
                                                                    index
                                                                ? ColorUtils
                                                                    .whiteColor
                                                                : ColorUtils
                                                                    .colorE7E7E7,
                                                            border: Border.all(
                                                                color: deliveryOrdersDetailsProvider
                                                                            .currentPage ==
                                                                        index
                                                                    ? ColorUtils
                                                                        .primaryColor
                                                                    : Colors
                                                                        .transparent),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5)),
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
                                                                    vertical:
                                                                        5.0),
                                                            child: Text(
                                                              'INV #${deliveryOrdersDetailsProvider.resultList.left.subResultList[index].id}',
                                                              style: FontUtilities.h20(
                                                                  fontColor:
                                                                      ColorUtils
                                                                          .color3F3E3E,
                                                                  fontWeight: FWT
                                                                      .semiBold),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }),
                                        ),
                                      )
                                : const SizedBox(),
                            Expanded(
                              child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15.0, vertical: 5),
                                  child:
                                      deliveryOrdersDetailsProvider
                                              .resultList.isLeft
                                          ? Column(
                                              children: [
                                                Expanded(
                                                  child: PageView.builder(
                                                      physics:
                                                          const NeverScrollableScrollPhysics(),
                                                      controller:
                                                          _pageController,
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      itemCount:
                                                          deliveryOrdersDetailsProvider
                                                              .resultList
                                                              .left
                                                              .subResultList
                                                              .length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        return Column(
                                                            children: [
                                                              Expanded(
                                                                child: ListView
                                                                    .builder(
                                                                        itemCount: deliveryOrdersDetailsProvider
                                                                            .resultList
                                                                            .left
                                                                            .subResultList[
                                                                                index]
                                                                            .itemList
                                                                            .length,
                                                                        shrinkWrap:
                                                                            true,
                                                                        physics:
                                                                            const BouncingScrollPhysics(),
                                                                        itemBuilder:
                                                                            (context,
                                                                                insidePage) {
                                                                          return Padding(
                                                                            padding:
                                                                                const EdgeInsets.symmetric(vertical: 10.0),
                                                                            child:
                                                                                AnimatedContainer(
                                                                              duration: const Duration(milliseconds: 300),
                                                                              curve: Curves.fastLinearToSlowEaseIn,
                                                                              decoration: BoxDecoration(color: ColorUtils.whiteColor, borderRadius: BorderRadius.circular(20)),
                                                                              child: Padding(
                                                                                padding: const EdgeInsets.all(15.0),
                                                                                child: Column(children: [
                                                                                  InputField(readOnly: true, controller: deliveryOrdersDetailsProvider.resultList.left.subResultList[index].itemList[insidePage].itemNameController!, label: LocaleKeys.item_name.tr(), hintText: LocaleKeys.enter_item_name.tr()),
                                                                                  Row(
                                                                                    children: [
                                                                                      Expanded(
                                                                                        child: InputField(
                                                                                            keyboardType: TextInputType.number,
                                                                                            controller: deliveryOrdersDetailsProvider.resultList.left.subResultList[index].itemList[insidePage].returnItemQtyController!,
                                                                                            validator: (val) {
                                                                                              if (val!.isNotEmpty) {
                                                                                                int totalQty = 0;

                                                                                                try {
                                                                                                  totalQty = int.parse(deliveryOrdersDetailsProvider.resultList.left.subResultList[index].itemList[insidePage].totalQtyController!.text);
                                                                                                } catch (e) {
                                                                                                  return LocaleKeys.enter_valid_returned_qty.tr();
                                                                                                }

                                                                                                if (int.parse(val).isNegative) {
                                                                                                  return LocaleKeys.enter_valid_returned_qty.tr();
                                                                                                }
                                                                                                if (int.parse(val) > totalQty) {
                                                                                                  return LocaleKeys.enter_valid_returned_qty.tr();
                                                                                                }
                                                                                              }
                                                                                              return null;
                                                                                            },
                                                                                            label: LocaleKeys.return_qty.tr(),
                                                                                            hintText: LocaleKeys.enter_return_qty.tr()),
                                                                                      ),
                                                                                      const SizedBox(width: 15),
                                                                                      Expanded(
                                                                                        child: InputField(
                                                                                          readOnly: true,
                                                                                          controller: deliveryOrdersDetailsProvider.resultList.left.subResultList[index].itemList[insidePage].totalQtyController!,
                                                                                          label: LocaleKeys.order_qty.tr(),
                                                                                          hintText: LocaleKeys.enter_item_qty.tr(),
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                  DropDownInputField(
                                                                                      validator: (val) {
                                                                                        if (deliveryOrdersDetailsProvider.resultList.left.subResultList[index].itemList[insidePage].returnItemQtyController!.text == '0') {
                                                                                          return null;
                                                                                        }

                                                                                        if (val!.toLowerCase() == 'Select reason for return'.toLowerCase()) {
                                                                                          return 'Please select at least one reason';
                                                                                        }
                                                                                        return null;
                                                                                      },
                                                                                      selectedValue: deliveryOrdersDetailsProvider.resultList.left.subResultList[index].itemList[insidePage].selectedReturnReason,
                                                                                      items: returnReasonsList.map((e) => DropdownMenuItem<String>(value: e, child: Text(e))).toList(),
                                                                                      onChanged: (val) {
                                                                                        deliveryOrdersDetailsProvider.updateReturnReason(productCode: deliveryOrdersDetailsProvider.resultList.left.subResultList[index].itemList[insidePage].productCode, returnReason: val!);
                                                                                      },
                                                                                      label: LocaleKeys.select_reason_for_return.tr(),
                                                                                      hintText: LocaleKeys.select_reason_for_return.tr())
                                                                                ]),
                                                                              ),
                                                                            ),
                                                                          );
                                                                        }),
                                                              )
                                                            ]);
                                                      }),
                                                ),
                                              ],
                                            )
                                          : const SizedBox()),
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
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(children: [
              Expanded(
                child: PrimaryButton(
                    width: VariableUtilities.screenSize.width / 2,
                    onTap: () {
                      // Navigator.pop(context);
                      final _formKey = GlobalKey<FormState>();
                      MixpanelManager.trackEvent(
                          eventName: 'OpenDialog',
                          properties: {'Dialog': 'FullReturnDialog'});

                      showDialog(
                          context: context,
                          builder: (context) {
                            return Form(
                              key: _formKey,
                              child: FullReturnDialog(
                                rejectOnTap: () {
                                  Navigator.pop(context);
                                },
                                rejectTitle: LocaleKeys.cancel.tr(),
                                imageUrl:
                                    AssetUtils.startTripContainerIconImage,
                                title: 'Full Return Order',
                                child: DropDownInputField(
                                    validator: (val) {
                                      if (val!.toLowerCase() ==
                                          'Select reason for return'
                                              .toLowerCase()) {
                                        return 'Please select at least one reason';
                                      }
                                      return null;
                                    },
                                    selectedValue: deliveryOrdersDetailsProvider
                                        .selectedReturnReason,
                                    items: returnReasonsList
                                        .map((e) => DropdownMenuItem<String>(
                                            value: e, child: Text(e)))
                                        .toList(),
                                    onChanged: (val) {
                                      deliveryOrdersDetailsProvider
                                          .selectedReturnReason = val!;
                                    },
                                    label: LocaleKeys.select_reason_for_return
                                        .tr(),
                                    hintText: LocaleKeys
                                        .select_reason_for_return
                                        .tr()),
                                submitTitle: LocaleKeys.ok.tr(),
                                submitOnTap: () async {
                                  if (_formKey.currentState!.validate()) {
                                    deliveryOrdersDetailsProvider
                                        .updateReturnReason(
                                            updateAll: true,
                                            productCode: '',
                                            returnReason:
                                                deliveryOrdersDetailsProvider
                                                    .selectedReturnReason);
                                    Navigator.pop(context);
                                    if (widget.deliveryOrdersArgs.resultList
                                            .subResultList.length <=
                                        1) {
                                      deliveryOrdersDetailsProvider
                                          .updateSalesOrderItemList();
                                      deliveryOrdersDetailsProvider
                                          .updateReturnedItemList(context);
                                      MixpanelManager.trackEvent(
                                          eventName: 'ScreenView',
                                          properties: {
                                            'Screen': 'ReturnOrdersScreen'
                                          });

                                      Navigator.pushNamed(context,
                                          RouteUtilities.returnOrdersScreen,
                                          arguments: ReturnOrdersArgs(
                                              timestamp: widget
                                                  .deliveryOrdersArgs.timestamp,
                                              navigateFrom:
                                                  NavigateFrom.orderReview,
                                              noOfItems: widget
                                                  .deliveryOrdersArgs.noOfItems,
                                              resultList: widget
                                                  .deliveryOrdersArgs
                                                  .resultList));
                                      return;
                                    }

                                    if (widget.deliveryOrdersArgs.resultList
                                                .subResultList.length -
                                            1 !=
                                        _pageController.page!.toInt()) {
                                      await _pageController.nextPage(
                                          duration:
                                              const Duration(milliseconds: 600),
                                          curve: Curves.easeIn);

                                      deliveryOrdersDetailsProvider
                                              .currentPage =
                                          int.parse(
                                              '${_pageController.page!.toInt()}');

                                      await controller.scrollToIndex(
                                          deliveryOrdersDetailsProvider
                                              .currentPage,
                                          preferPosition:
                                              AutoScrollPosition.middle);

                                      return;
                                    }
                                    if (widget.deliveryOrdersArgs.resultList
                                                .subResultList.length -
                                            1 ==
                                        _pageController.page!.toInt()) {
                                      deliveryOrdersDetailsProvider
                                          .updateSalesOrderItemList();
                                      deliveryOrdersDetailsProvider
                                          .updateReturnedItemList(context);
                                      MixpanelManager.trackEvent(
                                          eventName: 'ScreenView',
                                          properties: {
                                            'Screen': 'ReturnOrdersScreen'
                                          });

                                      Navigator.pushNamed(context,
                                          RouteUtilities.returnOrdersScreen,
                                          arguments: ReturnOrdersArgs(
                                              timestamp: widget
                                                  .deliveryOrdersArgs.timestamp,
                                              navigateFrom:
                                                  NavigateFrom.orderReview,
                                              noOfItems: widget
                                                  .deliveryOrdersArgs.noOfItems,
                                              resultList: widget
                                                  .deliveryOrdersArgs
                                                  .resultList));
                                    }
                                  }

                                  // Navigator.pushNamed(context,
                                  //     RouteUtilities.deliveryOrdersSummaryScreen,
                                  //     arguments: DeliveryOrdersArgs(
                                  //         resultList: widget
                                  //             .deliveryOrdersArgs.resultList));
                                },
                              ),
                            );
                          }).then((value) {
                        MixpanelManager.trackEvent(
                            eventName: 'CloseDialog',
                            properties: {'Dialog': 'FullReturnDialog'});
                      });
                    },
                    title: LocaleKeys.full_return.tr()),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: PrimaryButton(
                    borderColor: ColorUtils.color0D1F3D,
                    titleColor: ColorUtils.color0D1F3D,
                    textStyle: FontUtilities.h18(
                        fontColor: ColorUtils.color0D1F3D,
                        fontWeight: FWT.semiBold),
                    color: Colors.transparent,
                    width: VariableUtilities.screenSize.width / 2,
                    onTap: () async {
                      if (!_formKey.currentState!.validate()) {
                        Fluttertoast.showToast(
                            msg: LocaleKeys.please_enter_valid_value.tr());
                        return;
                      }

                      if (widget.deliveryOrdersArgs.resultList.subResultList
                                  .length -
                              1 !=
                          _pageController.page!.toInt()) {
                        await _pageController.nextPage(
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeIn);

                        deliveryOrdersDetailsProvider.currentPage =
                            int.parse('${_pageController.page!.toInt()}');

                        await controller.scrollToIndex(
                            deliveryOrdersDetailsProvider.currentPage,
                            preferPosition: AutoScrollPosition.middle);

                        return;
                      }

                      MixpanelManager.trackEvent(
                          eventName: 'OpenDialog',
                          properties: {'Dialog': 'DeliverOrderDialog'});
                      showDialog(
                          context: context,
                          builder: (context) {
                            return StartTripDialog(
                              imageUrl: AssetUtils.startTripContainerIconImage,
                              title: LocaleKeys.deliver_order.tr(),
                              subTitle:
                                  LocaleKeys.arrived_to_customer_location.tr(),
                              submitTitle: LocaleKeys.ok.tr(),
                              submitOnTap: () {
                                Navigator.pop(context);
                                deliveryOrdersDetailsProvider
                                    .updateSalesOrderItemList();
                                deliveryOrdersDetailsProvider
                                    .updateReturnedItemList(context);
                                MixpanelManager.trackEvent(
                                    eventName: 'ScreenView',
                                    properties: {
                                      'Screen': 'DeliveryOrdersSummaryScreen'
                                    });

                                Navigator.pushNamed(context,
                                    RouteUtilities.deliveryOrdersSummaryScreen,
                                    arguments: DeliverySummaryArgs(
                                        navigateFrom: NavigateFrom.orderReview,
                                        timestamp:
                                            widget.deliveryOrdersArgs.timestamp,
                                        noOfItems:
                                            widget.deliveryOrdersArgs.noOfItems,
                                        resultList: widget
                                            .deliveryOrdersArgs.resultList));
                              },
                              rejectTitle: LocaleKeys.cancel.tr(),
                              rejectOnTap: () {
                                Navigator.pop(context);
                              },
                            );
                          }).then((value) {
                        MixpanelManager.trackEvent(
                            eventName: 'CloseDialog',
                            properties: {'Dialog': 'DeliverOrderDialog'});
                      });
                    },
                    title: LocaleKeys.deliver.tr()),
              )
            ]),
          ),
        ),
      );
    });
  }
}
