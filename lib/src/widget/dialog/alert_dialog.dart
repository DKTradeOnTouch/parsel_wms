import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:parsel_flutter/src/widget/widget.dart';
import 'package:parsel_flutter/utils/utils.dart';

class CustomAlertDialog extends StatelessWidget {
  const CustomAlertDialog(
      {Key? key,
      required this.imageUrl,
      required this.title,
      required this.subTitle,
      required this.rejectTitle,
      required this.submitTitle,
      required this.rejectOnTap,
      required this.submitOnTap})
      : super(key: key);
  final String imageUrl;
  final String title;
  final String subTitle;
  final String rejectTitle;
  final String submitTitle;
  final VoidCallback rejectOnTap;
  final VoidCallback submitOnTap;

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
                    const SizedBox(height: 5),
                    Text(title,
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
                        children: [
                          Expanded(
                            child: PrimaryButton(
                                textStyle: TextStyle(
                                    color: ColorUtils.whiteColor,
                                    fontWeight: getFontWeight(FWT.semiBold),
                                    fontSize: 16.sp,
                                    fontFamily: 'Roboto'),
                                height: 45,
                                borderRadius: 10,
                                width: VariableUtilities.screenSize.width / 2,
                                onTap: rejectOnTap,
                                title: rejectTitle),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: PrimaryButton(
                                height: 45,
                                borderRadius: 10,
                                borderColor: ColorUtils.color0D1F3D,
                                titleColor: ColorUtils.color0D1F3D,
                                color: Colors.transparent,
                                width: VariableUtilities.screenSize.width / 2,
                                textStyle: TextStyle(
                                    color: ColorUtils.color0D1F3D,
                                    fontWeight: getFontWeight(FWT.semiBold),
                                    fontSize: 16.sp,
                                    fontFamily: 'Roboto'),
                                onTap: submitOnTap,
                                title: submitTitle),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 40,
                    width: 40,
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
