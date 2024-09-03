import 'package:easy_localization/easy_localization.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'package:parsel_flutter/src/mvp/dashboard/home/delivery_orders/args/delivery_orders_args.dart';
import 'package:parsel_flutter/src/mvp/dashboard/home/in_progress/args/in_progress_args.dart';
import 'package:parsel_flutter/src/mvp/dashboard/home/in_progress/model/get_sales_order_list_by_status_model.dart';
import 'package:parsel_flutter/src/mvp/dashboard/home/in_progress/provider/in_progress_item_provider.dart';
import 'package:parsel_flutter/src/mvp/dashboard/home/in_progress/view/progress_item_card.dart';
import 'package:parsel_flutter/src/widget/widget.dart';
import 'package:parsel_flutter/utils/utils.dart';
import 'package:provider/provider.dart';

class InProgressScreen extends StatefulWidget {
  const InProgressScreen({Key? key, required this.inProgressArgs})
      : super(key: key);
  final InProgressArgs inProgressArgs;

  @override
  State<InProgressScreen> createState() => _InProgressScreenState();
}

class _InProgressScreenState extends State<InProgressScreen> {
  final TextEditingController inProgressSkuController = TextEditingController();
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      InProgressItemProvider inProgressItemProvider =
          Provider.of(context, listen: false);
      inProgressItemProvider.inProgressItemsList = [];
      inProgressItemProvider.modifiedInProgressItemsList = [];
      inProgressItemProvider.getSalesOrderListByStatusResponse =
          Right(StaticException());
      inProgressItemProvider.onGoingStatusResponse = Right(StaticException());

