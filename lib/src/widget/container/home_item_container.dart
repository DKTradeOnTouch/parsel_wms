import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:parsel_flutter/utils/utils.dart';

class HomeItemContainer extends StatelessWidget {
  const HomeItemContainer(
      {Key? key,
      this.label,
      this.backgroundColor,
      this.itemImage,
      this.countContainerColor,
      this.countStyleColor,
      this.count,
      this.onTap})
      : super(key: key);
  final String? label;
  final String? itemImage;
  final Color? backgroundColor;
  final Color? countContainerColor;
  final Color? countStyleColor;
  final int? count;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () {},
      child: Container(
        height: 140,
        width: 220,
        decoration: BoxDecoration(
          border: Border.all(color: ColorUtils.colorC8D3E7),
          borderRadius: BorderRadius.circular(10),
          color: backgroundColor ?? ColorUtils.colorFFE2E2,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(
              itemImage ?? AssetUtils.pendingIconImage,
              height: 30,
              width: 46,
            ),
            Text(label ?? '',
                style: FontUtilities.h18(
                  fontColor: ColorUtils.color3F3E3E,
                )),
            Container(
              height: 35,
              width: 35,
              child: Center(
                  child: Text(count != null ? '$count' : '0',
                      style: FontUtilities.h16(
                        fontColor: countStyleColor ?? ColorUtils.color3F3E3E,
                      ))),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: countContainerColor ?? ColorUtils.whiteColor),
            )
          ],
        ),
      ),
    );
  }
}
