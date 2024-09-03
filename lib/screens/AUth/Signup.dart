import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:parsel_flutter/utils/utils.dart';
import 'package:parsel_flutter/api/api.dart';
import 'package:parsel_flutter/models/login_model.dart';
import 'package:parsel_flutter/resource/app_colors.dart';
import 'package:parsel_flutter/resource/app_fonts.dart';
import 'package:parsel_flutter/resource/app_helper.dart';
import 'package:parsel_flutter/resource/app_strings.dart';
import 'package:parsel_flutter/resource/app_styles.dart';
import 'package:parsel_flutter/screens/dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Forgot_password.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  var _isLoading = false;
  bool isDefault = false;
  final List<FocusNode> _focusNodes = [
    FocusNode(),
    FocusNode(),
  ];

  String domain = '';

  bool loginDATA = false;

  @override
  void initState() {
    for (var node in _focusNodes) {
      node.addListener(() {
        setState(() {});
      });
    }
    super.initState();
  }

  Future login(BuildContext context, var Email, var Phone, domain) async {
    setState(() {
      _isLoading = true;
    });
    return await API
        .login(
      context,
      Email,
      passwordController.text,
      Phone,
      domain,
      showNoInternet: true,
    )
        .then(
      (LogInModel? response) async {
        setState(() {
          _isLoading = false;
        });
        print('response-->' + response.toString());
        if (response != null) {
          // AppHelper.showSnackBar(context, AppStrings.strLoginSucessFully);
          final preference = await SharedPreferences.getInstance();
          preference.setBool('userlogined', true);
          preference.setString('userID', response.type.toString());
          preference.setString('mobile', response.phoneNumber.toString());
          preference.setString('email', response.email.toString());
          preference.setString('token', response.token.toString());
          loginDATA = preference.getBool('userlogined')!;
          print('loginDATA-->' + loginDATA.toString());
          // loginDATA
          //     ?
          await API
              .fetchUserConfiguration(context)
              .then((userConfigurationModel) {
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
          // AppHelper.changeScreen(context, DashBoardScreen());
          // : AppHelper.changeScreen(
          //     context,
          //     DashBoardScreen(
          //       logFirst: 1,
          //     ));
        } else {
          AppHelper.showSnackBar(context, AppStrings.strSomethingWentWrong);
        }
      },
    ).onError((error, stackTrace) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
          backgroundColor: ColorUtils.primaryColor,
          body: SingleChildScrollView(
              child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 150),
                  child: Container(
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
                SizedBox(
                  height: 25,
                ),
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  child: TextFormField(
                      controller: emailController,
                      focusNode: _focusNodes[0],
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          prefixIcon: Icon(
                            Icons.email_outlined,
                            color: _focusNodes[0].hasFocus
                                ? AppColors.blueColor
                                : AppColors.signDefaultIcon,
                          ),
                          errorStyle: TextStyle(color: AppColors.whiteColor),
                          hintText: 'Email or Phone Number',
                          hintStyle: TextStyle(
                              color: AppColors.signText,
                              fontFamily: appFontFamily,
                              fontWeight: FontWeight.w400),
                          fillColor: Colors.white,
                          focusColor: Colors.white),
                      validator: (value) {
                        if (value!.isEmpty ||
                            !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(value) &&
                                !RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)')
                                    .hasMatch(value)) {
                          return 'Please enter a valid email or phone number.';
                        }
                      }),
                ),
                Container(
                  margin:
                      const EdgeInsets.only(left: 50, right: 50, bottom: 40),
                  child: TextFormField(
                    controller: passwordController,
                    focusNode: _focusNodes[1],
                    obscureText: true,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        filled: true,
                        prefixIcon: Icon(
                          Icons.lock_outline,
                          color: _focusNodes[1].hasFocus
                              ? AppColors.blueColor
                              : AppColors.signDefaultIcon,
                        ),
                        hintText: 'Password',
                        hintStyle: TextStyle(
                            color: AppColors.signText,
                            fontWeight: FontWeight.w400,
                            fontFamily: appFontFamily),
                        fillColor: Colors.white,
                        focusColor: Colors.grey),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please Enter your password';
                      }
                      return null;
                    },
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        String str = emailController.text;
                        const start = "@";
                        const end = ".";
                        final startIndex = str.indexOf(start);
                        final endIndex =
                            str.indexOf(end, startIndex + start.length);
                        if (startIndex != -1) {
                          domain = str.substring(
                              startIndex + start.length, endIndex);
                        } else {
                          domain = '';
                        }
                        print('domain-->' + domain.toString());
                        if (_formKey.currentState!.validate()) {
                          if (RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(emailController.text) ==
                              true) {
                            login(context, emailController.text, "", domain);
                            print("email");
                          } else if (RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)')
                                  .hasMatch(emailController.text) ==
                              true) {
                            login(context, "", emailController.text, domain);
                            print("phone");
                          }
                        } else {
                          return;
                        }
                      },
                      child: _isLoading
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : Container(
                              width: 180,
                              padding: const EdgeInsets.symmetric(
                                vertical: 18,
                              ),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: AppColors.black2Color,
                              ),
                              child: Text(
                                'SIGN IN',
                                style: AppStyles.buttonTextStyle,
                              ),
                            ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    InkWell(
                      onTap: () {
                        AppHelper.changeScreen(context, ForgotpasswordScreen());
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Forgot Password',
                            style: AppStyles.buttonSkipTextStyle),
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Help',
                          style: AppStyles.buttonSkipTextStyle,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.yellowColor)),
                          child: Icon(
                            Icons.question_mark,
                            color: AppColors.yellowColor,
                            size: 16,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ))),
    );
  }
}
