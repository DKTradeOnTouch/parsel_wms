import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:parsel_flutter/utils/utils.dart';

///Primary button
class PrimaryButton extends StatelessWidget {
  ///Constructor Primary button

  const PrimaryButton({
    required this.onTap,
    required this.title,
    this.height,
    this.width,
    this.centerWidget,
    this.color,
    this.titleColor,
    this.borderColor,
    this.textStyle,
    this.borderRadius,
    this.titleImage,
    this.visibilityColor,
    Key? key,
  }) : super(key: key);

  ///call back for button
  final VoidCallback onTap;

  ///Button height
  final double? height;

  ///Button width
  final double? width;

  ///Button color
  final Color? color;

  ///Button color
  final Color? visibilityColor;

  ///Button title color
  final Color? titleColor;

  ///Button Border color
  final Color? borderColor;

  ///Button title
  final String title;

  ///Button title
  final Widget? titleImage;

  ///Text style
  final TextStyle? textStyle;

  final Widget? centerWidget;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: visibilityColor == null ? onTap : () {},
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: height ?? 45.h,
            width: width ?? 222.w,
            decoration: BoxDecoration(
                color: color ?? ColorUtils.color0D1F3D,
                borderRadius: BorderRadius.circular(borderRadius ?? 5),
                border: Border.all(
                    color: borderColor ?? ColorUtils.colorADB3BE, width: 0)),
            child: Center(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  titleImage ?? const SizedBox(),
                  titleImage != null
                      ? const SizedBox(width: 10)
                      : const SizedBox(),
                  FittedBox(
                    fit: BoxFit.contain,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: centerWidget ??
                          Text(
                            title,
                            style: textStyle ??
                                FontUtilities.h18(
                                    fontColor:
                                        titleColor ?? ColorUtils.whiteColor,
                                    fontWeight: FWT.semiBold),
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          visibilityColor != null
              ? Container(
                  height: height ?? 45.h,
                  width: width ?? 222.w,
                  decoration: BoxDecoration(
                      color: visibilityColor ?? Colors.transparent,
                      borderRadius: BorderRadius.circular(borderRadius ?? 5),
                      border: Border.all(
                          color: borderColor ?? ColorUtils.colorADB3BE,
                          width: 0)),
                )
              : const SizedBox()
        ],
      ),
    );
  }
}
