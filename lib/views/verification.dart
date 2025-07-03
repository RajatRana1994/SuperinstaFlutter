import 'package:flutter/material.dart';
import 'package:instajobs/utils/baseClass.dart';
import 'package:instajobs/views/relax.dart';
import 'package:instajobs/widgets/rounded_edged_button.dart';

import '../utils/app_colors.dart';
import '../utils/app_styles.dart';

class Verification extends StatefulWidget {
  const Verification({super.key});

  @override
  State<Verification> createState() => _VerificationState();
}

class _VerificationState extends State<Verification> with BaseClass{
  List<String> data = [
    'Increase the credibility of your account by submitting a verification photo.',
    'Take a selfie HOLDING a paper with your username and and the code name flamingo hand written on it.',
    'YOUR FACE MUST BE CLEARLY VISIBLE ON THE PIC!',
    'Doesn\'t have to be a professional photo.',
    'You can only upload 1 photo.',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(backgroundColor: AppColors.bgColor,surfaceTintColor: Colors.transparent, centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Verification',
              style: AppStyles.fontInkika().copyWith(
                color: Colors.black,
                fontSize: 40,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Upload your image for Verification.',
              style: AppStyles.font400_12().copyWith(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Image(
                    image: AssetImage('assets/images/verify_one.png'),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Stack(
                    children: [
                      Image(image: AssetImage('assets/images/verify_2.png')),
                      Positioned(
                        top: 0,
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.camera_alt, color: AppColors.green),
                            SizedBox(height: 5),
                            Text(
                              'Snap with Govt. ID',
                              style: AppStyles.font400_12().copyWith(
                                color: AppColors.green,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 14),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: data.length,
              padding: EdgeInsets.zero,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  margin: EdgeInsets.only(top: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 14,
                        width: 14,
                        //margin: EdgeInsets.only(top: 8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Color(0xffF55563),width: 2),
                        ),
                      ),

                      SizedBox(width: 10),
                      Expanded(
                        child: Container(

                          child: Text(
                            data.elementAt(index),
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,

                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            SizedBox(height: 28),
            RoundedEdgedButton(buttonText: 'Send for verification', onButtonClick: (){
              pushToNextScreen(context: context, destination: RelaxPage());
            }),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
