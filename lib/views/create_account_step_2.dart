import 'dart:io';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instajobs/bottom_sheets/choose_image_bottom_sheet.dart';
import 'package:instajobs/controllers/freelancer_sign_up.dart';
import 'package:instajobs/utils/app_images.dart';
import 'package:instajobs/utils/baseClass.dart';
import 'package:instajobs/views/create_account_step_3.dart';
import 'package:instajobs/widgets/app_bar.dart';
import 'package:instajobs/widgets/form_input_with_hint_on_top.dart';
import 'package:instajobs/widgets/rounded_edged_button.dart';

import '../utils/app_colors.dart';
import '../utils/app_styles.dart';

class CreateAccountStep2 extends StatefulWidget {
  const CreateAccountStep2({super.key});

  @override
  State<CreateAccountStep2> createState() => _CreateAccountStep2State();
}

class _CreateAccountStep2State extends State<CreateAccountStep2>
    with BaseClass {
  final FreelancerSignUp freelancerSignUp = Get.put(FreelancerSignUp());
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
    freelancerSignUp.resetItems();
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
          'Create Account',
          style: AppStyles.fontInkika().copyWith(fontSize: 24),
        ),
      ),
      body: GetBuilder<FreelancerSignUp>(
        init: freelancerSignUp,
        builder: (snapshot) {
          return Column(
            children: [
              CustomAppBar(showStepOne: true, showStepTwo: false),
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
                        label: 'Company/Freelance Name',
                        hintText: 'Enter here...',
                        keyboardType: TextInputType.text,
                        controller: freelancerSignUp.companyNameController,
                      ),
                      SizedBox(height: 28),
                      FormInputWithHint(
                        label: 'Email ID',
                        hintText: 'Enter email',
                        keyboardType: TextInputType.emailAddress,
                        controller: freelancerSignUp.emailController,
                        /*suffixIcon: Text(
                          'Verify',
                          textAlign: TextAlign.center,
                          style: AppStyles.font400_12().copyWith(
                            color: AppColors.orange,
                          ),
                        ),*/
                      ),
                      SizedBox(height: 28),
                      FormInputWithHint(
                        label: 'Phone Number',
                        hintText: 'Enter phone number',
                        keyboardType: TextInputType.number,
                        isDigitsOnly: true,
                        controller: freelancerSignUp.phoneController,
                      ),
                      SizedBox(height: 28),
                      FormInputWithHint(
                        label: 'Password',
                        hintText: 'Enter your password',
                        keyboardType: TextInputType.text,
                        obscureText: freelancerSignUp.getPasswordStatus,
                        suffixIcon: GestureDetector(
                          onTap: () {
                            freelancerSignUp.updatePasswordVisibility();
                          },
                          child:
                              freelancerSignUp.getPasswordStatus
                                  ? const Icon(
                                    Icons.visibility_off_outlined,
                                    color: AppColors.primaryColor,
                                  )
                                  : const Icon(
                                    Icons.visibility,
                                    color: AppColors.primaryColor,
                                  ),
                        ),
                        controller: freelancerSignUp.passController,
                      ),
                      SizedBox(height: 28),
                      FormInputWithHint(
                        label: 'Confirm password',
                        hintText: 'Confirm your password',
                        suffixIcon: GestureDetector(
                          onTap: () {
                            freelancerSignUp.updateConfirmPasswordVisibility();
                          },
                          child:
                              freelancerSignUp.getConfirmPasswordStatus
                                  ? const Icon(
                                    Icons.visibility_off_outlined,
                                    color: AppColors.primaryColor,
                                  )
                                  : const Icon(
                                    Icons.visibility,
                                    color: AppColors.primaryColor,
                                  ),
                        ),
                        obscureText: freelancerSignUp.getConfirmPasswordStatus,
                        keyboardType: TextInputType.text,
                        controller: freelancerSignUp.confirmPassController,
                      ),
                      SizedBox(height: 28),
                      FormInputWithHint(
                        label: 'Description',
                        maxLine: 4,
                        hintText: 'Text here...',
                        keyboardType: TextInputType.text,
                        controller: freelancerSignUp.descriptionController,
                      ),
                      SizedBox(height: 16),
                      FormInputWithHint(
                        label: 'Languages',
                        hintText: '',
                        keyboardType: TextInputType.text,
                        controller: freelancerSignUp.languageController,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: Text(
                            '+ ADD MORE',
                            style: AppStyles.font500_14().copyWith(
                              color: AppColors.orange,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: FormInputWithHint(
                              label: 'Country',
                              keyboardType: TextInputType.text,
                              controller: freelancerSignUp.countryController,
                              hintText: '',
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: FormInputWithHint(
                              label: 'State',
                              keyboardType: TextInputType.text,
                              hintText: '',
                              controller: freelancerSignUp.stateController,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: FormInputWithHint(
                              label: 'City',
                              keyboardType: TextInputType.text,
                              hintText: '',
                              controller: freelancerSignUp.cityController,
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: FormInputWithHint(
                              label: 'Street',
                              keyboardType: TextInputType.text,
                              hintText: '',
                              controller: freelancerSignUp.streetController,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 28),
                      RoundedEdgedButton(
                        buttonText: 'Next',
                        onButtonClick: () async {
                          if (freelancerSignUp.companyNameController.text
                              .trim()
                              .isEmpty) {
                            showError(
                              title: 'Name',
                              message: 'Please enter name',
                            );
                          } else if (freelancerSignUp.emailController.text
                              .trim()
                              .isEmpty) {
                            showError(
                              title: 'Email',
                              message: 'Please enter email',
                            );
                          } else if (!EmailValidator.validate(
                            freelancerSignUp.emailController.text.trim(),
                          )) {
                            showError(
                              title: 'Email',
                              message: 'Email format is not correct',
                            );
                          } else if (freelancerSignUp.phoneController.text
                              .trim()
                              .isEmpty) {
                            showError(
                              title: 'Phone Number',
                              message: 'Please enter Phone Number',
                            );
                          } else if (freelancerSignUp.passController.text
                              .trim()
                              .isEmpty) {
                            showError(
                              title: 'Password',
                              message: 'Please enter Password',
                            );
                          } else if (freelancerSignUp.confirmPassController.text
                              .trim()
                              .isEmpty) {
                            showError(
                              title: 'Confirm Password',
                              message: 'Please Confirm your password',
                            );
                          } else if (freelancerSignUp.cityController.text
                              .trim()
                              .isEmpty) {
                            showError(
                              title: 'City',
                              message: 'Please enter City',
                            );
                          } else if (freelancerSignUp.stateController.text
                              .trim()
                              .isEmpty) {
                            showError(
                              title: 'State',
                              message: 'Please enter State',
                            );
                          } else if (freelancerSignUp.countryController.text
                              .trim()
                              .isEmpty) {
                            showError(
                              title: 'Country',
                              message: 'Please enter Country',
                            );
                          } else if (freelancerSignUp.passController.text
                                  .trim() !=
                              freelancerSignUp.confirmPassController.text
                                  .trim()) {
                            showError(
                              title: 'Confirm Password',
                              message:
                                  'Confirm Password and password does not match',
                            );
                          } else {
                            try {
                              showCircularDialog(context);
                              await freelancerSignUp.callSignUpApi();
                              popToPreviousScreen(context: context);
                              pushToNextScreen(
                                context: context,
                                destination: CreateAccountStep3(),
                              );
                            } catch (e) {
                              popToPreviousScreen(context: context);
                              showError(title: '', message: e.toString());
                            }
                          }
                        },
                      ),
                      SizedBox(height: 28),
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
