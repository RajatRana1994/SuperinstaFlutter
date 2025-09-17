import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instajobs/controllers/freelancer_sign_up.dart';
import 'package:instajobs/utils/app_colors.dart';
import 'package:instajobs/utils/app_images.dart';
import 'package:instajobs/utils/app_styles.dart';
import 'package:instajobs/utils/baseClass.dart';
import 'package:instajobs/views/create_account_step_2.dart';
import 'package:instajobs/widgets/form_input_with_hint_on_top.dart';
import 'package:instajobs/widgets/rounded_edged_button.dart';

import '../widgets/app_bar.dart';

class CreateAccountStepOne extends StatefulWidget {
  const CreateAccountStepOne({super.key});

  @override
  State<CreateAccountStepOne> createState() => _CreateAccountStepOneState();
}

class _CreateAccountStepOneState extends State<CreateAccountStepOne>
    with BaseClass {
  FreelancerSignUp freelancerSignUp = Get.put(FreelancerSignUp());
  List<String> list = [
    'Builders',
    'Art Work',
    'IT & Web',
    'Car Services',
    'Career',
    'Beauty & Spa',
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    freelancerSignUp.subCategoriesData = null;
    freelancerSignUp.selectedIndex = -1;

    freelancerSignUp.selectedSubCategories.clear();
    freelancerSignUp.getCategories();
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
          CustomAppBar(showStepOne: false, showStepTwo: false),
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: FormInputWithHint(
              label: '',
              hintText: 'Search by name',
              showLabel: false,
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 16),
                  GetBuilder<FreelancerSignUp>(
                    init: freelancerSignUp,
                    builder: (snapshot) {
                      return freelancerSignUp.categoriesData == null
                          ? Center(
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          child: const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.primaryColor,
                            ),
                          ),
                        ),
                      )
                          : Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: GridView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: snapshot.categoriesData?.length ?? 0,
                          shrinkWrap: true,
                          gridDelegate:
                          SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3, // 2 columns
                            crossAxisSpacing: 10,
                            childAspectRatio: 1,
                            mainAxisSpacing: 10,
                          ),
                          padding: EdgeInsets.all(0),
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () async {
                                try {
                                  snapshot.updateSelection(index);
                                  showCircularDialog(context);

                                  await snapshot.getSubCategories(
                                    categoryId:
                                    snapshot.categoriesData
                                        ?.elementAt(index)
                                        ?.id
                                        .toString() ??
                                        '',
                                  );
                                  snapshot.selectedSubCategories.clear();
                                  popToPreviousScreen(context: context);
                                } catch (e) {
                                  popToPreviousScreen(context: context);
                                  showError(
                                    title: '',
                                    message: e.toString(),
                                  );
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color:
                                    snapshot.categoriesData
                                        ?.elementAt(index)
                                        ?.isSelected ??
                                        false
                                        ? Colors.orange
                                        : Color(0xffEBEBEB),
                                  ),
                                  color: Colors.white,
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      alignment: Alignment.center,
                                      height: 50,
                                      width: 50,
                                      child: Image(
                                        image: NetworkImage(
                                          snapshot.categoriesData
                                              ?.elementAt(index)
                                              ?.image ??
                                              '',
                                        ),
                                        height: 80,
                                        width: 80,
                                      ),
                                    ),
                                    SizedBox(height: 16),
                                    Text(
                                      snapshot.categoriesData
                                          ?.elementAt(index)
                                          ?.name ??
                                          '',
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      style: AppStyles.font400_12()
                                          .copyWith(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),

                  GetBuilder<FreelancerSignUp>(
                    init: freelancerSignUp,
                    builder: (snapshot) {
                      return freelancerSignUp.subCategoriesData == null
                          ? SizedBox()
                          : Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                          child: Text(
                            'Sub Categories',
                            textAlign: TextAlign.start,
                            style: AppStyles.font600_18().copyWith(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  GetBuilder<FreelancerSignUp>(
                    init: freelancerSignUp,
                    builder: (snapshot) {
                      return freelancerSignUp.subCategoriesData == null
                          ? SizedBox()
                          : Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: GridView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          itemCount:
                          snapshot.subCategoriesData?.length ?? 0,
                          shrinkWrap: true,
                          gridDelegate:
                          SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3, // 2 columns
                            crossAxisSpacing: 10,
                            childAspectRatio: 1,
                            mainAxisSpacing: 10,
                          ),
                          padding: EdgeInsets.all(0),
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                snapshot.updateSubCategorySelection(
                                  id:
                                  snapshot.subCategoriesData
                                      ?.elementAt(index)
                                      ?.id,
                                  index: index,
                                );
                                /* pushToNextScreen(
                                      context: context,
                                      destination: CreateAccountStep2(),
                                    );*/
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color:
                                    snapshot.subCategoriesData
                                        ?.elementAt(index)
                                        ?.isSelected ??
                                        false
                                        ? Colors.orange
                                        : Color(0xffEBEBEB),
                                  ),
                                  color: Colors.white,
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      alignment: Alignment.center,
                                      height: 50,
                                      width: 50,
                                      child: Image(
                                        image: NetworkImage(
                                          snapshot.subCategoriesData
                                              ?.elementAt(index)
                                              ?.image
                                              ?.isEmpty ??
                                              false
                                              ? snapshot.categoriesData!
                                              .elementAt(
                                            snapshot.selectedIndex,
                                          )!
                                              .image!
                                              : snapshot.subCategoriesData!
                                              .elementAt(index)!
                                              .image!,
                                        ),
                                        height: 80,
                                        width: 80,
                                      ),
                                    ),
                                    SizedBox(height: 16),
                                    Text(
                                      snapshot.subCategoriesData
                                          ?.elementAt(index)
                                          ?.name ??
                                          '',
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      style: AppStyles.font400_12()
                                          .copyWith(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),

                  RoundedEdgedButton(
                    buttonText: 'Next',
                    leftMargin: 16,
                    rightMargin: 16,
                    bottomMargin: 16,
                    topMargin: 20,
                    onButtonClick: () {
                      if (freelancerSignUp.selectedIndex == -1) {
                        showError(
                          title: 'Category',
                          message: 'Please select category',
                        );
                      } else if (freelancerSignUp
                          .selectedSubCategories
                          .isEmpty) {
                        showError(
                          title: 'Sub Category',
                          message: 'Please select sub-category',
                        );
                      } else {
                        pushToNextScreen(
                          context: context,
                          destination: CreateAccountStep2(),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
