import 'package:flutter/material.dart';

import '../../controllers/profile_controller.dart';
import 'package:get/get.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_styles.dart';
import 'instaJobWidget.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  ProfileController controller = Get.put(ProfileController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.getInstaJobs(status: 2);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      init: controller,
      builder: (snapshot) {
        return snapshot.historyInstaJobsData == null
            ? Expanded(
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.primaryColor,
                  ),
                ),
              ),
            )
            : snapshot.historyInstaJobsData?.isEmpty ?? false
            ? Expanded(
              child: Center(
                child: Text(
                  'No History InstaJobs found',
                  style: AppStyles.font700_14().copyWith(color: Colors.black),
                ),
              ),
            )
            : Expanded(
              child: ListView.builder(
                itemCount: snapshot.historyInstaJobsData?.length ?? 0,
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return InstaJobWidget(
                    title:
                        snapshot.historyInstaJobsData?.elementAt(index)?.title ??
                        '',
                    location:
                        snapshot.historyInstaJobsData
                                    ?.elementAt(index)
                                    ?.isAnyWhere ==
                                1
                            ? 'Anywhere'
                            : snapshot.historyInstaJobsData
                                    ?.elementAt(index)
                                    ?.locations ??
                                '',
                    amount:
                        snapshot.historyInstaJobsData
                            ?.elementAt(index)
                            ?.totalBudgets
                            .toString() ??
                        '0',
                    proposals:
                        snapshot.historyInstaJobsData
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
