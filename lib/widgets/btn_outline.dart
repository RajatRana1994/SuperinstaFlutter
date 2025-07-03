import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class OutlineBtn extends StatelessWidget {
  final String btnText;
  final double width;
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;
  final double borderRadius;
  final double textSize;
  final EdgeInsetsGeometry textPadding;
  final EdgeInsetsGeometry margin;
  final VoidCallback onClick;

  const OutlineBtn(
      {super.key,
      required this.btnText,
      this.width = double.infinity,
      this.backgroundColor = AppColors.white,
      this.borderColor = AppColors.lightGrey,
      this.borderRadius = 35,
      this.textSize = 18,
      this.textColor = AppColors.lightGrey,
      this.textPadding = const EdgeInsets.symmetric(vertical: 20.0),
      this.margin = const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      required this.onClick});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      margin: margin,
      child: OutlinedButton(
        onPressed: () {
          onClick();
        },
        style: TextButton.styleFrom(
          backgroundColor: backgroundColor,
          side: BorderSide(width: 1.6, color: borderColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        child: Container(
          padding: textPadding,
          child: Text(
            btnText,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: textColor,
              fontSize: textSize,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
