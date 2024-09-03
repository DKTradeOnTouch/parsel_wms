import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'package:parsel_flutter/src/mvp/dashboard/home/pending_orders/provider/pending_orders_provider.dart';
import 'package:parsel_flutter/src/widget/indicator/custom_circular_progress_indicator.dart';
import 'package:parsel_flutter/src/widget/input/search_input.dart';
import 'package:parsel_flutter/utils/utils.dart';
import 'package:provider/provider.dart';

class PendingOrdersScreen extends StatefulWidget {
  const PendingOrdersScreen({Key? key}) : super(key: key);

  @override
  State<PendingOrdersScreen> createState() => _PendingOrdersScreenState();
}

class _PendingOrdersScreenState extends State<PendingOrdersScreen> {
  final TextEditingController _searchController = TextEditingController();

  int selectedIndex = 0;
  @override
  void initState() {
    PendingOrdersProvider pendingOrdersProvider =
        Provider.of(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      pendingOrdersProvider.pendingOrdersLocationResponse =
          Right(FetchingDataException());
      pendingOrdersProvider.searchSelectedWarehousesDetailList = [];
      pendingOrdersProvider.fetchPendingOrdersLocation(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
        builder: (context, PendingOrdersProvider pendingOrdersProvider, _) {
      return Stack(
        children: [
          WillPopScope(
            onWillPop: () {
              if (_searchController.text.isNotEmpty) {
                _searchController.text = '';
                setState(() {});
                return Future.value(false);
              }
              return Future.value(true);
            },
            child: Scaffold(
              body: Container(
                color: ColorUtils.primaryColor,
                child: SafeArea(
                  child: Column(children: [
                    Container(
                      width: double.infinity,
                      height: 90,
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
                            LocaleKeys.pending_orders.tr(),
                            style: FontUtilities.h20(
                                fontColor: ColorUtils.whiteColor),
                          )
                        ]),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        width: VariableUtilities.screenSize.width,
                        decoration: const BoxDecoration(
                            color: ColorUtils.whiteColor,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            )),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 30),
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${LocaleKeys.today.tr()}, ${GlobalVariablesUtils.getCurrentDate(locale: EasyLocalization.of(context)?.currentLocale?.languageCode ?? '')}',
                                    style: FontUtilities.h18(
                                      fontColor: ColorUtils.color2B2A2A,
                                    ),
                                  ),
                                  Center(
                                    child: Lottie.asset(
                                        AssetUtils.pendingOrdersLottie,
                                        // height: 300,
                                        width:
                                            MediaQuery.of(context).size.width),
                                  ),
                                  Container(
                                    width: VariableUtilities.screenSize.width,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: ColorUtils.colorC8D3E7),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10))),
                                    child: Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: SingleChildScrollView(
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                LocaleKeys.warehouse_location
                                                    .tr(),
                                                style: FontUtilities.h16(
                                                    fontColor:
                                                        ColorUtils.color3F3E3E),
                                              ),
                                              const SizedBox(height: 15),
                                              SearchInput(
                                                  hintText: LocaleKeys
                                                      .search_warehouse_location
                                                      .tr(),
                                                  padding:
                                                      const EdgeInsets.all(0),
                                                  onChanged: (val) {
                                                    if (val.isEmpty) {
                                                      pendingOrdersProvider
                                                          .searchSelectedWarehousesDetailList = [];
                                                      return;
                                                    }
                                                    pendingOrdersProvider
                                                        .searchSelectedWarehousesDetailList = [];
                                                    for (int i = 0;
                                                        i <
                                                            pendingOrdersProvider
                                                                .selectedWarehousesDetailList
                                                                .length;
                                                        i++) {
                                                      if (pendingOrdersProvider
                                                          .selectedWarehousesDetailList[
                                                              i]
                                                          .wareHouseName
                                                          .toLowerCase()
                                                          .startsWith(val
                                                              .toLowerCase())) {
                                                        pendingOrdersProvider
                                                            .searchSelectedWarehousesDetailList
                                                            .add(pendingOrdersProvider
                                                                .selectedWarehousesDetailList[i]);
                                                      }
                                                    }
                                                  },
                                                  controller:
                                                      _searchController),
                                              const SizedBox(height: 15),
                                              Stack(
                                                children: [
                                                  ListView.builder(
                                                    physics:
                                                        const BouncingScrollPhysics(),
                                                    itemCount: _searchController
                                                            .text.isEmpty
                                                        ? pendingOrdersProvider
                                                            .selectedWarehousesDetailList
                                                            .length
                                                        : pendingOrdersProvider
                                                            .searchSelectedWarehousesDetailList
                                                            .length,
                                                    shrinkWrap: true,
                                                    itemBuilder:
                                                        (context, index) =>
                                                            GestureDetector(
                                                      onTap: () {
                                                        if (pendingOrdersProvider
                                                            .searchSelectedWarehousesDetailList
                                                            .isNotEmpty) {
                                                          pendingOrdersProvider
                                                                  .selectedLocation =
                                                              pendingOrdersProvider
                                                                  .searchSelectedWarehousesDetailList[
                                                                      index]
                                                                  .wareHouseName;
                                                          Timer(
                                                              const Duration(
                                                                  milliseconds:
                                                                      300), () {
                                                            MixpanelManager
                                                                .trackEvent(
                                                                    eventName:
                                                                        'ScreenView',
                                                                    properties: {
                                                                  'Screen':
                                                                      'SelectPendingOrdersScreen'
                                                                });

                                                            Navigator.pushNamed(
                                                                context,
                                                                RouteUtilities
                                                                    .selectPendingOrdersScreen,
                                                                arguments: pendingOrdersProvider
                                                                    .searchSelectedWarehousesDetailList[
                                                                        index]
                                                                    .wareHouseName);
                                                          });
                                                          return;
                                                        }
                                                        pendingOrdersProvider
                                                                .selectedLocation =
                                                            pendingOrdersProvider
                                                                .selectedWarehousesDetailList[
                                                                    index]
                                                                .wareHouseName;
                                                        Timer(
                                                            const Duration(
                                                                milliseconds:
                                                                    300), () {
                                                          MixpanelManager
                                                              .trackEvent(
                                                                  eventName:
                                                                      'ScreenView',
                                                                  properties: {
                                                                'Screen':
                                                                    'SelectPendingOrdersScreen'
                                                              });
                                                          Navigator.pushNamed(
                                                              context,
                                                              RouteUtilities
                                                                  .selectPendingOrdersScreen,
                                                              arguments: pendingOrdersProvider
                                                                  .selectedWarehousesDetailList[
                                                                      index]
                                                                  .wareHouseName);
                                                        });
                                                      },
                                                      child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  vertical:
                                                                      4.0),
                                                          child: Container(
                                                            height: 40,
                                                            color: Colors
                                                                .transparent,
                                                            child: Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    Image.asset(
                                                                      AssetUtils
                                                                          .locationImage,
                                                                      height:
                                                                          25,
                                                                      width: 25,
                                                                    ),
                                                                    const SizedBox(
                                                                        width:
                                                                            10),
                                                                    Text(
                                                                        pendingOrdersProvider.searchSelectedWarehousesDetailList.isEmpty
                                                                            ? pendingOrdersProvider.selectedWarehousesDetailList[index].wareHouseName
                                                                            : pendingOrdersProvider.searchSelectedWarehousesDetailList[index].wareHouseName,
                                                                        style: FontUtilities.h16(
                                                                          fontColor:
                                                                              ColorUtils.color3F3E3E,
                                                                        )),
                                                                  ],
                                                                ),
                                                                AnimatedContainer(
                                                                  duration: const Duration(
                                                                      milliseconds:
                                                                          200),
                                                                  curve: Curves
                                                                      .linear,
                                                                  height: 20,
                                                                  width: 20,
                                                                  decoration: BoxDecoration(
                                                                      shape: BoxShape
                                                                          .circle,
                                                                      color: pendingOrdersProvider.selectedLocation == (pendingOrdersProvider.searchSelectedWarehousesDetailList.isNotEmpty ? pendingOrdersProvider.searchSelectedWarehousesDetailList[index] : pendingOrdersProvider.selectedWarehousesDetailList[index].wareHouseName)
                                                                          ? ColorUtils
                                                                              .primaryColor
                                                                          : Colors
                                                                              .transparent),
                                                                  child: pendingOrdersProvider
                                                                              .selectedLocation ==
                                                                          (pendingOrdersProvider.searchSelectedWarehousesDetailList.isNotEmpty
                                                                              ? pendingOrdersProvider.searchSelectedWarehousesDetailList[index]
                                                                              : pendingOrdersProvider.selectedWarehousesDetailList[index].wareHouseName)
                                                                      ? const Icon(
                                                                          Icons
                                                                              .check,
                                                                          size:
                                                                              15,
                                                                          color:
                                                                              ColorUtils.whiteColor,
                                                                        )
                                                                      : const SizedBox(),
                                                                )
                                                              ],
                                                            ),
                                                          )),
                                                    ),
                                                  ),
                                                  Visibility(
                                                    visible: (_searchController
                                                            .text.isNotEmpty &&
                                                        pendingOrdersProvider
                                                            .searchSelectedWarehousesDetailList
                                                            .isEmpty),
                                                    child: Center(
                                                      child: Lottie.asset(
                                                          AssetUtils
                                                              .notAssignedPendingOrdersLottie,
                                                          height: 250),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ]),
                                      ),
                                    ),
                                  )
                                ]),
                          ),
                        ),
                      ),
                    )
                  ]),
                ),
              ),
            ),
          ),
          Visibility(
            visible:
                pendingOrdersProvider.pendingOrdersLocationResponse.isRight &&
                    pendingOrdersProvider.pendingOrdersLocationResponse.right
                        is NoDataFoundException,
            child: CustomCircularProgressIndicator(),
          ),
        ],
      );
    });
  }
}
