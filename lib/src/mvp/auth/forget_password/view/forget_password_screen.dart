import 'package:flutter/material.dart';

import 'package:parsel_flutter/utils/utils.dart';
import 'package:parsel_flutter/src/widget/widget.dart';
import 'package:easy_localization/easy_localization.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  TextEditingController emailController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: ColorUtils.primaryColor,
        child: SafeArea(
          child: Column(children: [
            Container(
              width: double.infinity,
              height: 90,
              decoration: const BoxDecoration(
                  // color: ColorUtils.blueColor,
                  image: DecorationImage(
                      image: AssetImage(AssetUtils.authBgImage),
                      fit: BoxFit.cover)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        color: ColorUtils.whiteColor,
                      )),
                  const SizedBox(width: 10),
                  Text(
                    LocaleKeys.forget_password.tr(),
                    style: FontUtilities.h20(fontColor: ColorUtils.whiteColor),
                  )
                ]),
              ),
            ),
            Expanded(
                child: Form(
              key: _formKey,
              child: Container(
                width: VariableUtilities.screenSize.width,
                decoration: const BoxDecoration(
                    color: ColorUtils.whiteColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    )),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 30),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // InputField(
                        //   hintText: LocaleKeys.please_enter_email.tr(),
                        //   controller: emailController,
                        //   label: LocaleKeys.email.tr(),
                        //   validator: (value) {
                        //     final isEmailEmpty = Validators.validateEmptyField(
                        //         value: value.toString());
                        //     final isValidEmail = Validators.validateEmail(
                        //         value: value.toString());
                        //     if (!isEmailEmpty) {
                        //       return '${LocaleKeys.please_enter_email .tr()}!';
                        //     } else if (!isValidEmail) {
                        //       return LocaleKeys.please_enter_valid_email.tr();
                        //     }
                        //     return null;
                        //   },
                        // ),
                        const SizedBox(),
                        Text(
                          '${LocaleKeys.contact_administrator_for_new_password.tr()}.',
                          style: FontUtilities.h15(
                              fontColor: ColorUtils.color595959,
                              fontWeight: FWT.semiBold),
                        ),
                        PrimaryButton(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          title: LocaleKeys.ok.tr(),
                          width: VariableUtilities.screenSize.width,
                        )
                      ]),
                ),
              ),
            ))
          ]),
        ),
      ),
    );
  }
}
