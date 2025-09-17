import 'package:flutter/material.dart';
import 'package:instajobs/utils/app_images.dart';
import 'package:instajobs/utils/baseClass.dart';
import 'package:instajobs/views/my_portfolio/add_portfolio_page.dart';

import '../../models/my_portfolio_model.dart';

class PortfolioDetails extends StatelessWidget with BaseClass {
  final MyPortfolioModelDataData? portfolioModelDataData;

  const PortfolioDetails({super.key, required this.portfolioModelDataData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          portfolioModelDataData?.title ?? 'Portfolio Details',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {
              pushToNextScreen(
                context: context,
                destination: AddPortfolioPage(
                  isEditPortfolio: true,
                  portfolioModelDataData: portfolioModelDataData,
                ),
              );
            },
            icon: Icon(Icons.edit),
            color: Colors.orange,
          ),
          SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Image.network(
              portfolioModelDataData?.image ?? '',
              height: 300,
              width: double.infinity,
              fit: BoxFit.cover,
              // ⬇️ show a local fallback if the network image can’t load
              errorBuilder:
                  (context, error, stackTrace) => Image.asset(
                'assets/images/icon.png',
                height: 300,
                width: double.infinity,
                // put the asset in pubspec.yaml
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(8.0),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Text(
                portfolioModelDataData?.description ??
                    'No description available',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
