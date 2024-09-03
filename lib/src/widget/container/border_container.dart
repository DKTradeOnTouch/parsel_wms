import 'package:flutter/material.dart';
import 'package:parsel_flutter/utils/colors/colors_utils.dart';

class BorderContainer extends StatelessWidget {
  const BorderContainer({
    Key? key,
    this.isBorderRadiusBottomLeft = false,
    this.isBorderRadiusTopLeft = false,
    this.isBorderRadiusBottomRight = false,
    this.isBorderRadiusTopRight = false,
    this.isBorderBottom = false,
    this.isBorderLeft = false,
    this.isBorderRight = false,
    this.isBorderTop = false,
    this.isCenter = false,
    required this.child,
    this.onTap,
  }) : super(key: key);

  final bool isBorderRadiusBottomLeft;
  final bool isBorderRadiusTopLeft;
  final bool isBorderRadiusBottomRight;
  final bool isBorderRadiusTopRight;
  final bool isBorderBottom;
  final bool isBorderLeft;
  final bool isBorderRight;
  final bool isBorderTop;
  final bool isCenter;
  final Widget child;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () {},
      child: Container(
        height: 30,
        width: isCenter ? 40 : 35,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(isBorderRadiusBottomLeft ? 13 : 0),
            bottomRight: Radius.circular(isBorderRadiusBottomRight ? 13 : 0),
            topLeft: Radius.circular(isBorderRadiusTopLeft ? 13 : 0),
            topRight: Radius.circular(isBorderRadiusTopRight ? 13 : 0),
          ),
          border: Border(
              bottom: BorderSide(
                width: isBorderBottom ? 1 : 0,
                color: ColorUtils.primaryColor,
              ),
              left: BorderSide(
                width: isCenter
                    ? 0.0
                    : isBorderBottom
                        ? 1
                        : 0,
                color:
                    isBorderLeft ? ColorUtils.primaryColor : Colors.transparent,
              ),
              right: BorderSide(
                width: isCenter
                    ? 0.0
                    : isBorderRight
                        ? 1
                        : 0,
                color: ColorUtils.primaryColor,
              ),
              top: BorderSide(
                  width: isBorderTop ? 1 : 0, color: ColorUtils.primaryColor)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            child,
          ],
        ),
      ),
    );
  }
}
