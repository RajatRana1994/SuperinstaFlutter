import 'dart:io';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instajobs/controllers/sign_up_customer_controller.dart';
import 'package:instajobs/utils/baseClass.dart';
import 'package:instajobs/views/welcome_page.dart';

import '../../bottom_sheets/choose_image_bottom_sheet.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_images.dart';
import '../../utils/app_styles.dart';
import '../../widgets/form_input_with_hint_on_top.dart';
import '../../widgets/rounded_edged_button.dart';
import '../place_picker.dart';

class CustomerSignUp extends StatefulWidget {
  const CustomerSignUp({super.key});

  @override
  State<CustomerSignUp> createState() => _CustomerSignUpState();
}

class _CustomerSignUpState extends State<CustomerSignUp> with BaseClass {
  final SignUpCustomerController _signUpCustomerController = Get.put(
    SignUpCustomerController(),
  );
  bool isSelected = false;
  File? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _signUpCustomerController.resetItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Create Customer Account',
          style: AppStyles.fontInkika().copyWith(fontSize: 24),
        ),
      ),
      body: GetBuilder<SignUpCustomerController>(
        init: _signUpCustomerController,
        builder: (snapshot) {
          return Column(
            children: [
              SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          ChooseImageBottomSheet.show(
                            context: context,
                            onCancel: () {
                              popToPreviousScreen(context: context);
                            },
                            onCamera: () {
                              _pickImage(ImageSource.camera);
                            },
                            onGallery: () {
                              _pickImage(ImageSource.gallery);
                            },
                          );
                        },
                        child:
                        _image == null
                            ? Image(
                          image: AssetImage(AppImages.chooseImage),
                          height: 150,
                          width: 150,
                        )
                            : ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image(
                            image: FileImage(_image!),
                            fit: BoxFit.cover,
                            height: 150,
                            width: 150,
                          ),
                        ),
                      ),
                      SizedBox(height: 28),
                      FormInputWithHint(
                        label: 'Full Name',
                        hintText: 'Enter full name',
                        keyboardType: TextInputType.text,
                        controller: _signUpCustomerController.nameController,
                      ),
                      SizedBox(height: 28),
                      FormInputWithHint(
                        label: 'Email ID',
                        keyboardType: TextInputType.emailAddress,
                        hintText: 'Enter Email',
                        controller: _signUpCustomerController.emailController,
                      ),
                      SizedBox(height: 28),
                      FormInputWithHint(
                        label: 'Phone Number',
                        keyboardType: TextInputType.number,
                        isDigitsOnly: true,
                        hintText: 'Enter Phone Number',
                        controller: _signUpCustomerController.phoneController,
                      ),
                      SizedBox(height: 28),
                      FormInputWithHint(
                        label: 'Password',
                        keyboardType: TextInputType.text,
                        controller:
                        _signUpCustomerController.passwordController,
                        obscureText:
                        _signUpCustomerController.getPasswordStatus,
                        suffixIcon: GestureDetector(
                          onTap: () {
                            snapshot.updatePasswordVisibility();
                          },
                          child:
                          snapshot.getPasswordStatus
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
                      SizedBox(height: 28),
                      FormInputWithHint(
                        keyboardType: TextInputType.text,
                        label: 'Confirm Password',
                        suffixIcon: GestureDetector(
                          onTap: () {
                            snapshot.updateConfirmPasswordVisibility();
                          },
                          child:
                          snapshot.getConfirmPasswordStatus
                              ? const Icon(
                            Icons.visibility_off_outlined,
                            color: AppColors.primaryColor,
                          )
                              : const Icon(
                            Icons.visibility,
                            color: AppColors.primaryColor,
                          ),
                        ),
                        obscureText:
                        _signUpCustomerController.getConfirmPasswordStatus,
                        controller:
                        _signUpCustomerController.confirmPassController,
                        hintText: 'Confirm Password',
                      ),
                      SizedBox(height: 28),
                      FormInputWithHint(
                        label: 'City',
                        keyboardType: TextInputType.text,

                        hintText: '',
                        controller: _signUpCustomerController.cityController,
                      ),

                      SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: FormInputWithHint(
                              label: 'State',
                              keyboardType: TextInputType.text,
                              controller:
                              _signUpCustomerController.stateController,
                              hintText: '',
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: FormInputWithHint(
                              label: 'Country',
                              keyboardType: TextInputType.text,
                              controller:
                              _signUpCustomerController.countryController,
                              hintText: '',
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 28),
                      Row(
                        children: [
                          Checkbox(
                            value: isSelected,
                            onChanged: (value) {
                              setState(() {
                                isSelected = value ?? false;
                              });
                            },
                          ),

                          Text(
                            'I accept ',
                            style: AppStyles.fontInkika().copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            'Terms & Conditions ',
                            style: AppStyles.fontInkika().copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              color: AppColors.orange,
                            ),
                          ),
                          Text(
                            'of company',
                            style: AppStyles.fontInkika().copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              color: AppColors.black,
                            ),
                          ),
                        ],
                      ),
                      RoundedEdgedButton(
                        buttonText: 'Next',
                        onButtonClick: () async {
                          if (_signUpCustomerController.nameController.text
                              .trim()
                              .isEmpty) {
                            showError(
                              title: 'Name',
                              message: 'Please enter name',
                            );
                          } else if (_signUpCustomerController
                              .emailController
                              .text
                              .trim()
                              .isEmpty) {
                            showError(
                              title: 'Email',
                              message: 'Please enter email',
                            );
                          } else if (!EmailValidator.validate(
                            _signUpCustomerController.emailController.text
                                .trim(),
                          )) {
                            showError(
                              title: 'Email',
                              message: 'Email format is not correct',
                            );
                          } else if (_signUpCustomerController
                              .phoneController
                              .text
                              .trim()
                              .isEmpty) {
                            showError(
                              title: 'Phone Number',
                              message: 'Please enter Phone Number',
                            );
                          } else if (_signUpCustomerController
                              .passwordController
                              .text
                              .trim()
                              .isEmpty) {
                            showError(
                              title: 'Password',
                              message: 'Please enter Password',
                            );
                          } else if (_signUpCustomerController
                              .confirmPassController
                              .text
                              .trim()
                              .isEmpty) {
                            showError(
                              title: 'Confirm Password',
                              message: 'Please Confirm your passowrd',
                            );
                          } else if (_signUpCustomerController
                              .cityController
                              .text
                              .trim()
                              .isEmpty) {
                            showError(
                              title: 'City',
                              message: 'Please enter City',
                            );
                          } else if (_signUpCustomerController
                              .stateController
                              .text
                              .trim()
                              .isEmpty) {
                            showError(
                              title: 'State',
                              message: 'Please enter State',
                            );
                          } else if (_signUpCustomerController
                              .countryController
                              .text
                              .trim()
                              .isEmpty) {
                            showError(
                              title: 'Country',
                              message: 'Please enter Country',
                            );
                          } else if (_signUpCustomerController
                              .passwordController
                              .text
                              .trim() !=
                              _signUpCustomerController
                                  .confirmPassController
                                  .text
                                  .trim()) {
                            showError(
                              title: 'Confirm Password',
                              message:
                              'Confirm Password and password does not match',
                            );
                          } else if (!isSelected) {
                            showError(
                              title: 'Terms and conditions',
                              message: 'Terms and conditions are not selected',
                            );
                          } else {
                            try {
                              await _signUpCustomerController.callSignUpApi();
                            } catch (e) {
                              showError(title: '', message: e.toString());
                            }
                          }
                          //pushToNextScreen(context: context, destination: CreateAccountStep3());
                        },
                      ),
                      SizedBox(height: 14),
                      GestureDetector(
                        onTap: () {
                          pushReplaceAndClearStack(
                            context: context,
                            destination: WelcomePage(),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Already have an account? ',
                              style: AppStyles.fontInkika().copyWith(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              'Login ',
                              style: AppStyles.fontInkika().copyWith(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                                color: AppColors.orange,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 14),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
