import 'package:flutter/material.dart';
import 'package:instajobs/utils/baseClass.dart';
import 'package:instajobs/views/my_offers/add_offer_page.dart';

import '../../controllers/profile_controller.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_styles.dart';
import 'package:get/get.dart';

import '../../widgets/offers_widget.dart';
import '../market_tab/offer_details_page.dart';

class MyOffersPage extends StatefulWidget {
  const MyOffersPage({super.key});

  @override
  State<MyOffersPage> createState() => _MyOffersPageState();
}

class _MyOffersPageState extends State<MyOffersPage> with BaseClass {
  ProfileController profileController = Get.put(ProfileController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    profileController.getOffersApi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        backgroundColor: AppColors.bgColor,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {
              pushToNextScreen(context: context, destination: AddOfferPage());
            },
            icon: Icon(
              Icons.add_circle_outline_rounded,
              color: Colors.orange,
              size: 30,
            ),
          ),
        ],
        title: Text(
          'My offers',
          style: AppStyles.fontInkika().copyWith(fontSize: 24),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          Expanded(
            child: GetBuilder<ProfileController>(
              init: profileController,
              builder: (snapshot) {
                return snapshot.offersList == null
                    ? Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.primaryColor,
                        ),
                      ),
                    )
                    : ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      itemCount: snapshot.offersList?.length ?? 0,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            pushToNextScreen(
                              context: context,
                              destination: OfferDetailsPage(
                                isEdit: true,
                                offerID:
                                    snapshot.offersList
                                        ?.elementAt(index)
                                        ?.id
                                        .toString() ??
                                    '0',
                              ),
                            );
                          },
                          child: OffersWidget(
                            image:
                                (snapshot.offersList
                                            ?.elementAt(index)
                                            ?.offerImages
                                            ?.isEmpty ??
                                        true)
                                    ? ''
                                    : snapshot.offersList
                                            ?.elementAt(index)
                                            ?.offerImages
                                            ?.elementAt(0)
                                            ?.attachments ??
                                        '',
                            rating:
                                snapshot.offersList?.elementAt(index)?.rating ??
                                '0',
                            totalSold:
                                snapshot.offersList
                                    ?.elementAt(index)
                                    ?.totalSold
                                    .toString() ??
                                '0',
                            price:
                                snapshot.offersList
                                    ?.elementAt(index)
                                    ?.price
                                    .toString() ??
                                '0',
                            name:
                                snapshot.offersList?.elementAt(index)?.name ??
                                '',
                          ),
                        );
                      },
                    );
              },
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
