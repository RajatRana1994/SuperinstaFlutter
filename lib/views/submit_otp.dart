import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instajobs/controllers/sign_up_customer_controller.dart';
import 'package:instajobs/models/user_data/user_model.dart';
import 'package:instajobs/utils/baseClass.dart';
import 'package:instajobs/views/relax.dart';
import 'package:instajobs/views/verification.dart';
import 'package:instajobs/widgets/rounded_edged_button.dart';

import '../network/network_service.dart';
import '../storage_services/local_stoage_service.dart';
import '../utils/app_colors.dart';
import '../utils/app_styles.dart';
import '../utils/local_keys.dart';

class SubmitOtp extends StatefulWidget {
  const SubmitOtp({super.key});

  @override
  State<SubmitOtp> createState() => _SubmitOtpState();
}

class _SubmitOtpState extends State<SubmitOtp> with BaseClass {
  final int pinLength = 4;
  final List<FocusNode> _focusNodes = [];
  final List<TextEditingController> _controllers = [];
  SignUpCustomerController signUpCustomerController = Get.put(
    SignUpCustomerController(),
  );

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < pinLength; i++) {
      _focusNodes.add(FocusNode());
      _controllers.add(TextEditingController());
    }
  }

  @override
  void dispose() {
    for (var node in _focusNodes) {
      node.dispose();
    }
    for (var ctrl in _controllers) {
      ctrl.dispose();
    }
    super.dispose();
  }

  void _handleInput(String value, int index) {
    if (value.isNotEmpty) {
      if (index + 1 < pinLength) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus(); // Last field, dismiss keyboard
      }
    }
  }

  void _handleKey(RawKeyEvent event, int index) {
    if (event.logicalKey.keyLabel == 'Backspace' &&
        _controllers[index].text.isEmpty &&
        index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  String get pin => _controllers.map((controller) => controller.text).join();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        backgroundColor: AppColors.bgColor,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Text(
              'Submit OTP',
              style: AppStyles.fontInkika().copyWith(
                color: Colors.black,
                fontSize: 40,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Please type the verification code send to\nyour registered email id ',
              style: AppStyles.font400_12().copyWith(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 50),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(pinLength, (index) {
                  return Flexible(
                    flex: 1,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      child: RawKeyboardListener(
                        focusNode: FocusNode(), // for backspace support
                        onKey: (event) => _handleKey(event, index),
                        child: TextField(
                          controller: _controllers[index],
                          focusNode: _focusNodes[index],
                          maxLength: 1,
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(fontSize: 24),
                          decoration: const InputDecoration(
                            counterText: "",
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                width: 2,
                                color: Colors.grey,
                              ),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                width: 2,
                                color: Colors.orange,
                              ),
                            ),
                          ),
                          onChanged: (value) => _handleInput(value, index),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            SizedBox(height: 50),
            RoundedEdgedButton(
              buttonText: 'Continue',
              onButtonClick: () async {
                if (pin.isEmpty || pin.length < 4) {
                  showError(title: 'Pin', message: 'Please enter correct pin');
                } else {
                  try {
                    showCircularDialog(context);
                    await signUpCustomerController.verifyPin(pin: pin);
                    UserDataModel userDataModel =
                    StorageService().getUserData();
                    userDataModel.isLoggedIn = true;
                    popToPreviousScreen(context: context);
                    await StorageService().saveData(
                      LocalKeys.userData,
                      userDataModel.toMap(userDataModel),
                    );

                    NetworkService().setLoginToken(
                      StorageService().getUserData().getAuthToken(),
                    );
                    pushReplaceAndClearStack(
                      context: context,
                      destination: RelaxPage(),
                    );
                    /*pushToNextScreen(
                      context: context,
                      destination: Verification(),
                    );*/
                  } catch (e) {
                    popToPreviousScreen(context: context);
                    showError(title: '', message: e.toString());
                  }
                }
              },
            ),
            SizedBox(height: 50),
            Align(
              alignment: Alignment.center,
              child: TextButton(
                onPressed: () {},
                child: Text(
                  'Resend OTP',
                  style: AppStyles.font400_12().copyWith(
                    color: AppColors.orange,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