      inProgressItemProvider.fetchInProgressSku(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
        builder: (context, InProgressItemProvider inProgressItemProvider, __) {
      return PopScope(
        canPop: widget.inProgressArgs.navigateFrom == RouteUtilities.homeScreen,
        onPopInvoked: (val) async {
          if (inProgressSkuController.text.isNotEmpty) {
            inProgressSkuController.text = '';
            setState(() {});
            // return false;
          }

          if (widget.inProgressArgs.navigateFrom != RouteUtilities.homeScreen) {
            MixpanelManager.trackEvent(
                eventName: 'ScreenView',
                properties: {'Screen': 'DashboardScreen'});
            Navigator.pushNamedAndRemoveUntil(
                context, RouteUtilities.dashboardScreen, (route) => false);
            // return Future.value(false);
            return;
          }

          // return Future.value(true);
        },
        child: Stack(
          children: [
            Scaffold(
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(children: [
                                      Row(children: [
                                        IconButton(
                                            onPressed: () {
                                              if (inProgressSkuController
                                                  .text.isNotEmpty) {
                                                inProgressSkuController.text =
                                                    '';
                                                setState(() {});
                                                return;
                                              }

                                              if (widget.inProgressArgs
                                                      .navigateFrom !=
                                                  RouteUtilities.homeScreen) {
                                                MixpanelManager.trackEvent(
                                                    eventName: 'ScreenView',
                                                    properties: {
                                                      'Screen':
                                                          'DashboardScreen'
                                                    });
                                                Navigator
                                                    .pushNamedAndRemoveUntil(
                                                        context,
                                                        RouteUtilities
                                                            .dashboardScreen,
                                                        (route) => false);
                                                return;
                                              }
                                              Navigator.pop(context);
                                            },
                                            icon: const Icon(
                                              Icons.arrow_back_ios_new,
                                              color: ColorUtils.whiteColor,
                                            )),
                                        const SizedBox(width: 10),
                                        Text(
                                          LocaleKeys.progress.tr(),
                                          style: FontUtilities.h20(
                                              fontColor: ColorUtils.whiteColor),
                                        ),
                                      ]),
                                    ]),

                                    ///Later on Uncomment while implementing map's functionality

                                    // GestureDetector(
                                    //   onTap: () async {
                                    //     MixpanelManager.mixpanel
                                    //         .track('ScreenView', properties: {
                                    //       'Screen': 'MapScreen'
                                    //     });
                                    //     Navigator.pushNamed(
                                    //         context, RouteUtilities.mapScreen);
                                    //   },
                                    //   child: Row(
                                    //     crossAxisAlignment:
                                    //         CrossAxisAlignment.center,
                                    //     mainAxisAlignment:
                                    //         MainAxisAlignment.center,
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
                                    //             fontColor:
                                    //                 ColorUtils.whiteColor),
                                    //       ),
                                    //       const SizedBox(width: 10),
                                    //     ],
                                    //   ),
                                    // )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 18.0),
                                child: InputField(
                                  onChanged: (String val) {
                                    inProgressItemProvider.searchOrdersFunction(
                                        val: val);
                                  },
                                  prefixIcon: const Icon(
                                    Icons.search,
                                    size: 25,
                                    color: ColorUtils.blackColor,
                                  ),
                                  controller: inProgressSkuController,
                                  label: '',
                                  hintTextStyle: FontUtilities.h16(
                                      fontColor: ColorUtils.colorA4A9B0),
                                  hintText: LocaleKeys.order_near_you.tr(),
                                  suffixIcon: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                            child: Stack(
                          children: [
                            Container(
                              padding: const EdgeInsets.only(top: 20),
                              height: VariableUtilities.screenSize.height,
                              width: VariableUtilities.screenSize.width,
                              decoration: const BoxDecoration(
                                  color: ColorUtils.colorF7F9FF,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                  )),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${LocaleKeys.today.tr()}, ${GlobalVariablesUtils.getCurrentDate(locale: EasyLocalization.of(context)?.currentLocale?.languageCode ?? '')}',
                                      style: FontUtilities.h18(
                                        fontColor: ColorUtils.color2B2A2A,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Expanded(
                                      child: SingleChildScrollView(
                                        physics: const BouncingScrollPhysics(),
                                        child: Column(children: [
                                          Stack(
                                            children: [
                                              ListView.builder(
                                                  physics:
                                                      const NeverScrollableScrollPhysics(),
                                                  shrinkWrap: true,
                                                  itemCount: inProgressSkuController
                                                          .text.isEmpty
                                                      ? inProgressItemProvider
                                                          .modifiedInProgressItemsList
                                                          .length
                                                      : inProgressItemProvider
                                                          .searchInProgressItemsList
                                                          .length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return Column(
                                                      children: [
                                                        ProgressItemCard(
                                                            index: index,
                                                            navigateFrom:
                                                                NavigateFrom
                                                                    .inProgress,
                                                            onArrivedTap: () {
                                                              MixpanelManager
                                                                  .trackEvent(
                                                                      eventName:
                                                                          'OpenDialog',
                                                                      properties: {
                                                                    'Dialog':
                                                                        'InProgressStartTripDialog'
                                                                  });
                                                              showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (context) {
                                                                    return StatefulBuilder(builder:
                                                                        (context,
                                                                            state) {
                                                                      return Stack(
                                                                        children: [
                                                                          StartTripDialog(
                                                                              imageUrl: AssetUtils.startTripContainerIconImage,
                                                                              title: LocaleKeys.start_trip.tr(),
                                                                              subTitle: LocaleKeys.start_trip_title.tr(),
                                                                              submitTitle: LocaleKeys.start_trip.tr(),
                                                                              submitOnTap: () async {
                                                                                List<ResultList> subResultList = inProgressSkuController.text.isEmpty ? inProgressItemProvider.modifiedInProgressItemsList[index].subResultList : inProgressItemProvider.searchInProgressItemsList[index].subResultList;
                                                                                for (int i = 0; i < subResultList.length; i++) {
                                                                                  state(() {});
                                                                                  await inProgressItemProvider
                                                                                      .updateSalesOrders(
                                                                                    timestamp: DateTime.now().millisecondsSinceEpoch,
                                                                                    isCallFromOffline: false,
                                                                                    context: context,
                                                                                    isLastIndex: i == subResultList.length - 1,
                                                                                    salesOrderId: subResultList[i].salesOrderId,
                                                                                  )
                                                                                      .then((value) {
                                                                                    state(() {});
                                                                                  });
                                                                                }
                                                                                Navigator.pop(context);

                                                                                MixpanelManager.trackEvent(eventName: 'ScreenView', properties: {
                                                                                  'Screen': 'DeliveryOrdersScreen'
                                                                                });
                                                                                Navigator.pushNamed(context, RouteUtilities.deliveryOrdersScreen, arguments: DeliveryOrdersArgs(timestamp: DateTime.now().millisecondsSinceEpoch, noOfItems: inProgressItemProvider.getSalesOrderListByStatusResponse.isLeft ? inProgressItemProvider.getSalesOrderListByStatusResponse.left.body.data.noOfItems : 0, resultList: inProgressSkuController.text.isEmpty ? inProgressItemProvider.modifiedInProgressItemsList[index] : inProgressItemProvider.searchInProgressItemsList[index]));
                                                                              }),
                                                                          Visibility(
                                                                            visible:
                                                                                (inProgressItemProvider.onGoingStatusResponse.isRight && inProgressItemProvider.onGoingStatusResponse.right is NoDataFoundException),
                                                                            child:
                                                                                CustomCircularProgressIndicator(),
                                                                          ),
                                                                        ],
                                                                      );
                                                                    });
                                                                  }).then((value) {
                                                                MixpanelManager
                                                                    .trackEvent(
                                                                        eventName:
                                                                            'CloseDialog',
                                                                        properties: {
                                                                      'Dialog':
                                                                          'InProgressStartTripDialog'
                                                                    });
                                                              });
                                                            },
                                                            onDirectionTap: () {
                                                              MixpanelManager
                                                                  .trackEvent(
                                                                      eventName:
                                                                          'ScreenView',
                                                                      properties: {
                                                                    'Screen':
                                                                        'MapScreen'
                                                                  });
                                                              DeliveryAddressCoordinates coordinates = inProgressSkuController
                                                                      .text
                                                                      .isEmpty
                                                                  ? inProgressItemProvider
                                                                      .modifiedInProgressItemsList[
                                                                          index]
                                                                      .deliveryAddressCoordinates
                                                                  : inProgressItemProvider
                                                                      .searchInProgressItemsList[
                                                                          index]
                                                                      .deliveryAddressCoordinates;
                                                              launchMap(
                                                                  lat:
                                                                      coordinates
                                                                          .lat,
                                                                  long:
                                                                      coordinates
                                                                          .long);
                                                              // Navigator.pushNamed(
                                                              //     context,
                                                              //     RouteUtilities
                                                              //         .mapScreen);
                                                            },
                                                            inProgressItemModel:
                                                                inProgressSkuController
                                                                        .text
                                                                        .isEmpty
                                                                    ? inProgressItemProvider
                                                                            .modifiedInProgressItemsList[
                                                                        index]
                                                                    : inProgressItemProvider
                                                                            .searchInProgressItemsList[
                                                                        index]),
                                                      ],
                                                    );
                                                  }),
                                              Visibility(
                                                visible: ((inProgressSkuController
                                                            .text.isNotEmpty &&
                                                        inProgressItemProvider
                                                            .searchInProgressItemsList
                                                            .isEmpty) ||
                                                    (inProgressItemProvider
                                                        .modifiedInProgressItemsList
                                                        .isEmpty)),
                                                child: Container(
                                                  height: VariableUtilities
                                                          .screenSize.height /
                                                      2,
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
                                  ],
                                ),
                              ),
                            ),
                            Visibility(
                              visible: (inProgressItemProvider
                                      .getSalesOrderListByStatusResponse
                                      .isRight &&
                                  inProgressItemProvider
                                      .getSalesOrderListByStatusResponse
                                      .right is NoDataFoundException),
                              child: CustomCircularProgressIndicator(
                                  backgroundColor: ColorUtils.whiteColor),
                            ),
                          ],
                        ))
                      ],
                    )))),
          ],
        ),
      );
    });
  }
}
