import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:parsel_flutter/src/widget/widget.dart';
import 'package:parsel_flutter/utils/utils.dart';
import 'package:parsel_flutter/resource/app_colors.dart';
import 'package:parsel_flutter/screens/in_progress/location_service.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../resource/app_styles.dart';

class ProminentDisclosure extends StatefulWidget {
  const ProminentDisclosure({Key? key}) : super(key: key);

  @override
  State<ProminentDisclosure> createState() => _ProminentDisclosureState();
}

class _ProminentDisclosureState extends State<ProminentDisclosure>
    with WidgetsBindingObserver {
  int _locationPermTries = 0;
  int _serviceTries = 0;

  Future<void> _checkAndRequest() async {
    await Permission.notification.request();
    if (!await LocationService.instance.isPermissionGranted()) {
      if (_locationPermTries == 2) {
        SystemNavigator.pop();
      } else {
        _locationPermTries++;
        await LocationService.instance.requestPermission();
        return;
      }
    } else if (!await LocationService.instance.checkServiceEnabled()) {
      if (_serviceTries == 2) {
        SystemNavigator.pop();
      } else {
        _serviceTries++;
        await LocationService.instance.openLocationSettings();
        return;
      }
    }
    Navigator.pop(context, true);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      if (_locationPermTries >= 1 || _serviceTries >= 1) {
        _checkAndRequest();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorUtils.primaryColor,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
                decoration: const BoxDecoration(
                    color: AppColors.whiteColor,
                    borderRadius: BorderRadius.all(
                      Radius.circular(50),
                    )),
                child: const Icon(
                  Icons.location_on,
                  size: 100,
                )),
            const SizedBox(
              height: 25,
            ),
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(30),
                child: Text(
                  LocaleKeys.enable_location_description.tr(),
                  textAlign: TextAlign.center,
                  style: AppStyles.dashBoardWhiteTextStyle,
                )),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: PrimaryButton(
            borderColor: ColorUtils.color0D1F3D,
            onTap: () {
              _checkAndRequest();
            },
            title: LocaleKeys.enable_location.tr()),
      ),
      // Container(
      //   color: h,
      //     onPressed: () {

      //     },
      //     child: Text(
      //       ,
      //       style: AppStyles.dashBoardWhiteTextStyle,
      //     )),
    );
  }
}
