import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_fonts.dart';

class AppStyles {
  static TextStyle appBarTitleStyle = const TextStyle(
      color: AppColors.whiteColor,
      letterSpacing: 0.4,
      fontFamily: appFontFamily,
      fontSize: 14.0,
      fontWeight: FontWeight.w400);

  static TextStyle appBarDashBoardStyle = const TextStyle(
      color: AppColors.whiteColor,
      letterSpacing: 0.4,
      fontFamily: appFontFamily,
      fontSize: 14.0,
      fontWeight: FontWeight.w400);

  static TextStyle dashBoardWhiteTextStyle = const TextStyle(
      color: AppColors.whiteColor,
      letterSpacing: 0.4,
      fontFamily: appFontFamily,
      fontSize: 14.0,
      fontWeight: FontWeight.w500);

  static TextStyle dashBoardNumberStyle = const TextStyle(
      color: AppColors.dashBoardText,
      letterSpacing: 0.4,
      fontFamily: appFontFamily,
      fontSize: 20.0,
      fontWeight: FontWeight.w500);

  static TextStyle dashBoardTextStyle = const TextStyle(
      color: AppColors.dashBoardText,
      letterSpacing: 0.4,
      fontFamily: appFontFamily,
      fontSize: 14.0,
      fontWeight: FontWeight.w500);

  static TextStyle pickUpPoint = const TextStyle(
      color: AppColors.dashBoardText,
      fontFamily: appFontFamily,
      fontSize: 14.0,
      fontWeight: FontWeight.w400);

  static TextStyle pickUpPointHeading = const TextStyle(
      color: AppColors.dashBoardText,
      fontFamily: appFontFamily,
      fontSize: 14.0,
      fontWeight: FontWeight.w500);

  static TextStyle pickUpOrders = const TextStyle(
      color: AppColors.dashBoardText,
      fontFamily: appFontFamily,
      fontSize: 14.0,
      fontWeight: FontWeight.w400);

  static TextStyle inwardTextSKUOrders = const TextStyle(
      color: AppColors.dashBoardText,
      fontFamily: appFontFamily,
      fontSize: 14.0,
      fontWeight: FontWeight.w400);

  static TextStyle inwardSKUCount = const TextStyle(
      color: AppColors.dashBoardText,
      fontFamily: appFontFamily,
      fontSize: 16.0,
      fontWeight: FontWeight.bold);

  static TextStyle inwardTextSCANStyle = const TextStyle(
      color: AppColors.whiteColor,
      fontFamily: appFontFamily,
      fontSize: 12.0,
      fontWeight: FontWeight.w700);

  static TextStyle inwardTextBLUEStyle = const TextStyle(
      fontFamily: appFontFamily,
      fontWeight: FontWeight.w500,
      fontSize: 12,
      color: AppColors.blueColor);

  static TextStyle inward14TextBLUEStyle = const TextStyle(
      fontFamily: appFontFamily,
      fontWeight: FontWeight.w500,
      fontSize: 14,
      color: AppColors.blueColor);

  static TextStyle sortingLastList = const TextStyle(
      fontFamily: appFontFamily,
      fontWeight: FontWeight.bold,
      fontSize: 15,
      color: AppColors.black2Color);

  static TextStyle inwardTextDATAStyle = const TextStyle(
      color: AppColors.inwardDATAText,
      letterSpacing: 0.1,
      fontFamily: appFontFamily,
      fontSize: 12.0,
      fontWeight: FontWeight.bold);

  static TextStyle pickUpOrdersBold = const TextStyle(
      color: AppColors.dashBoardText,
      fontFamily: appFontFamily,
      fontSize: 10.0,
      fontWeight: FontWeight.w700);

  static TextStyle cashPayment = const TextStyle(
      color: AppColors.dashBoardText,
      fontFamily: appFontFamily,
      fontSize: 12.0,
      fontWeight: FontWeight.bold);

  static TextStyle pickUpOrdersCost = const TextStyle(
      color: AppColors.dashBoardText,
      fontFamily: appFontFamily,
      fontSize: 12.0,
      fontWeight: FontWeight.w400);

  static TextStyle dashBoardYellowTextStyle = const TextStyle(
      color: AppColors.signTextYellow,
      letterSpacing: 0.4,
      fontFamily: appFontFamily,
      fontSize: 20.0,
      fontWeight: FontWeight.w500);

  static TextStyle buttonSkipTextStyle = const TextStyle(
      color: AppColors.whiteColor,
      fontFamily: appFontFamily,
      fontSize: 12.0,
      fontWeight: FontWeight.w400);

  static TextStyle buttonTextStyle = const TextStyle(
      letterSpacing: 0.1,
      color: AppColors.whiteColor,
      fontFamily: appFontFamily,
      fontSize: 12.0,
      fontWeight: FontWeight.w700);

  static TextStyle submitButtonStyle = const TextStyle(
      letterSpacing: 0.1,
      color: AppColors.whiteColor,
      fontFamily: appFontFamily,
      fontSize: 12.0,
      fontWeight: FontWeight.w700);

  static TextStyle goodConsumableStyle = const TextStyle(
      color: AppColors.blackColor,
      fontFamily: appFontFamily,
      fontSize: 10.0,
      fontWeight: FontWeight.w600);

  static TextStyle sortingTextStyle = const TextStyle(
      color: AppColors.blackColor,
      fontFamily: appFontFamily,
      fontSize: 16.0,
      fontWeight: FontWeight.w600);

  static TextStyle storageBlue = const TextStyle(
      fontSize: 12,
      fontFamily: appFontFamily,
      fontWeight: FontWeight.w500,
      color: AppColors.blueColor);

  static TextStyle storageBlackBold = const TextStyle(
      fontSize: 18,
      fontFamily: appFontFamily,
      fontWeight: FontWeight.w800,
      color: AppColors.black2Color);

  static TextStyle blackTextStyle = const TextStyle(
      fontFamily: appFontFamily,
      fontWeight: FontWeight.w400,
      fontSize: 15,
      color: AppColors.blackColor);

  static TextStyle signYellowText = const TextStyle(
      letterSpacing: 2.3,
      fontFamily: appFontFamily,
      fontWeight: FontWeight.w600,
      fontSize: 10,
      color: AppColors.signTextYellow);
}
