import 'package:flutter/material.dart';
import 'package:instajobs/utils/app_colors.dart';
import 'package:instajobs/utils/app_images.dart';
import 'package:instajobs/utils/app_styles.dart';
import 'package:instajobs/utils/baseClass.dart';
import 'package:instajobs/views/create_account_step_one.dart';
import 'package:instajobs/views/user/customer_sign_up.dart';
import 'package:instajobs/widgets/rounded_edged_button.dart';

class WhoYouArePage extends StatefulWidget {
  const WhoYouArePage({super.key});

  @override
  State<WhoYouArePage> createState() => _WhoYouArePageState();
}

class _WhoYouArePageState extends State<WhoYouArePage> with BaseClass {
  bool isCustomer = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(backgroundColor: AppColors.bgColor,surfaceTintColor: Colors.transparent, elevation: 0),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 30,),
                Text(
                  'Tell us\nWho You Are?',
                  style: AppStyles.fontInkika().copyWith(
                    color: Colors.black,
                    fontSize: 40,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 22),
                Container(height: 2, width: 70, color: AppColors.orange),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: (){
                    isCustomer =true;
                    setState(() {

                    });
                  },
                  child: Row(
                    children: [
                      Container(
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            width: isCustomer?2:1,
                            color:
                            isCustomer
                                ? AppColors.orange
                                : AppColors.hintColor,
                          ),
                        ),
                        child: Center(
                          child: Image(
                            image: AssetImage(AppImages.customer),
                            height: 40,
                            width: 40,
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      Text(
                        'Customer',
                        style: AppStyles.fontInkika().copyWith(
                            color: Colors.black,
                            fontWeight:
                            isCustomer ? FontWeight.w700 : FontWeight.w500,
                            fontSize: 20
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 32),
                InkWell(
                  onTap: (){
                    isCustomer =false;
                    setState(() {

                    });
                  },
                  child: Row(
                    children: [
                      Container(
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            width: !isCustomer?2:1,
                            color:
                            !isCustomer
                                ? AppColors.orange
                                : AppColors.hintColor,
                          ),
                        ),
                        child: Center(
                          child: Image(
                            image: AssetImage(AppImages.freelancer),
                            height: 40,
                            width: 40,
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      Text(
                        'Freelancer/Vendor',
                        style: AppStyles.fontInkika().copyWith(
                            color: Colors.black,
                            fontWeight:
                            !isCustomer ? FontWeight.w700 : FontWeight.w500,
                            fontSize: 20
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            RoundedEdgedButton(buttonText: 'Continue', onButtonClick: (){
              if(isCustomer ){
                pushToNextScreen(context: context, destination: CustomerSignUp());
              }
              else{
                pushToNextScreen(context: context, destination: CreateAccountStepOne());
              }

            },bottomMargin: 30,),
          ],
        ),
      ),
    );
  }
}
