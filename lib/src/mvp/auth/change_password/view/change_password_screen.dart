import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:parsel_flutter/src/mvp/auth/change_password/provider/change_password_provider.dart';
import 'package:parsel_flutter/src/widget/widget.dart';
import 'package:parsel_flutter/utils/utils.dart';
import 'package:provider/provider.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordStateScreen();
}

class _ChangePasswordStateScreen extends State<ChangePasswordScreen> {
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ChangePasswordProvider changePasswordProvider =
          Provider.of(context, listen: false);
      changePasswordProvider.isConfirmPassVisible = true;
      changePasswordProvider.isNewPassVisible = true;
      changePasswordProvider.isOldPassVisible = true;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Form(
        key: _formKey,
        child: Consumer(
            builder: (__, ChangePasswordProvider changePasswordProvider, _) {
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
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
                                  LocaleKeys.change_password.tr(),
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
                        child: Column(
                          children: [
                            Expanded(
                              child: SingleChildScrollView(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25.0, vertical: 20),
                                  child: Column(children: [
                                    const SizedBox(height: 20),
                                    passwordInput(
                                        title: LocaleKeys.old_password.tr(),
                                        controller: oldPasswordController,
                                        isVisible: changePasswordProvider
                                            .isOldPassVisible,
                                        onTap: () {
                                          changePasswordProvider
                                                  .isOldPassVisible =
                                              !changePasswordProvider
                                                  .isOldPassVisible;
                                        },
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
                                        }),
                                    const SizedBox(height: 15),
                                    passwordInput(
                                        title: LocaleKeys.new_password.tr(),
                                        controller: newPasswordController,
                                        isVisible: changePasswordProvider
                                            .isNewPassVisible,
                                        onTap: () {
                                          changePasswordProvider
                                                  .isNewPassVisible =
                                              !changePasswordProvider
                                                  .isNewPassVisible;
                                        },
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
                                        }),
                                    const SizedBox(height: 15),
                                    passwordInput(
                                        title: LocaleKeys.confirm_password.tr(),
                                        controller: confirmPasswordController,
                                        isVisible: changePasswordProvider
                                            .isConfirmPassVisible,
                                        onTap: () {
                                          changePasswordProvider
                                                  .isConfirmPassVisible =
                                              !changePasswordProvider
                                                  .isConfirmPassVisible;
                                        },
                                        validator: (value) {
                                          final isPasswordEmpty =
                                              Validators.validateEmptyField(
                                                  value: value.toString());
                                          if (!isPasswordEmpty) {
                                            return '${LocaleKeys.please_enter_password.tr()}!';
                                          } else if (value !=
                                              newPasswordController.text) {
                                            return LocaleKeys
                                                .new_and_confirm_password_mis_match
                                                .tr();
                                          }
                                          return null;
                                        }),
                                  ]),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            PrimaryButton(
                              onTap: () {
                                if (_formKey.currentState!.validate()) {}
                              },
                              title: LocaleKeys.save_changes.tr(),
                              width: VariableUtilities.screenSize.width - 40,
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ))
                    ]),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget passwordInput(
      {required TextEditingController controller,
      required bool isVisible,
      required String title,
      required String? Function(String?)? validator,
      required VoidCallback onTap}) {
    return InputField(
      hintText: LocaleKeys.please_enter_password.tr(),
      controller: controller,
      isObscure: isVisible,
      label: title,
      validator: validator,
      suffixIcon: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: onTap,
            child: Container(
              height: 30,
              width: 40,
              color: Colors.transparent,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    isVisible
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
    );
  }
}
