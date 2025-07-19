import 'package:flutter/material.dart';


import '../utils/app_colors.dart';

// First, add this to your pubspec.yaml:
// dependencies:
//   dropdown_button2: ^2.3.9

import 'package:dropdown_button2/dropdown_button2.dart';

import '../utils/app_styles.dart';

class CustomDropdown<T> extends StatelessWidget {
  final List<T> items;
  final String hint;
  final T? selectedValue;
  final FontWeight? fontWeight;
  final double? fontSize;
  final Color? textColor;
  final double? height;
  final void Function(T?) onChanged;
  final String Function(T) labelBuilder;
  final double borderWidth;
  final Color borderColor;

  const CustomDropdown({
    super.key,
    required this.items,
    required this.hint,
    this.selectedValue,
    required this.onChanged,
    this.fontWeight = FontWeight.w500,
    this.fontSize = 14,
    this.textColor = Colors.black,
    this.height,
    required this.labelBuilder,
    this.borderWidth = 2.0,
    this.borderColor = AppColors.greenShade,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField2<T>(

      value: selectedValue,
      hint: Text(
        hint,
        style: AppStyles.font500_14().copyWith(
          color: textColor?.withOpacity(0.7) ?? Colors.grey,
          fontSize: fontSize,
          fontWeight: fontWeight,
        ),
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 6,
          vertical: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide:  BorderSide(color: borderColor, width: borderWidth),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide:  BorderSide(color: AppColors.primaryColor, width: borderWidth),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide:  BorderSide(color: AppColors.primaryColor, width: borderWidth),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide:  BorderSide(color: AppColors.primaryColor, width: borderWidth),
        ),
      ),
      isExpanded: true,
      items: items.map((T item) {
        return DropdownMenuItem<T>(
          value: item,
          child: Text(
            labelBuilder(item),
            style: AppStyles.font500_12().copyWith(
              color: textColor,
              fontSize: fontSize,
              fontWeight: fontWeight,
            ),
          ),
        );
      }).toList(),
      onChanged: onChanged,
      buttonStyleData: ButtonStyleData(
        height: 20,
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      iconStyleData: const IconStyleData(
        icon: Icon(
          Icons.keyboard_arrow_down_outlined,
          color: Colors.black,
        ),
        iconSize: 24,
      ),
      dropdownStyleData: DropdownStyleData(
        maxHeight: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        offset: const Offset(0, -5),
        scrollbarTheme: ScrollbarThemeData(
          radius: const Radius.circular(40),
          thickness: MaterialStateProperty.all(6),
          thumbVisibility: MaterialStateProperty.all(true),
        ),
      ),
      menuItemStyleData: const MenuItemStyleData(
        height: 50,
        padding: EdgeInsets.symmetric(horizontal: 16.0),
      ),
      // This ensures dropdown always opens below
      dropdownSearchData: null,
    );
  }
}


/*class CustomDropdown<T> extends StatelessWidget {
  final List<T> items;
  final String hint;
  final T? selectedValue;
  final FontWeight? fontWeight;
  final double? fontSize;
  final Color? textColor;
  final double? height;
  final void Function(T?) onChanged;
  final String Function(T) labelBuilder;

  const CustomDropdown({
    super.key,
    required this.items,
    required this.hint,
    this.selectedValue,
    required this.onChanged,
    this.fontWeight = FontWeight.w500,
    this.fontSize = 14,

    this.textColor = Colors.black,
    this.height,
    required this.labelBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SizedBox(
        height: height,
        child: DropdownButtonFormField<T>(
          value: selectedValue,
          padding: EdgeInsets.zero,
          hint: Text(
            hint,
            style: AppStyles.font500_14().copyWith(
              color: textColor,
              fontSize: fontSize,
              fontWeight: fontWeight,
            ),
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            *//*hintText: hint,

            hintStyle: AppStyles.font500_14().copyWith(color: Colors.black),*//*
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 14,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Dimensions.small),
              borderSide: BorderSide(color: AppColors.greenShade, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Dimensions.small),
              borderSide: BorderSide(color: AppColors.greenShade, width: 1),
            ),
          ),
          icon: const Icon(
            Icons.keyboard_arrow_down_outlined,
            color: Colors.black,
          ),
          isExpanded: true,
          items:
              items.map((T item) {
                return DropdownMenuItem<T>(
                  value: item,
                  child: Text(
                    labelBuilder(item),
                    style: AppStyles.font500_12().copyWith(
                      color: textColor,
                      fontSize: fontSize,

                      fontWeight: fontWeight,
                    ),
                  ),
                );
              }).toList(),
          selectedItemBuilder:
              (_) =>
                  items
                      .map(
                        (item) => Text(
                          labelBuilder(item),
                          style: AppStyles.font500_12().copyWith(
                            color: textColor,
                            fontSize: fontSize,

                            fontWeight: fontWeight,
                          ),
                        ),
                      )
                      .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}*/
