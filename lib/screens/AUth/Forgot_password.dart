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
import 'package:parsel_flutter/screens/AUth/Signup.dart';

class ForgotpasswordScreen extends StatefulWidget {
  const ForgotpasswordScreen({Key? key}) : super(key: key);
  @override
  State<ForgotpasswordScreen> createState() => _ForgotpasswordScreenState();
}

class _ForgotpasswordScreenState extends State<ForgotpasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();

  var _isLoading = false;
  bool isDefault = false;
  final List<FocusNode> _focusNodes = [
    FocusNode(),
    FocusNode(),
  ];
  @override
  void initState() {
    for (var node in _focusNodes) {
      node.addListener(() {
        setState(() {});
      });
    }
    super.initState();
  }

  Future login(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });
    return await API
        .forgotpassword(context, emailController.text, showNoInternet: true)
        .then(
      (LogInModel? response) async {
        setState(() {
          _isLoading = false;
        });
        print('rsponse-->' + response.toString());
        if (response != null) {
          AppHelper.changeScreen(context, SignupScreen());
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
                                .hasMatch(value))
                          return 'Enter a valid email address';
                      }),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          login(context);
                          // AppHelper.changeScreen(context, DashBoardScreen());
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
                                'Submit',
                                style: AppStyles.buttonTextStyle,
                              ),
                            ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    InkWell(
                      onTap: () {
                        AppHelper.changeScreen(context, SignupScreen());
                      },
                      child: Text('Back to Login',
                          style: AppStyles.buttonSkipTextStyle),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                  ],
                ),
              ],
            ),
          ))),
    );
  }
}
