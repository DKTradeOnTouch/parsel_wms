import 'package:flutter/material.dart';
import 'package:parsel_flutter/src/widget/widget.dart';
import 'package:parsel_flutter/utils/utils.dart';

class StartTripDialog extends StatelessWidget {
  const StartTripDialog({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.subTitle,
    required this.submitTitle,
    required this.submitOnTap,
    this.rejectTitle = '',
    this.rejectOnTap,
    this.isPaymentDialog = false,
  }) : super(key: key);

  final String imageUrl;
  final String title;
  final String subTitle;
  final String submitTitle;
  final String rejectTitle;
  final VoidCallback submitOnTap;
  final VoidCallback? rejectOnTap;
  final bool isPaymentDialog;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
          child: Theme(
        data: ThemeData(useMaterial3: false),
        child: AlertDialog(
          shape: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.circular(10),
          ),
          title: Stack(
            children: [
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      imageUrl,
                      height: 90,
                    ),
                    Text(title,
                        textAlign: TextAlign.center,
                        style: FontUtilities.h18(
                            fontColor: ColorUtils.color3F3E3E,
                            fontWeight: FWT.semiBold)),
                    const SizedBox(height: 8),
                    Text(subTitle,
                        textAlign: TextAlign.center,
                        style: FontUtilities.h16(
                            fontColor: ColorUtils.color9E9E9E)),
                    const SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          rejectTitle.isEmpty
                              ? const SizedBox()
                              : Expanded(
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: PrimaryButton(
                                            height: 45,
                                            borderRadius: 10,
                                            width: VariableUtilities
                                                    .screenSize.width /
                                                2,
                                            onTap: rejectOnTap ?? () {},
                                            title: rejectTitle),
                                      ),
                                      const SizedBox(width: 10),
                                    ],
                                  ),
                                ),
                          Expanded(
                            child: PrimaryButton(
                                height: 45,
                                borderRadius: 10,
                                borderColor: ColorUtils.color0D1F3D,
                                titleColor: rejectTitle.isEmpty
                                    ? ColorUtils.whiteColor
                                    : ColorUtils.color0D1F3D,
                                color: rejectTitle.isEmpty
                                    ? ColorUtils.color0D1F3D
                                    : Colors.transparent,
                                width: VariableUtilities.screenSize.width / 2,
                                onTap: submitOnTap,
                                title: submitTitle),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              isPaymentDialog
                  ? const SizedBox()
                  : Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          height: 20,
                          width: 30,
                          color: Colors.transparent,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Image.asset(
                                AssetUtils.cancelImage,
                                color: ColorUtils.color595959,
                                height: 15,
                                width: 15,
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
            ],
          ),
        ),
      )),
    );
  }
}
