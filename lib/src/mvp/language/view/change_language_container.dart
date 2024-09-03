import 'package:flutter/material.dart';
import 'package:parsel_flutter/utils/utils.dart';

class ChangeLanguageContainer extends StatelessWidget {
  const ChangeLanguageContainer(
      {Key? key,
      this.showDivider = true,
      required this.isLanguageSelected,
      required this.image,
      required this.subtitle,
      required this.title,
      required this.onTap})
      : super(key: key);
  final bool showDivider;
  final bool isLanguageSelected;
  final String image;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        InkWell(
          onTap: onTap,
          child: Container(
            color: Colors.transparent,
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset(
                    image,
                    height: 25,
                    width: 25,
                  ),
                  const SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: FontUtilities.h18(
                            fontColor: ColorUtils.color3F3E3E),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        subtitle,
                        style: FontUtilities.h16(
                            fontColor: ColorUtils.colorA4A9B0),
                      ),
                    ],
                  ),
                  const Spacer(),
                  isLanguageSelected
                      ? CircleAvatar(
                          radius: 11,
                          backgroundColor: ColorUtils.primaryColor,
                          child: const Icon(
                            Icons.check,
                            size: 12,
                            color: ColorUtils.whiteColor,
                          ),
                        )
                      : const SizedBox(),
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
