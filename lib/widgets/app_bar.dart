import 'package:flutter/material.dart';

import '../utils/app_colors.dart';
import '../utils/app_styles.dart';

class CustomAppBar extends StatelessWidget {
  final bool showStepOne;

  final bool showStepTwo;

  const CustomAppBar({
    super.key,
    required this.showStepOne,
    required this.showStepTwo,
  });

  Widget circle(String text) => Container(
    padding: EdgeInsets.all(10),
    decoration: BoxDecoration(color: AppColors.orange, shape: BoxShape.circle),
    child: Center(
      child: Text(
        text,
        style: AppStyles.font500_14().copyWith(
          color: Colors.white,
          fontSize: 12,
        ),
      ),
    ),
  );

  Widget expandedLine(bool visible) => Expanded(
    child: Container(
      height: 4,
      color: visible ? AppColors.orange : Colors.transparent,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            offset: Offset(0, 4), // x: 0, y: 4 → shadow goes down
            blurRadius: 6,
            spreadRadius: 0,
          ),
        ],
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Row for circles + lines
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: circle('1'),
                  ),
                  expandedLine(showStepOne),
                  circle('2'),
                  expandedLine(showStepTwo),
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: circle('3'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Row for labels
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Select Service',
                    textAlign: TextAlign.center,
                    style: AppStyles.font500_14().copyWith(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'Professional Info',
                    style: AppStyles.font500_14().copyWith(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: showStepOne ?FontWeight.w700:FontWeight.w500,
                    ),
                  ),
                  Text(
                    'Attachments',
                    style: AppStyles.font500_14().copyWith(
                      color: showStepTwo ?Colors.black: Colors.grey,
                      fontSize: 12,
                      fontWeight: showStepTwo ?FontWeight.w700: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
