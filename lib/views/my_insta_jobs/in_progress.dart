import 'package:flutter/material.dart';
import 'package:instajobs/utils/app_styles.dart';
import 'package:instajobs/utils/baseClass.dart';
import 'package:instajobs/views/jobs_tab/job_details_page.dart';
import 'package:instajobs/views/jobs_tab/job_details_page_new.dart';

import '../../controllers/profile_controller.dart';
import 'package:get/get.dart';

import '../../utils/app_colors.dart';
import 'instaJobWidget.dart';

class InProgressPage extends StatefulWidget {
  const InProgressPage({super.key});

  @override
  State<InProgressPage> createState() => _InProgressPageState();
}

class _InProgressPageState extends State<InProgressPage> with BaseClass {
  ProfileController controller = Get.put(ProfileController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.getInstaJobs(status: 1);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      init: controller,
      builder: (snapshot) {
        return snapshot.inProgressInstaJobsData == null
            ? Expanded(
          child: Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                AppColors.primaryColor,
              ),
            ),
          ),
        )
            : snapshot.inProgressInstaJobsData?.isEmpty ?? false
            ? Expanded(
          child: Center(
            child: Text(
              'No In progress InstaJobs found',
              style: AppStyles.font700_14().copyWith(color: Colors.black),
            ),
          ),
        )
            : Expanded(
          child: ListView.builder(
            itemCount: snapshot.inProgressInstaJobsData?.length ?? 0,
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              final job = snapshot.inProgressInstaJobsData?.elementAt(index);
              return GestureDetector(
                onTap: () {
                  pushToNextScreen(
                    context: context,
                    destination: JobDetailsPageNew(
                      jobId: job?.id?.toString() ?? '0',
                    ),
                  );
                },
                child: InstaJobWidget(
                  title:
                  snapshot.inProgressInstaJobsData
                      ?.elementAt(index)
                      ?.title ??
                      '',
                  location:
                  snapshot.inProgressInstaJobsData
                      ?.elementAt(index)
                      ?.isAnyWhere ==
                      1
                      ? 'Anywhere'
                      : '${snapshot.pendingInstaJobsData?.elementAt(index)?.state ?? ''}, ${snapshot.pendingInstaJobsData?.elementAt(index)?.country ?? ''}',
                  amount:
                  snapshot.inProgressInstaJobsData
                      ?.elementAt(index)
                      ?.totalBudgets
                      .toString() ??
                      '0',
                  proposals:
                  snapshot.inProgressInstaJobsData
                      ?.elementAt(index)
                      ?.totalProposals
                      .toString() ??
                      '0',
                ),
              );

              return InstaJobWidget(
                title:
                snapshot.inProgressInstaJobsData
                    ?.elementAt(index)
                    ?.title ??
                    '',
                location:
                snapshot.inProgressInstaJobsData
                    ?.elementAt(index)
                    ?.isAnyWhere ==
                    1
                    ? 'Anywhere'
                    : '${snapshot.pendingInstaJobsData?.elementAt(index)?.state ?? ''}, ${snapshot.pendingInstaJobsData?.elementAt(index)?.country ?? ''}',
                amount:
                snapshot.inProgressInstaJobsData
                    ?.elementAt(index)
                    ?.totalBudgets
                    .toString() ??
                    '0',
                proposals:
                snapshot.inProgressInstaJobsData
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
