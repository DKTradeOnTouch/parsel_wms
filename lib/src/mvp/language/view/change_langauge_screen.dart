import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:parsel_flutter/src/mvp/language/provider/select_language_provider.dart';
import 'package:parsel_flutter/src/mvp/language/view/change_language_container.dart';
import 'package:parsel_flutter/src/mvp/language/view/select_language_screen.dart';
import 'package:parsel_flutter/utils/utils.dart';
import 'package:provider/provider.dart';

class ChangeLanguageScreen extends StatefulWidget {
  const ChangeLanguageScreen({Key? key}) : super(key: key);

  @override
  State<ChangeLanguageScreen> createState() => _ChangeLanguageScreenState();
}

class _ChangeLanguageScreenState extends State<ChangeLanguageScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      String selectedLanguage = VariableUtilities.preferences
              .getString(LocalCacheKey.selectedLanguage) ??
          '';
      SelectLanguageProvider selectLanguageProvider =
          Provider.of(context, listen: false);
      selectLanguageProvider.selectedLanguage = selectedLanguage;
      setLanguage(language: selectedLanguage);
    });
    super.initState();
  }

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
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return true;
      },
      child: Consumer(
          builder: (__, SelectLanguageProvider selectLanguageProvider, _) {
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
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: const Icon(
                                  Icons.arrow_back_ios,
                                  color: ColorUtils.whiteColor,
                                ),
                              ),
                              Text(
                                LocaleKeys.language.tr(),
                                style: FontUtilities.h20(
                                    fontColor: ColorUtils.whiteColor),
                              ),
                            ],
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
                              horizontal: 25.0, vertical: 20),
                          child: Column(children: [
                            ListView.builder(
                                shrinkWrap: true,
                                itemCount: languagesList.length,
                                itemBuilder: (_, index) {
                                  return ChangeLanguageContainer(
                                    showDivider:
                                        index != languagesList.length - 1,
                                    isLanguageSelected: selectLanguageProvider
                                            .selectedLanguage ==
                                        languagesList[index].languageName,
                                    image: AssetUtils.changeLanguageIcon,
                                    onTap: () {
                                      selectLanguageProvider.selectedLanguage =
                                          languagesList[index].languageName;
                                      MixpanelManager.mixpanel
                                          .track('Localization', properties: {
                                        'Language':
                                            languagesList[index].languageName
                                      });

                                      setLanguage(
                                          language: languagesList[index]
                                              .languageName);
                                      setState(() {});
                                    },
                                    title: languagesList[index].languageName,
                                    subtitle:
                                        languagesList[index].languageNativeName,
                                  );
                                })
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
      }),
    );
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
