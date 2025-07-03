import 'package:flutter/material.dart';
import 'package:instajobs/views/my_insta_jobs/instaJobWidget.dart';

import '../../controllers/profile_controller.dart';
import 'package:get/get.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_styles.dart';

class PendingPage extends StatefulWidget {
  const PendingPage({super.key});

  @override
  State<PendingPage> createState() => _PendingPageState();
}

class _PendingPageState extends State<PendingPage> {
  ProfileController controller = Get.put(ProfileController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.getInstaJobs(status: 3);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      init: controller,
      builder: (snapshot) {
        return snapshot.pendingInstaJobsData == null
            ? Expanded(
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.primaryColor,
                  ),
                ),
              ),
            )
            : snapshot.pendingInstaJobsData?.isEmpty ?? false
            ? Expanded(
              child: Center(
                child: Text(
                  'No Pending InstaJobs found',
                  style: AppStyles.font700_14().copyWith(color: Colors.black),
                ),
              ),
            )
            : Expanded(
              child: ListView.builder(
                itemCount: snapshot.pendingInstaJobsData?.length ?? 0,
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return InstaJobWidget(
                    title:
                        snapshot.pendingInstaJobsData?.elementAt(index)?.title ??
                        '',
                    location:
                        snapshot.pendingInstaJobsData
                                    ?.elementAt(index)
                                    ?.isAnyWhere ==
                                1
                            ? 'Anywhere'
                            : snapshot.pendingInstaJobsData
                                    ?.elementAt(index)
                                    ?.locations ??
                                '',
                    amount:
                        snapshot.pendingInstaJobsData
                            ?.elementAt(index)
                            ?.totalBudgets
                            .toString() ??
                        '0',
                    proposals:
                        snapshot.pendingInstaJobsData
                            ?.elementAt(index)
                            ?.totalProposals
                            .toString() ??
                        '0',
                  );
                },
              ),
            );
      },
    );
  }
}
