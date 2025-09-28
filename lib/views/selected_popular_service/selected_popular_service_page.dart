import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instajobs/controllers/home_tab_controller.dart';
import 'package:instajobs/models/customer_home_model/customer_home_model.dart';
import 'package:instajobs/utils/baseClass.dart';
import 'package:instajobs/views/popular_service_details/popular_service_details_page.dart';
import 'package:instajobs/widgets/form_input_with_hint_on_top.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_styles.dart';

class SelectedPopularServicePage extends StatefulWidget {
  final CustomerHomeModelDataCategories? selectedCategory;

  const SelectedPopularServicePage(this.selectedCategory, {super.key});

  @override
  State<SelectedPopularServicePage> createState() =>
      _SelectedPopularServicePageState();
}

class _SelectedPopularServicePageState extends State<SelectedPopularServicePage>
    with BaseClass {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    homeTabController.applyFilter();
    homeTabController.getSelectedPopularServiceItem(
      categoryId: widget.selectedCategory?.id.toString() ?? '',
    );
  }

  HomeTabController homeTabController = Get.put(HomeTabController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(widget.selectedCategory?.name ?? '', style:  AppStyles.fontInkika().copyWith(fontSize: 20),),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
        child: Column(
          children: [
            FormInputWithHint(label: '',
              hintText: 'Search by name',
              showLabel: false,
              controller: homeTabController.searchController,),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 16),
                    GestureDetector(
                      onTap: () {
                        pushToNextScreen(
                          context: context,
                          destination: PopularServiceDetailsPage(
                            subCategoriesData:
                            homeTabController.subCategoriesData,
                            index: 0,
                            comeFrom: 'all',
                            caategoryId: widget.selectedCategory?.id.toString() ?? '',
                          ),
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Color(0xffEBEBEB), width: 2),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Center(child: Text('All')),
                      ),
                    ),

                    SizedBox(height: 10),
                    GetBuilder<HomeTabController>(
                      init: homeTabController,
                      builder: (snapshot) {
                        return homeTabController.subCategoriesData == null
                            ? Container(
                          margin: EdgeInsets.only(top: 100),
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.primaryColor,
                            ),
                          ),
                        )
                            : ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          itemCount:
                          snapshot.subCategoriesData?.length ?? 0,
                          shrinkWrap: true,

                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                print(index);
                                pushToNextScreen(
                                  context: context,
                                  destination: PopularServiceDetailsPage(
                                    subCategoriesData:
                                    homeTabController.subCategoriesData,
                                    index: index,
                                    comeFrom: 'subcategory',
                                    caategoryId: widget.selectedCategory?.id.toString() ?? '',

                                  ),
                                );
                              },
                              child: Container(
                                margin: EdgeInsets.only(bottom: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: Color(0xffEBEBEB),
                                    width: 2,
                                  ),
                                ),
                                padding: EdgeInsets.symmetric(
                                  vertical: 16,
                                  horizontal: 20,
                                ),
                                child: Row(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                  MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      alignment: Alignment.center,
                                      height: 36,
                                      width: 36,
                                      child: Image(
                                        image: NetworkImage(
                                          snapshot.subCategoriesData
                                              ?.elementAt(index)
                                              ?.image
                                              ?.isEmpty ??
                                              false
                                              ? widget
                                              .selectedCategory!
                                              .image!
                                              : snapshot.subCategoriesData!
                                              .elementAt(index)!
                                              .image!,
                                        ),
                                        height: 36,
                                        width: 36,
                                      ),
                                    ),
                                    SizedBox(width: 16),
                                    Expanded(
                                      child: Text(
                                        snapshot.subCategoriesData
                                            ?.elementAt(index)
                                            ?.name ??
                                            '',
                                        textAlign: TextAlign.start,
                                        maxLines: 2,
                                        style: AppStyles.font400_12()
                                            .copyWith(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      '${snapshot.subCategoriesData?.elementAt(index)?.totalUsers.toString() ?? ''} Users',
                                      textAlign: TextAlign.end,
                                      maxLines: 2,
                                      style: AppStyles.font700_12()
                                          .copyWith(
                                        color: AppColors.primaryColor,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
