import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instajobs/controllers/sign_up_customer_controller.dart';
import 'package:instajobs/storage_services/local_stoage_service.dart';
import 'package:instajobs/utils/baseClass.dart';
import 'package:instajobs/views/create_account.dart';
import 'package:instajobs/views/submit_otp.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;

import '../bottom_sheets/choose_image_bottom_sheet.dart';
import '../utils/app_colors.dart';
import '../utils/app_images.dart';
import '../utils/app_styles.dart';
import '../widgets/app_bar.dart';
import '../widgets/form_input_with_hint_on_top.dart';
import '../widgets/rounded_edged_button.dart';

class CreateAccountStep3 extends StatefulWidget {
  const CreateAccountStep3({super.key});

  @override
  State<CreateAccountStep3> createState() => _CreateAccountStep3State();
}

class _CreateAccountStep3State extends State<CreateAccountStep3>
    with BaseClass {
  Future<void> uploadImageWithText({
    required File imageFile,
    required String type,
    required String description,
  }) async {
    try {
      dio.FormData formData = dio.FormData(); // create empty form

      formData.fields.add(MapEntry("type", type));
      formData.fields.add(MapEntry("expireDate", '1719259987'));
      formData.fields.add(MapEntry("identifyId", 'sasaD233232'));

      formData.files.add(
        MapEntry(
          "attachments",
          await dio.MultipartFile.fromFile(
            imageFile.path,
            filename: path.basename(imageFile.path),
          ),
        ),
      );

      dio.Dio dio2 = dio.Dio();
      print(StorageService().getUserData().getAuthToken());
      final response = await dio2.post(
        "https://app.superinstajobs.com/api/v1/add-proof",
        data: formData,
        options: dio.Options(headers: {"Content-Type": "multipart/form-data","Authorization":StorageService().getUserData().getAuthToken()}),
      );


      if (response.statusCode == 200) {
        print("Upload successful: ${response.data}");
      } else {
        print("Upload failed: ${response.statusCode}");
      }
    } catch (e) {
      print("Error uploading: $e");
    }
  }

  File? _image;
  File? identityImagePath;
  SignUpCustomerController signUpCustomerController = Get.put(
    SignUpCustomerController(),
  );
  File? expiryImage;

  String? certificateExpiry;
  String? identityExpiry;

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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          'Create Account',
          style: AppStyles.fontInkika().copyWith(fontSize: 24),
        ),
      ),
      body: Column(
        children: [
          CustomAppBar(showStepOne: true, showStepTwo: true),
          SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Text(
                        'Identity Proofs',
                        style: GoogleFonts.roboto(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Spacer(),
                      /*TextButton(
                        onPressed: () {},
                        child: Text(
                          '+ ADD MORE',
                          style: AppStyles.font500_14().copyWith(
                            color: AppColors.orange,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),*/
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      ImageExpiryPickerSheet.show(context, (
                        File? image,
                        DateTime? date,
                      ) async {
                        if (image != null && date != null) {
                          identityImagePath = image;
                          identityExpiry =
                              DateFormat(
                                'yyyy-MM-dd',
                              ).parse(date.toString()).toString();
                          try {
                            showCircularDialog(context);
                            await uploadImageWithText(
                              imageFile: identityImagePath!,
                              type: '1',
                              description: '',
                            );
                            popToPreviousScreen(context: context);

                          }  catch (e) {
                            popToPreviousScreen(context: context);
                            showError(title: '', message: e.toString());
                          }
                          setState(() {});
                        }
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xffEBEBEB)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Identity Proofs',
                                  style: GoogleFonts.roboto(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Expiry Date: ${identityExpiry == null ? '' : identityExpiry?.split(' ').first}',
                                  style: GoogleFonts.roboto(
                                    color: Colors.grey,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          identityImagePath != null
                              ? Image(
                                image: FileImage(identityImagePath!),
                                height: 48,
                                width: 48,
                                fit: BoxFit.cover,
                              )
                              : SizedBox(),
                          SizedBox(width: 22),
                          Icon(Icons.edit, color: AppColors.orange, size: 14),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 16),
                  Row(
                    children: [
                      Text(
                        'Education Certificates',
                        style: GoogleFonts.roboto(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Spacer(),
                      /*TextButton(
                        onPressed: () {},
                        child: Text(
                          '+ ADD MORE',
                          style: AppStyles.font500_14().copyWith(
                            color: AppColors.orange,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),*/
                    ],
                  ),

                  GestureDetector(
                    onTap: () {
                      ImageExpiryPickerSheet.show(context, (
                        File? image,
                        DateTime? date,
                      ) async{
                        if (image != null && date != null) {
                          expiryImage = image;

                          certificateExpiry =
                              DateFormat(
                                'yyyy-MM-dd',
                              ).parse(date.toString()).toString();
                          try {
                            showCircularDialog(context);
                            await uploadImageWithText(
                            imageFile: expiryImage!,
                            type: '2',
                            description: '',
                            );
                            popToPreviousScreen(context: context);

                          }  catch (e) {
                            popToPreviousScreen(context: context);
                            showError(title: '', message: e.toString());
                          }
                          setState(() {});
                        }
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xffEBEBEB)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Identity Proofs',
                                  style: GoogleFonts.roboto(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Expiry Date: ${certificateExpiry == null ? '' : certificateExpiry?.split(' ').first}',
                                  style: GoogleFonts.roboto(
                                    color: Colors.grey,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          expiryImage != null
                              ? Image(
                                image: FileImage(expiryImage!),
                                height: 48,
                                width: 48,
                                fit: BoxFit.cover,
                              )
                              : SizedBox(),
                          SizedBox(width: 22),
                          Icon(Icons.edit, color: AppColors.orange, size: 14),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          RoundedEdgedButton(
            buttonText: 'Next',
            leftMargin: 16,
            rightMargin: 16,
            onButtonClick: () {
              if (identityImagePath == null) {
                showError(
                  title: 'Identity proof',
                  message: 'Please add identity proof',
                );
              } else if (identityExpiry == null) {
                showError(
                  title: 'Identity expiry',
                  message: 'Please add identity expiry',
                );
              } else if (expiryImage == null) {
                showError(
                  title: 'Certificate expiry',
                  message: 'Please add Certificate',
                );
              } else if (certificateExpiry == null) {
                showError(
                  title: 'Certificate expiry',
                  message: 'Please add Certificate expiry',
                );
              } else {
                pushToNextScreen(
                  context: context,
                  destination: SubmitOtp(),
                );
              }
            },
          ),
          SizedBox(height: 28),
        ],
      ),
    );
  }
}

class ImageExpiryPickerSheet {
  static Future<void> show(
    BuildContext context,
    Function(File?, DateTime?) onDone,
  ) async {
    File? selectedImage;
    DateTime? selectedDate;

    final picker = ImagePicker();
    final dateFormatter = DateFormat('yyyy-MM-dd'); // 📅 Format nicely!

    Future<void> pickImage(ImageSource source, StateSetter setState) async {
      final pickedFile = await picker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          selectedImage = File(pickedFile.path);
        });
      }
    }

    Future<void> pickDate(BuildContext context, StateSetter setState) async {
      final now = DateTime.now();
      final pickedDate = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: now,
        lastDate: DateTime(now.year + 10),
      );

      if (pickedDate != null) {
        setState(() {
          selectedDate = pickedDate;
        });
      }
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 30),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Select Image and Expiry Date',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          icon: const Icon(Icons.camera_alt),
                          label: const Text("Camera"),
                          onPressed: () async {
                            await pickImage(ImageSource.camera, setState);
                          },
                        ),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.photo_library),
                          label: const Text("Gallery"),
                          onPressed: () async {
                            await pickImage(ImageSource.gallery, setState);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    if (selectedImage != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          selectedImage!,
                          width: 200,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      )
                    else
                      const Text("No image selected."),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.calendar_today),
                      label: Text(
                        selectedDate == null
                            ? "Pick Expiry Date"
                            : "Expiry: ${dateFormatter.format(selectedDate!)}",
                      ),
                      // ✅ Correctly showing formatted date
                      onPressed: () => pickDate(context, setState),
                    ),
                    const SizedBox(height: 10),
                    if (selectedDate != null)
                      Text(
                        "Selected Expiry Date: ${dateFormatter.format(selectedDate!)}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    else
                      const Text(
                        "No expiry date selected.",
                        style: TextStyle(color: Colors.grey),
                      ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        onDone(selectedImage, selectedDate);
                      },
                      child: const Text("Done"),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
