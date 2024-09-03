import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:parsel_flutter/src/mvp/dashboard/home/delivery_orders/args/delivery_orders_args.dart';
import 'package:parsel_flutter/src/mvp/dashboard/home/delivery_orders_summary/args/delivery_summary_args.dart';
import 'package:parsel_flutter/src/mvp/dashboard/home/delivery_orders_summary/provider/delivery_orders_summary_provider.dart';
import 'package:parsel_flutter/src/mvp/dashboard/home/in_progress/model/get_sales_order_list_by_status_model.dart';
import 'package:parsel_flutter/src/mvp/dashboard/home/return_orders/args/return_order_args.dart';
import 'package:parsel_flutter/src/mvp/dashboard/home/return_orders/provider/return_orders_provider.dart';
import 'package:parsel_flutter/src/widget/widget.dart';
import 'package:parsel_flutter/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class DeliveryOrdersSummaryScreen extends StatefulWidget {
  const DeliveryOrdersSummaryScreen(
      {Key? key, required this.deliverySummaryArgs})
      : super(key: key);
  final DeliverySummaryArgs deliverySummaryArgs;

  @override
  State<DeliveryOrdersSummaryScreen> createState() =>
      _DeliveryOrdersSummaryScreenState();
}

class _DeliveryOrdersSummaryScreenState
    extends State<DeliveryOrdersSummaryScreen> {
  final PageController _pageController = PageController();

  double totalInvoiceValue = 0;
  int totalDelivered = 0;
  int totalReturned = 0;
  int totalQty = 0;
  late AutoScrollController controller;

  @override
  void initState() {
    controller = AutoScrollController(axis: Axis.horizontal);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      DeliveryOrdersSummaryProvider deliveryOrdersSummaryProvider =
          Provider.of(context, listen: false);

      deliveryOrdersSummaryProvider.currentPage = 0;
      for (int i = 0;
          i < widget.deliverySummaryArgs.resultList.subResultList.length;
          i++) {
        totalInvoiceValue = 0;
        totalDelivered = 0;
        totalReturned = 0;
        totalQty = 0;
        List<ItemList> itemList =
            widget.deliverySummaryArgs.resultList.subResultList[i].itemList;
        for (int j = 0; j < itemList.length; j++) {
          totalInvoiceValue = totalInvoiceValue +
              ((itemList[j].unitPrice * itemList[j].qty) -
                  (itemList[j].unitPrice *
                      int.parse(itemList[j].returnItemQtyController!.text)));
          totalDelivered = totalDelivered +
              (itemList[j].qty -
                  int.parse(itemList[j].returnItemQtyController!.text));
          totalReturned = totalReturned +
              int.parse(itemList[j].returnItemQtyController!.text);
          totalQty = totalQty + itemList[j].qty;
        }

        widget.deliverySummaryArgs.resultList.subResultList[i].invoiceValue =
            '${totalInvoiceValue.ceil()}';
        widget.deliverySummaryArgs.resultList.subResultList[i].totalQty =
            '$totalQty';
        widget.deliverySummaryArgs.resultList.subResultList[i].deliveredCount =
            '$totalDelivered';
        widget.deliverySummaryArgs.resultList.subResultList[i].returnCount =
            '$totalReturned';
        widget.deliverySummaryArgs.resultList.subResultList[i].noOfBoxesCount =
            '${widget.deliverySummaryArgs.noOfItems}';
        widget.deliverySummaryArgs.resultList.subResultList[i].skuTemperature =
            '${widget.deliverySummaryArgs.resultList.subResultList[i].temperature}';
        widget.deliverySummaryArgs.resultList.subResultList[i].remarks =
            'Delivered Successful';
        widget.deliverySummaryArgs.resultList.subResultList[i].itemList =
            itemList;
      }
      deliveryOrdersSummaryProvider.isDriverArrived = false;
      deliveryOrdersSummaryProvider.currentPage = 0;
      bool isDriverArrived = VariableUtilities.preferences.getBool(
              "${LocalCacheKey.isDriverArrivedToLocation}Arrived${widget.deliverySummaryArgs.resultList.salesOrderId}") ??
          false;
      if (isDriverArrived) {
        deliveryOrdersSummaryProvider.isDriverArrived = isDriverArrived;
      }
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context,
        DeliveryOrdersSummaryProvider deliveryOrdersSummaryProvider, __) {
      return Scaffold(
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
                        LocaleKeys.deliver_summary.tr(),
                        style:
                            FontUtilities.h20(fontColor: ColorUtils.whiteColor),
                      ),
                      const Spacer(),
                      (widget.deliverySummaryArgs.resultList
                                          .deliveryAddressCoordinates.lat !=
                                      0.0 ||
                                  widget.deliverySummaryArgs.resultList
                                          .deliveryAddressCoordinates.long !=
                                      0.0) &&
                              deliveryOrdersSummaryProvider.isDriverArrived
                          ? IconButton(
                              icon: Image.asset(AssetUtils.mapIconImage,
                                  height: 25),
                              onPressed: () {
                                launchMap(
                                    lat: widget.deliverySummaryArgs.resultList
                                        .deliveryAddressCoordinates.lat,
                                    long: widget.deliverySummaryArgs.resultList
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const SizedBox(height: 5),
                                    widget.deliverySummaryArgs.resultList
                                                .subResultList.length <=
                                            1
                                        ? Column(
                                            children: [
                                              const SizedBox(height: 10),
                                              Text(
                                                'INV #${widget.deliverySummaryArgs.resultList.id}',
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
                                              .deliverySummaryArgs
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
                          widget.deliverySummaryArgs.resultList.subResultList
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
                                                .deliverySummaryArgs
                                                .resultList
                                                .subResultList
                                                .length),
                                        maxLines: 2,
                                        style: FontUtilities.h15(
                                            fontColor: ColorUtils.color828282)),
                                  ),
                                ),
                          widget.deliverySummaryArgs.resultList.subResultList
                                      .length <=
                                  1
                              ? const SizedBox(height: 15)
                              : Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25.0, vertical: 15.0),
                                  child: SizedBox(
                                    height: 46,
                                    child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        shrinkWrap: true,
                                        controller: controller,
                                        itemCount: widget.deliverySummaryArgs
                                            .resultList.subResultList.length,
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
                                                  deliveryOrdersSummaryProvider
                                                      .currentPage = index;
                                                  _pageController
                                                      .jumpToPage(index);
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      color: deliveryOrdersSummaryProvider
                                                                  .currentPage ==
                                                              index
                                                          ? ColorUtils
                                                              .whiteColor
                                                          : ColorUtils
                                                              .colorE7E7E7,
                                                      border: Border.all(
                                                          color: deliveryOrdersSummaryProvider
                                                                      .currentPage ==
                                                                  index
                                                              ? ColorUtils
                                                                  .primaryColor
                                                              : Colors
                                                                  .transparent),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5)),
                                                  constraints:
                                                      const BoxConstraints(
                                                          minWidth: 145,
                                                          minHeight: 46),
                                                  child: Center(
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 15.0,
                                                          vertical: 5.0),
                                                      child: Text(
                                                        'INV #${widget.deliverySummaryArgs.resultList.subResultList[index].id}',
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
                                  ),
                                ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 5),
                              child: Container(
                                width: VariableUtilities.screenSize.width,
                                decoration: const BoxDecoration(
                                    color: ColorUtils.whiteColor,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                    )),
                                child: PageView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    controller: _pageController,
                                    itemCount: widget.deliverySummaryArgs
                                        .resultList.subResultList.length,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15.0, vertical: 15),
                                        child: SingleChildScrollView(
                                          physics:
                                              const BouncingScrollPhysics(),
                                          child: Column(children: [
                                            InputField(
                                                readOnly: true,
                                                controller: TextEditingController(
                                                    text:
                                                        '₹ ${widget.deliverySummaryArgs.resultList.subResultList[deliveryOrdersSummaryProvider.currentPage].invoiceValue}/-'),
                                                label: LocaleKeys.invoice_value
                                                    .tr(),
                                                hintText: LocaleKeys
                                                    .enter_invoice_value
                                                    .tr()),
                                            InputField(
                                                readOnly: true,
                                                controller: TextEditingController(
                                                    text: widget
                                                        .deliverySummaryArgs
                                                        .resultList
                                                        .subResultList[
                                                            deliveryOrdersSummaryProvider
                                                                .currentPage]
                                                        .totalQty),
                                                label: LocaleKeys.qty.tr(),
                                                hintText: LocaleKeys.qty.tr()),
                                            InputField(
                                                readOnly: true,
                                                controller: TextEditingController(
                                                    text: widget
                                                        .deliverySummaryArgs
                                                        .resultList
                                                        .subResultList[
                                                            deliveryOrdersSummaryProvider
                                                                .currentPage]
                                                        .deliveredCount),
                                                label:
                                                    LocaleKeys.delivered.tr(),
                                                hintText: LocaleKeys
                                                    .enter_delivered_value
                                                    .tr()),
                                            InputField(
                                                readOnly: true,
                                                controller: TextEditingController(
                                                    text: widget
                                                        .deliverySummaryArgs
                                                        .resultList
                                                        .subResultList[
                                                            deliveryOrdersSummaryProvider
                                                                .currentPage]
                                                        .returnCount),
                                                label: LocaleKeys.returned.tr(),
                                                hintText: LocaleKeys
                                                    .enter_returned_value
                                                    .tr()),
                                            InputField(
                                                readOnly: true,
                                                controller: TextEditingController(
                                                    text: widget
                                                        .deliverySummaryArgs
                                                        .resultList
                                                        .subResultList[
                                                            deliveryOrdersSummaryProvider
                                                                .currentPage]
                                                        .noOfBoxesCount),
                                                label:
                                                    LocaleKeys.no_of_boxes.tr(),
                                                hintText: LocaleKeys
                                                    .enter_no_of_boxes
                                                    .tr()),
                                            InputField(
                                                readOnly: true,
                                                controller: TextEditingController(
                                                    text: widget
                                                        .deliverySummaryArgs
                                                        .resultList
                                                        .subResultList[
                                                            deliveryOrdersSummaryProvider
                                                                .currentPage]
                                                        .skuTemperature),
                                                label: LocaleKeys
                                                    .sku_temperature
                                                    .tr(),
                                                hintText: LocaleKeys
                                                    .enter_temperature_value
                                                    .tr()),
                                            InputField(
                                                controller: TextEditingController(
                                                    text: widget
                                                        .deliverySummaryArgs
                                                        .resultList
                                                        .subResultList[
                                                            deliveryOrdersSummaryProvider
                                                                .currentPage]
                                                        .remarks),
                                                label: LocaleKeys.remarks.tr(),
                                                hintText: LocaleKeys
                                                    .enter_remarks
                                                    .tr()),
                                          ]),
                                        ),
                                      );
                                    }),
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
        bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(8.0),
            child: PrimaryButton(
                width: VariableUtilities.screenSize.width,
                onTap: () async {
                  List<ResultList> subResultList =
                      widget.deliverySummaryArgs.resultList.subResultList;
                  bool isReturnsAvailable = false;
                  for (int i = 0; i < subResultList.length; i++) {
                    if (subResultList[i].returnItemsList.isNotEmpty) {
                      isReturnsAvailable = true;
                      break;
                    }
                  }
                  print(
                      '$isReturnsAvailable ${widget.deliverySummaryArgs.navigateFrom}');
                  if (widget.deliverySummaryArgs.resultList.subResultList
                              .length -
                          1 !=
                      _pageController.page!.toInt()) {
                    await _pageController.nextPage(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeIn);
                    deliveryOrdersSummaryProvider.currentPage =
                        int.parse('${_pageController.page!.toInt()}');

                    await controller.scrollToIndex(
                        deliveryOrdersSummaryProvider.currentPage,
                        preferPosition: AutoScrollPosition.middle);

                    return;
                  }

                  if (widget.deliverySummaryArgs.navigateFrom ==
                      NavigateFrom.returnOrders) {
                    MixpanelManager.trackEvent(
                        eventName: 'ScreenView',
                        properties: {'Screen': 'ProofOfDeliveryScreen'});
                    Navigator.pushNamed(
                        context, RouteUtilities.proofOfDeliveryScreen,
                        arguments: DeliveryOrdersArgs(
                            timestamp: widget.deliverySummaryArgs.timestamp,
                            noOfItems: widget.deliverySummaryArgs.noOfItems,
                            resultList: widget.deliverySummaryArgs.resultList));
                  } else {
                    if (widget.deliverySummaryArgs.navigateFrom ==
                            NavigateFrom.orderReview &&
                        !isReturnsAvailable) {
                      MixpanelManager.trackEvent(
                          eventName: 'ScreenView',
                          properties: {'Screen': 'ProofOfDeliveryScreen'});
                      Navigator.pushNamed(
                          context, RouteUtilities.proofOfDeliveryScreen,
                          arguments: DeliveryOrdersArgs(
                              timestamp: widget.deliverySummaryArgs.timestamp,
                              noOfItems: widget.deliverySummaryArgs.noOfItems,
                              resultList:
                                  widget.deliverySummaryArgs.resultList));
                    } else {
                      MixpanelManager.trackEvent(
                          eventName: 'ScreenView',
                          properties: {'Screen': 'ReturnOrdersScreen'});

                      Navigator.pushNamed(
                          context, RouteUtilities.returnOrdersScreen,
                          arguments: ReturnOrdersArgs(
                              timestamp: widget.deliverySummaryArgs.timestamp,
                              navigateFrom: NavigateFrom.deliverSummary,
                              noOfItems: widget.deliverySummaryArgs.noOfItems,
                              resultList:
                                  widget.deliverySummaryArgs.resultList));
                    }
                  }
                },
                title:
                    widget.deliverySummaryArgs.resultList.subResultList.length -
                                1 ==
                            deliveryOrdersSummaryProvider.currentPage
                        ? LocaleKeys.submit.tr()
                        : LocaleKeys.next.tr())),
      );
    });
  }
}
