import 'package:flutter/material.dart';
import 'package:parsel_flutter/resource/app_colors.dart';
import 'package:parsel_flutter/utils/colors/colors_utils.dart';
import 'package:parsel_flutter/utils/fonts/font_utils.dart';

class SearchInput extends StatelessWidget {
  const SearchInput(
      {Key? key,
      required this.onChanged,
      required this.controller,
      this.hintText,
      this.padding})
      : super(key: key);
  final Function(String)? onChanged;
  final TextEditingController controller;
  final EdgeInsets? padding;
  final String? hintText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 30.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: TextFormField(
                style: FontUtilities.h16(fontColor: ColorUtils.blackColor),
                decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.search,
                    color: ColorUtils.blackColor,
                  ),
                  hintStyle:
                      FontUtilities.h16(fontColor: ColorUtils.colorAAAAAA),
                  hintText: hintText ?? "Search Item",
                  contentPadding: const EdgeInsets.only(
                      left: 15.0, right: 0.0, top: 0.0, bottom: 0.0),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                    borderSide: BorderSide(
                      // color: kTextFieldBorderColor,
                      width: 1,
                      color: ColorUtils.colorC8D3E7,
                    ),
                  ),
                ),
                onChanged: onChanged,
                controller: controller),
          ),
        ],
      ),
    );
  }
}
