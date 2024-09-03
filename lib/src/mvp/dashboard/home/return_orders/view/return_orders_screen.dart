import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:parsel_flutter/src/mvp/dashboard/home/delivery_orders/args/delivery_orders_args.dart';
import 'package:parsel_flutter/src/mvp/dashboard/home/delivery_orders_summary/args/delivery_summary_args.dart';
import 'package:parsel_flutter/src/mvp/dashboard/home/in_progress/model/get_sales_order_list_by_status_model.dart';
import 'package:parsel_flutter/src/mvp/dashboard/home/return_orders/args/return_order_args.dart';
import 'package:parsel_flutter/src/mvp/dashboard/home/return_orders/provider/return_orders_provider.dart';
import 'package:parsel_flutter/src/widget/widget.dart';
import 'package:parsel_flutter/utils/utils.dart';
import 'package:provider/provider.dart';

class ReturnOrdersScreen extends StatefulWidget {
  const ReturnOrdersScreen({Key? key, required this.returnOrdersArgs})
      : super(key: key);
  final ReturnOrdersArgs returnOrdersArgs;

  @override
  State<ReturnOrdersScreen> createState() => _ReturnOrdersScreenState();
}

class _ReturnOrdersScreenState extends State<ReturnOrdersScreen> {
  final TextEditingController returnOrdersController = TextEditingController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ReturnOrdersProvider returnOrdersProvider =
          Provider.of(context, listen: false);
      returnOrdersProvider.searchReturnOrdersList = [];
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
        builder: (context, ReturnOrdersProvider returnOrdersProvider, __) {
      return WillPopScope(
        onWillPop: () async {
          if (returnOrdersController.text.isNotEmpty) {
            returnOrdersController.text = '';
            setState(() {});
            return Future.value(false);
          }
          return Future.value(true);
        },
        child: Scaffold(
          body: Container(
              color: ColorUtils.primaryColor,
              child: SafeArea(
                  child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: 150,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(AssetUtils.authBgImage),
                            fit: BoxFit.cover)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const SizedBox(height: 5),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(children: [
                                Row(children: [
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
                                    LocaleKeys.return_order.tr(),
                                    style: FontUtilities.h20(
                                        fontColor: ColorUtils.whiteColor),
                                  )
                                ]),
                              ]),

                              ///Later on Uncomment while implementing map's functionality

                              // GestureDetector(
                              //   onTap: () async {},
                              //   child: Row(
                              //     crossAxisAlignment: CrossAxisAlignment.center,
                              //     mainAxisAlignment: MainAxisAlignment.center,
                              //     children: [
                              //       Image.asset(
                              //         AssetUtils.locationImage,
                              //         height: 25,
                              //         width: 25,
                              //         color: ColorUtils.whiteColor,
                              //       ),
                              //       const SizedBox(width: 5),
                              //       Text(
                              //         'Govandi',
                              //         style: FontUtilities.h16(
                              //             fontColor: ColorUtils.whiteColor),
                              //       ),
                              //       const SizedBox(width: 10),
                              //     ],
                              //   ),
                              // )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18.0),
                          child: InputField(
                            onChanged: (String val) {
                              List<ResultList> subResultList = List.from(widget
                                  .returnOrdersArgs.resultList.subResultList);

                              returnOrdersProvider.searchReturnOrders(
                                  resultList: subResultList, val: val);
                            },
                            prefixIcon: const Icon(
                              Icons.search,
                              size: 25,
                              color: ColorUtils.blackColor,
                            ),
                            controller: returnOrdersController,
                            label: '',
                            hintTextStyle: FontUtilities.h16(
                                fontColor: ColorUtils.colorA4A9B0),
                            hintText: LocaleKeys.search_return_products.tr(),
                            suffixIcon: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  AssetUtils.locationImage,
                                  height: 25,
                                  width: 25,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                      child: Container(
                    padding: const EdgeInsets.only(top: 20),
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
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15.0, vertical: 2.5),
                          child: Text(
                            '${LocaleKeys.today.tr()}, ${GlobalVariablesUtils.getCurrentDate(locale: EasyLocalization.of(context)?.currentLocale?.languageCode ?? '')}',
                            style: FontUtilities.h18(
                              fontColor: ColorUtils.color2B2A2A,
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Expanded(
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15.0, vertical: 1),
                              child: Column(children: [
                                Stack(
                                  children: [
                                    ((returnOrdersController.text.isEmpty))
                                        ? ListView.builder(
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount: widget
                                                .returnOrdersArgs
                                                .resultList
                                                .subResultList
                                                .length,
                                            itemBuilder: (context, index) {
                                              return widget
                                                      .returnOrdersArgs
                                                      .resultList
                                                      .subResultList[index]
                                                      .returnItemsList
                                                      .isEmpty
                                                  ? const SizedBox()
                                                  : Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 15.0),
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                                color: ColorUtils
                                                                    .whiteColor,
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                      color: const Color(
                                                                              0XFF979FAE)
                                                                          .withOpacity(
                                                                              .10),
                                                                      blurRadius:
                                                                          8,
                                                                      spreadRadius:
                                                                          0,
                                                                      offset:
                                                                          const Offset(
                                                                              0,
                                                                              0))
                                                                ],
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10)),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      15.0,
                                                                  vertical:
                                                                      20.0),
                                                          child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                widget
                                                                            .returnOrdersArgs
                                                                            .resultList
                                                                            .subResultList
                                                                            .length <=
                                                                        1
                                                                    ? const SizedBox()
                                                                    : Column(
                                                                        children: [
                                                                          Text(
                                                                              '${LocaleKeys.invoice.tr()} #${widget.returnOrdersArgs.resultList.subResultList[index].id}',
                                                                              style: FontUtilities.h20(fontColor: ColorUtils.primaryColor, fontWeight: FWT.semiBold)),
                                                                          const SizedBox(
                                                                              height: 15),
                                                                        ],
                                                                      ),
                                                                ListView
                                                                    .builder(
                                                                        physics:
                                                                            const NeverScrollableScrollPhysics(),
                                                                        shrinkWrap:
                                                                            true,
                                                                        itemCount: widget
                                                                            .returnOrdersArgs
                                                                            .resultList
                                                                            .subResultList[
                                                                                index]
                                                                            .returnItemsList
                                                                            .length,
                                                                        itemBuilder:
                                                                            (context,
                                                                                insideIndex) {
                                                                          return Column(
                                                                              children: [
                                                                                Row(
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                                  children: [
                                                                                    CircleAvatar(
                                                                                        radius: 25,
                                                                                        backgroundColor: ColorUtils.colorEAEEFF,
                                                                                        child: Image.asset(
                                                                                          AssetUtils.returnOrdersIconImage,
                                                                                          height: 22,
                                                                                          width: 18,
                                                                                        )),
                                                                                    const SizedBox(width: 10),
                                                                                    Expanded(
                                                                                      child: Column(
                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                        children: [
                                                                                          Text(
                                                                                            widget.returnOrdersArgs.resultList.subResultList[index].returnItemsList[insideIndex].productName,
                                                                                            maxLines: 2,
                                                                                            style: FontUtilities.h16(
                                                                                              fontColor: ColorUtils.color3F3E3E,
                                                                                            ),
                                                                                          ),
                                                                                          const SizedBox(height: 5),
                                                                                          Row(
                                                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                                                            children: [
                                                                                              CircleAvatar(
                                                                                                radius: 6,
                                                                                                backgroundColor: ColorUtils.primaryColor,
                                                                                              ),
                                                                                              const SizedBox(width: 10),
                                                                                              Expanded(
                                                                                                child: Text(
                                                                                                  widget.returnOrdersArgs.resultList.subResultList[index].returnItemsList[insideIndex].selectedReturnReason,
                                                                                                  maxLines: 2,
                                                                                                  style: FontUtilities.h16(
                                                                                                    fontColor: ColorUtils.colorA4A9B0,
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                            ],
                                                                                          )
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                    const SizedBox(width: 10),
                                                                                    Text(
                                                                                      '${LocaleKeys.qty.tr()} : ${widget.returnOrdersArgs.resultList.subResultList[index].returnItemsList[insideIndex].returnItemQtyController!.text}',
                                                                                      style: FontUtilities.h16(
                                                                                        fontColor: ColorUtils.colorA4A9B0,
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                                widget.returnOrdersArgs.resultList.subResultList[index].returnItemsList.length - 1 == insideIndex
                                                                                    ? const SizedBox()
                                                                                    : const Column(
                                                                                        children: [
                                                                                          SizedBox(height: 5),
                                                                                          Divider(),
                                                                                          SizedBox(height: 5)
                                                                                        ],
                                                                                      ),
                                                                              ]);
                                                                        }),
                                                              ]),
                                                        ),
                                                      ),
                                                    );
                                            })
                                        : ListView.builder(
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount: returnOrdersProvider
                                                .searchReturnOrdersList.length,
                                            itemBuilder: (context, index) {
                                              return returnOrdersProvider
                                                      .searchReturnOrdersList[
                                                          index]
                                                      .returnItemsList
                                                      .isEmpty
                                                  ? const SizedBox()
                                                  : Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 15.0),
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                                color: ColorUtils
                                                                    .whiteColor,
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                      color: const Color(
                                                                              0XFF979FAE)
                                                                          .withOpacity(
                                                                              .10),
                                                                      blurRadius:
                                                                          8,
                                                                      spreadRadius:
                                                                          0,
                                                                      offset:
                                                                          const Offset(
                                                                              0,
                                                                              0))
                                                                ],
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10)),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      15.0,
                                                                  vertical:
                                                                      20.0),
                                                          child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                widget
                                                                            .returnOrdersArgs
                                                                            .resultList
                                                                            .subResultList
                                                                            .length <=
                                                                        1
                                                                    ? const SizedBox()
                                                                    : Column(
                                                                        children: [
                                                                          Text(
                                                                              '${LocaleKeys.invoice.tr()} #${returnOrdersProvider.searchReturnOrdersList[index].id}',
                                                                              style: FontUtilities.h20(fontColor: ColorUtils.primaryColor, fontWeight: FWT.semiBold)),
                                                                          const SizedBox(
                                                                              height: 15),
                                                                        ],
                                                                      ),
                                                                ListView
                                                                    .builder(
                                                                        physics:
                                                                            const NeverScrollableScrollPhysics(),
                                                                        shrinkWrap:
                                                                            true,
                                                                        itemCount: returnOrdersProvider
                                                                            .searchReturnOrdersList[
                                                                                index]
                                                                            .returnItemsList
                                                                            .length,
                                                                        itemBuilder:
                                                                            (context,
                                                                                insideIndex) {
                                                                          return Column(
                                                                              children: [
                                                                                Row(
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                                  children: [
                                                                                    CircleAvatar(
                                                                                        radius: 25,
                                                                                        backgroundColor: ColorUtils.colorEAEEFF,
                                                                                        child: Image.asset(
                                                                                          AssetUtils.returnOrdersIconImage,
                                                                                          height: 22,
                                                                                          width: 18,
                                                                                        )),
                                                                                    const SizedBox(width: 10),
                                                                                    Expanded(
                                                                                      child: Column(
                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                        children: [
                                                                                          Text(
                                                                                            returnOrdersProvider.searchReturnOrdersList[index].returnItemsList[insideIndex].productName,
                                                                                            maxLines: 2,
                                                                                            style: FontUtilities.h16(
                                                                                              fontColor: ColorUtils.color3F3E3E,
                                                                                            ),
                                                                                          ),
                                                                                          const SizedBox(height: 5),
                                                                                          Row(
                                                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                                                            children: [
                                                                                              CircleAvatar(
                                                                                                radius: 6,
                                                                                                backgroundColor: ColorUtils.primaryColor,
                                                                                              ),
                                                                                              const SizedBox(width: 10),
                                                                                              Expanded(
                                                                                                child: Text(
                                                                                                  returnOrdersProvider.searchReturnOrdersList[index].returnItemsList[insideIndex].selectedReturnReason,
                                                                                                  maxLines: 2,
                                                                                                  style: FontUtilities.h16(
                                                                                                    fontColor: ColorUtils.colorA4A9B0,
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                            ],
                                                                                          )
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                    const SizedBox(width: 10),
                                                                                    Text(
                                                                                      '${LocaleKeys.qty.tr()} : ${returnOrdersProvider.searchReturnOrdersList[index].returnItemsList[insideIndex].returnItemQtyController!.text}',
                                                                                      style: FontUtilities.h16(
                                                                                        fontColor: ColorUtils.colorA4A9B0,
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                                returnOrdersProvider.searchReturnOrdersList[index].returnItemsList.length - 1 == insideIndex
                                                                                    ? const SizedBox()
                                                                                    : const Column(
                                                                                        children: [
                                                                                          SizedBox(height: 5),
                                                                                          Divider(),
                                                                                          SizedBox(height: 5)
                                                                                        ],
                                                                                      ),
                                                                              ]);
                                                                        }),
                                                              ]),
                                                        ),
                                                      ),
                                                    );
                                            }),

                                    // ListView.builder(
                                    //     physics:
                                    //         const NeverScrollableScrollPhysics(),
                                    //     shrinkWrap: true,
                                    //     itemCount:
                                    //         returnOrdersController.text.isEmpty
                                    //             ? returnOrdersProvider
                                    //                 .returnedItemList.length
                                    //             : returnOrdersProvider
                                    //                 .searchReturnOrdersList
                                    //                 .length,
                                    //     itemBuilder: (context, index) {
                                    //       return Padding(
                                    //         padding: const EdgeInsets.symmetric(
                                    //             horizontal: 5.0, vertical: 5),
                                    //         child: Container(
                                    //           decoration: BoxDecoration(
                                    //               color: ColorUtils.whiteColor,
                                    //               boxShadow: [
                                    //                 BoxShadow(
                                    //                     color: ColorUtils
                                    //                         .blackColor
                                    //                         .withOpacity(0.1),
                                    //                     blurRadius: 6,
                                    //                     offset:
                                    //                         const Offset(0, 1),
                                    //                     spreadRadius: -2)
                                    //               ],
                                    //               borderRadius:
                                    //                   BorderRadius.circular(
                                    //                       10)),
                                    //           child: Column(children: [
                                    //             Padding(
                                    //               padding:
                                    //                   const EdgeInsets.only(
                                    //                       bottom: 5,
                                    //                       left: 10,
                                    //                       right: 10,
                                    //                       top: 10),
                                    //               child: Row(
                                    //                 crossAxisAlignment:
                                    //                     CrossAxisAlignment
                                    //                         .start,
                                    //                 mainAxisAlignment:
                                    //                     MainAxisAlignment.start,
                                    //                 children: [
                                    //                   CircleAvatar(
                                    //                       radius: 25,
                                    //                       backgroundColor:
                                    //                           ColorUtils
                                    //                               .colorEAEEFF,
                                    //                       child: Image.asset(
                                    //                         AssetUtils
                                    //                             .returnOrdersIconImage,
                                    //                         height: 22,
                                    //                         width: 18,
                                    //                       )),
                                    //                   const SizedBox(width: 10),
                                    //                   Expanded(
                                    //                     child: Text(
                                    //                       returnOrdersController
                                    //                               .text.isEmpty
                                    //                           ? returnOrdersProvider
                                    //                               .returnedItemList[
                                    //                                   index]
                                    //                               .productName
                                    //                           : returnOrdersProvider
                                    //                               .searchReturnOrdersList[
                                    //                                   index]
                                    //                               .productName,
                                    //                       maxLines: 2,
                                    //                       style:
                                    //                           FontUtilities.h16(
                                    //                         fontColor: ColorUtils
                                    //                             .color3F3E3E,
                                    //                       ),
                                    //                     ),
                                    //                   ),
                                    //                   const SizedBox(width: 10),
                                    //                   Text(
                                    //                     '${LocaleKeys.qty.tr()} : ${returnOrdersController.text.isEmpty ? returnOrdersProvider.returnedItemList[index].returnItemQtyController!.text : returnOrdersProvider.searchReturnOrdersList[index].returnItemQtyController!.text}',
                                    //                     style:
                                    //                         FontUtilities.h16(
                                    //                       fontColor: ColorUtils
                                    //                           .colorA4A9B0,
                                    //                     ),
                                    //                   ),
                                    //                 ],
                                    //               ),
                                    //             ),
                                    //             const Divider(),
                                    //             Padding(
                                    //               padding:
                                    //                   const EdgeInsets.only(
                                    //                       bottom: 10,
                                    //                       left: 18,
                                    //                       right: 10,
                                    //                       top: 0),
                                    //               child: Row(
                                    //                 crossAxisAlignment:
                                    //                     CrossAxisAlignment
                                    //                         .center,
                                    //                 mainAxisAlignment:
                                    //                     MainAxisAlignment.start,
                                    //                 children: [
                                    //                   CircleAvatar(
                                    //                     radius: 8,
                                    //                     backgroundColor:
                                    //                         ColorUtils
                                    //                             .primaryColor,
                                    //                   ),
                                    //                   const SizedBox(width: 10),
                                    //                   Expanded(
                                    //                     child: Text(
                                    //                       returnOrdersProvider
                                    //                           .returnedItemList[
                                    //                               index]
                                    //                           .selectedReturnReason,
                                    //                       maxLines: 2,
                                    //                       style:
                                    //                           FontUtilities.h16(
                                    //                         fontColor: ColorUtils
                                    //                             .colorA4A9B0,
                                    //                       ),
                                    //                     ),
                                    //                   ),
                                    //                 ],
                                    //               ),
                                    //             )
                                    //           ]),
                                    //         ),
                                    //       );
                                    //     }),

                                    Visibility(
                                      visible: ((returnOrdersController
                                              .text.isNotEmpty &&
                                          isReturnOrderListIsEmpty(
                                                  list: returnOrdersProvider
                                                      .searchReturnOrdersList) ==
                                              true)),
                                      child: SizedBox(
                                        height: VariableUtilities
                                                .screenSize.height /
                                            2,
                                        width:
                                            VariableUtilities.screenSize.width,
                                        child: Center(
                                          child: Lottie.asset(
                                              AssetUtils
                                                  .notAssignedPendingOrdersLottie,
                                              height: 250),
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              ]),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ))
                ],
              ))),
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
                    textStyle: FontUtilities.h18(
                        fontColor: ColorUtils.color0D1F3D,
                        fontWeight: FWT.semiBold),
                    color: Colors.transparent,
                    width: VariableUtilities.screenSize.width / 2,
                    onTap: () {
                      if (widget.returnOrdersArgs.navigateFrom ==
                          NavigateFrom.orderReview) {
                        MixpanelManager.trackEvent(
                            eventName: 'ScreenView',
                            properties: {
                              'Screen': 'DeliveryOrdersSummaryScreen'
                            });

                        Navigator.pushNamed(
                            context, RouteUtilities.deliveryOrdersSummaryScreen,
                            arguments: DeliverySummaryArgs(
                                timestamp: widget.returnOrdersArgs.timestamp,
                                navigateFrom: NavigateFrom.returnOrders,
                                noOfItems: widget.returnOrdersArgs.noOfItems,
                                resultList:
                                    widget.returnOrdersArgs.resultList));
                      } else {
                        MixpanelManager.trackEvent(
                            eventName: 'ScreenView',
                            properties: {'Screen': 'ProofOfDeliveryScreen'});
                        Navigator.pushNamed(
                            context, RouteUtilities.proofOfDeliveryScreen,
                            arguments: DeliveryOrdersArgs(
                                timestamp: widget.returnOrdersArgs.timestamp,
                                noOfItems: widget.returnOrdersArgs.noOfItems,
                                resultList:
                                    widget.returnOrdersArgs.resultList));
                      }
                    },
                    title: LocaleKeys.ok.tr()),
              )
            ]),
          ),
        ),
      );
    });
  }

  bool isReturnOrderListIsEmpty({required List<ResultList> list}) {
    bool isReturnOrderListIsEmpty = true;
    for (int i = 0; i < list.length; i++) {
      if (list[i].returnItemsList.isNotEmpty) {
        isReturnOrderListIsEmpty = false;
        break;
      }
    }
    print('isReturnOrderListIsEmpty $isReturnOrderListIsEmpty');
    return isReturnOrderListIsEmpty;
  }
}
