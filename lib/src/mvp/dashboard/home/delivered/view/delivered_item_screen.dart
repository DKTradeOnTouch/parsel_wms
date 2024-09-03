import 'package:easy_localization/easy_localization.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';

import 'package:parsel_flutter/src/mvp/dashboard/home/delivered/provider/delivered_item_provider.dart';
import 'package:parsel_flutter/src/mvp/dashboard/home/in_progress/args/in_progress_args.dart';
import 'package:parsel_flutter/src/mvp/dashboard/home/in_progress/view/progress_item_card.dart';
import 'package:parsel_flutter/src/widget/widget.dart';
import 'package:parsel_flutter/utils/utils.dart';
import 'package:provider/provider.dart';

class DeliveredItemScreen extends StatefulWidget {
  const DeliveredItemScreen({Key? key, required this.deliveredArgs})
      : super(key: key);
  final InProgressArgs deliveredArgs;

  @override
  State<DeliveredItemScreen> createState() => _DeliveredItemScreenState();
}

class _DeliveredItemScreenState extends State<DeliveredItemScreen> {
  final TextEditingController deliveredSkuController = TextEditingController();
  DateTime? currentBackPressTime;

  Future<bool> exitFromApp() async {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
      currentBackPressTime = now;

      Fluttertoast.showToast(
          msg: LocaleKeys.swipe_again_to_exit_app
              .tr()); // return Future.value(false);
      return Future.value(false);
    }
    await SystemNavigator.pop();
    return Future.value(true);
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      DeliveredItemProvider deliveredItemProvider =
          Provider.of(context, listen: false);
      deliveredItemProvider.deliveredItemsList = [];
      deliveredItemProvider.getSalesOrderListByStatusResponse =
          Right(NoDataFoundException());
      deliveredItemProvider.fetchDeliveredSku(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
        builder: (context, DeliveredItemProvider deliveredItemProvider, __) {
      return Stack(
        children: [
          WillPopScope(
            onWillPop: () async {
              if (deliveredSkuController.text.isNotEmpty) {
                deliveredSkuController.text = '';
                setState(() {});
                return false;
              }

              if (widget.deliveredArgs.navigateFrom ==
                  RouteUtilities.dashboardScreen) {
                exitFromApp();
                return false;
              }
              if (widget.deliveredArgs.navigateFrom ==
                  RouteUtilities.dispatchSummaryScreen) {
                MixpanelManager.trackEvent(
                    eventName: 'ScreenView',
                    properties: {'Screen': 'DashboardScreen'});
                Navigator.pushNamedAndRemoveUntil(
                    context, RouteUtilities.dashboardScreen, (route) => false);
                return false;
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(children: [
                                      Row(children: [
                                        widget.deliveredArgs.navigateFrom ==
                                                RouteUtilities.dashboardScreen
                                            ? const SizedBox()
                                            : IconButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                icon: const Icon(
                                                  Icons.arrow_back_ios_new,
                                                  color: ColorUtils.whiteColor,
                                                )),
                                        const SizedBox(width: 10),
                                        Text(
                                          'Delivered',
                                          style: FontUtilities.h20(
                                              fontColor: ColorUtils.whiteColor),
                                        )
                                      ]),
                                    ]),

                                    ///Later on Uncomment while implementing map's functionality
                                    // GestureDetector(
                                    //   onTap: () async {},
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
                                    deliveredItemProvider.searchOrdersFunction(
                                        val: val);
                                  },
                                  prefixIcon: const Icon(
                                    Icons.search,
                                    size: 25,
                                    color: ColorUtils.blackColor,
                                  ),
                                  controller: deliveredSkuController,
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
                                    Row(
                                      children: [
                                        Text(
                                          'Today, ${GlobalVariablesUtils.getCurrentDate(locale: EasyLocalization.of(context)?.currentLocale?.languageCode ?? '')}',
                                          style: FontUtilities.h18(
                                            fontColor: ColorUtils.color2B2A2A,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Container(
                                          height: 25,
                                          width: 25,
                                          decoration: const BoxDecoration(
                                              color: ColorUtils.color0DB65B,
                                              shape: BoxShape.circle),
                                          child: const Icon(
                                            Icons.check,
                                            color: ColorUtils.whiteColor,
                                            size: 18,
                                          ),
                                        )
                                      ],
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
                                                  itemCount: deliveredSkuController
                                                          .text.isEmpty
                                                      ? deliveredItemProvider
                                                          .modifiedInProgressItemsList
                                                          .length
                                                      : deliveredItemProvider
                                                          .searchDeliveredItemsList
                                                          .length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return ProgressItemCard(
                                                        index: index,
                                                        navigateFrom:
                                                            NavigateFrom
                                                                .delivered,
                                                        inProgressItemModel:
                                                            deliveredSkuController
                                                                    .text
                                                                    .isEmpty
                                                                ? deliveredItemProvider
                                                                        .modifiedInProgressItemsList[
                                                                    index]
                                                                : deliveredItemProvider
                                                                        .searchDeliveredItemsList[
                                                                    index]);
                                                  }),
                                              Visibility(
                                                visible: ((deliveredSkuController
                                                            .text.isNotEmpty &&
                                                        deliveredItemProvider
                                                            .searchDeliveredItemsList
                                                            .isEmpty) ||
                                                    (deliveredItemProvider
                                                        .modifiedInProgressItemsList
                                                        .isEmpty)),
                                                child: SizedBox(
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
                                              ),
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
                              visible: deliveredItemProvider
                                      .getSalesOrderListByStatusResponse
                                      .isRight &&
                                  deliveredItemProvider
                                      .getSalesOrderListByStatusResponse
                                      .right is NoDataFoundException,
                              child: CustomCircularProgressIndicator(
                                  backgroundColor: ColorUtils.whiteColor),
                            ),
                          ],
                        ))
                      ],
                    )))),
          ),
        ],
      );
    });
  }
}
