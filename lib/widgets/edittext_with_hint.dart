import 'package:flutter/material.dart';

import '../utils/app_colors.dart';


class EditTextWithHint extends StatelessWidget {
  final String? hintText;
  final double leftMargin;
  final double rightMargin;
  final double topMargin;
  final double bottomMargin;
  final TextEditingController? textEditingController;
  final bool isObscure;
  final IconData? trailingIcon;
  final IconData? leadingIcon;
  final double radius;
  final Color? iconColor;
  final bool? isEnabled;
  final double leftPadding;
  final ValueChanged<String>? onChanged;

  const EditTextWithHint({
    super.key,
    required this.hintText,
    this.onChanged,
    this.leftMargin = 0,
    this.rightMargin = 0,
    this.radius = 0,
    this.topMargin = 0,
    this.bottomMargin = 0,
    this.leftPadding = 15,
    this.textEditingController,
    this.isObscure = false,
    this.trailingIcon,
    this.leadingIcon,
    this.isEnabled = true,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          left: leftMargin,
          right: rightMargin,
          top: topMargin,
          bottom: bottomMargin),
      decoration: BoxDecoration(
        color: Colors.white,
/*
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.05),
              blurRadius: 8.0,
              offset: Offset(0.0, 1),
            ),
          ],*/
        border: Border.all(color: Colors.grey.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: EdgeInsets.only(
              left: leftPadding,
            ),
            child: TextField(
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
              maxLines: 1,
              controller: textEditingController,
              enabled: isEnabled,
              cursorColor: AppColors.primaryColor,
              obscureText: isObscure,
              onChanged: onChanged,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(top: 12, bottom: 0),
                border: InputBorder.none,
                /*  labelText: hintText,
                labelStyle: const TextStyle(
                  color: Colors.grey,
                ),*/
                prefixIcon: Icon(
                  leadingIcon,
                  color: iconColor,
                ),
                suffixIcon: Icon(
                  trailingIcon,
                  color: iconColor,
                ),
                hintText: hintText,
                hintStyle: const TextStyle(
                  color: AppColors.lightGrey,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
