import 'package:flutter/material.dart';
import 'package:instajobs/utils/baseClass.dart';
import 'package:instajobs/views/my_offers/edit_offer.dart';
import 'package:instajobs/widgets/currency_widget.dart';
import 'package:instajobs/widgets/rounded_edged_button.dart';
import 'dart:convert';

import '../../controllers/job_controller/job_tab_controller.dart';
import 'package:get/get.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_styles.dart';
import '../../widgets/offers_widget.dart';
import 'package:instajobs/views/message/chat_vc.dart';
import 'package:instajobs/storage_services/local_stoage_service.dart';
import 'package:instajobs/views/my_wallet/pay_coins_page.dart';

class OfferDetailsPage extends StatefulWidget {
  final String offerID;
  final bool isEdit;

  const OfferDetailsPage({
    super.key,
    required this.offerID,
    this.isEdit = false,
  });

  @override
  State<OfferDetailsPage> createState() => _OfferDetailsPageState();
}

class _OfferDetailsPageState extends State<OfferDetailsPage> with BaseClass {
  final JobTabController jobTabController = Get.put(JobTabController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    jobTabController.getAppSetting();
    jobTabController.getOffersDetailsApi(widget.offerID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        backgroundColor: AppColors.bgColor,
        surfaceTintColor: Colors.transparent,
        title: Text(
          'Offer Details',
          style: AppStyles.fontInkika().copyWith(fontSize: 24),
        ),
        actions: [
          widget.isEdit
              ? IconButton(
            onPressed: () {
              pushAndReplace(
                context: context,
                destination: EditOffer(
                  offerDetailsModelData:
                  jobTabController.offerDetailsModelData,
                ),
              );
            },
            icon: Icon(Icons.edit_note),
          )
              : SizedBox(),
        ],
      ),
      body: GetBuilder<JobTabController>(
        init: jobTabController,
        builder: (snapShot) {
          return snapShot.offerDetailsModelData == null
              ? Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).primaryColor,
              ),
            ),
          )
              : SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                OffersWidget(
                  image: '',
                  isFavOffer:
                  snapShot.offerDetailsModelData?.isFavOffer ?? 0,
                  offerImages:
                  (snapShot
                      .offerDetailsModelData
                      ?.offerImages
                      ?.isEmpty ??
                      true)
                      ? []
                      : snapShot.offerDetailsModelData?.offerImages ??
                      [],
                  rating: snapShot.offerDetailsModelData?.rating ?? '0',
                  totalSold:
                  snapShot.offerDetailsModelData?.totalSold
                      .toString() ??
                      '0',
                  price:
                  snapShot.offerDetailsModelData?.price.toString() ??
                      '0',
                  name: snapShot.offerDetailsModelData?.name ?? '',
                ),
                SizedBox(height: 0),
                // Divider(),
                //  Text(snapShot.offerDetailsModelData?.description ?? '', style: AppStyles.font500_14().copyWith(
                //    color: AppColors.black,
                //  ),),
                //   SizedBox(height: 20),
                //   SizedBox(height: 16),
                //    Row(
                //      crossAxisAlignment: CrossAxisAlignment.start,
                //      mainAxisAlignment: MainAxisAlignment.start,
                //      children: [
                //        (snapShot.offerDetailsModelData?.users?.profile ==
                //                    null ||
                //                (snapShot
                //                        .offerDetailsModelData
                //                        ?.users
                //                        ?.profile
                //                        ?.isEmpty ??
                //                    true))
                //            ? SizedBox()
                //            : ClipRRect(
                //              borderRadius: BorderRadius.circular(40),
                //              child: Image(
                //                image: NetworkImage(
                //                  snapShot
                //                          .offerDetailsModelData
                //                          ?.users
                //                          ?.profile ??
                //                      '',
                //                ),
                //                fit: BoxFit.cover,
                //                height: 40,
                //                width: 40,
                //              ),
                //            ),
                //        SizedBox(width: 10),
                //
                //        Text(
                //          snapShot.offerDetailsModelData?.users?.name ?? '',
                //          style: AppStyles.font500_14().copyWith(
                //            color: AppColors.black,
                //          ),
                //        ),
                //      ],
                //    ),
                SizedBox(height: 0),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 8,
                  ),
                  child: Text(
                    snapShot.offerDetailsModelData?.description ?? '',
                    style: AppStyles.font500_14().copyWith(
                      color: AppColors.black,
                    ),
                  ),
                ),
                SizedBox(height: 16),
                widget.isEdit
                    ? RoundedEdgedButton(
                  buttonText:
                  (snapShot.offerDetailsModelData?.isBoosted == 1)
                      ? 'Boosted - ${jobTabController.boostFeedSetting?.value ?? ''}'
                      : 'Boost my offer ${jobTabController.boostFeedSetting?.value ?? ''} coins',
                  onButtonClick: () {
                    if (snapShot.offerDetailsModelData?.isBoosted ==
                        0) {
                      int id = snapShot.offerDetailsModelData?.id ?? 0;
                      jobTabController.boostMyOffer(
                        id.toString(),
                        jobTabController.boostFeedSetting?.value ?? '',
                      );
                    }
                    // handle click
                  },
                )
                    : Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        final bookingId =
                            snapShot.offerDetailsModelData?.id
                                .toString() ??
                                '';
                        final currentLoginUserId =
                        StorageService()
                            .getUserData()
                            .userId
                            .toString();

                        String friendId =
                            snapShot.offerDetailsModelData?.userId
                                .toString() ??
                                '';

                        pushToNextScreen(
                          context: context,
                          destination: ChatVc(
                            chatId: '',
                            bookingId: bookingId,
                            type: 'offer',
                            friendId: friendId,
                          ),
                        );
                      },
                      child: Container(
                        height: 48,
                        width: 48,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.grey,
                        ),
                        child: Center(
                          child: Icon(
                            Icons.message,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(width: 8),
                    Expanded(
                      child: RoundedEdgedButton(
                        height: 50,
                        buttonText: 'Buy now',
                        onButtonClick: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Dialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    16,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    children: [
                                      // Title paragraph
                                      Text(
                                        'Review the offer:',
                                        style: TextStyle(
                                          fontSize: 18,

                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),

                                      // Description paragraph
                                      Text(
                                        'Make sure you fully understand what the offer details. What is the service or product? Does it meet your expectations?',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        'Payment Security:',
                                        style: TextStyle(
                                          fontSize: 18,

                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),

                                      // Another description / extra info
                                      Text(
                                        'Confirm that the payment process is secure. Make sure you were using a trusted payment gateway.',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        'Escrow Terms:',
                                        style: TextStyle(
                                          fontSize: 18,

                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        'Since the money is escrow initially, ensure that you know when and how it will be settled once the work is completed.',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      SizedBox(height: 10),
                                      // Buttons row
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.end,
                                        children: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(
                                                context,
                                              ).pop();
                                            },
                                            child: Text('No'),
                                          ),
                                          SizedBox(width: 10),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context,).pop();


                                              // Get all selected adOns
                                              final selectedAdOns = snapShot.offerDetailsModelData?.adOn
                                                  ?.where((ad) => ad?.isSelected == true) // filter selected
                                                  .map((ad) => {
                                                "title": ad?.title ?? '',
                                                "workingDays": ad?.workingDays ?? 0,
                                                "price": ad?.price ?? 0
                                              })
                                                  .toList();

                                              // Convert to JSON string
                                              final selectedAdOnsJson = jsonEncode(selectedAdOns);

                                              print("Selected AdOns: $selectedAdOnsJson");


                                              final bookingId =
                                                  snapShot
                                                      .offerDetailsModelData
                                                      ?.id
                                                      .toString() ??
                                                      '';
                                              final int deliveryDays = snapShot.offerDetailsModelData?.deliveryTime ?? 0;
                                              final int deliverySeconds = deliveryDays * 24 * 60 * 60;

                                              final amount =
                                                  snapShot
                                                      .offerDetailsModelData
                                                      ?.price
                                                      .toString() ??
                                                      '';
                                              pushToNextScreen(
                                                context: context,
                                                destination:
                                                PayCoinsPage(
                                                  coins: amount,
                                                  walletId: '',
                                                  bookId: '',
                                                  offerTime: deliverySeconds.toString(),
                                                  adOns: selectedAdOnsJson,
                                                  offerId:
                                                  bookingId,
                                                ),
                                              );
                                            },
                                            child: Text('Buy'),
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
                    ),
                  ],
                ),
                SizedBox(height: 16),
                (snapShot.offerDetailsModelData?.adOn?.isEmpty ?? true)
                    ? SizedBox()
                    : Text(
                  'Get more with offer adds on',
                  style: AppStyles.font700_16().copyWith(
                    color: AppColors.black,
                  ),
                ),
                SizedBox(height: 12),

                ListView.separated(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount:
                  snapShot.offerDetailsModelData?.adOn?.length ?? 0,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                        border: Border.all(color: AppColors.borderColor),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 8,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Checkbox
                          Checkbox(
                            value:
                            snapShot.offerDetailsModelData?.adOn
                                ?.elementAt(index)
                                ?.isSelected ??
                                false,
                            onChanged: (value) {
                              snapShot
                                  .offerDetailsModelData
                                  ?.adOn
                                  ?.elementAt(index)
                                  ?.isSelected = value ?? false;
                              snapShot.update();
                            },
                            activeColor: AppColors.btncolor,
                            checkColor: AppColors.white,
                          ),
                          // Title and Working Days
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  snapShot.offerDetailsModelData?.adOn
                                      ?.elementAt(index)
                                      ?.title ??
                                      '',
                                  style: AppStyles.font500_16().copyWith(
                                    color: Colors.black,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  snapShot.offerDetailsModelData?.adOn
                                      ?.elementAt(index)
                                      ?.workingDays ??
                                      '',
                                  style: AppStyles.font500_16().copyWith(
                                    color: Colors.black,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Price with Currency
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                GetCurrencyWidget(),
                                SizedBox(width: 6),
                                Text(
                                  '${snapShot.offerDetailsModelData?.adOn?.elementAt(index)?.price ?? ''}',
                                  style: AppStyles.font500_16().copyWith(
                                    color: Colors.black,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  separatorBuilder:
                      (context, index) => const SizedBox(height: 16),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
