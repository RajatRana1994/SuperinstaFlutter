import 'package:flutter/material.dart';

import '../utils/app_colors.dart';
import '../utils/app_styles.dart';

class MagicBudgetWidget extends StatelessWidget {
  final Function onTap;

  const MagicBudgetWidget({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        onTap();
      },
      child: Text(
        'Magic Budget',
        style: AppStyles.font600_14().copyWith(color: AppColors.primaryColor),
      ),
    );
  }
}
