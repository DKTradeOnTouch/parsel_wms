import 'package:flutter/material.dart';
import 'package:parsel_flutter/utils/colors/colors_utils.dart';
import 'package:parsel_flutter/utils/fonts/fonts.dart';
import 'package:parsel_flutter/utils/settings/settings.dart';

class ProfileContainerWidget extends StatelessWidget {
  const ProfileContainerWidget(
      {Key? key,
      this.showDivider = true,
      required this.image,
      required this.title,
      required this.onTap})
      : super(key: key);
  final bool showDivider;
  final String image;
  final String title;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 30),
        InkWell(
          onTap: onTap,
          child: Container(
            color: Colors.transparent,
            child: Row(children: [
              Image.asset(
                image,
                height: 25,
                width: 25,
              ),
              const SizedBox(width: 20),
              Text(
                title,
                style: FontUtilities.h18(fontColor: ColorUtils.color3F3E3E),
              ),
              const Spacer(),
              const Icon(
                Icons.arrow_forward_ios_outlined,
                size: 20,
              )
            ]),
          ),
        ),
        showDivider
            ? Column(
                children: [
                  const SizedBox(height: 15),
                  Container(
                    width: VariableUtilities.screenSize.width,
                    height: 1,
                    color: ColorUtils.colorC8D3E7,
                  ),
                ],
              )
            : const SizedBox(),
      ],
    );
  }
}
