import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:parsel_flutter/resource/app_logs.dart';
import 'package:parsel_flutter/utils/utils.dart';
import 'package:parsel_flutter/src/mvp/splash/view/splash_animation.dart';
import 'package:in_app_update/in_app_update.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (Core.isKeyboardOpen(context)) {
        Core.hideKeyBoard();
      }
      await checkForUpdate();

      Timer.periodic(const Duration(seconds: 4), (timer) {
        bool isOnBoardingVisited = VariableUtilities.preferences
                .getBool(LocalCacheKey.isOnBoardingVisited) ??
            false;

        bool isUserLogin =
            VariableUtilities.preferences.getBool(LocalCacheKey.isUserLogin) ??
                false;

        bool isLanguageSelected = VariableUtilities.preferences
                .getBool(LocalCacheKey.isLanguageSelected) ??
            false;

        print(
            "isUserLogin $isUserLogin ,isLanguageSelected $isLanguageSelected, isOnBoardingVisited $isOnBoardingVisited ");
        timer.cancel();

        if (isLanguageSelected == false) {
          try {
            MixpanelManager.trackEvent(
                eventName: 'ScreenView',
                properties: {'Screen': 'SelectLanguageScreen'});
          } catch (e) {
            if (kDebugMode) {
              print(e);
            }
          }
          Navigator.pushNamedAndRemoveUntil(
              context, RouteUtilities.selectLanguageScreen, (route) => false);
          return;
        }
        String selectedLanguage = VariableUtilities.preferences
                .getString(LocalCacheKey.selectedLanguage) ??
            '';
        setLanguage(language: selectedLanguage);
        if (isOnBoardingVisited == false) {
          try {
            MixpanelManager.trackEvent(
                eventName: 'ScreenView',
                properties: {'Screen': 'OnBoardingScreen'});
          } catch (e) {
            appLogs(e);
          }
          Navigator.pushNamedAndRemoveUntil(
              context, RouteUtilities.onBoardingScreen, (route) => false);
          return;
        }
        if (isUserLogin) {
          try {
            MixpanelManager.trackEvent(
                eventName: 'ScreenView',
                properties: {'Screen': 'DashboardScreen'});
          } catch (e) {
            appLogs(e);
          }
          Navigator.pushNamedAndRemoveUntil(
              context, RouteUtilities.dashboardScreen, (route) => false);
          return;
        } else {
          try {
            MixpanelManager.trackEvent(
                eventName: 'ScreenView',
                properties: {'Screen': 'SignInScreen'});
          } catch (e) {
            appLogs(e);
          }
          Navigator.pushNamedAndRemoveUntil(
              context, RouteUtilities.signInScreen, (route) => false);
          return;
        }
      });
    });

    super.initState();
  }

  Future<void> checkForUpdate() async {
    InAppUpdate.checkForUpdate().then((updateInfo) {
      print('updateInfo --> $updateInfo');
      // if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
      //   VariableUtilities.preferences
      //       .setBool(LocalCacheKey.isAppUpdateAvailable, true);
      // if (updateInfo.immediateUpdateAllowed) {
      //   // Perform immediate update
      //   InAppUpdate.performImmediateUpdate().then((appUpdateResult) {
      //     if (appUpdateResult == AppUpdateResult.success) {
      //       //App Update successful
      //     }
      //   });
      // } else if (updateInfo.flexibleUpdateAllowed) {
      //Perform flexible update
      // InAppUpdate.startFlexibleUpdate().then((appUpdateResult) {
      //   if (appUpdateResult == AppUpdateResult.success) {
      //     VariableUtilities.preferences
      //         .setBool(LocalCacheKey.isAppUpdateAvailable, false);
      //     //App Update successful
      //     InAppUpdate.completeFlexibleUpdate();
      //   }
      // });
      // }
      // }
    }).catchError((e) {
      print("error while Splash screen -> $e");
    });
  }

  void setLanguage({required String language}) {
    print("Language --> $language");
    switch (language) {
      case 'Gujarati':
        EasyLocalization.of(context)?.setLocale(const Locale('gu', 'IN'));
        VariableUtilities.preferences
            .setString(LocalCacheKey.selectedLanguage, language);
        break;

      case 'Hindi':
        EasyLocalization.of(context)?.setLocale(const Locale('hi', 'IN'));
        VariableUtilities.preferences
            .setString(LocalCacheKey.selectedLanguage, language);
        break;

      case 'English':
        EasyLocalization.of(context)?.setLocale(const Locale('en', 'US'));
        VariableUtilities.preferences
            .setString(LocalCacheKey.selectedLanguage, language);
        break;

      case 'Marathi':
        EasyLocalization.of(context)?.setLocale(const Locale('mr', 'IN'));
        VariableUtilities.preferences
            .setString(LocalCacheKey.selectedLanguage, language);
        break;

      default:
        EasyLocalization.of(context)?.setLocale(const Locale('en', 'US'));
    }
  }

  @override
  Widget build(BuildContext context) {
    VariableUtilities.screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: IgnorePointer(
                  child: AnimationScreen(color: ColorUtils.primaryColor),
                ),
              ),
            ]),
      ),
    );
  }
}
