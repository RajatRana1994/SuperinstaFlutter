import 'package:flutter/material.dart';


import '../utils/app_colors.dart';
import '../utils/app_styles.dart';

class FillBtnWithImg extends StatelessWidget {
  final String btnText;
  final String btnImg;
  final double width;
  final Color backgroundColor;
  final Color textColor;
  final double borderRadius;
  final EdgeInsetsGeometry textPadding;
  final EdgeInsetsGeometry margin;
  final VoidCallback onClick;
  final double textSize;

  const FillBtnWithImg({
    super.key,
    required this.btnText,
    this.btnImg = "",
    this.width = double.infinity,
    this.backgroundColor = AppColors.bgBtn,
    this.textColor = AppColors.darkGreen,
    this.borderRadius = 16,

    this.textSize = 16,
    this.textPadding = const EdgeInsets.symmetric(vertical: 14.0),
    this.margin = const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onClick();
      },
      child: Container(
        width: width,
        margin: margin,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(color: AppColors.darkGreen),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (btnImg.isNotEmpty) ...[
              Image.asset(
                btnImg,
                height: 24.0,
                width: 24.0,
              ),
              const SizedBox(
                width: 50,
              ),
            ],
            Flexible(
              child: Container(
                padding: textPadding,
                child: Text(
                  btnText,
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.ellipsis,
                  style: AppStyles.font600_14().copyWith(color: textColor,fontSize: textSize),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
