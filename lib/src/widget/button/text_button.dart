import 'package:flutter/material.dart';
import 'package:parsel_flutter/utils/utils.dart';

///Text button
class TextButtonWidget extends StatelessWidget {
  ///Constructor Text button

  const TextButtonWidget({
    required this.onTap,
    required this.title,
    this.textStyle,
    this.overlayColor,
    this.edgeInsets,
    Key? key,
  }) : super(key: key);

  ///call back for button
  final VoidCallback onTap;

  ///Overlay color
  final Color? overlayColor;

  ///Button title
  final String title;

  ///Text style
  final TextStyle? textStyle;

  ///Border Radius
  final EdgeInsets? edgeInsets;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: onTap,
        style: ButtonStyle(
            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(edgeInsets ??
                const EdgeInsets.symmetric(horizontal: 0, vertical: 0)),
            overlayColor: MaterialStateProperty.all(
                overlayColor ?? ColorUtils.primaryColor.withOpacity(0.1))),
        child: Text(
          title,
          style: textStyle ??
              FontUtilities.h16(fontColor: ColorUtils.primaryColor),
        ));
  }
}
