import 'package:flutter/material.dart';
import 'package:instajobs/utils/app_styles.dart';
import 'package:instajobs/widgets/currency_widget.dart';

import '../../../utils/app_constants.dart';

class WalletWidget extends StatelessWidget {
  final String title;

  final String status;

  final int dateTime;

  final String amount;

  const WalletWidget({
    super.key,
    required this.title,
    required this.status,
    required this.dateTime,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.symmetric(horizontal: 12,vertical: 12),
      decoration: BoxDecoration(
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.05),
            blurRadius: 8.0,
            offset: Offset(0.0, 1),
          ),
        ],
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppStyles.font700_16().copyWith(color: Colors.black),
          ),
          SizedBox(height: 8),
          Text(
            'Transaction status: $status',
            style: AppStyles.font700_16().copyWith(color: Colors.green),
          ),
          SizedBox(height: 8),
          Text(
            formatDateTime(dateTime),
            style: AppStyles.font500_16().copyWith(color: Colors.black),
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GetCurrencyWidget(),
              SizedBox(width: 8),
              Text(
                amount,
                style: AppStyles.font700_18().copyWith(color: Colors.orange),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
