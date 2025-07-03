import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/app_colors.dart';

class FormInput extends StatelessWidget {
  final String label;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String prefixIcon;
  final Widget? suffixIcon;
  final String? errorText;

  /*final Function onChanged;*/
  final FocusNode focusNode;
  final String? initialValue;
  final String? hintText;
  final bool isEnabled;
  final double editTextHeight;

  final int maxLine;
  final double formRadius;
  final Color borderColor;
  final bool isDense;

  final double suffixIconMinimumHeightWidth;
  final double textFieldHeight;
  final TextEditingController controller;

  const FormInput(
      {Key? key,
      required this.label,
      this.obscureText = false,
      this.keyboardType,
      required this.prefixIcon,
      this.editTextHeight = 54,
      this.suffixIcon,
      this.isEnabled = true,
      this.isDense = false,
      required this.controller,
      this.suffixIconMinimumHeightWidth = 48,
      this.maxLine = 1,
      this.errorText,
      this.formRadius = 8,
      this.borderColor = AppColors.lightGrey,
      /*required this.onChanged,*/
      required this.focusNode,
      this.initialValue,
      required this.hintText,
      this.textFieldHeight = 0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: editTextHeight,
      child: TextFormField(
        focusNode: focusNode,
        enabled: isEnabled,
        controller: controller,
        decoration: InputDecoration(
          filled: true,
          focusColor: Colors.red,
          fillColor: AppColors.lightGrey,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              formRadius,
            ),
            borderSide: BorderSide(width: 0, color: borderColor),
          ),
          hintStyle: GoogleFonts.plusJakartaSans(
            textStyle: GoogleFonts.inter(
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: AppColors.lightGrey,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              formRadius,
            ),
            borderSide: const BorderSide(
              width: 1,
              color: AppColors.lightGrey,
            ),
          ),
          contentPadding: EdgeInsets.symmetric(
            vertical: textFieldHeight,
            horizontal: 30,
          ),
          prefixIcon: Container(
            margin: const EdgeInsets.only(left: 12,right: 12),
            height: 24,
            width: 24,
            alignment: Alignment.centerLeft,
            child: Image(
              image: AssetImage(prefixIcon),
              height: 24,
              width: 24,
            ),
          ),
          suffixIcon: suffixIcon,
          isDense: isDense,
          suffixIconConstraints: BoxConstraints(
            minHeight: suffixIconMinimumHeightWidth,
            minWidth: suffixIconMinimumHeightWidth,
          ),
          errorText: errorText,
          errorMaxLines: 3,
          hintText: hintText,
        ),
        style: GoogleFonts.plusJakartaSans(
          textStyle: const TextStyle(
              fontSize: 14,
              color: Colors.black,
              letterSpacing: 0.7,
              fontWeight: FontWeight.w400),
        ),
        obscureText: obscureText,
        keyboardType: keyboardType,
        maxLines: maxLine,
        key: key,
        /*onChanged: onChanged(),*/
        initialValue: initialValue,
      ),
    );
  }
}
