import 'package:flutter/material.dart';
import 'package:instajobs/utils/baseClass.dart';
import 'package:instajobs/views/submit_otp.dart';

import '../utils/app_colors.dart';
import '../utils/app_images.dart';
import '../utils/app_styles.dart';
import '../widgets/form_input_with_hint_on_top.dart';
import '../widgets/rounded_edged_button.dart';

class CreateAccount extends StatefulWidget  {
  const CreateAccount({super.key});

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> with BaseClass{
  bool isSelected =  false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        backgroundColor: AppColors.bgColor,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          'Create Account',
          style: AppStyles.fontInkika().copyWith(fontSize: 20),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image(
              image: AssetImage(AppImages.chooseImage),
              height: 150,
              width: 150,
            ),
            SizedBox(height: 28),
            FormInputWithHint(label: 'Full Name', hintText: 'Enter here...'),
            SizedBox(height: 28),
            FormInputWithHint(label: 'Email ID', hintText: ''),
            SizedBox(height: 28),
            FormInputWithHint(
              label: 'Phone Number',
              hintText: '',
            ),
            SizedBox(height: 28),
            FormInputWithHint(
              label: 'Password',

              hintText: '',
            ),
            SizedBox(height: 28),
            FormInputWithHint(label: 'Confirm Password', hintText: ''),

            SizedBox(height: 12),
            Row(
              children: [
                Checkbox(value: isSelected, onChanged: (value){
                  setState(() {
                    isSelected =value??false;
                  });
                }),

                Text(
                  'I accept ',
                  style: AppStyles.fontInkika().copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: Colors.black
                  ),
                ),
                Text(
                  'Terms & Conditions ',
                  style: AppStyles.fontInkika().copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: AppColors.orange
                  ),
                ),
                Text(
                  'of company',
                  style: AppStyles.fontInkika().copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: AppColors.black
                  ),
                ),


              ],
            ),
            SizedBox(height: 12),

            RoundedEdgedButton(
              buttonText: 'Next',
              onButtonClick: () {
                pushToNextScreen(context: context, destination: SubmitOtp());
              },
            ),
            SizedBox(height: 12,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Text(
                  'Already have an account? ',
                  style: AppStyles.fontInkika().copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: Colors.black
                  ),
                ),
                Text(
                  'Login',
                  style: AppStyles.fontInkika().copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: AppColors.orange
                  ),
                ),



              ],
            ),
            SizedBox(height: 28),
          ],
        ),
      ),
    );
  }
}
