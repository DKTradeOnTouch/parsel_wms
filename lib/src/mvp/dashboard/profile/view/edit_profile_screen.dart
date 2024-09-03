import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import 'package:parsel_flutter/src/mvp/auth/sign_in/model/user_model.dart';
import 'package:parsel_flutter/src/widget/widget.dart';
import 'package:parsel_flutter/utils/utils.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  @override
  void initState() {
    String token =
        VariableUtilities.preferences.getString(LocalCacheKey.userToken) ?? '';
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    UserResponse userResponse = UserResponse.fromJson(decodedToken);
    emailController = TextEditingController(text: userResponse.user.email);
    nameController =
        TextEditingController(text: userResponse.user.email.split("@")[0]);
    usernameController =
        TextEditingController(text: userResponse.user.email.split("@")[0]);
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Stack(
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
                              LocaleKeys.edit_profile.tr(),
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
                                  horizontal: 25.0, vertical: 10),
                              child: Column(children: [
                                const SizedBox(height: 30),
                                const CircleAvatar(
                                  backgroundColor: ColorUtils.colorC8D3E7,
                                  radius: 55,
                                  child: Icon(Icons.person,
                                      color: Colors.white, size: 55),
                                ),
                                const SizedBox(height: 5),
                                const SizedBox(height: 20),
                                InputField(
                                  hintText: LocaleKeys.please_enter_email.tr(),
                                  controller: emailController,
                                  label: LocaleKeys.email.tr(),
                                  validator: (value) {
                                    final isEmailEmpty =
                                        Validators.validateEmptyField(
                                            value: value.toString());
                                    final isValidEmail =
                                        Validators.validateEmail(
                                            value: value.toString());
                                    if (!isEmailEmpty) {
                                      return '${LocaleKeys.please_enter_email.tr()}!';
                                    } else if (!isValidEmail) {
                                      return LocaleKeys.please_enter_valid_email
                                          .tr();
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 15),
                                InputField(
                                  hintText:
                                      LocaleKeys.please_enter_username.tr(),
                                  controller: usernameController,
                                  label: LocaleKeys.username.tr(),
                                  validator: (value) {
                                    final isNameEmpty =
                                        Validators.validateEmptyField(
                                            value: value.toString());
                                    if (!isNameEmpty) {
                                      return '${LocaleKeys.please_enter_username.tr()}!';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 15),
                                InputField(
                                  hintText: LocaleKeys.please_enter_name.tr(),
                                  controller: nameController,
                                  label: LocaleKeys.name.tr(),
                                  validator: (value) {
                                    final isNameEmpty =
                                        Validators.validateEmptyField(
                                            value: value.toString());
                                    if (!isNameEmpty) {
                                      return '${LocaleKeys.please_enter_name.tr()}!';
                                    }
                                    return null;
                                  },
                                ),
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
      ),
    );
  }
}
