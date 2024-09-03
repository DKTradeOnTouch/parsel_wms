import 'package:flutter/material.dart';
import 'package:parsel_flutter/src/widget/widget.dart';
import 'package:parsel_flutter/utils/utils.dart';

///Validator for text field
typedef DropDownOnChanged = Function(String?)?;

///Input text field
class DropDownInputField extends StatefulWidget {
  ///Input text field constructor

  const DropDownInputField({
    required this.items,
    required this.label,
    required this.hintText,
    required this.selectedValue,
    // required this.focusNode,
    this.validator,
    this.labelButton,
    this.suffixIcon,
    this.hintTextStyle,
    this.prefixIcon,
    this.onTap,
    this.readOnly,
    this.isObscure = false,
    Key? key,
    this.onChanged,
  }) : super(key: key);

  ///Controller for input field
  final List<DropdownMenuItem<String>> items;

  ///Selected Item From Drop Down
  final String selectedValue;

  ///Label for input textfield
  final String label;

  ///Label Button for input textfield
  final Widget? labelButton;

  ///Hint Text for input textfield
  final String hintText;

  ///Hint TextStyle for input textfield
  final TextStyle? hintTextStyle;

  ///Validator for textfield
  final Validator validator;

  ///OnChanged for textfield
  final DropDownOnChanged onChanged;

  ///Suffix Icon
  final Widget? suffixIcon;

  ///Prefix Icon
  final Widget? prefixIcon;

  ///On tap for input field
  final VoidCallback? onTap;

  ///Read only
  final bool? readOnly;

  ///Text Field is obscure
  final bool? isObscure;

  @override
  State<DropDownInputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<DropDownInputField> {
  bool isTapped = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        widget.label.isEmpty
            ? const SizedBox()
            : Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.label,
                    style: FontUtilities.h16(fontColor: ColorUtils.colorA4A9B0),
                  ),
                  widget.labelButton ?? const SizedBox()
                ],
              ),
        const SizedBox(height: 5),
        Focus(
          onFocusChange: (focus) {
            isTapped = focus;
            setState(() {});
          },
          child: DropdownButtonFormField<String>(
            value: widget.selectedValue,
            onTap: widget.onTap ?? () {},
            validator: widget.validator ??
                (String? val) {
                  return 'Please Enter Appropriate Value';
                },
            items: widget.items,
            icon: const Visibility(
                visible: true, child: Icon(Icons.keyboard_arrow_down)),
            onChanged: widget.onChanged,
            style: FontUtilities.h16(fontColor: ColorUtils.color3F3E3E),
            decoration: InputDecoration(
                prefixIcon: widget.prefixIcon,
                hintText: widget.hintText,
                hintStyle: widget.hintTextStyle ??
                    FontUtilities.h14(fontColor: ColorUtils.colorA4A9B0),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                enabledBorder: CustomInputBorder(
                  boxShadow: [
                    BoxShadow(
                      color: isTapped
                          ? ColorUtils.primaryColor.withOpacity(0.4)
                          : ColorUtils.primaryColor.withOpacity(0.0),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(
                          0, 1), // Adjust the offset as per your preference
                    ),
                  ],
                  // borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(
                      color: ColorUtils.colorC8D3E7, style: BorderStyle.solid),
                ),
                border: CustomInputBorder(
                  boxShadow: [
                    BoxShadow(
                      color: isTapped
                          ? ColorUtils.primaryColor.withOpacity(0.4)
                          : ColorUtils.primaryColor.withOpacity(0.0),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(
                          0, 1), // Adjust the offset as per your preference
                    ),
                  ],
                  // borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(
                      color: ColorUtils.colorC8D3E7, style: BorderStyle.solid),
                ),
                focusedBorder: CustomInputBorder(
                  boxShadow: [
                    BoxShadow(
                      color: isTapped
                          ? ColorUtils.primaryColor.withOpacity(0.4)
                          : ColorUtils.primaryColor.withOpacity(0.0),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(
                          0, 1), // Adjust the offset as per your preference
                    ),
                  ],
                  borderSide: BorderSide(
                      color: ColorUtils.primaryColor, style: BorderStyle.solid),
                ),
                focusedErrorBorder: CustomInputBorder(
                  boxShadow: [
                    BoxShadow(
                      color: isTapped
                          ? ColorUtils.redColor.withOpacity(0.4)
                          : ColorUtils.redColor.withOpacity(0.0),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(
                          0, 1), // Adjust the offset as per your preference
                    ),
                  ],
                  // borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(
                      color: ColorUtils.redColor, style: BorderStyle.solid),
                ),
                errorBorder: CustomInputBorder(
                  boxShadow: [
                    BoxShadow(
                      color: isTapped
                          ? ColorUtils.primaryColor.withOpacity(0.4)
                          : ColorUtils.primaryColor.withOpacity(0.0),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(
                          0, 1), // Adjust the offset as per your preference
                    ),
                  ],
                  // borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(
                      color: ColorUtils.colorC8D3E7, style: BorderStyle.solid),
                ),
                hoverColor: ColorUtils.colorC8D3E7),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
