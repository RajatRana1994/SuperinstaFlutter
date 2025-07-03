import 'package:flutter/material.dart';
import 'package:instajobs/controllers/job_controller/job_tab_controller.dart';
import 'package:instajobs/utils/baseClass.dart';
import 'package:instajobs/views/market_tab/offer_details_page.dart';
import 'package:instajobs/widgets/offers_widget.dart';

import '../../utils/app_colors.dart';
import 'package:get/get.dart';

class MarketTabPage extends StatefulWidget {
  MarketTabPage({super.key});

  @override
  State<MarketTabPage> createState() => _MarketTabPageState();
}

class _MarketTabPageState extends State<MarketTabPage> with BaseClass{
  final JobTabController jobTabController = Get.put(JobTabController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    jobTabController.getOffersApi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.greyBackground,
      body: Column(
        children: [
          SizedBox(height: 20),
          Expanded(
            child: GetBuilder<JobTabController>(
              init: jobTabController,
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
                          onTap: (){
                          pushToNextScreen(context: context, destination: OfferDetailsPage(offerID: snapshot.offersList
                              ?.elementAt(index)
                              ?.id
                              .toString() ?? '0'));
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
                                snapshot.offersList?.elementAt(index)?.name ?? '',
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
