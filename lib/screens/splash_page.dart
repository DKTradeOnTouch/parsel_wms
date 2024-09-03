import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:parsel_flutter/api/api.dart';
import 'package:parsel_flutter/utils/global/global_variables_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../resource/app_styles.dart';
import 'AUth/Signup.dart';
import 'dashboard.dart';

class SplashPage extends StatefulWidget {
  SplashPage({Key? key}) : super(key: key);

  @override
  SplashPageState createState() => SplashPageState();
}

class SplashPageState extends State<SplashPage> {
  bool? loginData = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      checkSignedIn();
    });
  }

  void checkSignedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    loginData = prefs.getBool("userlogined");
    if (loginData == true) {
      await API.fetchUserConfiguration(context).then((userConfigurationModel) {
        if (userConfigurationModel != null) {
          if (userConfigurationModel.status == true) {
            GlobalVariablesUtils.hasEnabledWms =
                userConfigurationModel.data.enabledWms;
          }
        }
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DashBoardScreen()),
        );
      });
    } else {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const SignupScreen(),
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff002BCA),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Image.asset
          Padding(
            padding: const EdgeInsets.only(top: 180),
            child: SizedBox(
              width: 173,
              height: 46,
              child: SvgPicture.asset(
                "assets/Logo_signup.svg",
                semanticsLabel: 'Acme Logo',
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 75, right: 40),
            alignment: Alignment.center,
            child: Text(
              'TAP TO DELIVER',
              style: AppStyles.signYellowText,
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          const SizedBox(height: 60),
          const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(),
          ),
        ],
      ),
    );
  }
}
