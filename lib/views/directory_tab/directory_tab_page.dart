import 'package:flutter/material.dart';
import 'package:instajobs/controllers/directory_controller.dart';
import 'package:instajobs/utils/baseClass.dart';
import 'package:instajobs/widgets/form_input_with_hint_on_top.dart';
import 'package:get/get.dart';
import '../../models/customer_home_model/customer_home_model.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_styles.dart';
import '../selected_popular_service/selected_popular_service_page.dart';

class DirectoryTabPage extends StatefulWidget {
  const DirectoryTabPage({super.key});

  @override
  State<DirectoryTabPage> createState() => _DirectoryTabPageState();
}

class _DirectoryTabPageState extends State<DirectoryTabPage> with BaseClass {
  final DirectoryTabController directoryTabController = Get.put(
    DirectoryTabController(),
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    directoryTabController.getCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.greyBackground,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            FormInputWithHint(
              label: '',
              hintText: 'Search by name',
              showLabel: false,
            ),
            SizedBox(height: 20),
            GetBuilder<DirectoryTabController>(
              init: directoryTabController,

              builder: (snapshot) {
                return directoryTabController.categoriesData == null
                    ? Expanded(
                      child: Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.primaryColor,
                          ),
                        ),
                      ),
                    )
                    : GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: snapshot.categoriesData?.length ?? 0,
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // 2 columns
                        crossAxisSpacing: 10,
                        childAspectRatio: 1,
                        mainAxisSpacing: 10,
                      ),
                      padding: EdgeInsets.all(0),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () async {
                            CustomerHomeModelDataCategories
                            categoryHomeModel = CustomerHomeModelDataCategories(
                              id: snapshot.categoriesData?.elementAt(index)?.id,
                              name:
                                  snapshot.categoriesData
                                      ?.elementAt(index)
                                      ?.name,
                              image:
                                  snapshot.categoriesData
                                      ?.elementAt(index)
                                      ?.image,
                            );
                            pushToNextScreen(
                              context: context,
                              destination: SelectedPopularServicePage(
                                categoryHomeModel,
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.white),
                              color: Colors.white,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  height: 80,
                                  width: 80,
                                  child: Image(
                                    image: NetworkImage(
                                      snapshot.categoriesData
                                              ?.elementAt(index)
                                              ?.image ??
                                          '',
                                    ),
                                    height: 50,
                                    width: 50,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  snapshot.categoriesData
                                          ?.elementAt(index)
                                          ?.name ??
                                      '',
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  style: AppStyles.font400_12().copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        '${snapshot.categoriesData?.elementAt(index)?.totalUsers.toString() ?? 0} Users',
                                        textAlign: TextAlign.center,
                                        maxLines: 1,
                                        style: AppStyles.font400_12().copyWith(
                                          color: Colors.deepOrangeAccent,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        '${snapshot.categoriesData?.elementAt(index)?.totalSubCategories.toString() ?? 0} Sub Dir...',
                                        textAlign: TextAlign.center,
                                        maxLines: 1,
                                        style: AppStyles.font400_12().copyWith(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ],
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
    );
  }
}
