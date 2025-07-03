import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:instajobs/controllers/login_controller.dart';
import 'package:instajobs/utils/app_images.dart';
import 'package:instajobs/utils/app_styles.dart';
import 'package:instajobs/utils/baseClass.dart';
import 'package:instajobs/views/forgot_pasword.dart';
import 'package:instajobs/views/who_you_are.dart';
import 'package:instajobs/widgets/btn_fill_with_img.dart';
import 'package:instajobs/widgets/form_input_with_hint_on_top.dart';
import 'package:instajobs/widgets/rounded_edged_button.dart';

import '../utils/app_colors.dart';

class WelcomePage extends StatelessWidget with BaseClass {
  WelcomePage({super.key});

  final LoginController loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),

      body: GetBuilder<LoginController>(
        init: loginController,
        builder: (snapshot) {
          return Container(
            decoration: BoxDecoration(),
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  top: 0,
                  child: Image(
                    image: AssetImage(AppImages.bgImage),
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.black.withOpacity(0.5),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 20,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 50),
                        child: Text(
                          'Welcome!',
                          style: AppStyles.fontInkika().copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: 40,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FormInputWithHint(
                              label: '',
                              showLabel: false,
                              hintText: 'Email ID',
                              controller: loginController.emailController,
                            ),
                            SizedBox(height: 16),
                            FormInputWithHint(
                              label: 'Password',
                              showLabel: false,
                              keyboardType: TextInputType.text,
                              controller: loginController.passwordController,
                              obscureText: loginController.getPasswordStatus,
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  loginController.updatePasswordVisibility();
                                },
                                child:
                                    loginController.getPasswordStatus
                                        ? const Icon(
                                          Icons.visibility_off_outlined,
                                          color: AppColors.primaryColor,
                                        )
                                        : const Icon(
                                          Icons.visibility,
                                          color: AppColors.primaryColor,
                                        ),
                              ),
                              hintText: 'Enter Password',
                            ),
                            SizedBox(height: 8),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  pushToNextScreen(context: context, destination: ForgotPasword());
                                },
                                child: Text(
                                  'Forgot password?',
                                  style: AppStyles.font500_16().copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 16),
                            RoundedEdgedButton(
                              buttonText: 'Continue',
                              onButtonClick: () async {
                                if (loginController.emailController.text
                                    .trim()
                                    .isEmpty) {
                                  showError(
                                    title: 'Email',
                                    message: 'Please enter email',
                                  );
                                } else if (!EmailValidator.validate(
                                  loginController.emailController.text.trim(),
                                )) {
                                  showError(
                                    title: 'Email',
                                    message: 'Email format is not correct',
                                  );
                                } else if (loginController
                                    .passwordController
                                    .text
                                    .trim()
                                    .isEmpty) {
                                  showError(
                                    title: 'Password',
                                    message: 'Please enter Password',
                                  );
                                } else {
                                  try {
                                    await loginController.callLoginApi();
                                  } catch (e) {
                                    showError(title: '', message: e.toString());
                                  }
                                }
                              },
                            ),
                            SizedBox(height: 16),

                            /* Text('or', style: AppStyles.font700_12()),
                            SizedBox(height: 16),
                            FillBtnWithImg(
                              btnText: 'Continue with Facebook',
                              onClick: () {},
                              btnImg: AppImages.fb,
                            ),
                            SizedBox(height: 16),
                            FillBtnWithImg(
                              btnText: 'Continue with Google',
                              btnImg: AppImages.google,
                              onClick: () {},
                            ),
                            SizedBox(height: 16),
                            FillBtnWithImg(
                              btnText: 'Continue with Apple',
                              onClick: () {},
                              btnImg: AppImages.apple,
                            ),*/
                            SizedBox(height: 60),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    //pushToNextScreen(context: context, destination: WhoYouArePage());
                                  },
                                  child: Text(
                                    'Continue as a Guest',
                                    style: AppStyles.font500_16().copyWith(
                                      color: Color(0xffFF5200),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                Text('or', style: AppStyles.font700_12()),
                                TextButton(
                                  onPressed: () {
                                    pushToNextScreen(
                                      context: context,
                                      destination: WhoYouArePage(),
                                    );
                                  },
                                  child: Text(
                                    'Sign Up',
                                    style: AppStyles.font500_16().copyWith(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 80),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
