import 'dart:io';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instajobs/utils/baseClass.dart';
import 'package:instajobs/widgets/currency_widget.dart';
import 'package:instajobs/widgets/form_input_with_hint_on_top.dart';
import 'package:instajobs/widgets/rounded_edged_button.dart';

import '../../bottom_sheets/choose_image_bottom_sheet.dart';
import '../../controllers/profile_controller.dart';
import 'package:get/get.dart';

import '../../models/profile_details_model.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_styles.dart';

class MyProfilePage extends StatefulWidget {
  final ProfileDetailsModelData? profileDetailsModelData;

  const MyProfilePage({super.key, required this.profileDetailsModelData});

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> with BaseClass {
  final ProfileController _profileController = Get.put(ProfileController());
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController hourlyPriceController = TextEditingController();
  TextEditingController dailyPriceController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController profileImageController = TextEditingController();

  ///---
  ProfileController profileController = Get.put(ProfileController());
  int userType = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final name1 = splitName(
      widget.profileDetailsModelData?.userInfo?.name ?? '',
    );
    firstNameController.text = name1.first;
    lastNameController.text = name1.last;
    userType = widget.profileDetailsModelData?.userInfo?.userTypes ?? 0;
    emailController.text =
        widget.profileDetailsModelData?.userInfo?.email ?? '';
    phoneController.text =
        widget.profileDetailsModelData?.userInfo?.phone ?? '';
    descriptionController.text =
        widget.profileDetailsModelData?.userInfo?.descriptions ?? '';
    hourlyPriceController.text =
        widget.profileDetailsModelData?.userInfo?.hourlyPrice.toString() ?? '';
    dailyPriceController.text =
        widget.profileDetailsModelData?.userInfo?.dailyPrice.toString() ?? '';
    cityController.text =
        widget.profileDetailsModelData?.userInfo?.city.toString() ?? '';
    stateController.text =
        widget.profileDetailsModelData?.userInfo?.state.toString() ?? '';
    countryController.text =
        widget.profileDetailsModelData?.userInfo?.country.toString() ?? '';
  }

  ({String first, String last}) splitName(String raw) {
    // Normalise whitespace and trim ends
    final parts = raw.trim().split(RegExp(r'\s+'));

    if (parts.length == 1) {
      return (first: parts[0], last: '');
    } else {
      final first = parts.first;
      final last = parts.sublist(1).join(' '); // keeps “Mary Jane” intact
      return (first: first, last: last);
    }
  }

