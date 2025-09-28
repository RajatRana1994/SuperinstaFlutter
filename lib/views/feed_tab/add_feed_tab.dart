import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:instajobs/utils/baseClass.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_styles.dart';
import 'package:instajobs/widgets/form_input_with_hint_on_top.dart';
import 'package:instajobs/bottom_sheets/choose_image_bottom_sheet.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:instajobs/widgets/rounded_edged_button.dart';
import 'package:instajobs/controllers/feed_tab_controller.dart';
import 'dart:convert';
import 'package:dio/dio.dart' as diox;
import 'package:instajobs/storage_services/local_stoage_service.dart';
import 'package:image/image.dart' as img;
class AddFeedTab extends StatefulWidget {
  const AddFeedTab({super.key});

  @override
  State<AddFeedTab> createState() => _AddFeedTabState();
}

class _AddFeedTabState extends State<AddFeedTab> with BaseClass {
  FeedTabController feedTabController = Get.put(FeedTabController());
  TextEditingController descriptionController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  final List<File> _pickedImages = [];
  Future<void> _pickOne(ImageSource source) async {
    final XFile? file = await _picker.pickImage(
      source: source,
      imageQuality: 100,
    );
    if (file == null) return;

    final bytes = await file.readAsBytes();
    final originalImage = img.decodeImage(bytes);

    if (originalImage == null) return;

    final jpgBytes = img.encodeJpg(originalImage, quality: 100);
    final newPath = "${file.path}.jpg";
    final newFile = await File(newPath).writeAsBytes(jpgBytes);

    setState(() {
      _pickedImages.add(newFile);
    });
  }

  void _removeImage(int index) {
    setState(() {
      _pickedImages.removeAt(index);
    });
  }

  Map<String, dynamic> queryParams = {};
  final Map<String, String> headers = {
    "Content-Type": "multipart/form-data",
    "Authorization": StorageService().getUserData().getAuthToken() ?? '',
  };

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
        'https://app.superinstajobs.com/api/v1/add-portfolio',
        data: formData,
        options: diox.Options(headers: headers),
      );

      Get.back();
      if (response.statusCode == 200) {
        feedTabController.getMyFeedData();
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
      appBar: AppBar(
        backgroundColor: AppColors.bgColor,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        title: Text(
          'Add Feed',
          style: AppStyles.fontInkika().copyWith(fontSize: 20),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            SizedBox(height: 20),
            FormInputWithHint(
              label: 'Description',
              hintText: 'Enter text here...',
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



            SizedBox(height: 16),
            RoundedEdgedButton(
              buttonText: 'Add',
              borderColor: AppColors.btncolor,
              onButtonClick: () async {
                FocusScope.of(context).unfocus();
                if (_pickedImages.length == 0) {
                  showError(title: 'Files', message: 'Please add feed images');
                } else if (descriptionController.text.trim().isEmpty) {
                  showError(title: 'Description', message: 'Enter Description');
                } else {
                  queryParams.addAll({
                    'description': descriptionController.text,
                    'type': '1',
                    'title': 'Feeds'
                  });
                  _uploadImages();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
