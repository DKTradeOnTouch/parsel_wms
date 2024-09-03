import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:parsel_flutter/resource/app_logs.dart';
import 'package:parsel_flutter/utils/utils.dart';
import 'package:parsel_flutter/src/mvp/language/provider/select_language_provider.dart';
import 'package:parsel_flutter/src/widget/button/button.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

class LanguageModel {
  final String languageName;
  final String languageNativeName;

  LanguageModel({required this.languageName, required this.languageNativeName});
}

class SelectLanguageScreen extends StatefulWidget {
  const SelectLanguageScreen({Key? key}) : super(key: key);

  @override
  State<SelectLanguageScreen> createState() => _SelectLanguageScreenState();
}

class _SelectLanguageScreenState extends State<SelectLanguageScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      SelectLanguageProvider selectLanguageProvider =
          Provider.of(context, listen: false);
      setLanguage(language: selectLanguageProvider.selectedLanguage);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<LanguageModel> languagesList = [
      LanguageModel(
        languageName: 'English',
        languageNativeName: 'English',
      ),
      LanguageModel(
        languageName: 'Hindi',
        languageNativeName: 'हिंदी',
      ),
      LanguageModel(
        languageName: 'Marathi',
        languageNativeName: 'मराठी',
      ),
      LanguageModel(
        languageName: 'Gujarati',
        languageNativeName: 'ગુજરાતી',
      ),
    ];
    DateTime? currentBackPressTime;

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
        backgroundColor: ColorUtils.colorF7F9FF,
        body: SafeArea(
          child: Consumer(builder:
              (context, SelectLanguageProvider selectLanguageProvider, _) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 30),
                          Text(
                            LocaleKeys.select_language_to_continue.tr(),
                            style: FontUtilities.h18(
                                fontColor: ColorUtils.color3F3E3E,
                                fontWeight: FWT.bold),
                          ),
                          const SizedBox(height: 20),
                          Expanded(
                              child: GridView.builder(
                                  itemCount: languagesList.length,
                                  shrinkWrap: true,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    mainAxisSpacing: 10,
                                    crossAxisSpacing: 10,
                                    childAspectRatio: 1.2,
                                  ),
                                  itemBuilder: (context, index) =>
                                      GestureDetector(
                                        onTap: () {
                                          selectLanguageProvider
                                                  .selectedLanguage =
                                              languagesList[index].languageName;
                                          MixpanelManager.mixpanel.track(
                                              'Localization',
                                              properties: {
                                                'Language': languagesList[index]
                                                    .languageName
                                              });
                                          setLanguage(
                                              language: languagesList[index]
                                                  .languageName);
                                        },
                                        child: Container(
                                          height: 150,
                                          width: 220,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: ColorUtils.colorC8D3E7),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: ColorUtils.whiteColor,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                            languagesList[index]
                                                                .languageName,
                                                            style: FontUtilities
                                                                .h18(
                                                              fontColor: ColorUtils
                                                                  .color3F3E3E,
                                                            )),
                                                        Text(
                                                            languagesList[index]
                                                                .languageNativeName,
                                                            style: FontUtilities
                                                                .h18(
                                                              fontColor: ColorUtils
                                                                  .color3F3E3E,
                                                            )),
                                                      ],
                                                    ),
                                                    AnimatedContainer(
                                                      height: 20,
                                                      width: 20,
                                                      duration: const Duration(
                                                          milliseconds: 300),
                                                      decoration: BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          border: Border.all(
                                                              width: 1.5,
                                                              color: ColorUtils
                                                                  .blackColor)),
                                                      child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            AnimatedContainer(
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: selectLanguageProvider
                                                                            .selectedLanguage ==
                                                                        languagesList[index]
                                                                            .languageName
                                                                    ? ColorUtils
                                                                        .primaryColor
                                                                    : Colors
                                                                        .transparent,
                                                                shape: BoxShape
                                                                    .circle,
                                                              ),
                                                              height: 12,
                                                              width: 12,
                                                              duration:
                                                                  const Duration(
                                                                      milliseconds:
                                                                          300),
                                                            )
                                                          ]),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )))
                        ]),
                  ),
                  PrimaryButton(
                      width: VariableUtilities.screenSize.width,
                      onTap: () {
                        setLanguage(
                            language: selectLanguageProvider.selectedLanguage);
                        VariableUtilities.preferences.setString(
                            LocalCacheKey.selectedLanguage,
                            selectLanguageProvider.selectedLanguage);
                        VariableUtilities.preferences
                            .setBool(LocalCacheKey.isLanguageSelected, true);

                        try {
                          MixpanelManager.mixpanel.track('ScreenView',
                              properties: {'Screen': 'OnBoardingScreen'});
                        } catch (e) {
                          appLogs(e);
                        }
                        Navigator.pushNamedAndRemoveUntil(context,
                            RouteUtilities.onBoardingScreen, (route) => false);
                      },
                      title: 'Continue')
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  void setLanguage({required String language}) {
    switch (language) {
      case 'Gujarati':
        EasyLocalization.of(context)?.setLocale(const Locale('gu', 'IN'));
        break;

      case 'Hindi':
        EasyLocalization.of(context)?.setLocale(const Locale('hi', 'IN'));
        break;

      case 'English':
        EasyLocalization.of(context)?.setLocale(const Locale('en', 'US'));

        break;

      case 'Marathi':
        EasyLocalization.of(context)?.setLocale(const Locale('mr', 'IN'));
        break;
      default:
        EasyLocalization.of(context)?.setLocale(const Locale('en', 'US'));
    }
  }
}
