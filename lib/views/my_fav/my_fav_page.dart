import 'package:flutter/material.dart';
import 'package:instajobs/views/my_fav/feed_fav_page.dart';
import 'package:instajobs/views/my_fav/freelancer_fav_page.dart';
import 'package:instajobs/views/my_fav/offers_fav_page.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_styles.dart';

class MyFavPage extends StatefulWidget {
  const MyFavPage({super.key});

  @override
  State<MyFavPage> createState() => _MyFavPageState();
}

class _MyFavPageState extends State<MyFavPage> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        backgroundColor: AppColors.bgColor,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        title: Text(
          'My Favourites',
          style: AppStyles.fontInkika().copyWith(fontSize: 24),
        ),

      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      selectedIndex = 0;
                      setState(() {});
                    },
                    child: Container(
                      height: 42,
                      decoration: BoxDecoration(
                        color:
                        selectedIndex == 0
                            ? Colors.orange
                            : Colors.orange.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          'Freelancers',
                          style: AppStyles.font500_14().copyWith(
                            color:
                            selectedIndex == 0
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      selectedIndex = 1;
                      setState(() {});
                    },
                    child: Container(
                      height: 42,
                      decoration: BoxDecoration(
                        color:
                        selectedIndex == 1
                            ? Colors.orange
                            : Colors.orange.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          'Offers',
                          style: AppStyles.font500_14().copyWith(
                            color:
                            selectedIndex == 1
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      selectedIndex = 2;
                      setState(() {});
                    },
                    child: Container(
                      height: 42,
                      decoration: BoxDecoration(
                        color:
                        selectedIndex == 2
                            ? Colors.orange
                            : Colors.orange.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          'Feed',
                          style: AppStyles.font500_14().copyWith(
                            color:
                            selectedIndex == 2
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            SizedBox(height: 20),
            Expanded(
              child: selectedIndex == 0
                  ? FreelancerFavPage()
                  : selectedIndex == 1
                  ? OffersFavPage()
                  : FeedFavPage(),
            ),
          ],
        ),
      ),
    );
  }
}
