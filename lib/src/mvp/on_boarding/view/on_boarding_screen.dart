import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:parsel_flutter/resource/app_logs.dart';
import 'package:parsel_flutter/utils/utils.dart';
import 'package:parsel_flutter/src/mvp/on_boarding/model/on_boarding_model.dart';
import 'package:parsel_flutter/src/mvp/on_boarding/provider/on_boarding_provider.dart';
import 'package:parsel_flutter/src/widget/button/primary_button.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _pageController = PageController(initialPage: 0);

  List<OnBoardingDataModel> onBoardingDataModelList = [
    OnBoardingDataModel(
      imageType: ImageType.png,
      titleImage: '',
      title: LocaleKeys.search_warehouse_location.tr(),
      subTitle: LocaleKeys.intro_1.tr(),
      image: AssetUtils.onBoarding1Image,
    ),
    OnBoardingDataModel(
      imageType: ImageType.lottie,
      titleImage: 'Map',
      title: LocaleKeys.how_to_start_trip.tr(),
      subTitle: LocaleKeys.intro_2.tr(),
      image: AssetUtils.onBoarding2Lottie,
    ),
    OnBoardingDataModel(
      imageType: ImageType.lottie,
      titleImage: '',
      title: LocaleKeys.arrived_to_location_check_invoice.tr(),
      subTitle: LocaleKeys.intro_3.tr(),
      image: AssetUtils.onBoarding3Lottie,
    ),
  ];
  DateTime? currentBackPressTime;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        DateTime now = DateTime.now();
        if (currentBackPressTime == null ||
            now.difference(currentBackPressTime!) >
                const Duration(seconds: 2)) {
          currentBackPressTime = now;
          Fluttertoast.showToast(msg: LocaleKeys.swipe_again_to_exit_app.tr());

          // return Future.value(false);
          return Future.value(false);
        }
        await SystemNavigator.pop();
        return Future.value(true);
      },
      child: Consumer(
          builder: (context, OnBoardingProvider onBoardingProvider, _) {
        return Scaffold(
          body: SafeArea(
            child: Stack(
              children: [
                SizedBox(
                  width: VariableUtilities.screenSize.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      Container(
                        height: 375,
                        child: Image.asset(
                          AssetUtils.onBoarding2Image,
                          width: VariableUtilities.screenSize.width - 40,
                          color: Colors.transparent,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        margin: const EdgeInsets.only(bottom: 35),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            for (int i = 0; i < 3; i++)
                              if (i == onBoardingProvider.currentPage) ...[
                                circleBar(true)
                              ] else
                                circleBar(false),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Column(children: [
                  Expanded(
                    child: Container(
                      width: VariableUtilities.screenSize.width,
                      color: Colors.transparent,
                      child: PageView.builder(
                        controller: _pageController,
                        clipBehavior: Clip.none,
                        itemCount: onBoardingDataModelList.length,
                        itemBuilder: (_, index) {
                          return Column(
                            children: [
                              const SizedBox(height: 20),
                              onBoardingDataModelList[index].imageType ==
                                      ImageType.png
                                  ? SizedBox(
                                      height: 380,
                                      child: Image.asset(
                                        onBoardingDataModelList[index].image,
                                        width:
                                            VariableUtilities.screenSize.width -
                                                40,
                                      ),
                                    )
                                  : Container(
                                      decoration: BoxDecoration(
                                          color: ColorUtils.colorE9EDFF,
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      height: 370,
                                      child: Lottie.asset(
                                        onBoardingDataModelList[index].image,
                                        width:
                                            VariableUtilities.screenSize.width -
                                                40,
                                      ),
                                    ),
                              const SizedBox(height: 50),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    onBoardingDataModelList[index]
                                            .titleImage
                                            .isEmpty
                                        ? const SizedBox()
                                        : const SizedBox(width: 20),
                                    Text(
                                      onBoardingDataModelList[index].title,
                                      // maxLines: 2,
                                      textAlign: TextAlign.center,
                                      style: FontUtilities.h22(
                                        fontWeight: FWT.semiBold,
                                        fontColor: ColorUtils.color3F3E3E,
                                      ),
                                    ),
                                    onBoardingDataModelList[index]
                                            .titleImage
                                            .isEmpty
                                        ? const SizedBox()
                                        : Row(
                                            children: [
                                              const SizedBox(width: 10),
                                              const Icon(
                                                Icons.location_on,
                                                size: 35,
                                                color: ColorUtils.colorD9524B,
                                              ),
                                            ],
                                          )
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              // Padding(
                              //   padding: const EdgeInsets.symmetric(
                              //       horizontal: 40.0),
                              //   child: Text(
                              //       onBoardingDataModelList[index].subTitle,
                              //       textAlign: TextAlign.center,
                              //       style: FontUtilities.h16(
                              //           fontColor: ColorUtils.color3F3E3E)),
                              // ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  child: AutoSizeText(
                                    onBoardingDataModelList[index].subTitle,
                                    textAlign: TextAlign.center,
                                    style: FontUtilities.h16(
                                        fontColor: ColorUtils.color3F3E3E),
                                    presetFontSizes: const [
                                      18,
                                      16,
                                      15,
                                      14,
                                      13,
                                      12,
                                      11,
                                      10,
                                      9,
                                      8,
                                      7,
                                      6,
                                      5
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                        onPageChanged: (int page) {
                          onBoardingProvider.currentPage = page;
                        },
                        physics: const ClampingScrollPhysics(),
                      ),
                    ),
                  ),
                  // SizedBox(height: 100),
                ]),
              ],
            ),
          ),
          bottomNavigationBar: SizedBox(
              height: 130,
              // color: Colors.red,
              width: VariableUtilities.screenSize.width,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 25.0,
                    vertical: onBoardingProvider.currentPage == 2 ? 0 : 15),
                child: onBoardingProvider.currentPage != 2
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            child: Text(
                              LocaleKeys.skip.tr(),
                              style: FontUtilities.h18(
                                  fontColor: ColorUtils.color3F3E3E,
                                  fontWeight: FWT.semiBold),
                            ),
                            onPressed: () {
                              _pageController.animateToPage(3,
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.linearToEaseOut);
                            },
                          ),
                          FloatingActionButton(
                            elevation: 0,
                            backgroundColor: ColorUtils.primaryColor,
                            onPressed: () {
                              _pageController.nextPage(
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.linearToEaseOut);
                            },
                            child: Image.asset(
                              AssetUtils.rightArrowImage,
                              height: 30,
                              width: 30,
                            ),
                          )
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          PrimaryButton(
                              width: VariableUtilities.screenSize.width,
                              onTap: () {
                                VariableUtilities.preferences.setBool(
                                    LocalCacheKey.isOnBoardingVisited, true);
                                try {
                                  MixpanelManager.mixpanel.track('ScreenView',
                                      properties: {'Screen': 'SignInScreen'});
                                } catch (e) {
                                  appLogs(e);
                                }
                                Navigator.pushNamedAndRemoveUntil(
                                    context,
                                    RouteUtilities.signInScreen,
                                    (route) => false);
                              },
                              title: LocaleKeys.sign_in.tr()),
                          // const SizedBox(height: 10),
                          // Expanded(
                          //   child: PrimaryButton(
                          //     borderColor: ColorUtils.color0D1F3D,
                          //     color: ColorUtils.whiteColor,
                          //     onTap: () {
                          //       VariableUtilities.preferences.setBool(
                          //           LocalCacheKey.isOnBoardingVisited, true);
                          //       try {
                          //         MixpanelManager.mixpanel.track('ScreenView',
                          //             properties: {'Screen': 'SignUpScreen'});
                          //       } catch (e) {
                          //         appLogs(e);
                          //       }
                          //       Navigator.pushNamedAndRemoveUntil(
                          //           context,
                          //           RouteUtilities.signUpScreen,
                          //           (route) => false);
                          //     },
                          //     title: LocaleKeys.sign_up.tr(),
                          //     textStyle: FontUtilities.h18(
                          //         fontColor: ColorUtils.color0D1F3D,
                          //         fontWeight: FWT.semiBold),
                          //     width: VariableUtilities.screenSize.width,
                          //   ),
                          // ),
                          const SizedBox(height: 10),
                        ],
                      ),
              )),
        );
      }),
    );
  }

  Widget circleBar(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 800),
      margin: const EdgeInsets.symmetric(horizontal: 5),
      height: isActive ? 8 : 8,
      width: isActive ? 26 : 26,
      curve: Curves.fastLinearToSlowEaseIn,
      decoration: BoxDecoration(
          color: isActive ? ColorUtils.primaryColor : ColorUtils.colorC8D3E7,
          borderRadius: const BorderRadius.all(Radius.circular(20))),
    );
  }
}
