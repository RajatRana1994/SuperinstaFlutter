
import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

class ProgressDialog extends StatelessWidget {
  const ProgressDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 5,
        color: Colors.white,
        child: Container(
          padding: const EdgeInsets.all(10),
          child: const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              AppColors.primaryColor,
            ),
          ),),
      ),
    );}
}


