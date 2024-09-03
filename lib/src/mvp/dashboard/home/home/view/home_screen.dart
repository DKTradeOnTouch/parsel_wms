import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:parsel_flutter/src/mvp/dashboard/home/home/provider/home_provider.dart';
import 'package:parsel_flutter/src/mvp/dashboard/home/in_progress/args/in_progress_args.dart';
import 'package:parsel_flutter/src/widget/widget.dart';
import 'package:parsel_flutter/utils/utils.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    initConnectivity();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      HomeProvider homeProvider = Provider.of(context, listen: false);
      homeProvider.getOrdersCountResponse = Right(StaticException());
      homeProvider.isPendingApisCalling = false;
      homeProvider.isAppUpdateAvailable = VariableUtilities.preferences
              .getBool(LocalCacheKey.isAppUpdateAvailable) ??
          false;
      homeProvider.getOrdersCount(context,
          calledFrom: 'home_screen_init_state');
      if (ConnectivityHandler.connectivityResult
              .contains(ConnectivityResult.mobile) ||
          ConnectivityHandler.connectivityResult
              .contains(ConnectivityResult.wifi)) {
        await homeProvider.updateOfflineLocation();
        await homeProvider.startUpdateLatLngToFirebase(context);
        await updatePendingApi(isConnectivityChanged: false);
      }
    });
    super.initState();
  }

  static final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  Future initConnectivity() async {
    late List<ConnectivityResult> result;

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    return;
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    print('Function called for _updateConnectionStatus$result');
    HomeProvider homeProvider = Provider.of(context, listen: false);

    if (result.contains(ConnectivityResult.mobile) ||
        result.contains(ConnectivityResult.wifi)) {
      await updatePendingApi(isConnectivityChanged: true);
    }
    if (result.contains(ConnectivityResult.none)) {
      homeProvider.callFunctionWhileUserOffline();
    }
  }

  Future<void> updatePendingApi({required bool isConnectivityChanged}) async {
    HomeProvider homeProvider = Provider.of(context, listen: false);

    await homeProvider.callUpdateOnGoingApiWhileUserRetrieveInternet(
        context: context);
    await homeProvider.callArrivedLocationApiWhileUserRetrieveInternet(
        context: context);
    await homeProvider.callUpdateDistanceTravelApiWhileUserRetrieveInternet(
        context: context);
    await homeProvider.callUpdateArrivedApiWhileUserRetrieveInternet(
        context: context);
    await homeProvider.callUploadDocsApiWhileUserRetrieveInternet(
        context: context);
    await homeProvider.callPendingApiWhileUserRetrieveInternet(
        context: context);

    await homeProvider.callCreatePaymentApiWhileUserRetrieveInternet(
        context: context);

    if (isConnectivityChanged) {
      await homeProvider.getOrdersCount(context,
          calledFrom: 'update_pending_api');
    }
  }

  @override
  void dispose() {
    if (_connectivitySubscription != null) {
      _connectivitySubscription.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, HomeProvider homeProvider, __) {
      return Stack(
        children: [
          Scaffold(
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
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Row(
                            children: [
                              Text(
                                LocaleKeys.home.tr(),
                                style: FontUtilities.h20(
                                    fontColor: ColorUtils.whiteColor),
                              ),
                              const Spacer(),
                              IconButton(
                                  onPressed: () {
                                    print(
                                        "storedArrivedLocationRequests ${VariableUtilities.preferences.getStringList(LocalCacheKey.storedArrivedLocationRequests)}");
                                    print(
                                        "storedPaymentRequests ${VariableUtilities.preferences.getStringList(LocalCacheKey.storedPaymentRequests)}");
                                    print(
                                        "storedPendingRequests ${VariableUtilities.preferences.getStringList(LocalCacheKey.storedPendingRequests)}");
                                    print(
                                        "storedProofOfDeliveryRequests ${VariableUtilities.preferences.getStringList(LocalCacheKey.storedProofOfDeliveryRequests)}");
                                    print(
                                        "storedUpdateArrivedOrdersRequests ${VariableUtilities.preferences.getStringList(LocalCacheKey.storedUpdateArrivedOrdersRequests)}");
                                    print(
                                        "storedUpdateDistanceRequests ${VariableUtilities.preferences.getStringList(LocalCacheKey.storedUpdateDistanceRequests)}");

                                    print(
                                        "storedUpdateOnGoingOrdersRequests ${VariableUtilities.preferences.getStringList(LocalCacheKey.storedUpdateOnGoingOrdersRequests)}");
                                    // return;

                                    HomeProvider homeProvider =
                                        Provider.of(context, listen: false);
                                    homeProvider.getOrdersCount(context,
                                        calledFrom: 'on_refresh');
                                  },
                                  icon: const Icon(
                                    Icons.refresh,
                                    color: ColorUtils.whiteColor,
                                    size: 30,
                                  )),
                            ],
                          )),
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
                          horizontal: 20.0, vertical: 0),
                      child: SingleChildScrollView(
                        child: Column(children: [
                          const SizedBox(height: 50),
                          HomeItemContainer(
                              onTap: () {
                                MixpanelManager.trackEvent(
                                    eventName: 'ScreenView',
                                    properties: {
                                      'Screen': 'PendingOrdersScreen'
                                    });

                                Navigator.pushNamed(context,
                                    RouteUtilities.pendingOrdersScreen);
                              },
                              backgroundColor: ColorUtils.colorFFE2E2,
                              count: homeProvider.pendingOrdersCount,
                              itemImage: AssetUtils.pendingIconImage,
                              label: LocaleKeys.pending_orders.tr()),
                          const SizedBox(height: 15),
                          HomeItemContainer(
                              onTap: () {
                                MixpanelManager.trackEvent(
                                    eventName: 'ScreenView',
                                    properties: {'Screen': 'InProgressScreen'});
                                Navigator.pushNamed(
                                    context, RouteUtilities.inProgressScreen,
                                    arguments: InProgressArgs(
                                        navigateFrom:
                                            RouteUtilities.homeScreen));
                              },
                              backgroundColor: ColorUtils.colorDFEAFF,
                              count: homeProvider.inProgressOrdersCount,
                              itemImage: AssetUtils.inProgressIconImage,
                              countContainerColor: ColorUtils.primaryColor,
                              countStyleColor: ColorUtils.whiteColor,
                              label: LocaleKeys.progress_orders.tr()),
                          const SizedBox(height: 15),
                          HomeItemContainer(
                              onTap: () {
                                MixpanelManager.trackEvent(
                                    eventName: 'ScreenView',
                                    properties: {'Screen': 'DeliveredScreen'});
                                Navigator.pushNamed(
                                    context, RouteUtilities.deliveredScreen,
                                    arguments: InProgressArgs(
                                        navigateFrom:
                                            RouteUtilities.homeScreen));
                              },
                              backgroundColor: ColorUtils.colorE2FFE7,
                              count: homeProvider.deliveredOrdersCount,
                              itemImage: AssetUtils.deliveredIconImage,
                              label: LocaleKeys.delivered.tr()),
                        ]),
                      ),
                    ),
                  )),
                ]),
              ),
            ),
          ),
          // homeProvider.isAppUpdateAvailable
          //     ? Align(
          //         alignment: Alignment.bottomCenter,
          //         child: Container(
          //           color: ColorUtils.whiteColor,
          //           child: Padding(
          //             padding: const EdgeInsets.symmetric(
          //                 horizontal: 25.0, vertical: 10),
          //             child: Row(children: [
          //               Expanded(
          //                 child: Text('App Update is now available.',
          //                     style: FontUtilities.h15(
          //                         fontColor: ColorUtils.blackColor)),
          //               ),
          //               const SizedBox(width: 10),
          //               InkWell(
          //                 onTap: () async {
          //                   await checkForUpdate();
          //                 },
          //                 child: Container(
          //                   decoration: BoxDecoration(
          //                     borderRadius: BorderRadius.circular(5),
          //                     color: ColorUtils.primaryColor,
          //                   ),
          //                   height: 45,
          //                   child: Padding(
          //                     padding:
          //                         const EdgeInsets.symmetric(horizontal: 15.0),
          //                     child: Center(
          //                         child: Text('Install Now',
          //                             style: FontUtilities.h15(
          //                                 fontColor: ColorUtils.whiteColor))),
          //                   ),
          //                 ),
          //               ),
          //             ]),
          //           ),
          //         ),
          //       )
          //     : const SizedBox(),
          homeProvider.isPendingApisCalling
              ? CustomCircularProgressIndicator(isPendingApisCalling: true)
              : const SizedBox(),
          (homeProvider.getOrdersCountResponse.isRight &&
                  homeProvider.getOrdersCountResponse.right
                      is FetchingDataException)
              ? CustomCircularProgressIndicator()
              : const SizedBox()
        ],
      );
    });
  }

  Future<void> checkForUpdate() async {
    InAppUpdate.checkForUpdate().then((updateInfo) {
      print('updateInfo --> $updateInfo');
      if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
        VariableUtilities.preferences
            .setBool(LocalCacheKey.isAppUpdateAvailable, true);

        //Perform flexible update
        InAppUpdate.startFlexibleUpdate().then((appUpdateResult) {
          if (appUpdateResult == AppUpdateResult.success) {
            VariableUtilities.preferences
                .setBool(LocalCacheKey.isAppUpdateAvailable, false);
            //App Update successful
            HomeProvider homeProvider = Provider.of(context, listen: false);
            homeProvider.isAppUpdateAvailable = false;
            InAppUpdate.completeFlexibleUpdate();
          }
        });
      }
    }).catchError((e) {
      print("error while Splash screen -> $e");
    });
  }
}
