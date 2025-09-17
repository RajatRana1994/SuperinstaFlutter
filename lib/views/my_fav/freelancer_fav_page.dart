import 'package:flutter/material.dart';
import 'package:instajobs/controllers/profile_controller.dart';
import 'package:get/get.dart';
import 'package:instajobs/utils/baseClass.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_images.dart';
import '../../utils/app_styles.dart';
import '../../widgets/currency_widget.dart';
import '../vendor_details/vendor_details_page.dart';

class FreelancerFavPage extends StatefulWidget {
  const FreelancerFavPage({super.key});

  @override
  State<FreelancerFavPage> createState() => _FreelancerFavPageState();
}

class _FreelancerFavPageState extends State<FreelancerFavPage> with BaseClass {
  ProfileController profileController = Get.put(ProfileController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    profileController.getFavFreelancers();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      init: profileController,
      builder: (snapshot) {
        return profileController.favFreelancers == null
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
            :  ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: snapshot.favFreelancers?.length ?? 0,
          shrinkWrap: true,

          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                pushToNextScreen(
                  context: context,
                  destination: VendorDetailsPage(
                    snapshot.favFreelancers
                        ?.elementAt(index)
                        ?.vendorId
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
                  border: Border.all(color: Color(0xffEBEBEB), width: 2),
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
                            width: 110,
                            child: Image(
                              image: AssetImage(AppImages.icon),
                              //    height: 150,
                              width: 110,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 8,
                          left: 8,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.7),
                              shape: BoxShape.circle,
                            ),
                            child: SizedBox(
                              width: 30,
                              height: 30,
                              child: IconButton(
                                icon: Icon(
                                  Icons.favorite ,
                                  color: Colors.red,
                                  size: 18, // icon visual size
                                ),
                                onPressed: () {
                                  profileController.removeVenderToFav(snapshot.favFreelancers
                                      ?.elementAt(index)
                                      ?.vendorId
                                      .toString() ??
                                      '', index);

                                },
                                padding: EdgeInsets.zero, // remove default padding
                                constraints: BoxConstraints(), // remove default size constraints
                                splashRadius: 16, // splash radius for tap feedback
                              ),
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

                      ],
                    ),
                    SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          snapshot.favFreelancers
                              ?.elementAt(index)
                              ?.vendors
                              ?.name ??
                              '',
                          textAlign: TextAlign.start,
                          maxLines: 1,
                          style: AppStyles.font400_12().copyWith(
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
                          snapshot.favFreelancers
                              ?.elementAt(index)
                              ?.vendors
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
                          '${snapshot.favFreelancers?.elementAt(index)?.vendors?.country ?? ''},${snapshot.favFreelancers?.elementAt(index)?.vendors?.city ?? ''}${snapshot.favFreelancers?.elementAt(index)?.vendors?.state ?? ''}',
                        ),
                        SizedBox(height: 2),
                        getItemWidget(
                          icon: Icon(
                            Icons.star,
                            color: AppColors.orange,
                            size: 14,
                          ),
                          title:
                          snapshot.favFreelancers
                              ?.elementAt(index)
                              ?.vendors
                              ?.overallRating ??
                              '',
                        ),
                        SizedBox(height: 2),
                        Row(
                          children: [
                            Row(
                              children: [
                                GetCurrencyWidget(),
                                SizedBox(width: 2),
                                getItemWidget(
                                  icon: Text(
                                    'Hourly Price:',
                                    style: AppStyles.font600_12()
                                        .copyWith(color: Colors.black),
                                  ),
                                  title:
                                  snapshot.favFreelancers
                                      ?.elementAt(index)
                                      ?.vendors
                                      ?.hourlyPrice
                                      .toString() ??
                                      '',
                                ),
                              ],
                            ),
                            SizedBox(width: 5),
                            Row(
                              children: [
                                GetCurrencyWidget(),
                                SizedBox(width: 2),
                                getItemWidget(
                                  icon: Text(
                                    'Daily Price:',
                                    style: AppStyles.font600_12()
                                        .copyWith(color: Colors.black),
                                  ),
                                  title:
                                  snapshot.favFreelancers
                                      ?.elementAt(index)
                                      ?.vendors
                                      ?.dailyPrice
                                      .toString() ??
                                      '',
                                ),
                              ],
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
                                style: AppStyles.font600_12().copyWith(
                                  color: Colors.black,
                                ),
                              ),
                              title:
                              snapshot.favFreelancers
                                  ?.elementAt(index)
                                  ?.vendors
                                  ?.totalJobs
                                  .toString() ??
                                  '',
                            ),
                          ],
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
