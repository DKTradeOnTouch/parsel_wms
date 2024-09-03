import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:parsel_flutter/utils/utils.dart';
import 'package:parsel_flutter/src/mvp/auth/sign_up/provider/sign_up_provider.dart';
import 'package:parsel_flutter/src/widget/widget.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:easy_localization/easy_localization.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final signUpProvider =
          Provider.of<SignUpProvider>(context, listen: false);
      signUpProvider.isAgreedToTermsAndPrivacy = false;
      signUpProvider.isVisible = true;
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();
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
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Consumer(builder: (__, SignUpProvider signUpProvider, _) {
          return Container(
            color: ColorUtils.whiteColor,
            height: VariableUtilities.screenSize.height,
            width: VariableUtilities.screenSize.width,
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(children: [
                  SlidingContainer(
                      heading: '',
                      subTitle: LocaleKeys.sign_up_with_your_credentials.tr(),
                      title: LocaleKeys.sign_up.tr()),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: [
                        InputField(
                          hintText: LocaleKeys.please_enter_name.tr(),
                          controller: nameController,
                          label: LocaleKeys.name.tr(),
                          validator: (value) {
                            final isNameEmpty = Validators.validateEmptyField(
                                value: value.toString());
                            if (!isNameEmpty) {
                              return '${LocaleKeys.please_enter_name.tr()}!';
                            }
                            return null;
                          },
                        ),
                        InputField(
                          hintText: LocaleKeys.please_enter_email.tr(),
                          controller: emailController,
                          label: LocaleKeys.email.tr(),
                          validator: (value) {
                            final isEmailEmpty = Validators.validateEmptyField(
                                value: value.toString());
                            final isValidEmail = Validators.validateEmail(
                                value: value.toString());
                            if (!isEmailEmpty) {
                              return '${LocaleKeys.please_enter_email.tr()}!';
                            } else if (!isValidEmail) {
                              return LocaleKeys.please_enter_valid_email.tr();
                            }
                            return null;
                          },
                        ),
                        InputField(
                          hintText: LocaleKeys.please_enter_password.tr(),
                          controller: passwordController,
                          isObscure: signUpProvider.isVisible,
                          label: LocaleKeys.password.tr(),
                          validator: (value) {
                            final isPasswordEmpty =
                                Validators.validateEmptyField(
                                    value: value.toString());
                            if (!isPasswordEmpty) {
                              return '${LocaleKeys.please_enter_password.tr()}!';
                            } else if (value!.length < 6) {
                              return LocaleKeys
                                  .password_length_must_be_6_character
                                  .tr();
                            }
                            return null;
                          },
                          suffixIcon: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  signUpProvider.isVisible =
                                      !signUpProvider.isVisible;
                                },
                                child: Container(
                                  height: 30,
                                  width: 40,
                                  color: Colors.transparent,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        signUpProvider.isVisible
                                            ? AssetUtils.visibilityImage
                                            : AssetUtils.visibilityOffImage,
                                        height: 22,
                                        width: 22,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            SizedBox(
                              height: 24,
                              width: 24,
                              child: Checkbox(
                                value: signUpProvider.isAgreedToTermsAndPrivacy,
                                onChanged: (val) {
                                  signUpProvider.isAgreedToTermsAndPrivacy =
                                      !signUpProvider.isAgreedToTermsAndPrivacy;
                                },
                                side: const BorderSide(
                                    color: ColorUtils.blackColor, width: 1.5),
                                fillColor: MaterialStateProperty.all(
                                    ColorUtils.primaryColor),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(2)),
                                visualDensity: VisualDensity.standard,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              LocaleKeys.agree_terms_privacy.tr(),
                              style: FontUtilities.h16(
                                  fontColor: ColorUtils.colorA4A9B0),
                            ),
                            TextButtonWidget(
                              edgeInsets: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 0),
                              overlayColor:
                                  ColorUtils.colorA4A9B0.withOpacity(0.2),
                              title: LocaleKeys.terms_and_privacy.tr(),
                              textStyle: FontUtilities.h16(
                                  fontColor: ColorUtils.colorA4A9B0,
                                  decoration: TextDecoration.underline),
                              onTap: () {
                                MixpanelManager.trackEvent(
                                    eventName: 'RedirectToUrl',
                                    properties: {'URL': 'TermsAndPrivacy'});
                                Timer(const Duration(milliseconds: 300), () {
                                  _launchUrl(
                                      'https://www.google.com/search?q=example+website&rlz=1C1UEAD_enIN1058IN1058&oq=example+website&gs_lcrp=EgZjaHJvbWUyBggAEEUYOTIHCAEQABiABDIHCAIQABiABDIHCAMQABiABDIHCAQQABiABDIHCAUQABiABDIHCAYQABiABDIHCAcQABiABDIHCAgQABiABDIHCAkQABiABNIBCDY4ODRqMGo3qAIAsAIA&sourceid=chrome&ie=UTF-8');
                                });
                              },
                            )
                          ],
                        ),
                        const SizedBox(height: 20),
                        PrimaryButton(
                            width: VariableUtilities.screenSize.width,
                            onTap: () {
                              if (_formKey.currentState!.validate()) {
                                if (!signUpProvider.isAgreedToTermsAndPrivacy) {
                                  Fluttertoast.showToast(
                                      msg: LocaleKeys
                                          .please_agree_with_our_terms_and_conditions
                                          .tr());
                                  return;
                                }
                                Timer(const Duration(milliseconds: 300), () {
                                  VariableUtilities.preferences
                                      .setBool(LocalCacheKey.isUserLogin, true);
                                  MixpanelManager.trackEvent(
                                      eventName: 'ScreenView',
                                      properties: {
                                        'Screen': 'DashboardScreen'
                                      });

                                  Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      RouteUtilities.dashboardScreen,
                                      (route) => false);
                                });
                              }
                            },
                            title: LocaleKeys.sign_up.tr()),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            Text(
                              LocaleKeys.already_have_an_account.tr(),
                              style: FontUtilities.h16(
                                  fontColor: ColorUtils.colorA4A9B0),
                            ),
                            TextButtonWidget(
                                onTap: () {
                                  MixpanelManager.trackEvent(
                                      eventName: 'ScreenView',
                                      properties: {'Screen': 'SignInScreen'});
                                  Timer(const Duration(milliseconds: 300), () {
                                    Navigator.pushNamedAndRemoveUntil(
                                        context,
                                        RouteUtilities.signInScreen,
                                        (route) => false);
                                  });
                                },
                                title: LocaleKeys.sign_in.tr()),
                          ],
                        ),
                      ],
                    ),
                  )
                ]),
              ),
            ),
          );
        }),
      ),
    );
  }

  Future<void> _launchUrl(String _url) async {
    if (!await launchUrl(Uri.parse(_url))) {
      throw Exception('Could not launch $_url');
    }
  }
}
