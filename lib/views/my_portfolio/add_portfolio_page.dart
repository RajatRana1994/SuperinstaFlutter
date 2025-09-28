import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instajobs/utils/baseClass.dart';
import 'package:instajobs/widgets/form_input_with_hint_on_top.dart';
import 'package:instajobs/widgets/rounded_edged_button.dart';
import 'package:get/get.dart';
import '../../bottom_sheets/choose_image_bottom_sheet.dart';
import '../../controllers/profile_controller.dart';
import '../../models/my_portfolio_model.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_images.dart';
import '../../utils/app_styles.dart';

class AddPortfolioPage extends StatefulWidget {
  final bool isEditPortfolio;
  final MyPortfolioModelDataData? portfolioModelDataData;

  const AddPortfolioPage({
    super.key,
    this.isEditPortfolio = false,
    this.portfolioModelDataData,
  });

  @override
  State<AddPortfolioPage> createState() => _AddPortfolioPageState();
}

class _AddPortfolioPageState extends State<AddPortfolioPage> with BaseClass {
  final ProfileController controller = Get.put(ProfileController());

  final TextEditingController titleController = TextEditingController();

  final TextEditingController descController = TextEditingController();

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
    if (widget.isEditPortfolio) {
      titleController.text = widget.portfolioModelDataData?.title ?? '';
      descController.text = widget.portfolioModelDataData?.description ?? '';
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
          widget.isEditPortfolio ? 'Update Portfolio' : 'Add Portfolio',
          style: AppStyles.fontInkika().copyWith(fontSize: 20),
        ),
        actions: [],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
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
                  ? widget.isEditPortfolio
                  ? Image.network(
                widget.portfolioModelDataData?.image ?? '',
                height: 150,
                width: 150,
                // fit: BoxFit.cover,
                // ⬇️ show a local fallback if the network image can’t load
                errorBuilder:
                    (context, error, stackTrace) => Image.asset(
                  'assets/images/icon.png',
                  height: 150,
                  width: 150,
                  // put the asset in pubspec.yaml
                  fit: BoxFit.cover,
                ),
              )
                  : Image(
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
              label: 'Title',
              hintText: 'Enter here',
              controller: titleController,
            ),
            SizedBox(height: 20),
            FormInputWithHint(
              label: 'Description',
              controller: descController,
              hintText: 'Enter text here',
              keyboardAction: TextInputAction.done,
              maxLine: 5,
            ),
            SizedBox(height: 20),
            RoundedEdgedButton(
              buttonText: widget.isEditPortfolio?'Update': 'Save',
              onButtonClick: () async {
                String title = titleController.text.trim();
                String description = descController.text.trim();
                if (title.isEmpty) {
                  showError(title: 'Title', message: 'Please add title');
                } else if (description.isEmpty) {
                  showError(
                    title: 'Description',
                    message: 'Please add Description',
                  );
                } else {
                  try {
                    if (_image == null) {
                      if(widget.isEditPortfolio){
                        await controller.editPortfolio(title, description,widget.portfolioModelDataData?.id.toString()??'');
                      }
                      else{
                        await controller.addPortfolio(title, description);
                      }

                    } else {
                      if(widget.isEditPortfolio){
                        await controller.uploadImageHttp(
                            imageFile: _image!,
                            title:title,
                            description:description,
                            isEditPortfolio: true,
                            itemId: widget.portfolioModelDataData?.id.toString()??''
                        );

                      }
                      else{
                        await controller.uploadImageHttp(
                          imageFile: _image!,
                          title:title,
                          description:description,
                        );
                      }

                    }
                  } catch (e) {
                    showError(title: 'Add Portfolio', message: e.toString());
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
