import 'package:flutter/material.dart';
import 'package:instajobs/controllers/notifications.dart';
import 'package:instajobs/utils/baseClass.dart';
import 'package:get/get.dart';

import '../utils/app_colors.dart';
import '../utils/app_styles.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> with BaseClass {
  NotificationController notificationController = Get.put(
    NotificationController(),
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notificationController.getNotification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        backgroundColor: AppColors.bgColor,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        title: Text(
          'Notifications',
          style: AppStyles.fontInkika().copyWith(fontSize: 24),
        ),
      ),
      body: GetBuilder<NotificationController>(
        init: notificationController,
        builder: (snapshot) {
          return snapshot.notifications == null
              ? Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.primaryColor,
                  ),
                ),
              )
              : ListView.builder(
                itemCount: snapshot.notifications?.length ?? 0,
                padding: EdgeInsets.symmetric(horizontal: 16),
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 8,
                            offset: const Offset(
                              0,
                              4,
                            ), // changes position of shadow
                          ),
                        ],
                        color: Colors.white,
                      ),
                      margin: EdgeInsets.only(bottom: 8, top: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            snapshot.notifications
                                        ?.elementAt(index)
                                        ?.usersOffers ==
                                    null
                                ? 'Push Notification'
                                : snapshot.notifications
                                        ?.elementAt(index)
                                        ?.usersOffers
                                        ?.name ??
                                    '',
                            style: AppStyles.font500_14().copyWith(
                              color: Colors.orange,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            snapshot.notifications?.elementAt(index)?.text ??
                                '',
                            style: AppStyles.font700_14().copyWith(
                              color: AppColors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
        },
      ),
    );
  }
}
