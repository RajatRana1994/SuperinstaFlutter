import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instajobs/models/subCategory_model.dart';
import 'package:instajobs/utils/app_colors.dart';
import 'package:instajobs/utils/app_images.dart';
import 'package:instajobs/utils/baseClass.dart';
import 'package:instajobs/views/vendor_details/vendor_details_page.dart';
import 'package:instajobs/widgets/currency_widget.dart';

import '../../controllers/home_tab_controller.dart';
import '../../utils/app_styles.dart';
import '../../widgets/form_input_with_hint_on_top.dart';

class PopularServiceDetailsPage extends StatefulWidget {
  final List<SubCategoryModelDataSubCategories?>? subCategoriesData;
  final int index;
  final String caategoryId;
  final String comeFrom;

  const PopularServiceDetailsPage({
    super.key,
    required this.subCategoriesData,
    required this.index,
    required this.comeFrom,
    required this.caategoryId,
  });

  @override
  State<PopularServiceDetailsPage> createState() =>
      _PopularServiceDetailsPageState();
}

class _PopularServiceDetailsPageState extends State<PopularServiceDetailsPage>
    with BaseClass {
  HomeTabController homeTabController = Get.put(HomeTabController());
  int selectedIndex = -1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedIndex = widget.index;

    final subCategoryId =
    (widget.comeFrom == 'all')
        ? '' // send empty for "All"
        : (widget.subCategoriesData?[selectedIndex]?.id ?? 0).toString();


    WidgetsBinding.instance.addPostFrameCallback((_) {
      homeTabController.loadInitial(widget.caategoryId, subCategoryId);
    });
 //   homeTabController.loadInitial(widget.caategoryId, subCategoryId);
    // homeTabController.getUsersPopularServices(
    //   widget.caategoryId,
    //   subCategoryId,
    //   '1',
    // );
    if (subCategoryId != '') {
      selectedIndex = selectedIndex + 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          widget.subCategoriesData?.elementAt(widget.index)?.name ?? '',
          style: AppStyles.fontInkika().copyWith(fontSize: 20),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 70,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,

                itemCount: (widget.subCategoriesData?.length ?? 0) + 1,
                itemBuilder: (BuildContext context, int index) {
                  final isAllTab = index == 0;
                  final displayName =
                  isAllTab
                      ? 'All'
                      : widget.subCategoriesData!
                      .elementAt(index - 1)
                      ?.name ??
                      '';
                  final categoryId =
                  isAllTab
                      ? ''
                      : widget.subCategoriesData!
                      .elementAt(index - 1)
                      ?.id
                      .toString() ??
                      '';

                  return GestureDetector(
                    onTap: () {
                      selectedIndex = index;
                      setState(() {});
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        homeTabController.loadInitial(widget.caategoryId, categoryId);
                      });

                      // homeTabController.getUsersPopularServices(
                      //   widget.caategoryId,
                      //   categoryId,
                      //   '1',
                      // );
                    },
                    child: Center(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        margin: EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color:
                          selectedIndex == index
                              ? AppColors.primaryColor
                              : Colors.orange.shade300,
                        ),
                        height: 50,
                        child: Center(
                          child: Text(
                            displayName,
                            style: AppStyles.font500_16().copyWith(
                              color:
                              selectedIndex == index
                                  ? Colors.white
                                  : Colors.black,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: 10),
            GetBuilder<HomeTabController>(
              init: homeTabController,
              builder: (snapshot) {
                return homeTabController.popularServiceDetailsModel == null
                    ? Center(
                  child: Container(
                    margin: EdgeInsets.only(top: 100),
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.primaryColor,
                      ),
                    ),
                  ),
                )
                    : Expanded(
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (ScrollNotification scrollInfo) {
                      if (!homeTabController.isLoadingMore &&
                          homeTabController.hasMoreData &&
                          scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
                        // Reached bottom
                        homeTabController.loadMore(
                          widget.caategoryId,
                          selectedIndex == 0
                              ? ''
                              : widget.subCategoriesData
                              ?.elementAt(selectedIndex - 1)
                              ?.id
                              .toString() ??
                              '',
                        );
                      }
                      return false;
                    },
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount:
                      snapshot.popularServiceDetailsModel?.length ?? 0,
                      shrinkWrap: true,

                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            pushToNextScreen(
                              context: context,
                              destination: VendorDetailsPage(
                                snapshot.popularServiceDetailsModel
                                    ?.elementAt(index)
                                    ?.users
                                    ?.id
                                    .toString() ??
                                    '',
                              ),
                            );
                          },
                          child: Container(
                            //height: 170,
                            margin: EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Color(0xffEBEBEB),
                                width: 2,
                              ),
                            ),

                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(16),
                                        bottomLeft: Radius.circular(16),
                                      ),
                                      child: Container(
                                        height: 150,
                                        decoration: BoxDecoration(
                                          //color: Colors.green.shade500,
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(16),
                                            bottomLeft: Radius.circular(16),
                                          ),
                                        ),
                                        width: 120,
                                        child: Image.network(
                                          snapshot.popularServiceDetailsModel
                                              ?.elementAt(index)
                                              ?.users
                                              ?.profile ??
                                              '',
                                          width: 120,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) {
                                            return Image.asset(
                                              AppImages.icon, // your local dummy asset
                                              width: 120,
                                              fit: BoxFit.cover,
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      left: 8,
                                      bottom: 8,
                                      child: Container(
                                        height: 20,
                                        width: 20,
                                        decoration: BoxDecoration(
                                          color: AppColors.orange,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                          child: Icon(
                                            Icons.check,
                                            color: AppColors.white,
                                            size: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 8,
                                      left: 8,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(
                                            0.7,
                                          ),
                                          shape: BoxShape.circle,
                                        ),
                                        child: SizedBox(
                                          width: 30,
                                          height: 30,
                                          child: IconButton(
                                            icon: Icon(
                                              ((snapshot.popularServiceDetailsModel
                                                  ?.elementAt(
                                                index,
                                              )
                                                  ?.users
                                                  ?.favVendor ??
                                                  0) ==
                                                  0)
                                                  ? Icons.favorite_border
                                                  : Icons.favorite,
                                              color: Colors.red,
                                              size: 18, // icon visual size
                                            ),
                                            onPressed: () {
                                              var verdorId =
                                                  snapshot
                                                      .popularServiceDetailsModel
                                                      ?.elementAt(index)
                                                      ?.users
                                                      ?.id ??
                                                      0;

                                              homeTabController
                                                  .addRemoveFacVendor(
                                                verdorId.toString(),
                                                index,
                                              );
                                              // profileController.removeVenderToFav(snapshot.favFreelancers
                                              //     ?.elementAt(index)
                                              //     ?.vendorId
                                              //     .toString() ??
                                              //     '', index);
                                            },
                                            padding:
                                            EdgeInsets
                                                .zero, // remove default padding
                                            constraints:
                                            BoxConstraints(), // remove default size constraints
                                            splashRadius:
                                            16, // splash radius for tap feedback
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        snapshot.popularServiceDetailsModel
                                            ?.elementAt(index)
                                            ?.users
                                            ?.name ??
                                            '',
                                        textAlign: TextAlign.start,
                                        maxLines: 1,
                                        style: AppStyles.font400_12()
                                            .copyWith(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      SizedBox(height: 2),
                                      getItemWidget(
                                        icon: Icon(
                                          Icons.phone,
                                          color: AppColors.orange,
                                          size: 14,
                                        ),
                                        textColor: Colors.blue,
                                        title:
                                        snapshot
                                            .popularServiceDetailsModel
                                            ?.elementAt(index)
                                            ?.users
                                            ?.phone ??
                                            '',
                                      ),
                                      SizedBox(height: 2),
                                      getItemWidget(
                                        icon: Icon(
                                          Icons.add_location_alt_sharp,
                                          color: AppColors.orange,
                                          size: 14,
                                        ),
                                        title:
                                        '${snapshot.popularServiceDetailsModel?.elementAt(index)?.users?.country ?? ''},${snapshot.popularServiceDetailsModel?.elementAt(index)?.users?.city ?? ''}${snapshot.popularServiceDetailsModel?.elementAt(index)?.users?.state ?? ''}',
                                      ),
                                      SizedBox(height: 2),
                                      getItemWidget(
                                        icon: Icon(
                                          Icons.star,
                                          color: AppColors.orange,
                                          size: 14,
                                        ),
                                        title:
                                        snapshot
                                            .popularServiceDetailsModel
                                            ?.elementAt(index)
                                            ?.users
                                            ?.overallRating ??
                                            '',
                                      ),
                                      SizedBox(height: 2),
                                      Row(
                                        children: [
                                          GetCurrencyWidget(),
                                          SizedBox(width: 2),
                                          getItemWidget(
                                            icon: Text(
                                              'Hourly Price:',
                                              style: AppStyles.font600_12()
                                                  .copyWith(
                                                color: Colors.black,
                                              ),
                                            ),
                                            title:
                                            snapshot
                                                .popularServiceDetailsModel
                                                ?.elementAt(index)
                                                ?.users
                                                ?.hourlyPrice
                                                .toString() ??
                                                '',
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 2),
                                      Row(
                                        children: [
                                          GetCurrencyWidget(),
                                          SizedBox(width: 2),
                                          getItemWidget(
                                            icon: Text(
                                              'Daily Price:',
                                              style: AppStyles.font600_12()
                                                  .copyWith(
                                                color: Colors.black,
                                              ),
                                            ),
                                            title:
                                            snapshot
                                                .popularServiceDetailsModel
                                                ?.elementAt(index)
                                                ?.users
                                                ?.dailyPrice
                                                .toString() ??
                                                '',
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 2),
                                      Row(
                                        children: [
                                          GetCurrencyWidget(),
                                          SizedBox(width: 2),
                                          getItemWidget(
                                            icon: Text(
                                              'Offers From:',
                                              style: AppStyles.font600_12()
                                                  .copyWith(
                                                color: Colors.black,
                                              ),
                                            ),
                                            title:
                                            snapshot
                                                .popularServiceDetailsModel
                                                ?.elementAt(index)
                                                ?.users
                                                ?.totalJobs
                                                .toString() ??
                                                '',
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );

              },
            ),
          ],
        ),
      ),
    );
  }

  Widget getItemWidget({
    required Widget icon,
    required String title,
    Color textColor = Colors.black,
  }) {
    final display = (title.length > 30) ? '${title.substring(0, 30)}…' : title;
    return Row(
      children: [
        icon,
        SizedBox(width: 4),
        Text(
          display,
          softWrap: false, // ⬅️ no wrapping
          overflow: TextOverflow.ellipsis, // ⬅️ show “…”
          maxLines: 1, // ⬅️ limit to one line

          style: AppStyles.font600_12().copyWith(color: textColor),
        ),
      ],
    );
  }
}


/*

 */
