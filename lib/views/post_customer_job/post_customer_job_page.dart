import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instajobs/bottom_sheets/choose_image_bottom_sheet.dart';
import 'package:instajobs/controllers/post_a_job/post_job_controller.dart';
import 'package:instajobs/utils/baseClass.dart';
import 'package:instajobs/widgets/currency_widget.dart';
import 'package:instajobs/widgets/form_input_with_hint_on_top.dart';
import 'package:instajobs/widgets/rounded_edged_button.dart';
import 'package:get/get.dart';
import '../../dialogs/ask_dialog.dart';
import '../../models/categoris.dart';
import '../../models/subCategory_model.dart';
import '../../models/tags_model.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_styles.dart';
import '../../widgets/custom_drop_down.dart';

class PostCustomerJobPage extends StatefulWidget {
  const PostCustomerJobPage({super.key});

  @override
  State<PostCustomerJobPage> createState() => _PostCustomerJobPageState();
}

class _PostCustomerJobPageState extends State<PostCustomerJobPage>
    with BaseClass {
  PostJobController postJobController = Get.put(PostJobController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    postJobController.resetItems();
    hitAPi();
  }

  hitAPi() async {
    await Future.wait([postJobController.getCategories()]);
  }

  final List<int> _numbers = List.generate(90, (i) => i + 1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        backgroundColor: AppColors.bgColor,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,

        title: Text(
          'Post a Job',
          style: AppStyles.fontInkika().copyWith(fontSize: 24),
        ),
      ),
      body: GetBuilder<PostJobController>(
        init: postJobController,
        builder: (snapshot) {
          if (snapshot.categoriesData == null) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.primaryColor,
                  ),
                ),
              ),
            );
          }
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 12),
                Text(
                  'Get your project Done!\nPost a project for free and start receiving proposals',
                  style: AppStyles.font700_12().copyWith(color: Colors.black),
                ),
                SizedBox(height: 16),
                FormInputWithHint(
                  label: 'Title',
                  hintText: 'Title for your project',
                  controller: snapshot.titleController,
                ),
                SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Category',
                      textAlign: TextAlign.left,
                      style: AppStyles.font400_14().copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 6),
                    CustomDropdown<CategoriesModelDataCategories?>(
                      items: snapshot.categoriesData ?? [],
                      hint: 'Category',
                      selectedValue: snapshot.selectedCategory,
                      onChanged: (value) {
                        setState(() {
                          snapshot.selectedCategory = value;
                          snapshot.selectedSubCategory = null;
                          snapshot.subCategoriesData = [];
                        });
                        snapshot.getSubCategories(
                          categoryId:
                              snapshot.selectedCategory?.id.toString() ?? '',
                        );
                        snapshot.getExperience(
                          categoryId:
                              snapshot.selectedCategory?.id.toString() ?? '',
                        );
                        if (kDebugMode) {
                          print('Selected: $value');
                        }
                      },
                      labelBuilder: (c) => c?.name ?? '',
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sub Category',
                      textAlign: TextAlign.left,
                      style: AppStyles.font400_14().copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 6),
                    CustomDropdown<SubCategoryModelDataSubCategories?>(
                      items: snapshot.subCategoriesData ?? [],
                      hint: 'Sub Category',
                      selectedValue: snapshot.selectedSubCategory,
                      onChanged: (value) {
                        setState(() {
                          snapshot.selectedSubCategory = value;
                        });
                        if (kDebugMode) {
                          print('Selected: $value');
                        }
                      },
                      labelBuilder: (c) => c?.name ?? '',
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Experience',
                      textAlign: TextAlign.left,
                      style: AppStyles.font400_14().copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 6),
                    CustomDropdown<String?>(
                      items: snapshot.experienceList ?? [],
                      hint: 'Experience',
                      selectedValue: snapshot.selectedExperience,
                      onChanged: (value) {
                        setState(() {
                          snapshot.selectedExperience = value;
                        });
                        if (kDebugMode) {
                          print('Selected: $value');
                        }
                      },
                      labelBuilder: (c) => c ?? '',
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: FormInputWithHint(
                        label: 'Price',
                        hintText: 'Price From',
                        isDigitsOnly: true,
                        keyboardType: TextInputType.number,
                        controller: snapshot.priceFromController,
                        prefixIcon: GetCurrencyWidget(),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: FormInputWithHint(
                        label: '',
                        hintText: 'Price To',
                        isDigitsOnly: true,
                        keyboardType: TextInputType.number,
                        controller: snapshot.priceToController,
                        prefixIcon: GetCurrencyWidget(),
                      ),
                    ),
                  ],
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
                            selectedValue: snapshot.selectedDelivery,
                            onChanged: (value) async {
                              snapshot.selectedDelivery = value;
                            },
                            labelBuilder: (c) => '$c days',
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: FormInputWithHint(
                        label: '',
                        hintText: 'Budget',
                        keyboardType: TextInputType.number,
                        isDigitsOnly: true,
                        controller: snapshot.budgetController,
                        prefixIcon: GetCurrencyWidget(),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: FormInputWithHint(
                        label: 'Select Location',
                        hintText: 'Country',
                        controller: snapshot.countryController,
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: FormInputWithHint(
                        label: '',
                        hintText: 'State',
                        controller: snapshot.stateController,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                FormInputWithHint(
                  label: 'Describe your project in more detail!',
                  hintText: 'Enter text here',
                  maxLine: 3,
                  keyboardAction: TextInputAction.done,
                  controller: snapshot.descriptionController,
                ),

                SizedBox(height: 16),
                (snapshot.tagsData != null &&
                        (snapshot.tagsData?.isNotEmpty ?? false))
                    ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Skills & Expertise',
                          style: AppStyles.font400_14().copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 16),
                        // give the Wrap the full width to work with:
                        SizedBox(
                          width: double.infinity,
                          child: Wrap(
                            spacing: 8, // gap between items horizontally
                            runSpacing: 8, // gap between lines vertically
                            alignment:
                                WrapAlignment.start, // left-align each run
                            children:
                                snapshot.tagsData!
                                    .asMap() // turns List<T> into Map<int, T>
                                    .entries
                                    .map((entry) {
                                      final index = entry.key;
                                      final item = entry.value;
                                      return GestureDetector(
                                        onTap: () {
                                          snapshot.updateTagSelection(
                                            index,
                                            item?.isSelected ?? false,
                                          );
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 8,
                                            horizontal: 12,
                                          ),
                                          decoration: BoxDecoration(
                                            color:
                                                (item?.isSelected ?? false)
                                                    ? Colors.orange
                                                    : Colors.orange.shade50,
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            border: Border.all(
                                              color: Colors.orange.shade200,
                                            ),
                                          ),
                                          child: Text(
                                            item?.name ?? '',
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color:
                                                  (item?.isSelected ?? false)
                                                      ? Colors.white
                                                      : Colors.black,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      );
                                    })
                                    .toList(),
                          ),
                        ),
                      ],
                    )
                    : SizedBox(),
                SizedBox(height: 16),
                GestureDetector(
                  onTap: () {
                    ChooseImageBottomSheet.show(
                      context: context,
                      onCancel: () {
                        popToPreviousScreen(context: context);
                      },
                      onCamera: () {
                        popToPreviousScreen(context: context);
                        snapshot.pickOne(ImageSource.camera);
                      },
                      onGallery: () {
                        popToPreviousScreen(context: context);
                        snapshot.pickOne(ImageSource.gallery);
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
                snapshot.pickedImages.isNotEmpty
                    ? SizedBox(height: 16)
                    : SizedBox(),
                GridView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: snapshot.pickedImages.length,
                  itemBuilder: (context, idx) {
                    return Stack(
                      children: [
                        Positioned.fill(
                          child: Image.file(
                            snapshot.pickedImages[idx],
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 4,
                          right: 4,
                          child: InkWell(
                            onTap: () => snapshot.removeImage(idx),
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
                  buttonText: 'Post a job',
                  onButtonClick: () async {
                    removeFocusFromEditText(context: context);
                    final List<TagsModelDataData?> tags =
                        snapshot.tagsData ?? [];

                    final String selectedTags = tags
                        .where((tag) => tag?.isSelected == true)
                        .map((tag) => tag?.name ?? '')
                        .join(', ');
                    String title = snapshot.titleController.text.trim();
                    String fromPrice = snapshot.priceFromController.text.trim();
                    String toPrice = snapshot.priceToController.text.trim();
                    String budget = snapshot.budgetController.text.trim();
                    if (title.isEmpty) {
                      showError(title: 'Title', message: 'Please add title');
                    } else if (snapshot.selectedCategory == null) {
                      showError(
                        title: 'Category',
                        message: 'Please select Category',
                      );
                    } else if (snapshot.selectedSubCategory == null) {
                      showError(
                        title: 'Sub Category',
                        message: 'Please select Sub category',
                      );
                    } else if (snapshot.selectedExperience == null) {
                      showError(
                        title: 'Experience',
                        message: 'Please select Experience',
                      );
                    } else if (snapshot.priceFromController.text
                        .trim()
                        .isEmpty) {
                      showError(
                        title: 'From Price',
                        message: 'Please add From Price',
                      );
                    }
                    else if (double.parse(fromPrice)<=0) {
                      showError(
                        title: 'From Price',
                        message: 'From price cannot be 0',
                      );
                    }

                    else if (snapshot.priceToController.text.trim().isEmpty) {
                      showError(
                        title: 'To Price',
                        message: 'Please add To Price',
                      );
                    }
                    else if (double.parse(toPrice)<=0) {
                      showError(
                        title: 'To Price',
                        message: 'To price cannot be 0',
                      );
                    }
                    else if (double.parse(fromPrice)>double.parse(toPrice)) {
                      showError(
                        title: 'From Price',
                        message: 'From price cannot be more than To Price',
                      );
                    }

                    else if (snapshot.selectedDelivery == null) {
                      showError(
                        title: 'Delivery',
                        message: 'Please select Delivery',
                      );
                    } else if (snapshot.priceToController.text.trim().isEmpty) {
                      showError(title: 'Budget', message: 'Please add budget');
                    }
                    else if (double.parse(budget)<=0) {
                      showError(
                        title: 'Budget',
                        message: 'Budget cannot be 0',
                      );
                    }

                    else if (snapshot.countryController.text.trim().isEmpty) {
                      showError(
                        title: 'Country',
                        message: 'Please add country',
                      );
                    } else if (snapshot.stateController.text.trim().isEmpty) {
                      showError(title: 'State', message: 'Please add state');
                    } else if (selectedTags.trim().isEmpty) {
                      showError(
                        title: 'Skills & Expertise',
                        message: 'Please choose Skills & Expertise',
                      );
                    } else if (snapshot.descriptionController.text
                        .trim()
                        .isEmpty) {
                      showError(
                        title: 'Description',
                        message: 'Please add description',
                      );
                    } else {

                      final result = await showCupertinoConfirmDialog(
                        context: context,
                        title: 'Post Job',
                        description:
                            'Are you ready to post your job requirements?',
                      );

                      if (result == true) {
                        if (snapshot.pickedImages.isNotEmpty) {
                          await snapshot.uploadImages();
                        } else {
                          await snapshot.postJobAPi();
                        }
                      } else if (result == false) {
                        // user pressed No
                      } else {
                        // dialog dismissed
                      }
                    }
                  },
                ),
                SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
    );
  }
}
