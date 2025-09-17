import 'package:flutter/material.dart';
import 'package:instajobs/utils/app_images.dart';

import '../utils/app_styles.dart';
import '../models/feed_tab_model.dart';
import '../models/offer_tab_model.dart';

class OffersWidget extends StatelessWidget {
  final String image;
  final String rating;
  final String totalSold;
  final String price;
  final String name;
  final int isFavOffer;
  final int showFav;
  final VoidCallback? onClickFav;
  // List<OfferTabModelDataDataOfferImages?> offerImages;
  final List<OfferTabModelDataDataOfferImages?> offerImages;
  const OffersWidget({
    super.key,
    required this.image,
    required this.rating,
    required this.totalSold,
    required this.price,
    required this.name,
    required this.offerImages,
    required this.isFavOffer,
    this.onClickFav,
    this.showFav = 0,

  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Card(
          child: Column(
            children: [
              Stack(
                children: [
                  SizedBox(
                    height: 168,
                    width: double.infinity,
                    child: ClipRRect(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                      child: offerImages.isEmpty
                          ? Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(AppImages.icon),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(12),
                            bottom: Radius.circular(12),
                          ),
                        ),
                      )
                          : PageView.builder(
                        itemCount: offerImages.length,
                        itemBuilder: (context, index) {
                          final imageUrl = offerImages[index]?.attachments ?? '';
                          return Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Center(child: Icon(Icons.broken_image)),
                          );
                        },
                      ),
                    ),
                  ),

                  if (showFav == 1) ... [Positioned(
                    top: 8,
                    right: 8,
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
                            isFavOffer == 1 ? Icons.favorite : Icons.favorite_border,
                            color: Colors.red,
                            size: 18, // icon visual size
                          ),
                          onPressed: () {
                            onClickFav?.call();
                            // Handle tap
                          },
                          padding: EdgeInsets.zero, // remove default padding
                          constraints: BoxConstraints(), // remove default size constraints
                          splashRadius: 16, // splash radius for tap feedback
                        ),
                      ),
                    ),
                  ),],


                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      color: Colors.black.withOpacity(0.55),
                      child: Row(
                        children: [
                          Row(
                            children: [
                              Text(
                                'Rating: ${rating}',
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
                            'Sold: ${totalSold} Times',
                            style: AppStyles.font600_12().copyWith(
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
                    SizedBox(width: 8),
                    Expanded(child: Text(name, style: AppStyles.font500_14().copyWith(
                      color: Colors.black,
                    ),)
                    ),
                    Row(
                      children: [


                        Text(price, style: AppStyles.font700_16().copyWith(
                          color: Colors.black,
                        ),),
                        SizedBox(width: 4),
                        getCurrencyCode(),
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
}