  File? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });

      // Close the bottom sheet after picking the image
      Navigator.of(context).pop(); // 👈 add this line
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        backgroundColor: AppColors.bgColor,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        title: Text(
          'My profile',
          style: AppStyles.fontInkika().copyWith(fontSize: 24),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 100,
                  width: 100,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black,
                  ),
                  child: _image == null
                      ? (_profileController.profileDetailsModel?.userInfo?.profile == null ||
                      (_profileController.profileDetailsModel?.userInfo?.profile?.isEmpty ?? true))
                      ? const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 48,
                  )
                      : ClipOval(
                    child: Image.network(
                      _profileController.profileDetailsModel?.userInfo?.profile ?? '',
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                  )
                      : ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image(
                      image: FileImage(_image!),
                      fit: BoxFit.cover,
                      height: 100,
                      width: 100,
                    ),
                  ),
                ),

                // Edit Icon – now opens the image picker
                Positioned(
                  top: -4,
                  right: -4,
                  child: GestureDetector(
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
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.edit,
                        size: 20,
                        color: AppColors.orange,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: FormInputWithHint(
                    label: 'First Name',
                    hintText: 'First Name',
                    controller: firstNameController,
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: FormInputWithHint(
                    label: 'Last Name',
                    hintText: 'Last Name',
                    controller: lastNameController,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            FormInputWithHint(
              label: 'Email ID',
              hintText: 'Email ID',
              controller: emailController,
              isEnabled: false,
            ),
            SizedBox(height: 16),
            FormInputWithHint(
              label: 'Phone number',
              hintText: 'Phone number',
              isDigitsOnly: true,
              keyboardType: TextInputType.phone,
              controller: phoneController,
            ),
            SizedBox(height: 16),
            FormInputWithHint(
              label: 'Description',
              hintText: 'Description',
              controller: descriptionController,
              maxLine: 4,
            ),
            SizedBox(height: 16),
            if (userType != 0) ...[
              FormInputWithHint(
                label: 'Hourly Price',
                hintText: 'Hourly Price',
                controller: hourlyPriceController,
                keyboardType: TextInputType.number,
                prefixIcon: GetCurrencyWidget(fontSize: 16),
                isDigitsOnly: true,
              ),
              SizedBox(height: 16),
              FormInputWithHint(
                label: 'Daily Price',
                hintText: 'Daily Price',
                keyboardType: TextInputType.number,
                prefixIcon: GetCurrencyWidget(fontSize: 16),
                isDigitsOnly: true,
                controller: dailyPriceController,
              ),
              SizedBox(height: 16),
            ],
            FormInputWithHint(
              label: 'City',
              hintText: 'City',
              controller: cityController,
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: FormInputWithHint(
                    label: 'State',
                    hintText: 'State',
                    controller: stateController,
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: FormInputWithHint(
                    label: 'Country',
                    hintText: 'Country',
                    controller: countryController,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            RoundedEdgedButton(
              buttonText: 'Save changes',
              onButtonClick: () async {
                if (firstNameController.text.trim().isEmpty) {
                  showError(
                    title: 'First Name',
                    message: 'Please add first name.',
                  );
                } else if (lastNameController.text.trim().isEmpty) {
                  showError(
                    title: 'Last Name',
                    message: 'Please add last name.',
                  );
                } else if (emailController.text.trim().isEmpty) {
                  showError(title: 'Email', message: 'Please add email.');
                } else if (!EmailValidator.validate(
                  emailController.text.trim(),
                )) {
                  showError(
                    title: 'Email',
                    message: 'Email format is not correct',
                  );
                } else if (phoneController.text.trim().isEmpty) {
                  showError(
                    title: 'Phone number',
                    message: 'Please add phone number.',
                  );
                } else if (descriptionController.text.trim().isEmpty) {
                  showError(
                    title: 'Description',
                    message: 'Please add description.',
                  );
                } else if (hourlyPriceController.text.trim().isEmpty) {
                  showError(
                    title: 'Hourly Price',
                    message: 'Please add hourly price.',
                  );
                } else if (dailyPriceController.text.trim().isEmpty) {
                  showError(
                    title: 'Daily Price',
                    message: 'Please add daily price.',
                  );
                } else if (cityController.text.trim().isEmpty) {
                  showError(title: 'City', message: 'Please add City.');
                } else if (stateController.text.trim().isEmpty) {
                  showError(title: 'State', message: 'Please add State.');
                } else if (countryController.text.trim().isEmpty) {
                  showError(title: 'Country', message: 'Please add Country.');
                } else {
                  try {
                    showGetXCircularDialog();
                    await _profileController.updateProfile(
                      firstName: firstNameController.text,
                      lastName: lastNameController.text,
                      email: emailController.text,
                      phone: phoneController.text,
                      description: descriptionController.text,
                      hourlyPrice: double.tryParse(hourlyPriceController.text) ?? 0.0,
                      dailyPrice: double.tryParse(dailyPriceController.text) ?? 0.0,
                      city: cityController.text,
                      state: stateController.text,
                      country: countryController.text,
                      latitude: widget.profileDetailsModelData?.userInfo?.latitude.toString() ?? '',
                      longitude: widget.profileDetailsModelData?.userInfo?.longitude.toString() ?? '',
                      street: widget.profileDetailsModelData?.userInfo?.street.toString() ?? '',
                      profile: _image,
                    );
                    Get.back();
                    showSuccess(
                      title: 'Success',
                      message: 'Profile updated successfully',
                    );
                  } catch (e) {
                    showError(title: 'Edit Profile', message: e.toString());
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
