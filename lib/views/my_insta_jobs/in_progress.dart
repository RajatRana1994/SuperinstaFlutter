import 'package:flutter/material.dart';
import 'package:instajobs/utils/app_styles.dart';

import '../../controllers/profile_controller.dart';
import 'package:get/get.dart';

import '../../utils/app_colors.dart';
import 'instaJobWidget.dart';

class InProgressPage extends StatefulWidget {
  const InProgressPage({super.key});

  @override
  State<InProgressPage> createState() => _InProgressPageState();
}

class _InProgressPageState extends State<InProgressPage> {
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
                            : snapshot.inProgressInstaJobsData
                                    ?.elementAt(index)
                                    ?.locations ??
                                '',
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
