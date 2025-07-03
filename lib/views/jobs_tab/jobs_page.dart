import 'package:flutter/material.dart';
import 'package:instajobs/controllers/job_controller/job_tab_controller.dart';
import 'package:instajobs/utils/app_colors.dart';
import 'package:instajobs/utils/app_styles.dart';
import 'package:get/get.dart';
import 'package:instajobs/utils/baseClass.dart';
import 'package:instajobs/views/jobs_tab/job_details_page.dart';

class JobsPage extends StatefulWidget {
  const JobsPage({super.key});

  @override
  State<JobsPage> createState() => _JobsPageState();
}

class _JobsPageState extends State<JobsPage> with BaseClass {
  JobTabController jobTabController = Get.put(JobTabController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    jobTabController.getJobsApi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.greyBackground,
      body: GetBuilder<JobTabController>(
        init: jobTabController,
        builder: (snapshot) {
          return snapshot.jobsList == null
              ? Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.primaryColor,
                  ),
                ),
              )
              : ListView.builder(
                itemCount: snapshot.jobsList?.length ?? 0,
                padding: EdgeInsets.symmetric(horizontal: 16),
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      pushToNextScreen(
                        context: context,
                        destination: JobDetailsPage(
                          jobId:
                              snapshot.jobsList
                                  ?.elementAt(index)
                                  ?.id
                                  .toString() ??
                              '0',
                        ),
                      );
                    },
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
                            'Posted 3 Months Ago',
                            style: AppStyles.font500_14().copyWith(
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            snapshot.jobsList?.elementAt(index)?.title ?? '',
                            style: AppStyles.font700_16().copyWith(
                              color: AppColors.primaryColor,
                            ),
                          ),
                          SizedBox(height: 4),
                          Row(
                            children: [
                              getCurrencyCode(),
                              SizedBox(width: 5),
                              Text(
                                'Budget: ${snapshot.jobsList?.elementAt(index)?.totalBudgets ?? ''}',
                                style: AppStyles.font500_14().copyWith(
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 4),
                          Text(
                            snapshot.jobsList?.elementAt(index)?.descriptions ??
                                '',
                            style: AppStyles.font700_12().copyWith(
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 4),
                          Divider(),
                          SizedBox(height: 4),
                          Row(
                            children: [
                              Text(
                                'Proposals',
                                style: AppStyles.font500_14().copyWith(
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                ': ${snapshot.jobsList?.elementAt(index)?.totalProposals ?? ''}',
                                style: AppStyles.font500_14().copyWith(
                                  color: AppColors.green,
                                ),
                              ),
                            ],
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

  Widget getCurrencyCode() {
    return CircleAvatar(
      radius: 8,
      backgroundColor: Colors.orange,
      child: Text(
        '₦',
        style: TextStyle(
          fontSize: 10,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
