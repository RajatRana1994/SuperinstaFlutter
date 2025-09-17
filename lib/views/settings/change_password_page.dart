import 'package:flutter/material.dart';
import 'package:instajobs/controllers/profile_controller.dart';
import 'package:instajobs/utils/baseClass.dart';
import 'package:instajobs/widgets/form_input_with_hint_on_top.dart';
import 'package:instajobs/widgets/rounded_edged_button.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_styles.dart';
import 'package:get/get.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage>
    with BaseClass {
  final ProfileController _profileController = Get.put(ProfileController());
  TextEditingController oldPassController = TextEditingController();
  TextEditingController newPassController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();
  bool isOldPassVisible = true;
  bool isNewPassVisible = true;
  bool isConfirmPassVisible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        backgroundColor: AppColors.bgColor,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        title: Text(
          'Change Password',
          style: AppStyles.fontInkika().copyWith(fontSize: 24),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            FormInputWithHint(
              label: 'Old Password',
              hintText: 'Enter old password',
              prefixIcon: Icon(Icons.lock, color: Colors.orange),
              suffixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    isOldPassVisible = !isOldPassVisible;
                  });
                },
                child:
                isOldPassVisible
                    ? Icon(Icons.visibility_off)
                    : Icon(Icons.visibility),
              ),
              controller: oldPassController,
              obscureText: isOldPassVisible,
            ),
            SizedBox(height: 24),
            FormInputWithHint(
              label: 'New Password',
              prefixIcon: Icon(Icons.lock, color: Colors.orange),
              suffixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    isNewPassVisible = !isNewPassVisible;
                  });
                },
                child:
                isNewPassVisible
                    ? Icon(Icons.visibility_off)
                    : Icon(Icons.visibility),
              ),
              hintText: 'Enter new password',
              obscureText: isNewPassVisible,
              controller: newPassController,
            ),
            SizedBox(height: 24),
            FormInputWithHint(
              label: 'Confirm Password',
              prefixIcon: Icon(Icons.lock, color: Colors.orange),
              hintText: 'Enter confirm password',
              suffixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    isConfirmPassVisible = !isConfirmPassVisible;
                  });
                },
                child:
                isConfirmPassVisible
                    ? Icon(Icons.visibility_off)
                    : Icon(Icons.visibility),
              ),
              obscureText: isConfirmPassVisible,
              controller: confirmPassController,
            ),
            SizedBox(height: 24),
            RoundedEdgedButton(
              buttonText: 'Save Changes',
              onButtonClick: () async {
                removeFocusFromEditText(context: context);
                String oldPass = oldPassController.text.trim();
                String newPass = newPassController.text.trim();
                String confirmPass = confirmPassController.text.trim();

                if (oldPass.isEmpty) {
                  showError(
                    title: 'Old Password',
                    message: 'Please add old password',
                  );
                } else if (oldPass.isEmpty) {
                  showError(
                    title: 'Old Password',
                    message: 'Please add old password',
                  );
                } else if (newPass.isEmpty) {
                  showError(
                    title: 'New Password',
                    message: 'Please add new password',
                  );
                } else if (confirmPass.isEmpty) {
                  showError(
                    title: 'Confirm Password',
                    message: 'Please add confirm password',
                  );
                } else if (newPass != confirmPass) {
                  showError(
                    title: 'Password Mismatch',
                    message: 'New password and confirm password do not match',
                  );
                } else {
                  try {
                    //    showGetXCircularDialog();
                    await _profileController.changePasswordApi(
                      oldPass,
                      newPass,
                    );
                    //   Get.back();
                    // showSuccess(title: 'Password Changed', message: 'Password Changed successfully');
                  } catch (e) {
                    showError(title: 'Change password', message: e.toString());
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
