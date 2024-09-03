import 'package:easy_localization/easy_localization.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:parsel_flutter/resource/app_logs.dart';
import 'package:parsel_flutter/src/mvp/auth/sign_in/api/sign_in_api.dart';
import 'package:parsel_flutter/src/mvp/auth/sign_in/model/sign_in_model.dart';
import 'package:parsel_flutter/utils/utils.dart';

class SignInProvider extends ChangeNotifier {
  bool _isVisible = true;
  bool get isVisible => _isVisible;
  set isVisible(bool val) {
    _isVisible = val;
    notifyListeners();
  }

  bool _isAgreedToTermsAndPrivacy = true;
  bool get isAgreedToTermsAndPrivacy => _isAgreedToTermsAndPrivacy;
  set isAgreedToTermsAndPrivacy(bool val) {
    _isAgreedToTermsAndPrivacy = val;
    notifyListeners();
  }

  Either<SignInModel, Exception> _signInResponse = Right(StaticException());
  Either<SignInModel, Exception> get signInResponse => _signInResponse;
  set signInResponse(Either<SignInModel, Exception> val) {
    _signInResponse = val;
    notifyListeners();
  }

  signIn(BuildContext context,
      {required String email, required String password}) async {
    signInResponse = Right(FetchingDataException());
    String domain = '';
    String str = email;
    const start = "@";
    const end = ".";
    final startIndex = str.indexOf(start);
    final endIndex = str.indexOf(end, startIndex + start.length);
    if (startIndex != -1) {
      domain = str.substring(startIndex + start.length, endIndex);
    } else {
      domain = '';
    }
    Either<SignInModel, Exception> apiResponse = await userSignInApi(context,
        email: email, password: password, domain: domain);

    if (apiResponse.isLeft) {
      signInResponse = apiResponse;
      if (signInResponse.left.token.isNotEmpty) {
        VariableUtilities.preferences.setBool(LocalCacheKey.isUserLogin, true);
        VariableUtilities.preferences
            .setBool(LocalCacheKey.isLanguageSelected, true);
        VariableUtilities.preferences
            .setBool(LocalCacheKey.isOnBoardingVisited, true);
        VariableUtilities.preferences
            .setString(LocalCacheKey.userId, signInResponse.left.type);
        VariableUtilities.preferences.setString(
            LocalCacheKey.userMobile, '${signInResponse.left.phoneNumber}');
        VariableUtilities.preferences
            .setString(LocalCacheKey.userEmail, signInResponse.left.email);
        VariableUtilities.preferences
            .setString(LocalCacheKey.userToken, signInResponse.left.token);
        try {
          MixpanelManager.trackEvent(
              eventName: 'ScreenView',
              properties: {'Screen': 'DashboardScreen'});
        } catch (e) {
          appLogs(e);
        }
        Navigator.pushNamedAndRemoveUntil(
            context, RouteUtilities.dashboardScreen, (route) => false);
        Fluttertoast.showToast(
            msg: LocaleKeys.user_authorized_successfully.tr());
      } else {
        Fluttertoast.showToast(msg: LocaleKeys.something_went_wrong.tr());
      }
    } else {
      if (signInResponse.right is FetchingDataException) {
        signInResponse = Right(BadRequestException());
        Fluttertoast.showToast(msg: LocaleKeys.failed_to_login.tr());
      } else if (apiResponse.right is AuthorizationException) {
        Fluttertoast.showToast(
            msg: LocaleKeys.email_or_password_is_incorrect.tr());
      } else {
        Fluttertoast.showToast(msg: LocaleKeys.failed_to_login.tr());
      }
      print(signInResponse.right);
    }
  }
}
