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
import 'dart:convert';

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
  List<Map<String, dynamic>> addOnList = [];
 // Map<String, dynamic> addOnList = {};
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
              borderColor: AppColors.borderColor,
              hintText: 'Title of your project',
              controller: nameController,
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Delivery',
                        textAlign: TextAlign.left,
                        style: AppStyles.fontInkika13().copyWith(
                          color: AppColors.labelColor,
                        ),
                      ),
                      SizedBox(height: 8),
                      CustomDropdown<int?>(
                        items: _numbers,
                        height: 48,
                        hint: 'Select Time',
                        borderColor: AppColors.borderColor,
                        borderWidth: 1,
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
                SizedBox(width: 16),
                Expanded(
                  child: FormInputWithHint(
                    label: 'Price',
                    hintText: 'Price',
                    borderColor: AppColors.borderColor,
                    controller: priceController,
                    keyboardType: TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    isDigitsOnly: true,
                    prefixIcon: SizedBox(
                      width: 40, // control width
                      height: 40, // control height
                      child: Center(
                        child: GetCurrencyWidget(
                          radius: 15,   // smaller circle
                          fontSize: 20, // smaller ₦ symbol
                        ),
                      ),
                    ),

                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            FormInputWithHint(
              label: 'Describe your offer in more details!',
              hintText: 'Enter text here',
              controller: descriptionController,
              borderColor: AppColors.borderColor,
              maxLine: 3,
            ),
            SizedBox(height: 20),
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
                      border: Border.all(color: AppColors.btncolor),
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: Text(
                      '+ Upload files',
                      style: AppStyles.font500_14().copyWith(
                        color: AppColors.btncolor,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    pushToNextScreen(
                      context: context,
                      destination: AddAddonsPage(
                        addOnList: {},
                        onTap: (String title, String price, int workingDays) {
                          if (addOnList.isNotEmpty) {
                            // print('object');
                            // addOnList.clear();
                          }

                          addOnList.add({
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
                      border: Border.all(color: AppColors.btncolor),
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: Text(
                      '+ Add Addons',
                      style: AppStyles.font500_14().copyWith(
                        color: AppColors.btncolor,
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
                : Column(
              children: addOnList.asMap().entries.map((entry) {
                int index = entry.key;
                var addOn = entry.value;

                return Dismissible(
                  key: ValueKey(index),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    color: Colors.red,
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (direction) {
                    setState(() {
                      addOnList.removeAt(index);
                    });
                  },
                  child: GestureDetector(
                    onTap: () {
                      pushToNextScreen(
                        context: context,
                        destination: AddAddonsPage(
                          addOnList: addOn,
                          onTap: (String title, String price, int workingDays) {
                            addOnList[index] = {
                              'title': title,
                              'workingDays': workingDays,
                              'price': price,
                            };
                            setState(() {});
                          },
                        ),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: 10),
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
                                addOn['title'] ?? '',
                                style: AppStyles.font500_16().copyWith(
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    addOn['price'] ?? '',
                                    style: AppStyles.font500_16().copyWith(
                                      color: Colors.black,
                                      fontSize: 14,
                                    ),
                                  ),
                                  SizedBox(width: 6),
                                  GetCurrencyWidget(),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Additional ${addOn['workingDays'].toString()} working days',
                            style: AppStyles.font500_16().copyWith(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),





            SizedBox(height: 16),
            RoundedEdgedButton(
              buttonText: 'Post a offer',
              borderColor: AppColors.btncolor,
              onButtonClick: () async {
                String description = descriptionController.text.trim();
                String name = nameController.text.trim();
                String price = priceController.text.trim();
                print(_pickedImages.isEmpty);
                int deliveryTime = _selectedNumber ?? 0;
                if (name.isEmpty) {
                  showError(title: 'Name', message: 'Please add name');
                } else if (name.length < 3) {
                  showError(title: 'Name', message: 'Name Should be 3 character long');
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
                } else if (_pickedImages.length == 0) {
                  showError(title: 'Image', message: 'Please upload a image');
                } else {
                  try {
                    if (_pickedImages.isNotEmpty) {
                      print('with images');
                      queryParams.addAll({
                        'description': description,
                        'name': name,
                        'price': price,
                        'deliveryTime': deliveryTime,
                      });
                      if (addOnList.isNotEmpty) {

                        queryParams['adOn'] = jsonEncode(addOnList.map((item) {
                          return item.map((key, value) => MapEntry(key.toString(), value.toString()));
                        }).toList());

                       // queryParams.putIfAbsent('adOn', () => addOnList);
                      }
                      print(queryParams);
                      await _uploadImages();
                    } else {
                      print('withImage');
                      await profileController.addOfferApi(
                        description: description,
                        name: name,
                        price: price,
                        deliveryTime: deliveryTime,
                        adOn: addOnList.isNotEmpty ? addOnList : null,
                      );
                      // await profileController.addOfferApi(
                      //   description: description,
                      //   name: name,
                      //   price: price,
                      //   deliveryTime: deliveryTime,
                      // );
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
