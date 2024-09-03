import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:parsel_flutter/utils/utils.dart';

import 'app_colors.dart';
import 'app_styles.dart';

class AppHelper {
  static void hideKeyboard(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (Platform.isIOS) {
      if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
        FocusManager.instance.primaryFocus!.unfocus();
      }
    } else if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  static Future<void> changeScreen(BuildContext context, Widget screen) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) => screen,
      ),
    );
  }

  static Future<dynamic> changeScreenForResult(
      BuildContext context, Widget screen,
      {bool fullscreenDialog = false}) {
    return Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: fullscreenDialog,
        builder: (BuildContext context) => screen,
      ),
    );
  }

  static double dp(double? val, int places) {
    num mod = pow(10.0, places);
    return ((val! * mod).round().toDouble() / mod);
  }

  static void changeScreenReplace(BuildContext context, Widget screen) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (BuildContext context) => screen,
      ),
    );
  }

  static void changeScreenClearStack(BuildContext context, Widget screen) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (BuildContext context) => screen),
      (route) => false,
    );
  }

  static void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  static void showLog(String message) {
    //print(message.toString());
  }

  static bool isValidEmail(String email) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }

  static Color getColorFromHex(String hexColor) {
    return Color(
      int.parse((hexColor).replaceAll('#', '0xff')),
    );
  }

  static dashboardAppBar(
    BuildContext context,
    String title,
    Widget? callButton,
    IconData icon, {
    List<Widget>? actions,
    required VoidCallback callBack,
  }) {
    return AppBar(
      backgroundColor: Colors.black,
      leading: IconButton(
        icon: Icon(
          icon,
          size: 20,
          color: AppColors.whiteColor,
        ),
        onPressed: callBack,
      ),
      actions: actions,
      title: Text(title, style: AppStyles.appBarDashBoardStyle),

      /*flexibleSpace: Row(
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => callButton));
            },
            child: Container(
              //padding: const EdgeInsets.only(top: 20),
              margin: const EdgeInsets.only(*/ /*top: 40,*/ /* left: 35, bottom: 21),
              child: Icon(
                icon,
                size: 20,
                color: AppColors.whiteColor,
              ),
            ),
          ),
          Container(
            //padding: const EdgeInsets.only(top: 20),
            //margin: const EdgeInsets.only(top: 43, left: 34, bottom: 21),
            alignment: Alignment.centerLeft,
            child: Text(title, style: AppStyles.appBarDashBoardStyle),
          ),
        ],
      ),*/
    );
  }

  static appBar(BuildContext context, String title, callButton, IconData icon,
      {List<Widget>? actions}) {
    return AppBar(
      backgroundColor: Colors.black,
      leading: IconButton(
          icon: Icon(
            icon,
            size: 20,
            color: AppColors.whiteColor,
          ),
          onPressed: () => Navigator.maybePop(context)),
      actions: actions,
      title: Text(title, style: AppStyles.appBarDashBoardStyle),

      /*flexibleSpace: Row(
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => callButton));
            },
            child: Container(
              //padding: const EdgeInsets.only(top: 20),
              margin: const EdgeInsets.only(*/ /*top: 40,*/ /* left: 35, bottom: 21),
              child: Icon(
                icon,
                size: 20,
                color: AppColors.whiteColor,
              ),
            ),
          ),
          Container(
            //padding: const EdgeInsets.only(top: 20),
            //margin: const EdgeInsets.only(top: 43, left: 34, bottom: 21),
            alignment: Alignment.centerLeft,
            child: Text(title, style: AppStyles.appBarDashBoardStyle),
          ),
        ],
      ),*/
    );
  }

  static appBarWithActionIcon(BuildContext context, String title, callButton,
      callButtonActionIcon, IconData icon, IconData actionIcon) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(80.0), // here the desired height
      child: AppBar(
        backgroundColor: Colors.black,
        leading: const SizedBox(),
        flexibleSpace: Row(
          children: [
            InkWell(
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => callButton));
              },
              child: Container(
                padding: const EdgeInsets.only(top: 20),
                margin: const EdgeInsets.only(top: 40, left: 35, bottom: 21),
                child: Icon(
                  icon,
                  size: 20,
                  color: AppColors.whiteColor,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 20),
              margin: const EdgeInsets.only(top: 43, left: 34, bottom: 21),
              alignment: Alignment.centerLeft,
              child: Text(title, style: AppStyles.appBarDashBoardStyle),
            ),
          ],
        ),
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              callButtonActionIcon;
            },
            child: Container(
              margin: EdgeInsets.only(left: 75, right: 35, top: 35),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.whiteColor)),
              child: Icon(
                actionIcon,
                size: 16,
              ),
            ),
          )
        ],
      ),
    );
  }

  static appbarWithActionIcon2(BuildContext context, String title, callButton1,
      callButtonAtionIcon, IconData icon, IconData actionIcon) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(80.0), // here the desired height
      child: AppBar(
        backgroundColor: Colors.black,
        leading: const SizedBox(),
        flexibleSpace: Row(
          children: [
            InkWell(
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => callButton1));
              },
              child: Container(
                padding: const EdgeInsets.only(top: 20),
                margin: const EdgeInsets.only(top: 40, left: 35, bottom: 21),
                child: Icon(
                  icon,
                  size: 20,
                  color: AppColors.whiteColor,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 20),
              margin: const EdgeInsets.only(top: 43, left: 34, bottom: 21),
              alignment: Alignment.centerLeft,
              child: Text(title, style: AppStyles.appBarDashBoardStyle),
            ),
          ],
        ),
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => callButtonAtionIcon));
            },
            child: Container(
              margin: EdgeInsets.only(left: 75, right: 35, top: 35),
              child: Icon(
                actionIcon,
                size: 26,
              ),
            ),
          )
        ],
      ),
    );
  }

  static locationUpdate() {}

  static showAlert(
      String title, String message, BuildContext context, positiveCallback) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            children: [
              Container(
                  alignment: Alignment.center,
                  child: Container(
                    width: 40,
                    height: 40,
                    child: SvgPicture.asset("assets/logo.svg",
                        height: 40, width: 40, semanticsLabel: 'Acme Logo'),
                  )),
              Padding(
                padding: const EdgeInsets.only(top: 15.0, bottom: 8.0),
                child: Text(
                  title,
                  style: TextStyle(
                      color: ColorUtils.kBottomButtonColor, fontSize: 18),
                ),
              ),
            ],
          ),
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(message,
                textAlign: TextAlign.center, style: AppStyles.blackTextStyle),
          ),
          actions: <Widget>[
            Row(
              children: [
                Expanded(
                  child: InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                          height: 40,
                          width: 130,
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(4),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                offset: Offset(5, 5),
                                blurRadius: 10,
                              )
                            ],
                          ),
                          child: const Text(
                            'CANCEL',
                            style: TextStyle(color: Colors.white),
                          ))),
                ),
                const SizedBox(
                  width: 15.0,
                ),
                Expanded(
                  child: InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => positiveCallback));
                      },
                      child: Container(
                          height: 40,
                          width: 130,
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(4),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                offset: Offset(5, 5),
                                blurRadius: 10,
                              )
                            ],
                          ),
                          child: const Text(
                            'OK',
                            style: TextStyle(color: Colors.white),
                          ))),
                )
              ],
            ),
          ],
        );
      },
    );
  }
}
