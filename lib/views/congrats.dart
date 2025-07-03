import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instajobs/utils/app_colors.dart';
import 'package:instajobs/utils/baseClass.dart';
import 'package:instajobs/views/home_page.dart';
import 'package:instajobs/widgets/rounded_edged_button.dart';

import '../utils/app_styles.dart';

class Congrats extends StatelessWidget with BaseClass{
  const Congrats({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
               // Image(image: AssetImage('assets/images/user.png'),height: 120,width: 120,),
                SizedBox(height: 20,),
                Text(
                  'Congratulations!',
                  style: AppStyles.fontInkika().copyWith(
                    color: Colors.black,
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Hello ! You have successfully verified\nyour account.',
                  textAlign: TextAlign.center,
                  style: AppStyles.font400_12().copyWith(
                    color: Colors.black,

                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                RoundedEdgedButton(
                  buttonText: 'Let’s Get Started',
                  onButtonClick: () {
                    pushReplaceAndClearStack(context: context, destination: HomePage());
                  },
                  topMargin: 30,
                  leftMargin: Get.width * 0.3,
                  rightMargin: Get.width * 0.3,
                ),
              ],
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Image(
                image: AssetImage('assets/images/congrats.png'),
                width: double.infinity,
                height: Get.height * 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
