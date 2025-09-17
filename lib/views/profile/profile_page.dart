import 'package:flutter/material.dart';
import 'package:instajobs/controllers/profile_controller.dart';
import 'package:instajobs/storage_services/local_stoage_service.dart';
import 'package:instajobs/utils/app_colors.dart';
import 'package:instajobs/utils/app_images.dart';
import 'package:instajobs/utils/app_styles.dart';
import 'package:instajobs/utils/baseClass.dart';
import 'package:instajobs/views/feed_tab/feed_tab_page.dart';
import 'package:instajobs/views/feed_tab/my_feed_tab.dart';
import 'package:instajobs/views/message/inbox.dart';
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
    _profileController.getAppSetting();
    _profileController.getProfileDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.bgColor,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        title: Text('', style: AppStyles.fontInkika().copyWith(fontSize: 24)),
      ),
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
                SizedBox(height: 10),
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
                          fit: BoxFit.cover,
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
                        IconButton(
                          onPressed: () {
                            pushToNextScreen(
                              context: context,
                              destination: SettingsPage(),
                            );
                          },
                          icon: Image.asset(
                            AppImages.icSetting,
                            height: 24,
                            width: 24,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                Divider(),
                if ((StorageService().getUserData().isCustomer ?? true) ==
                    false)
                  ...[
                    Container(
                      margin: const EdgeInsets.all(0),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.orange.shade200,
                          width: 0.8,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Left side (icon + text)
                          Row(
                            children: [
                              // Circle placeholder
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.grey, width: 4),
                                ),
                              ),
                              const SizedBox(width: 12),

                              // Texts
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Boost Profile",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    ((_profileController
                                        .profileDetailsModel
                                        ?.userInfo
                                        ?.isBoosted ??
                                        0) == 0) ?  "0 Days left" : "${_profileController.profileDetailsModel?.userInfo?.remainBoostedTime?.daysDifference ?? 0} Days left",
                                    style: TextStyle(
                                      color: Colors.orange,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          // Right side button
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange.shade700,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () {
                              if ((_profileController
                                  .profileDetailsModel
                                  ?.userInfo
                                  ?.isBoosted ??
                                  0) == 1) {
                                showSuccess(title: 'Boost', message: 'Already Boosted');
                              } else {
                                _profileController.boostMyProfile();
                              }
                            },
                            icon: const Icon(
                              Icons.monetization_on,
                              color: Colors.white,
                              size: 18,
                            ),
                            label: Text(
                              "Boost ${_profileController.boostProfile?.value ?? ''}",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],


                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            (_profileController
                                .profileDetailsModel
                                ?.userInfo
                                ?.totalJobPosted ??
                                0)
                                .toString(),
                            textAlign: TextAlign.center,
                            style: AppStyles.font700_16().copyWith(
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            'Posted\nInstaJobs',
                            textAlign: TextAlign.center,
                            style: AppStyles.font400_14().copyWith(
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
                            (_profileController
                                .profileDetailsModel
                                ?.userInfo
                                ?.totalOfferPurchased ??
                                0)
                                .toString(),
                            textAlign: TextAlign.center,
                            style: AppStyles.font700_16().copyWith(
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            'Offers\nPurchased',
                            textAlign: TextAlign.center,
                            style: AppStyles.font400_14().copyWith(
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
                            (StorageService().getUserData().isCustomer ?? true)
                                ? (_profileController
                                .profileDetailsModel
                                ?.userInfo
                                ?.totalAmountSpend ??
                                0)
                                .toString()
                                : (_profileController
                                .profileDetailsModel
                                ?.userInfo
                                ?.totalAmountEarned ??
                                0)
                                .toString(),
                            textAlign: TextAlign.center,
                            style: AppStyles.font700_16().copyWith(
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            'Total\nSpendings',
                            textAlign: TextAlign.center,
                            style: AppStyles.font400_14().copyWith(
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
                          image: AppImages.icProfile,
                          title: 'My Profile',
                          onTap: () {
                            pushToNextScreen(
                              context: context,
                              destination: MyProfilePage(
                                profileDetailsModelData:
                                _profileController.profileDetailsModel,
                              ),
                            );
                          },
                        ),
                        ProfileWidget(
                          image: AppImages.my_offer,
                          title: 'Messages',
                          onTap: () {
                            pushToNextScreen(context: context, destination: Inbox());
                          },
                        ),
                        (StorageService().getUserData().isCustomer ?? true)
                            ? SizedBox()
                            : ProfileWidget(
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
                          image: AppImages.icInstajob,
                          title: 'My InstaJobs',
                          onTap: () {
                            pushToNextScreen(
                              context: context,
                              destination: MyInstaJobsPage(),
                            );
                          },
                        ),
                        ProfileWidget(
                          image: AppImages.portfolio,
                          title: 'My Bookings',
                          onTap: () {
                            pushToNextScreen(
                              context: context,
                              destination: MyBookingsPage(),
                            );
                          },
                        ),
                        (StorageService().getUserData().isCustomer ?? true)
                            ? SizedBox()
                            : ProfileWidget(
                          image: AppImages.portfolio,
                          title: 'My Portfolio',
                          onTap: () {
                            pushToNextScreen(
                              context: context,
                              destination: MyPortfolioPage(),
                            );
                          },
                        ),
                        (StorageService().getUserData().isCustomer ?? true)
                            ? SizedBox()
                            : ProfileWidget(
                          image: '',
                          title: 'My Feeds',
                          onTap: () {
                            pushToNextScreen(
                              context: context,
                              destination: MyFeedTab(),
                            );
                          },
                        ),
                        (StorageService().getUserData().isCustomer ?? true)
                            ? SizedBox()
                            : ProfileWidget(
                          image: AppImages.my_offer,
                          title: 'My Offers',
                          onTap: () {
                            pushToNextScreen(
                              context: context,
                              destination: MyOffersPage(),
                            );
                          },
                        ),
                        (StorageService().getUserData().isCustomer ?? true)
                            ? ProfileWidget(
                          image: AppImages.my_offer,
                          title: 'My Purchased Offers',
                          onTap: () {},
                        )
                            : ProfileWidget(
                          image: '',
                          title: 'My Sell/Purchased Offers',
                          onTap: () {},
                        ),
                        ProfileWidget(
                          image: AppImages.myFavorites,
                          title: 'Favourites',
                          onTap: () {
                            pushToNextScreen(
                              context: context,
                              destination: MyFavPage(),
                            );
                          },
                        ),
                        ProfileWidget(
                          image: AppImages.wallet,
                          title: 'Wallet',
                          onTap: () {
                            pushToNextScreen(
                              context: context,
                              destination: MyWalletPage(),
                            );
                          },
                        ),
                        ProfileWidget(
                          image: AppImages.black_listed,
                          title: 'Blacklisted Clients',
                          onTap: () {},
                        ),
                        ProfileWidget(
                          image: AppImages.icSetting,
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
        },
      ),
    );
  }
}
