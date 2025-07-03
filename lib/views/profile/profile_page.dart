import 'package:flutter/material.dart';
import 'package:instajobs/controllers/profile_controller.dart';
import 'package:instajobs/storage_services/local_stoage_service.dart';
import 'package:instajobs/utils/app_colors.dart';
import 'package:instajobs/utils/app_images.dart';
import 'package:instajobs/utils/app_styles.dart';
import 'package:instajobs/utils/baseClass.dart';
import 'package:instajobs/views/my_bookings/my_bookings_page.dart';
import 'package:instajobs/views/my_fav/my_fav_page.dart';
import 'package:instajobs/views/my_insta_jobs/my_insta_jobs_page.dart';
import 'package:instajobs/views/my_offers/my_offers_page.dart';
import 'package:instajobs/views/my_portfolio.dart';
import 'package:instajobs/views/my_profile/my_profile_page.dart';
import 'package:instajobs/views/notification_page.dart';
import 'package:instajobs/views/profile/widgets/profile_widget.dart';
import 'package:instajobs/views/settings/settings_page.dart';
import 'package:instajobs/views/welcome_page.dart';
import 'package:get/get.dart';
import 'package:instajobs/views/working_timings/working_timings_page.dart';
import '../my_wallet/my_wallet_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with BaseClass {
  final ProfileController _profileController = Get.put(ProfileController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _profileController.getProfileDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: GetBuilder<ProfileController>(
        init: _profileController,
        builder: (snapshot) {
          if (_profileController.profileDetailsModel == null) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppColors.primaryColor,
                ),
              ),
            );
          }
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                SizedBox(height: 50),
                Row(
                  children: [
                    Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black,
                      ),
                      child:
                          (_profileController
                                          .profileDetailsModel
                                          ?.userInfo
                                          ?.profile ==
                                      null ||
                                  (_profileController
                                          .profileDetailsModel
                                          ?.userInfo
                                          ?.profile
                                          ?.isEmpty ??
                                      true))
                              ? Container(
                                height: 80,
                                width: 80,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.black,
                                ),
                              )
                              : ClipRRect(
                                borderRadius: BorderRadius.circular(40),
                                child: Image(
                                  height: 80,
                                  width: 80,
                                  image: NetworkImage(
                                    _profileController
                                            .profileDetailsModel
                                            ?.userInfo
                                            ?.profile ??
                                        '',
                                  ),
                                ),
                              ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _profileController
                                    .profileDetailsModel
                                    ?.userInfo
                                    ?.name ??
                                '',
                            style: AppStyles.font700_16().copyWith(
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            _profileController
                                    .profileDetailsModel
                                    ?.userInfo
                                    ?.email ??
                                '',
                            style: AppStyles.font500_16().copyWith(
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        IconButton(
                          onPressed: () {
                            pushToNextScreen(
                              context: context,
                              destination: NotificationPage(),
                            );
                          },
                          icon: Icon(Icons.notifications),
                        ),

                        Icon(Icons.info, color: Colors.amber),
                      ],
                    ),
                  ],
                ),

                Divider(),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            '0',
                            textAlign: TextAlign.center,
                            style: AppStyles.font700_16().copyWith(
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            'Completed\nInstaJobs',
                            textAlign: TextAlign.center,
                            style: AppStyles.font400_16().copyWith(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            '0',
                            textAlign: TextAlign.center,
                            style: AppStyles.font700_16().copyWith(
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            'Offers\nSell',
                            textAlign: TextAlign.center,
                            style: AppStyles.font400_16().copyWith(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            '0',
                            textAlign: TextAlign.center,
                            style: AppStyles.font700_16().copyWith(
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            'Total\nEarnings',
                            textAlign: TextAlign.center,
                            style: AppStyles.font400_16().copyWith(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Divider(),
                SizedBox(height: 12),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Column(
                      children: [
                        ProfileWidget(
                          image: '',
                          title: 'My Profile',
                          onTap: () {
                            pushToNextScreen(
                              context: context,
                              destination: MyProfilePage(profileDetailsModelData: _profileController.profileDetailsModel),
                            );
                          },
                        ),
                        ProfileWidget(image: '', title: 'Messages', onTap: () {}),
                      (StorageService().getUserData().isCustomer??true)?SizedBox():  ProfileWidget(
                          image: '',
                          title: 'My Working Timings',
                          onTap: () {
                            pushToNextScreen(
                              context: context,
                              destination: WorkingTimingsPage(),
                            );
                          },
                        ),
                        ProfileWidget(
                          image: '',
                          title: 'My InstaJobs',
                          onTap: () {
                            pushToNextScreen(
                              context: context,
                              destination: MyInstaJobsPage(),
                            );
                          },
                        ),
                        ProfileWidget(
                          image: '',
                          title: 'My Bookings',
                          onTap: () {
                            pushToNextScreen(
                              context: context,
                              destination: MyBookingsPage(),
                            );
                          },
                        ),
                        (StorageService().getUserData().isCustomer??true)?SizedBox(): ProfileWidget(
                          image: AppImages.portfolio,
                          title: 'My Portfolio',
                          onTap: () {
                            pushToNextScreen(
                              context: context,
                              destination: MyPortfolioPage(),
                            );
                          },
                        ),
                        (StorageService().getUserData().isCustomer??true)?SizedBox():  ProfileWidget(image: '', title: 'My Feeds', onTap: () {}),
                        (StorageService().getUserData().isCustomer??true)?SizedBox():  ProfileWidget(
                          image: AppImages.my_offer,
                          title: 'My Offers',
                          onTap: () {
                            pushToNextScreen(
                              context: context,
                              destination: MyOffersPage(),
                            );
                          },
                        ),
                        (StorageService().getUserData().isCustomer??true)?ProfileWidget(
                          image: '',
                          title: 'My Purchased Offers',
                          onTap: () {},
                        ):   ProfileWidget(
                          image: '',
                          title: 'My Sell/Purchased Offers',
                          onTap: () {},
                        ),
                        ProfileWidget(
                          image: AppImages.fav_clients,
                          title: 'My Favourites',
                          onTap: () {
                            pushToNextScreen(
                              context: context,
                              destination: MyFavPage(),
                            );
                          },
                        ),
                        ProfileWidget(
                          image: AppImages.wallet,
                          title: 'My Wallet',
                          onTap: () {
                            pushToNextScreen(
                              context: context,
                              destination: MyWalletPage(),
                            );
                          },
                        ),
                        ProfileWidget(
                          image: '',
                          title: 'My Blacklisted Clients',
                          onTap: () {},
                        ),
                        ProfileWidget(
                          image: '',
                          title: 'Settings',
                          onTap: () {
                            pushToNextScreen(
                              context: context,
                              destination: SettingsPage(),
                            );
                          },
                        ),
                        /*ProfileWidget(
                          image: '',
                          title: 'Logout',
                          onTap: () {
                            StorageService().clearData();
                            pushReplaceAndClearStack(
                              context: context,
                              destination: WelcomePage(),
                            );
                          },
                        ),*/
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      ),
    );
  }
}
