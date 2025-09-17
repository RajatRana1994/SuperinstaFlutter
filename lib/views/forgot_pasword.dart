import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:instajobs/network/network_service.dart';
import 'package:instajobs/utils/app_colors.dart';
import 'package:instajobs/utils/app_styles.dart';
import 'package:instajobs/utils/baseClass.dart';
import 'package:instajobs/widgets/form_input_with_hint_on_top.dart';
import 'package:instajobs/widgets/rounded_edged_button.dart';

import '../models/forgot_pass.dart';
import '../repositories/authentification.dart';

class ForgotPasword extends StatefulWidget {
  const ForgotPasword({super.key});

  @override
  State<ForgotPasword> createState() => _ForgotPaswordState();
}

class _ForgotPaswordState extends State<ForgotPasword> with BaseClass {
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  void _showOtpBottomSheet(BuildContext context, Function onVerify) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: OTPBottomSheetContent(
            onVerify: () {
              onVerify();
            },
          ),
        );
      },
    );
  }

  bool isVerified = false;
  String? forgotPasswordToken;

  Future<void> callForgotPasswordApi() async {
    try {
      showGetXCircularDialog();
      final response = await SignUpRepository().forgotPassword(
        params: {"email": emailController.text.trim()},
      );
      Get.back();
      if (response.isSuccess) {
        forgotPasswordToken = response.data?.data?.forgotPasswordToken;
        _showOtpBottomSheet(context, () {
          isVerified = true;
          setState(() {});
        });
      } else {
        throw response.message.toString();
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> callResetPassword(String newPassword) async {
    try {
      showGetXCircularDialog();
      final response = await SignUpRepository().resetPassword(
        newPassword: newPassword,
        forgotPasswordToken: forgotPasswordToken ?? '',
      );
      Get.back();
      if (response.isSuccess) {

      } else {
        throw response.message.toString();
      }
    } catch (e) {
      throw e.toString();
    }
  }

  bool isPasswordShown = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,

        title: Text('Forgot password'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 30),
              Text(
                'We will check your email address to verify that you are registered on SuperInstaJobs or not.',
                style: AppStyles.font600_18().copyWith(color: Colors.black),
              ),
              SizedBox(height: 30),

              FormInputWithHint(
                label: 'Email',
                controller: emailController,
                hintText: 'Enter your email address',
              ),
              SizedBox(height: 30),

              isVerified
                  ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your account is verified Please enter new password to reset in given New Password field and save.',
                    style: AppStyles.font500_16().copyWith(
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(height: 16),
                  FormInputWithHint(
                    label: 'New Password',
                    hintText: 'Enter new password',
                    obscureText: isPasswordShown,
                    controller: passController,
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          isPasswordShown = !isPasswordShown;
                        });
                      },
                      child:
                      isPasswordShown
                          ? Icon(Icons.visibility_off)
                          : Icon(Icons.visibility),
                    ),
                  ),
                  SizedBox(height: 16),
                ],
              )
                  : SizedBox(),
              RoundedEdgedButton(
                buttonText: isVerified ? 'Reset Password' : 'Send',
                onButtonClick: () async {
                  if (isVerified) {
                    if(passController.text.trim().isEmpty){
                      showError(title: 'Password', message: 'Please enter password');
                    }
                    else{
                      try {
                        await callResetPassword(passController.text.trim());
                      }  catch (e) {
                        showError(title: 'Reset Password', message: e.toString());
                      }
                    }
                  } else {
                    if (emailController.text.trim().isEmpty) {
                      showError(title: 'Email', message: 'Please enter email');
                    } else if (!EmailValidator.validate(
                      emailController.text.trim(),
                    )) {
                      showError(
                        title: 'Email',
                        message: 'Email format is not correct',
                      );
                    } else {
                      try {
                        await callForgotPasswordApi();
                      }  catch (e) {
                        showError(title: 'Email', message: e.toString());
                      }
                    }
                  }
                },
              ),
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}

class OTPBottomSheetContent extends StatefulWidget {
  final Function onVerify;

  const OTPBottomSheetContent({super.key, required this.onVerify});

  @override
  _OTPBottomSheetContentState createState() => _OTPBottomSheetContentState();
}

class _OTPBottomSheetContentState extends State<OTPBottomSheetContent>
    with BaseClass {
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());
  final List<TextEditingController> _controllers = List.generate(
    4,
        (_) => TextEditingController(),
  );

  @override
  void dispose() {
    _focusNodes.forEach((node) => node.dispose());
    _controllers.forEach((controller) => controller.dispose());
    super.dispose();
  }

  void _submitOTP() {
    String otp = _controllers.map((c) => c.text).join();
    // You can validate and send the OTP here
    print("Entered OTP: $otp");
    Navigator.pop(context); // Close bottom sheet
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 16),
        Text(
          'Submit OTP',
          style: AppStyles.font600_18().copyWith(color: Colors.black),
        ),
        const SizedBox(height: 24),
        Text(
          "Please type the verification code sent to your registered email id. (OTP - 1111)",
          style: AppStyles.font500_16().copyWith(color: Colors.black),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(4, (index) => _buildOTPField(index)),
        ),
        const SizedBox(height: 50),
        RoundedEdgedButton(
          buttonText: 'Verify',
          onButtonClick: () {
            String otp = _controllers.map((c) => c.text).join();
            if (otp.isEmpty) {
              showError(title: 'OTP', message: 'Please enter otp');
            } else if (otp == "1111") {
              widget.onVerify();
              /*showSuccess(
                title: 'Reset password',
                message:
                'Your account is verified\nPlease enter new password to reset in given New Password field and save.',
              );*/
              popToPreviousScreen(context: context);
              removeFocusFromEditText(context: context);
            } else {
              showError(title: 'OTP', message: 'Incorrect OTP');
            }
          },
        ),
        const SizedBox(height: 30),
      ],
    );
  }

  Widget _buildOTPField(int index) {
    return SizedBox(
      width: 50,
      child: Focus(
        onKey: (FocusNode node, RawKeyEvent event) {
          if (event is RawKeyDownEvent &&
              event.logicalKey == LogicalKeyboardKey.backspace) {
            if (_controllers[index].text.isEmpty && index > 0) {
              _focusNodes[index - 1].requestFocus();
              _controllers[index - 1].clear();
            }
          }
          return KeyEventResult.ignored;
        },
        child: TextField(
          controller: _controllers[index],
          focusNode: _focusNodes[index],
          keyboardType: TextInputType.number,
          maxLength: 1,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 24),
          decoration: InputDecoration(counterText: ""),
          onChanged: (value) {
            if (value.isNotEmpty && index < 3) {
              _focusNodes[index + 1].requestFocus();
            }
          },
        ),
      ),
    );
  }
}
