import 'package:flutter/material.dart';
import 'package:instajobs/utils/app_styles.dart';
import 'package:instajobs/views/my_insta_jobs/history.dart';
import 'package:instajobs/views/my_insta_jobs/in_progress.dart';
import 'package:instajobs/views/my_insta_jobs/pending.dart';

import '../../utils/app_colors.dart';

class MyInstaJobsPage extends StatefulWidget {
  const MyInstaJobsPage({super.key});

  @override
  State<MyInstaJobsPage> createState() => _MyInstaJobsPageState();
}

class _MyInstaJobsPageState extends State<MyInstaJobsPage> {
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
          'My InstaJobs',
          style: AppStyles.fontInkika().copyWith(fontSize: 20),
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
                          'Pending',
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
                          'In Progress',
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
                          'History',
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
            selectedIndex == 0
                ? PendingPage()
                : selectedIndex == 1
                ? InProgressPage()
                : HistoryPage(),
          ],
        ),
      ),
    );
  }
}
