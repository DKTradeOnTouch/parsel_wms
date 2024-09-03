import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:parsel_flutter/src/mvp/auth/sign_in/model/user_model.dart';
import 'package:parsel_flutter/src/mvp/dashboard/profile/view/profile_container_widget.dart';
import 'package:parsel_flutter/utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserResponse? userResponse;
  @override
  void initState() {
    print('Profile screen');
    String token =
        VariableUtilities.preferences.getString(LocalCacheKey.userToken) ?? '';
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    userResponse = UserResponse.fromJson(decodedToken);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    EasyLocalization.of(context)?.setLocale(context.locale);
    return Stack(
      children: [
        Scaffold(
          body: Container(
            color: ColorUtils.primaryColor,
            child: SafeArea(
              child: Column(children: [
                Container(
                  width: double.infinity,
                  height: 90,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(AssetUtils.authBgImage),
                          fit: BoxFit.cover)),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        LocaleKeys.profile.tr(),
                        style:
                            FontUtilities.h20(fontColor: ColorUtils.whiteColor),
                      ),
                    ),
                  ),
                ),
                Expanded(
                    child: Container(
                  width: VariableUtilities.screenSize.width,
                  decoration: const BoxDecoration(
                      color: ColorUtils.whiteColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      )),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 0),
                      child: Column(children: [
                        const SizedBox(height: 30),
                        const CircleAvatar(
                          backgroundColor: ColorUtils.colorC8D3E7,
                          radius: 55,
                          child:
                              Icon(Icons.person, color: Colors.white, size: 55),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          userResponse == null
                              ? 'unknown'
                              : capitalizeFirstLetter(
                                  userResponse!.user.email.split("@")[0]),
                          style: FontUtilities.h18(
                              fontColor: ColorUtils.color3F3E3E,
                              fontWeight: FWT.medium),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          userResponse == null
                              ? 'unknown'
                              : userResponse!.user.email,
                          style: FontUtilities.h18(
                              fontColor: ColorUtils.colorA4A9B0),
                        ),
                        const SizedBox(height: 10),
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
                        ProfileContainerWidget(
                          image: AssetUtils.changeLanguageIcon,
                          onTap: () {
                            MixpanelManager.trackEvent(
                                eventName: 'ScreenView',
                                properties: {'Screen': 'ChangeLanguageScreen'});

                            Navigator.pushNamed(context,
                                    RouteUtilities.changeLanguageScreen)
                                .then((value) {
                              print("context.locale --> ${context.locale} ");
                            });
                          },
                          title: LocaleKeys.language.tr(),
                        ),
                        // ProfileContainerWidget(
                        //   image: AssetUtils.changePasswordIcon,
                        //   onTap: () {
                        //     MixpanelManager.trackEvent(
                        //         eventName: 'ScreenView',
                        //         properties: {'Screen': 'ChangePasswordScreen'});

                        //     Navigator.pushNamed(context,
                        //             RouteUtilities.changePasswordScreen)
                        //         .then((value) {
                        //       EasyLocalization.of(context)
                        //           ?.setLocale(context.locale);
                        //     });
                        //   },
                        //   title: LocaleKeys.change_password.tr(),
                        // ),
                        // ProfileContainerWidget(
                        //   image: AssetUtils.editProfileIcon,
                        //   onTap: () {
                        //     MixpanelManager.trackEvent(
                        //         eventName: 'ScreenView',
                        //         properties: {'Screen': 'EditProfileScreen'});

                        //     Navigator.pushNamed(
                        //         context, RouteUtilities.editProfileScreen);
                        //   },
                        //   title: LocaleKeys.edit_profile.tr(),
                        // ),
                        ProfileContainerWidget(
                          image: AssetUtils.helpSupportIcon,
                          onTap: () {
                            MixpanelManager.trackEvent(
                                eventName: 'RedirectToUrl',
                                properties: {'URL': 'HelpAndSupport'});

                            Timer(const Duration(milliseconds: 300), () {
                              _launchUrl(
                                  'mailto:info@datatribe.co.in?subject=Parsel App Support');
                            });
                          },
                          title: LocaleKeys.help_and_support.tr(),
                        ),
                        ProfileContainerWidget(
                          image: AssetUtils.logoutIcon,
                          onTap: () {
                            String selectedLanguage =
                                VariableUtilities.preferences.getString(
                                        LocalCacheKey.selectedLanguage) ??
                                    '';
                            MixpanelManager.trackEvent(
                                eventName: 'ScreenView',
                                properties: {'Screen': 'SignInScreen'});

                            Navigator.pushNamedAndRemoveUntil(context,
                                RouteUtilities.signInScreen, (route) => false);
                            if (GlobalVariablesUtils.globalUpdateTimer !=
                                null) {
                              GlobalVariablesUtils.globalUpdateTimer?.cancel();
                            }
                            VariableUtilities.preferences.clear();

                            VariableUtilities.preferences
                                .setBool(LocalCacheKey.isUserLogin, false);
                            VariableUtilities.preferences.setString(
                                LocalCacheKey.selectedLanguage,
                                selectedLanguage);
                            setLanguage(language: selectedLanguage);

                            VariableUtilities.preferences.setBool(
                                LocalCacheKey.isLanguageSelected, true);
                            VariableUtilities.preferences.setBool(
                                LocalCacheKey.isOnBoardingVisited, true);
                          },
                          showDivider: false,
                          title: LocaleKeys.logout.tr(),
                        ),
                      ]),
                    ),
                  ),
                ))
              ]),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _launchUrl(String _url) async {
    if (!await launchUrl(Uri.parse(_url),
        mode: LaunchMode.externalNonBrowserApplication)) {
      throw Exception('Could not launch $_url');
    }
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
}
