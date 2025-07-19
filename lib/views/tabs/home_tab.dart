import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instajobs/storage_services/local_stoage_service.dart';
import 'package:instajobs/utils/baseClass.dart';
import 'package:instajobs/views/post_customer_job/post_customer_job_page.dart';
import 'package:instajobs/views/selected_popular_service/selected_popular_service_page.dart';
import 'package:instajobs/views/tabs/widgets/last_viewed_vendors.dart';
import 'package:instajobs/views/tabs/widgets/top_freelancer_widget.dart';
import 'package:instajobs/views/vendor_details/vendor_details_page.dart';
import 'package:instajobs/widgets/rounded_edged_button.dart';

import '../../controllers/home_tab_controller.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_styles.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> with BaseClass {
  final HomeTabController homeTabController = Get.put(HomeTabController());

  @override
  void initState() {
    super.initState();
    // Wrap this in post-frame to ensure it's called AFTER build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      homeTabController.getHomeData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeTabController>(
      init: homeTabController,
      builder: (snapshot) {
        return snapshot.customerHomeModel == null
            ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppColors.primaryColor,
                ),
              ),
            )
            : SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                (StorageService().getUserData().isCustomer??false)?  RoundedEdgedButton(
                    buttonText: '+ Post a job',
                    height: 45,
                    topMargin: 0,
                    onButtonClick: () {
                      pushToNextScreen(context: context, destination: PostCustomerJobPage());
                    },
                    backgroundColor: Colors.white,
                    borderColor: Color(0xFFFF5200),
                    bottomMargin: 16,
                    textColor: Color(0xFFFF5200),
                  ):SizedBox(),

                  snapshot.customerHomeModel?.boostProfile?.isNotEmpty ?? false
                      ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Top Freelancers',
                            style: AppStyles.font700_18().copyWith(
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 15),
                          SizedBox(
                            height: 180,
                            child: ListView.builder(
                              itemCount:
                                  snapshot
                                      .customerHomeModel
                                      ?.boostProfile
                                      ?.length ??
                                  0,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (BuildContext context, int index) {
                                return TopFreelancerWidget(
                                  onTap: () {
                                    pushToNextScreen(
                                      context: context,
                                      destination: VendorDetailsPage(
                                        snapshot.customerHomeModel?.boostProfile
                                                ?.elementAt(index)
                                                ?.id
                                                .toString() ??
                                            '',
                                      ),
                                    );
                                  },
                                  name:
                                      snapshot.customerHomeModel?.boostProfile
                                          ?.elementAt(index)
                                          ?.name ??
                                      '',
                                  profilePic:
                                      snapshot.customerHomeModel?.boostProfile
                                          ?.elementAt(index)
                                          ?.profile ??
                                      '',
                                  price:
                                      snapshot.customerHomeModel?.boostProfile
                                          ?.elementAt(index)
                                          ?.hourlyPrice
                                          .toString() ??
                                      '',
                                  currency: 'N',
                                  rating:
                                      snapshot.customerHomeModel?.boostProfile
                                          ?.elementAt(index)
                                          ?.overallRating
                                          .toString() ??
                                      '',
                                  isFav:
                                      snapshot.customerHomeModel?.boostProfile
                                                  ?.elementAt(index)
                                                  ?.isFav ==
                                              1
                                          ? true
                                          : false,
                                );
                              },
                            ),
                          ),
                          SizedBox(height: 30),
                        ],
                      )
                      : SizedBox(),
                  snapshot.customerHomeModel?.categories?.isNotEmpty ?? false
                      ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Popular Services',
                            style: AppStyles.font700_18().copyWith(
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 15),
                          SizedBox(
                            height: 150,
                            child: ListView.builder(
                              itemCount:
                                  snapshot
                                      .customerHomeModel
                                      ?.categories
                                      ?.length ??
                                  0,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                  onTap: () async {
                                    pushToNextScreen(
                                      context: context,
                                      destination: SelectedPopularServicePage(
                                        snapshot.customerHomeModel?.categories
                                            ?.elementAt(index),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    height: 120,
                                    width: 120,
                                    margin: EdgeInsets.only(right: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Color(0xffEBEBEB),
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
                                              snapshot
                                                      .customerHomeModel
                                                      ?.categories
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
                                          snapshot.customerHomeModel?.categories
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
                          ),
                          SizedBox(height: 30),
                        ],
                      )
                      : SizedBox(),

                  snapshot.customerHomeModel?.viewVendors?.isNotEmpty ?? false
                      ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Last Viewed Vendors',
                            style: AppStyles.font700_18().copyWith(
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 15),
                          SizedBox(
                            height: 200,
                            child: ListView.builder(
                              itemCount:
                                  snapshot
                                      .customerHomeModel
                                      ?.viewVendors
                                      ?.length ??
                                  0,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (BuildContext context, int index) {
                                return LastViewedVendors(
                                  profile:
                                      snapshot.customerHomeModel?.viewVendors
                                          ?.elementAt(index)
                                          ?.users
                                          ?.profile ??
                                      '',
                                  name:
                                      snapshot.customerHomeModel?.viewVendors
                                          ?.elementAt(index)
                                          ?.users
                                          ?.name ??
                                      '',
                                  price:
                                      snapshot.customerHomeModel?.viewVendors
                                          ?.elementAt(index)
                                          ?.users
                                          ?.hourlyPrice
                                          .toString() ??
                                      '',
                                  rating:
                                      snapshot.customerHomeModel?.viewVendors
                                          ?.elementAt(index)
                                          ?.reviewsRating
                                          ?.overallRating ??
                                      '0.0',
                                  reviews:
                                      snapshot.customerHomeModel?.viewVendors
                                          ?.elementAt(index)
                                          ?.reviewsRating
                                          ?.reviewsCount
                                          .toString() ??
                                      '0',
                                );
                              },
                            ),
                          ),
                          SizedBox(height: 30),
                        ],
                      )
                      : SizedBox(),
                ],
              ),
            );
      },
    );
  }
}
