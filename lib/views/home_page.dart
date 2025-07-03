import 'package:flutter/material.dart';
import 'package:instajobs/utils/app_images.dart';
import 'package:instajobs/utils/baseClass.dart';
import 'package:instajobs/views/directory_tab/directory_tab_page.dart';
import 'package:instajobs/views/market_tab/market_tab_page.dart';
import 'package:instajobs/views/profile/profile_page.dart';
import 'package:instajobs/views/tabs/home_tab.dart';

import 'feed_tab/feed_tab_page.dart';
import 'jobs_tab/jobs_page.dart';
import 'notification_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with BaseClass {
  int _currentIndex = 0;

  final List<String> labels = ['Home', 'Jobs', 'Feeds', 'Directory', 'Market'];
  final List<String> icons = [
    AppImages.home,
    AppImages.jobs,
    AppImages.feed,
    AppImages.directory,
    AppImages.directory,

  ];

  final List<Widget> screens = [
    HomeTab(),
    JobsPage(),
    FeedTabPage(),
    DirectoryTabPage(),
    MarketTabPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Image(
          image: AssetImage(AppImages.super_jobs),
          height: 30,
          width: 180,
        ),
        backgroundColor: Colors.white,

        actions: [
          IconButton(icon: Icon(Icons.chat), onPressed: () {}),
          IconButton(icon: Icon(Icons.notifications), onPressed: () {
            pushToNextScreen(context: context, destination: NotificationPage());
          }),
          IconButton(
            icon: Icon(Icons.supervised_user_circle),
            onPressed: () {
              pushToNextScreen(context: context, destination: ProfilePage());
            },
          ),
        ],
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        backgroundColor: Colors.white,
        elevation: 8,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        onTap: (index) => setState(() => _currentIndex = index),
        items: List.generate(5, (index) {
          final isSelected = _currentIndex == index;
          return BottomNavigationBarItem(
            icon: Image.asset(
              icons[index],
              color: isSelected ? Colors.orange : Colors.grey,
              width: 24,
              height: 24,
            ),
            label: labels[index],
          );
        }),
      ),
    );
  }
}
