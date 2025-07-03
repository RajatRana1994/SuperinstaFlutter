import 'package:flutter/material.dart';
import 'package:instajobs/widgets/currency_widget.dart';

import '../../controllers/job_controller/job_tab_controller.dart';
import 'package:get/get.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_styles.dart';

class JobDetailsPage extends StatefulWidget {
  final String jobId;

  const JobDetailsPage({super.key, required this.jobId});

  @override
  State<JobDetailsPage> createState() => _JobDetailsPageState();
}

class _JobDetailsPageState extends State<JobDetailsPage> {
  JobTabController jobTabController = Get.put(JobTabController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    jobTabController.getJobDetailsApi(widget.jobId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: Text(
          'Job Details',
          style: TextStyle(
            color: AppColors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      body: GetBuilder<JobTabController>(
        init: jobTabController,
        builder: (snapshot) {
          return snapshot.jobDetailsModelData == null
              ? Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.primaryColor,
                  ),
                ),
              )
              : SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      snapshot.jobDetailsModelData?.title ?? '',
                      style: AppStyles.font600_18().copyWith(
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Icon(Icons.location_pin, color: AppColors.orange),
                        SizedBox(width: 4),
                        Text(
                          (snapshot.jobDetailsModelData?.isAnyWhere == 1)
                              ? 'Anywhere'
                              : '',
                          style: AppStyles.font500_14().copyWith(
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Text(
                      snapshot.jobDetailsModelData?.descriptions ?? '',
                      style: AppStyles.font500_16().copyWith(
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.location_history, color: AppColors.orange),
                        SizedBox(width: 5),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              snapshot.jobDetailsModelData?.experience ?? '',
                              style: AppStyles.font500_16().copyWith(
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Experience Level',
                              style: AppStyles.font500_14().copyWith(
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GetCurrencyWidget(radius: 12, fontSize: 14),
                        SizedBox(width: 5),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              snapshot.jobDetailsModelData?.totalBudgets
                                      .toString() ??
                                  '',
                              style: AppStyles.font500_16().copyWith(
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Experience Level',
                              style: AppStyles.font500_14().copyWith(
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Divider(),
                    SizedBox(height: 8),
                    Text(
                      'Skills & Expertise',
                      style: AppStyles.font500_14().copyWith(
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.grey.shade300,
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      child: Text(
                        snapshot.jobDetailsModelData?.skills.toString() ?? '',
                        style: AppStyles.font500_14().copyWith(
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Divider(),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Text(
                          'About Client',
                          style: AppStyles.font500_14().copyWith(
                            color: Colors.black,
                          ),
                        ),
                        Spacer(),
                        Row(
                          children: [
                            Icon(Icons.flag, color: AppColors.orange),
                            Text(
                              'Flag an inappropriate client',
                              style: AppStyles.font500_14().copyWith(
                                color: AppColors.orange,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        (snapshot.jobDetailsModelData?.users?.profile == null ||
                                (snapshot
                                        .jobDetailsModelData
                                        ?.users
                                        ?.profile
                                        ?.isEmpty ??
                                    true))
                            ? SizedBox()
                            : ClipRRect(
                              borderRadius: BorderRadius.circular(40),
                              child: Image(
                                image: NetworkImage(
                                  snapshot
                                          .jobDetailsModelData
                                          ?.users
                                          ?.profile ??
                                      '',
                                ),
                                fit: BoxFit.cover,
                                height: 40,
                                width: 40,
                              ),
                            ),
                        SizedBox(width: 10),
                        Column(
                          children: [
                            Text(
                              snapshot.jobDetailsModelData?.users?.name ?? '',
                              style: AppStyles.font500_14().copyWith(
                                color: AppColors.black,
                              ),
                            ),
                            SizedBox(height: 0),
                            Text(
                              snapshot.jobDetailsModelData?.users?.country ??
                                  '',
                              style: AppStyles.font500_14().copyWith(
                                color: AppColors.black,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    SizedBox(height: 10),
                    Text(
                      '${snapshot.jobDetailsModelData?.users?.totalJobPosted.toString() ?? ''} Jobs Posted',
                      style: AppStyles.font500_14().copyWith(
                        color: AppColors.black,
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        GetCurrencyWidget(radius: 12, fontSize: 14),
                        SizedBox(width: 4),
                        Text(
                          '${snapshot.jobDetailsModelData?.users?.totalAmountSpend.toString() ?? ''} total Spent',
                          style: AppStyles.font500_14().copyWith(
                            color: AppColors.black,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text(
                        snapshot.jobDetailsModelData?.categories==null?'':   snapshot.jobDetailsModelData?.categories?.name.toString() ?? '',
                      style: AppStyles.font500_14().copyWith(
                        color: AppColors.black,
                      ),
                    ),
                  ],
                ),
              );
        },
      ),
    );
  }
}
