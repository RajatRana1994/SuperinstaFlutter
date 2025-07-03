import 'package:flutter/material.dart';
import 'package:instajobs/controllers/home_tab_controller.dart';
import 'package:instajobs/models/customer_home_model/customer_home_model.dart';
import 'package:get/get.dart';
import 'package:instajobs/utils/app_styles.dart';
import 'package:instajobs/utils/baseClass.dart';
import 'package:instajobs/views/create_appointment/create_appointment_date_time_page.dart';

import '../../utils/app_colors.dart';

class VendorDetailsPage extends StatefulWidget {
  final String vendorId;

  //final CustomerHomeModelDataBoostProfile? vendorDetailsItem;

  const VendorDetailsPage(
    this.vendorId /*this.vendorDetailsItem*/, {
    super.key,
  });

  @override
  State<VendorDetailsPage> createState() => _VendorDetailsPageState();
}

class _VendorDetailsPageState extends State<VendorDetailsPage> with BaseClass {
  HomeTabController homeTabController = Get.put(HomeTabController());
  bool isAbout = true;
  bool isPortfolio = false;
  bool isOffers = false;
  bool isFeed = false;
  bool isReviews = false;

  resetSelection(int index) {
    if (index == 0) {
      isAbout = true;
      isPortfolio = false;
      isOffers = false;
      isReviews = false;
      isFeed = false;
    } else if (index == 1) {
      isAbout = false;
      isPortfolio = true;
      isOffers = false;
      isReviews = false;
      isFeed = false;
    } else if (index == 2) {
      isAbout = false;
      isPortfolio = false;
      isOffers = true;
      isReviews = false;
      isFeed = false;
    } else if (index == 3) {
      isAbout = false;
      isPortfolio = false;
      isOffers = false;
      isReviews = false;
      isFeed = true;
    } else if (index == 4) {
      isAbout = false;
      isPortfolio = false;
      isOffers = false;
      isReviews = true;
      isFeed = false;
    }
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() async {
    try {
      await Future.wait([
        homeTabController.getVendorDetails(vendorId: widget.vendorId),
        homeTabController.getVendorPortfolio(vendorId: widget.vendorId),
        homeTabController.getVendorOffers(vendorId: widget.vendorId),
        homeTabController.getVendorFeed(vendorId: widget.vendorId),
      ]);
    } catch (e) {
      showError(title: 'Details', message: e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: GetBuilder<HomeTabController>(
        init: homeTabController,
        builder: (snapshot) {
          return snapshot.vendorDetailsModel == null
              ? Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.primaryColor,
                  ),
                ),
              )
              : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 350,
                      child: Stack(
                        children: [
                          ((snapshot.portfolioModelData != null) &&
                                  (snapshot
                                          .portfolioModelData
                                          ?.data
                                          ?.isNotEmpty ??
                                      false))
                              ? Image(
                                image: NetworkImage(
                                  snapshot.portfolioModelData?.data
                                          ?.elementAt(0)
                                          ?.image ??
                                      '',
                                ),
                                height: 300,

                                width: double.infinity,
                                fit: BoxFit.cover,
                              )
                              : Container(
                                color: Colors.green,
                                height: 300,
                                width: double.infinity,
                              ),

                          Positioned(
                            left: 8,
                            top: 30,
                            child: IconButton(
                              onPressed: () {
                                popToPreviousScreen(context: context);
                              },
                              icon: Icon(
                                Icons.arrow_back_ios_new_sharp,
                                color: Colors.deepOrange,
                              ),
                            ),
                          ),
                          Positioned(
                            left: 20,
                            bottom: 0,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(60),
                              child:
                                  ((snapshot
                                                  .vendorDetailsModel
                                                  ?.userInfo
                                                  ?.profile ==
                                              null) ||
                                          (snapshot
                                                  .vendorDetailsModel
                                                  ?.userInfo
                                                  ?.profile
                                                  ?.isEmpty ??
                                              true))
                                      ? Container(
                                        height: 100,

                                        width: 100,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                          child: Icon(Icons.person, size: 30),
                                        ),
                                      )
                                      : Image(
                                        image: NetworkImage(
                                          snapshot
                                                  .vendorDetailsModel
                                                  ?.userInfo
                                                  ?.profile ??
                                              '',
                                        ),
                                        height: 100,
                                        width: 100,
                                        fit: BoxFit.cover,
                                      ),
                            ),
                          ),
                          Positioned(
                            bottom: 15,
                            left: 140,
                            right: 20,

                            child: Row(
                              children: [
                                Text(
                                  (snapshot
                                                  .vendorDetailsModel
                                                  ?.userInfo
                                                  ?.category !=
                                              null &&
                                          (snapshot
                                                  .vendorDetailsModel
                                                  ?.userInfo
                                                  ?.category
                                                  ?.isNotEmpty ??
                                              false))
                                      ? snapshot
                                              .vendorDetailsModel
                                              ?.userInfo
                                              ?.category
                                              ?.elementAt(0)
                                              ?.categoryName ??
                                          ''
                                      : '',
                                ),
                                Spacer(),
                                Row(
                                  children: [
                                    Icon(Icons.star, color: Colors.amber),
                                    Text(
                                      snapshot
                                              .vendorDetailsModel
                                              ?.userInfo
                                              ?.rating
                                              ?.overallRating
                                              .toString() ??
                                          '0',
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            snapshot.vendorDetailsModel?.userInfo?.name ?? '',
                            style: AppStyles.font700_16(),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '${snapshot.vendorDetailsModel?.userInfo?.city ?? ''} ${snapshot.vendorDetailsModel?.userInfo?.city ?? ''} ${snapshot.vendorDetailsModel?.userInfo?.city ?? ''}',
                            style: AppStyles.font400_14().copyWith(
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 4),
                          Row(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Hourly Price',
                                    style: AppStyles.font700_14().copyWith(
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(width: 4),
                                  Row(
                                    children: [
                                      const CircleAvatar(
                                        radius: 8,
                                        backgroundColor: Colors.orange,
                                        child: Text(
                                          '₦',
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        snapshot
                                                .vendorDetailsModel
                                                ?.userInfo
                                                ?.hourlyPrice
                                                .toString() ??
                                            'NA',
                                        style: AppStyles.font700_14().copyWith(
                                          color: AppColors.primaryColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Spacer(),
                              Row(
                                children: [
                                  Text(
                                    'Daily Price',
                                    style: AppStyles.font700_14().copyWith(
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(width: 4),
                                  Row(
                                    children: [
                                      const CircleAvatar(
                                        radius: 8,
                                        backgroundColor: Colors.orange,
                                        child: Text(
                                          '₦',
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        snapshot
                                                .vendorDetailsModel
                                                ?.userInfo
                                                ?.dailyPrice
                                                .toString() ??
                                            'NA',
                                        style: AppStyles.font700_14().copyWith(
                                          color: AppColors.primaryColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          Row(
                            children: [
                              Text(
                                '${snapshot.vendorDetailsModel?.userInfo?.totalJobComplete.toString() ?? '0'}%\nJob Success',
                                textAlign: TextAlign.start,
                                style: AppStyles.font600_12().copyWith(
                                  color: AppColors.black,
                                ),
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: Container(
                                  height: 15,

                                  decoration: BoxDecoration(
                                    color: Colors.green.shade100,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    resetSelection(0);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 8,
                                      horizontal: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color:
                                          isAbout
                                              ? AppColors.primaryColor
                                              : Colors.orange.shade200,
                                    ),
                                    child: Center(
                                      child: Text(
                                        'About',
                                        style: AppStyles.font700_10().copyWith(
                                          color:
                                              isAbout
                                                  ? AppColors.white
                                                  : AppColors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 3),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    resetSelection(1);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 8,
                                      horizontal: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color:
                                          isPortfolio
                                              ? AppColors.primaryColor
                                              : Colors.orange.shade200,
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Portfolio',
                                        style: AppStyles.font700_10().copyWith(
                                          color:
                                              isPortfolio
                                                  ? AppColors.white
                                                  : AppColors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 3),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    resetSelection(2);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 8,
                                      horizontal: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color:
                                          isOffers
                                              ? AppColors.primaryColor
                                              : Colors.orange.shade200,
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Offers',
                                        style: AppStyles.font700_10().copyWith(
                                          color:
                                              isOffers
                                                  ? AppColors.white
                                                  : AppColors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 3),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    resetSelection(3);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 8,
                                      horizontal: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color:
                                          isFeed
                                              ? AppColors.primaryColor
                                              : Colors.orange.shade200,
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Feed',
                                        style: AppStyles.font700_10().copyWith(
                                          color:
                                              isFeed
                                                  ? AppColors.white
                                                  : AppColors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 3),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    resetSelection(4);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 8,
                                      horizontal: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color:
                                          isReviews
                                              ? AppColors.primaryColor
                                              : Colors.orange.shade200,
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Reviews',
                                        style: AppStyles.font700_10().copyWith(
                                          color:
                                              isReviews
                                                  ? AppColors.white
                                                  : AppColors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          isAbout
                              ? aboutWidget()
                              : isPortfolio
                              ? getPortfolio()
                              : isOffers
                              ? getOffers()
                              : SizedBox(),
                        ],
                      ),
                    ),
                  ],
                ),
              );
        },
      ),
    );
  }

  Widget aboutWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                '${homeTabController.vendorDetailsModel?.userInfo?.totalJobComplete.toString() ?? ''}\nCompleted Jobs',
                textAlign: TextAlign.center,
                style: AppStyles.font700_14().copyWith(color: Colors.black),
              ),
            ),
            Expanded(
              child: Text(
                '${homeTabController.vendorDetailsModel?.userInfo?.totalOfferSale.toString() ?? ''}\nOffer Sell',
                textAlign: TextAlign.center,
                style: AppStyles.font700_14().copyWith(color: Colors.black),
              ),
            ),
            Expanded(
              child: Text(
                '${homeTabController.vendorDetailsModel?.userInfo?.totalAmountEarned.toString() ?? ''}\nEarnings',
                textAlign: TextAlign.center,
                style: AppStyles.font700_14().copyWith(color: Colors.black),
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Text(
          'Information',
          style: AppStyles.font700_14().copyWith(color: Colors.black),
        ),
        SizedBox(height: 4),
        Text(
          homeTabController.vendorDetailsModel?.userInfo?.descriptions ?? '',
          style: AppStyles.font500_14().copyWith(
            color: Colors.black,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 12),
        Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Offer selling from',
                    style: AppStyles.font700_14().copyWith(color: Colors.black),
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      getCurrencyCode(),
                      SizedBox(width: 4),
                      Text(
                        homeTabController
                                .vendorDetailsModel
                                ?.userInfo
                                ?.lowestPrice
                                .toString() ??
                            '',
                        style: AppStyles.font700_14().copyWith(
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Spacer(),
              GestureDetector(
                onTap: () {
                  pushToNextScreen(
                    context: context,
                    destination: CreateAppointmentDateTimePage(),
                  );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text('Hire Now', style: AppStyles.font700_14()),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget getPortfolio() {
    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      itemCount: homeTabController.portfolioModelData?.data?.length ?? 0,
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
          onTap: () async {},
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
                  width: double.infinity,
                  child: Image(
                    image: NetworkImage(
                      homeTabController.portfolioModelData?.data
                              ?.elementAt(index)
                              ?.image ??
                          '',
                    ),
                    height: 130,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  homeTabController.portfolioModelData?.data
                          ?.elementAt(index)
                          ?.title ??
                      '',
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: AppStyles.font400_12().copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget getCurrencyCode() {
    return CircleAvatar(
      radius: 8,
      backgroundColor: Colors.orange,
      child: Text(
        '₦',
        style: TextStyle(
          fontSize: 10,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget getOffers() {
    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: NeverScrollableScrollPhysics(),
      itemCount: homeTabController.offersModelData?.data?.length ?? 0,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          margin: EdgeInsets.only(bottom: 10),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Card(
              child: Column(
                children: [
                  Stack(
                    children: [
                      SizedBox(
                        height: 190,
                        width: double.infinity,
                        child: ClipRRect(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(12),
                            bottom: Radius.circular(12),
                          ),
                          child: Image(
                            image: NetworkImage(
                              homeTabController.offersModelData?.data
                                      ?.elementAt(index)
                                      ?.offerImages
                                      ?.elementAt(0)
                                      ?.attachments ??
                                  '',
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          color: Colors.black.withOpacity(0.5),
                          child: Row(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Rating: ${homeTabController.offersModelData?.data?.elementAt(index)?.rating ?? '0'}',
                                    style: AppStyles.font500_14().copyWith(
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(width: 4),
                                  Icon(Icons.star, color: Colors.amber),
                                ],
                              ),
                              Spacer(),
                              Text(
                                'Sold: ${homeTabController.offersModelData?.data?.elementAt(index)?.totalSold ?? '0'} Times',
                                style: AppStyles.font500_14().copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            homeTabController.offersModelData?.data
                                    ?.elementAt(index)
                                    ?.name ??
                                '',
                          ),
                        ),
                        Row(
                          children: [
                            getCurrencyCode(),
                            SizedBox(width: 4),
                            Text(
                              homeTabController.offersModelData?.data
                                      ?.elementAt(index)
                                      ?.price
                                      .toString() ??
                                  '0',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 4),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
