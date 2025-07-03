import 'dart:io';

import 'package:dio/dio.dart' as diox;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instajobs/bottom_sheets/choose_image_bottom_sheet.dart';
import 'package:instajobs/controllers/profile_controller.dart';
import 'package:instajobs/storage_services/local_stoage_service.dart';
import 'package:instajobs/utils/baseClass.dart';
import 'package:instajobs/widgets/currency_widget.dart';
import 'package:instajobs/widgets/form_input_with_hint_on_top.dart';
import 'package:instajobs/widgets/rounded_edged_button.dart';
import 'package:get/get.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_styles.dart';
import '../../widgets/custom_drop_down.dart';
import 'add_addons_page.dart';

class AddOfferPage extends StatefulWidget {
  const AddOfferPage({super.key});

  @override
  State<AddOfferPage> createState() => _AddOfferPageState();
}

class _AddOfferPageState extends State<AddOfferPage> with BaseClass {
  TextEditingController nameController = TextEditingController();
  TextEditingController deliveryController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  ProfileController profileController = Get.put(ProfileController());
  final List<int> _numbers = List.generate(90, (i) => i + 1);
  int? _selectedNumber;
  Map<String, dynamic> addOnList = {};
  final ImagePicker _picker = ImagePicker();
  final List<File> _pickedImages = [];
  final Map<String, String> headers = {
    "Content-Type": "multipart/form-data",
    "Authorization": StorageService().getUserData().getAuthToken() ?? '',
  };
  Map<String, dynamic> queryParams = {};

  Future<void> _pickOne(ImageSource source) async {
    final XFile? file = await _picker.pickImage(
      source: source,
      imageQuality: 85,
    );
    if (file == null) return;

    setState(() {
      _pickedImages.add(File(file.path));
    });
  }

  void _removeImage(int index) {
    setState(() {
      _pickedImages.removeAt(index);
    });
  }

  Future<void> _uploadImages() async {
    if (_pickedImages.isEmpty) return;

    final dio = diox.Dio();
    try {
      showGetXCircularDialog();
      // Build multipart form data
      final formData = diox.FormData.fromMap({
        ...queryParams,
        'image':
            _pickedImages.map((file) {
              return diox.MultipartFile.fromFileSync(
                file.path,
                filename: file.path.split('/').last,
              );
            }).toList(),
      });


      final response = await dio.post(
        'https://app.superinstajobs.com/api/v1/offers',
        data: formData,
        options: diox.Options(headers: headers),
      );

      Get.back();
      if (response.statusCode == 200) {
        await profileController.getOffersApi();
        Get.back();
        showSuccess(title: 'Offer', message: 'Offer added successfully');


      } else {
        throw Exception('Failed with status ${response.statusCode}');
      }
    } catch (e) {
      print(e.toString());
      showError(title: 'Offer', message: e.toString());
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
          'Add Offer',
          style: AppStyles.fontInkika().copyWith(fontSize: 24),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            FormInputWithHint(
              label: 'Name',
              hintText: 'Title of your project',
              controller: nameController,
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Text(
                        'Delivery',
                        textAlign: TextAlign.left,
                        style: AppStyles.font400_14().copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 6),
                      CustomDropdown<int?>(
                        items: _numbers,
                        height: 48,
                        hint: 'Select Time',
                        selectedValue: _selectedNumber,
                        onChanged: (value) async {
                          setState(() {
                            _selectedNumber = value;
                          });
                        },
                        labelBuilder: (c) => '$c days',
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: FormInputWithHint(
                    label: 'Price',
                    hintText: 'Price',
                    controller: priceController,
                    keyboardType: TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    isDigitsOnly: true,
                    prefixIcon: GetCurrencyWidget(),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            FormInputWithHint(
              label: 'Describe your offer in more details!',
              hintText: 'Enter text here',
              controller: descriptionController,
              maxLine: 3,
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    ChooseImageBottomSheet.show(
                      context: context,
                      onCancel: () {
                        popToPreviousScreen(context: context);
                      },
                      onCamera: () {
                        popToPreviousScreen(context: context);
                        _pickOne(ImageSource.camera);
                      },
                      onGallery: () {
                        popToPreviousScreen(context: context);
                        _pickOne(ImageSource.gallery);
                      },
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.orange),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '+ Upload files',
                      style: AppStyles.font500_14().copyWith(
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    pushToNextScreen(
                      context: context,
                      destination: AddAddonsPage(
                        addOnList: addOnList,
                        onTap: (String title, String price, int workingDays) {
                          if (addOnList.isNotEmpty) {
                            addOnList.clear();
                          }

                          addOnList.addAll({
                            'title': title,
                            'workingDays': workingDays,
                            'price': price,
                          });
                          setState(() {});
                        },
                      ),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.orange),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '+ Add Addons',
                      style: AppStyles.font500_14().copyWith(
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            GridView.builder(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: _pickedImages.length,
              itemBuilder: (context, idx) {
                return Stack(
                  children: [
                    Positioned.fill(
                      child: Image.file(_pickedImages[idx], fit: BoxFit.cover),
                    ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: InkWell(
                        onTap: () => _removeImage(idx),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            shape: BoxShape.circle,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            addOnList.isEmpty
                ? SizedBox()
                : Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            addOnList['title'] ?? '',
                            style: AppStyles.font500_16().copyWith(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 0, left: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,

                              children: [
                                Text(
                                  addOnList['price'],
                                  style: AppStyles.font500_16().copyWith(
                                    color: Colors.black,
                                    fontSize: 14,
                                  ),
                                ),
                                SizedBox(width: 6),
                                GetCurrencyWidget(),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Additional ${addOnList['workingDays'].toString()} working days',
                        style: AppStyles.font500_16().copyWith(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
            SizedBox(height: 16),
            RoundedEdgedButton(
              buttonText: 'Post a offer',
              onButtonClick: () async {
                String description = descriptionController.text.trim();
                String name = nameController.text.trim();
                String price = priceController.text.trim();
                int deliveryTime = _selectedNumber ?? 0;
                if (name.isEmpty) {
                  showError(title: 'Name', message: 'Please add name');
                } else if (price.isEmpty) {
                  showError(title: 'Price', message: 'Please add price');
                } else if (description.isEmpty) {
                  showError(
                    title: 'Description',
                    message: 'Please add description',
                  );
                } else if (_selectedNumber == null) {
                  showError(
                    title: 'Delivery',
                    message: 'Please choose delivery time',
                  );
                } else {
                  try {
                    if (_pickedImages.isNotEmpty) {

                      queryParams.addAll({
                        'description': description,
                        'name': name,
                        'price': price,
                        'deliveryTime': deliveryTime,
                      });
                      if (addOnList.isNotEmpty) {
                        queryParams.putIfAbsent('adOn', () => addOnList);
                      }
                      print(queryParams);
                      await _uploadImages();

                    } else {

                      await profileController.addOfferApi(
                        description: description,
                        name: name,
                        price: price,
                        deliveryTime: deliveryTime,
                      );





                    }
                  } catch (e) {
                    showError(title: 'Add Offer', message: e.toString());
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
