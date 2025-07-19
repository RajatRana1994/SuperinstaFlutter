import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/app_colors.dart';
import '../utils/app_styles.dart';

class FormInputWithHint extends StatelessWidget {
  final String label;
  final bool obscureText;
  final Color borderColor;
  final TextInputType? keyboardType;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? errorText;
  final Function? onChanged;
  final FocusNode? focusNode;
  final String? initialValue;
  final TextInputAction? keyboardAction;
  final String? hintText;
  final int maxLine;
  final int? maxLength;
  final bool isEnabled;
  final TextEditingController? controller;
  final double formSize;
  final double horizontalTextPadding;
  final double textFieldHeight;
  final Color? fillColor;
  final double formRadius;
  final bool isDigitsOnly;
  final bool showLabel;

  const FormInputWithHint({
    super.key,
    required this.label,
    this.obscureText = false,
    this.showLabel = true,
    this.borderColor = AppColors.greenShade,
    this.keyboardType,
    this.keyboardAction,
    this.formSize = 45,
    this.prefixIcon,
    this.suffixIcon,
    this.horizontalTextPadding = 20,
    this.controller,
    this.isDigitsOnly = false,
    this.fillColor = AppColors.white,
    this.isEnabled = true,
    this.maxLine = 1,
    this.maxLength,
    this.errorText,
    this.onChanged,
    this.focusNode,
    this.initialValue,
    required this.hintText,
    this.textFieldHeight = 12,
    this.formRadius = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        showLabel
            ? Text(
              label,
              textAlign: TextAlign.left,
              style: AppStyles.fontInkika13().copyWith(
                color: Colors.black,
                fontWeight: FontWeight.w700,
              ),
            )
            : const SizedBox(),
        showLabel ? const SizedBox(height: 6) : SizedBox(),
        TextField(
          focusNode: focusNode,
          enabled: isEnabled,
          controller: controller,
          maxLength: maxLength,
          cursorColor: AppColors.darkGreen,
          decoration: InputDecoration(
            enabled: isEnabled,
            filled: true,
            hintStyle: AppStyles.font500_14().copyWith(
              color: AppColors.hintColor,
            ),
            fillColor: fillColor,
            alignLabelWithHint: true,
            /*  border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(formRadius),
              borderSide: const BorderSide(
                width: 0,
                style: BorderStyle.solid,
              ),
            ),*/
            contentPadding: EdgeInsets.symmetric(
              vertical: textFieldHeight,
              horizontal: horizontalTextPadding,
            ),
            prefixIcon:
                prefixIcon != null
                    ? Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: prefixIcon,
                    )
                    : null,
            suffixIcon:
                suffixIcon != null
                    ? Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: suffixIcon,
                    )
                    : null,
            errorText: errorText,
            errorMaxLines: 3,
            hintText: hintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(formRadius),
              borderSide: BorderSide(color: borderColor, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: borderColor, width: 2),
              borderRadius: BorderRadius.circular(formRadius),
            ),
            disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: borderColor, width: 1),
              borderRadius: BorderRadius.circular(formRadius),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: borderColor, width: 1),
              borderRadius: BorderRadius.circular(formRadius),
            ),
          ),
          inputFormatters: [
            if (isDigitsOnly) FilteringTextInputFormatter.digitsOnly,
          ],
          style: AppStyles.font500_14().copyWith(color: Colors.black),

          /*style: const TextStyle(fontSize: 16, letterSpacing: 0.7),*/
          obscureText: obscureText,
          keyboardType: keyboardType,
          textInputAction: keyboardAction,
          maxLines: maxLine,
          key: key,
          onChanged: (value) {
            if (onChanged != null) {
              onChanged!(value);
            }
          },
        ),
      ],
    );
  }
}
