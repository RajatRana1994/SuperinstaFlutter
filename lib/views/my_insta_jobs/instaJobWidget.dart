import 'package:flutter/material.dart';
import 'package:instajobs/utils/app_styles.dart';
import 'package:instajobs/widgets/currency_widget.dart';

class InstaJobWidget extends StatelessWidget {
  final String title;
  final String location;
  final String amount;
  final String proposals;

  const InstaJobWidget({
    super.key,
    required this.title,
    required this.location,
    required this.amount,
    required this.proposals,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,                     // 1️⃣ white background
      child: Padding(                          // 2️⃣ inner padding
        padding: const EdgeInsets.all(12.0),   //    adjust as you like
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppStyles.font700_14().copyWith(color: Colors.black),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.location_on_outlined,
                    color: Colors.grey, size: 16),
                const SizedBox(width: 4),
                Text(
                  location,
                  style: AppStyles.font400_12().copyWith(color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const GetCurrencyWidget(),
                const SizedBox(width: 4),
                Text(
                  amount,
                  style: AppStyles.font700_12().copyWith(color: Colors.black),
                ),
              ],
            ),
            const Divider(),
            Row(
              children: [
                Text(
                  'Proposals',
                  style: AppStyles.font700_12().copyWith(color: Colors.black),
                ),
                const SizedBox(width: 4),
                Text(
                  proposals,
                  style: AppStyles.font700_12().copyWith(color: Colors.green),
                ),
              ],
            ),
          ],
        ),
      ),
    );

  }
}
