import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:instajobs/utils/baseClass.dart';
import 'package:get/get.dart';
import '../../controllers/profile_controller.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_styles.dart';
import '../../widgets/offers_widget.dart';
import '../market_tab/offer_details_page.dart';

class OffersFavPage extends StatefulWidget {
  const OffersFavPage({super.key});

  @override
  State<OffersFavPage> createState() => _OffersFavPageState();
}

class _OffersFavPageState extends State<OffersFavPage> with BaseClass {
  ProfileController profileController = Get.put(ProfileController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    profileController.getFavOffersApi();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      init: profileController,
      builder: (snapshot) {
        return snapshot.favOffersList == null
            ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppColors.primaryColor,
                ),
              ),
            )
            : ListView.builder(
              physics: NeverScrollableScrollPhysics(),

              itemCount: snapshot.favOffersList?.length ?? 0,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    pushToNextScreen(
                      context: context,
                      destination: OfferDetailsPage(
                        isEdit: true,
                        offerID:
                            snapshot.favOffersList
                                ?.elementAt(index)
                                ?.id
                                .toString() ??
                            '0',
                      ),
                    );
                  },
                  child: OffersWidget(
                    image: '',
                    offerImages: (snapshot.favOffersList
                        ?.elementAt(index)
                        ?.usersOffers?.offerImages
                        ?.isEmpty ??
                        true)
                        ? []
                        : (snapshot.favOffersList?.elementAt(index)?.usersOffers?.offerImages ?? [])
                    ,
                    rating:
                        snapshot.favOffersList?.elementAt(index)?.rating ?? '0',
                    totalSold:
                        snapshot.favOffersList
                            ?.elementAt(index)?.usersOffers
                            ?.totalSold
                            .toString() ??
                        '0',
                    price:
                        snapshot.favOffersList
                            ?.elementAt(index)?.usersOffers
                            ?.price
                            .toString() ??
                        '0',
                    name: snapshot.favOffersList?.elementAt(index)?.usersOffers?.name ?? '',
                  ),
                );
              },
            );
      },
    );
  }
}
