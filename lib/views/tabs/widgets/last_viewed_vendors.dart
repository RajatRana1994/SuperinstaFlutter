import 'package:flutter/material.dart';
import 'package:instajobs/utils/app_styles.dart';

class LastViewedVendors extends StatelessWidget {
  final String profile;
  final String name;
  final String price;
  final String rating;
  final String reviews;

  const LastViewedVendors({
    super.key,
    required this.profile,
    required this.name,
    required this.price,
    required this.rating,
    required this.reviews,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 170,
      margin: EdgeInsets.only(right: 12),
      height: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          profile.isNotEmpty
              ? ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            child: Image(
              image: NetworkImage(profile),
              height: 100,
              width: 170,
              fit: BoxFit.cover,
            ),
          )
              : Container(
            decoration: const BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            height: 100,
            width: 170,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  name,
                  maxLines: 1,
                  style: AppStyles.font700_16().copyWith(color: Colors.black),
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    const Icon(Icons.star, size: 14, color: Colors.amber),
                    Text(
                      rating,
                      style: AppStyles.font500_14().copyWith(
                          color: Colors.black,
                          fontSize: 12
                      ),
                    ),
                    Text(
                      '($reviews Reviews)',
                      style: AppStyles.font500_14().copyWith(
                          color: Colors.black,
                          fontSize: 12
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5),
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
                    SizedBox(width: 5),
                    Text(price,style: AppStyles.font500_14().copyWith(
                        color: Colors.black,
                        fontSize: 12
                    ),),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
