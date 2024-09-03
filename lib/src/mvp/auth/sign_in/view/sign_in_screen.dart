import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:parsel_flutter/api/endpoints.dart';
import 'package:parsel_flutter/utils/utils.dart';
import 'package:parsel_flutter/src/mvp/auth/sign_in/provider/sign_in_provider.dart';
import 'package:parsel_flutter/src/widget/widget.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:easy_localization/easy_localization.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController emailController =
      TextEditingController(text: kDebugMode ? 'santosh@tjuk.com' : '');
  TextEditingController passwordController =
      TextEditingController(text: kDebugMode ? '008899' : '');

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final signInProvider =
          Provider.of<SignInProvider>(context, listen: false);

      signInProvider.isAgreedToTermsAndPrivacy = kDebugMode ? true : false;
      signInProvider.isVisible = true;
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
    return Consumer(builder: (__, SignInProvider signInProvider, _) {
      return Stack(
        children: [
          WillPopScope(
            onWillPop: () async {
              DateTime now = DateTime.now();
              if (currentBackPressTime == null ||
                  now.difference(currentBackPressTime!) >
                      const Duration(seconds: 2)) {
                currentBackPressTime = now;
                Fluttertoast.showToast(
                    msg: LocaleKeys.swipe_again_to_exit_app.tr());
                // return Future.value(false);
                return Future.value(false);
              }
              await SystemNavigator.pop();
              return Future.value(true);
            },
            child: Scaffold(
              resizeToAvoidBottomInset: true,
              body: Container(
                color: ColorUtils.whiteColor,
                height: VariableUtilities.screenSize.height,
                width: VariableUtilities.screenSize.width,
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(children: [
                      SlidingContainer(
                          heading:
                              LocaleKeys.welcome_to_parsel_delivery_app.tr(),
                          subTitle:
                              LocaleKeys.enter_email_and_enter_password.tr(),
                          title: LocaleKeys.sign_in.tr()),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          children: [
                            InputField(
                              hintText: LocaleKeys.please_enter_email.tr(),
                              controller: emailController,
                              label: LocaleKeys.email.tr(),
                              validator: (value) {
                                final isEmailEmpty =
                                    Validators.validateEmptyField(
                                        value: value.toString());
                                final isValidEmail = Validators.validateEmail(
                                    value:
                                        value.toString().toLowerCase().trim());
                                if (!isEmailEmpty) {
                                  return '${LocaleKeys.please_enter_email.tr()}!';
                                } else if (!isValidEmail) {
                                  return LocaleKeys.please_enter_valid_email
                                      .tr();
                                }
                                return null;
                              },
                            ),
                            InputField(
                              hintText: LocaleKeys.please_enter_password.tr(),
                              controller: passwordController,
                              isObscure: signInProvider.isVisible,
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
                              labelButton: SizedBox(
                                height: 30,
                                child: TextButtonWidget(
                                    onTap: () {
                                      MixpanelManager.trackEvent(
                                          eventName: 'ScreenView',
                                          properties: {
                                            'Screen': 'ForgotPasswordScreen'
                                          });
                                      Timer(const Duration(milliseconds: 300),
                                          () {
                                        Navigator.pushNamed(
                                            context,
                                            RouteUtilities
                                                .forgotPasswordScreen);
                                      });
                                    },
                                    title: LocaleKeys.forget_password.tr()),
                              ),
                              suffixIcon: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      signInProvider.isVisible =
                                          !signInProvider.isVisible;
                                    },
                                    child: Container(
                                      height: 30,
                                      width: 40,
                                      color: Colors.transparent,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            signInProvider.isVisible
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

                            ///Uncomment this code whenever we needed.
                            // DropdownButtonFormField(
                            //     value: APIUtilities.staticBaseUrl,
                            //     items: const [
                            //       DropdownMenuItem<String>(
                            //           value:
                            //               "http://${isProd ? "web" : "backend"}.parsel.in:9091/",
                            //           child: Text(
                            //             "http://${isProd ? "web" : "backend"}.parsel.in:9091/",
                            //           )),
                            //       DropdownMenuItem<String>(
                            //           value:
                            //               "http://${isProd ? "web" : "backend"}.parsel.in:9090/",
                            //           child: Text(
                            //             "http://${isProd ? "web" : "backend"}.parsel.in:9090/",
                            //           ))
                            //     ],
                            //     onChanged: (val) {
                            //       APIUtilities.staticBaseUrl = val as String;
                            //     }),
                            // const SizedBox(height: 10),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: Checkbox(
                                      value: signInProvider
                                          .isAgreedToTermsAndPrivacy,
                                      onChanged: (val) {
                                        signInProvider
                                                .isAgreedToTermsAndPrivacy =
                                            !signInProvider
                                                .isAgreedToTermsAndPrivacy;
                                      },
                                      side: BorderSide(
                                          color: ColorUtils.primaryColor,
                                          width: 1.5),
                                      fillColor: MaterialStateProperty.all(
                                          signInProvider
                                                  .isAgreedToTermsAndPrivacy
                                              ? ColorUtils.primaryColor
                                              : ColorUtils.whiteColor),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(2)),
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
                                          properties: {
                                            'URL': 'TermsAndPrivacy'
                                          });

                                      Timer(const Duration(milliseconds: 300),
                                          () {
                                        _launchUrl(
                                            'https://www.parselexchange.com/general-8');
                                      });
                                    },
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            PrimaryButton(
                                width: VariableUtilities.screenSize.width,
                                onTap: () async {
                                  if (_formKey.currentState!.validate()) {
                                    if (!signInProvider
                                        .isAgreedToTermsAndPrivacy) {
                                      Fluttertoast.showToast(
                                          msg: LocaleKeys
                                              .please_agree_with_our_terms_and_conditions
                                              .tr());
                                      return;
                                    }
                                    await signInProvider.signIn(context,
                                        email: emailController.text,
                                        password: passwordController.text);
                                  }
                                },
                                title: LocaleKeys.sign_in.tr()),
                            const SizedBox(height: 10),
                            // Row(
                            //   children: [
                            //     Text(
                            //       LocaleKeys.do_not_have_an_account.tr(),
                            //       style: FontUtilities.h16(
                            //           fontColor: ColorUtils.colorA4A9B0),
                            //     ),
                            //     TextButtonWidget(
                            //         onTap: () {
                            //           MixpanelManager.trackEvent(
                            //               eventName: 'ScreenView',
                            //               properties: {
                            //                 'Screen': 'SignUpScreen'
                            //               });
                            //           Timer(const Duration(milliseconds: 300),
                            //               () {
                            //             Navigator.pushNamedAndRemoveUntil(
                            //                 context,
                            //                 RouteUtilities.signUpScreen,
                            //                 (route) => false);
                            //           });
                            //         },
                            //         title: LocaleKeys.sign_up.tr()),
                            //   ],
                            // ),
                          ],
                        ),
                      ),
                    ]),
                  ),
                ),
              ),
              // bottomNavigationBar: Container(
              //   decoration: const BoxDecoration(
              //     border: Border(
              //       top: BorderSide(width: 1, color: ColorUtils.colorA4A9B0),
              //     ),
              //     color: ColorUtils.whiteColor,
              //   ),
              //   height: 55,
              //   width: VariableUtilities.screenSize.width,
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       Text(
              //         LocaleKeys.become_delivery_driver.tr(),
              //         style:
              //             FontUtilities.h16(fontColor: ColorUtils.colorA4A9B0),
              //       ),
              //       TextButtonWidget(
              //           onTap: () {
              //             MixpanelManager.trackEvent(
              //                 eventName: 'ScreenView',
              //                 properties: {'Screen': 'SignUpScreen'});
              //             Timer(const Duration(milliseconds: 300), () {
              //               Navigator.pushNamedAndRemoveUntil(context,
              //                   RouteUtilities.signUpScreen, (route) => false);
              //             });
              //           },
              //           title: LocaleKeys.sign_up.tr()),
              //     ],
              //   ),
              // ),
            ),
          ),
          (signInProvider.signInResponse.isRight &&
                  signInProvider.signInResponse.right is FetchingDataException)
              ? CustomCircularProgressIndicator()
              : const SizedBox()
        ],
      );
    });
  }

  Future<void> _launchUrl(String _url) async {
    if (!await launchUrl(Uri.parse(_url),
        mode: LaunchMode.externalNonBrowserApplication)) {
      throw Exception('Could not launch $_url');
    }
  }
}
