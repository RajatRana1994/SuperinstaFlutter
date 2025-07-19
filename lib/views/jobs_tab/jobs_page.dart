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
    jobTabController.getJobsApi(isInitialLoad: true);
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
              : NotificationListener<ScrollNotification>(
            onNotification: (scrollNotification) {
              if (scrollNotification is ScrollEndNotification &&
                  scrollNotification.metrics.pixels ==
                      scrollNotification.metrics.maxScrollExtent) {
                jobTabController.getJobsApi(); // Load next page
              }
              return false;
            },
            child: RefreshIndicator(
              onRefresh: () async {
                await jobTabController.getJobsApi(isInitialLoad: true);
              },
              child: ListView.builder(
                itemCount: snapshot.jobsList?.length == null
                    ? 0
                    : snapshot.jobsList!.length , // 👈 Add 1 for loader
                padding: EdgeInsets.symmetric(horizontal: 16),
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {


                  // 👇 Existing job item UI
                  final job = snapshot.jobsList.elementAt(index);
                  final int? timestamp = job?.created;
                  String timeAgoText = 'Posted recently';
                  if (timestamp != null) {
                    final createdDate = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
                    final diff = DateTime.now().difference(createdDate);
                    if (diff.inDays >= 30) {
                      final months = (diff.inDays / 30).floor();
                      timeAgoText = 'Posted $months month${months > 1 ? 's' : ''} ago';
                    } else if (diff.inDays >= 1) {
                      timeAgoText = 'Posted ${diff.inDays} day${diff.inDays > 1 ? 's' : ''} ago';
                    } else if (diff.inHours >= 1) {
                      timeAgoText = 'Posted ${diff.inHours} hour${diff.inHours > 1 ? 's' : ''} ago';
                    } else if (diff.inMinutes >= 1) {
                      timeAgoText = 'Posted ${diff.inMinutes} minute${diff.inMinutes > 1 ? 's' : ''} ago';
                    } else if (diff.inSeconds >= 1) {
                      timeAgoText = 'Posted ${diff.inSeconds} second${diff.inSeconds > 1 ? 's' : ''} ago';
                    } else {
                      timeAgoText = 'Posted just now';
                    }
                  }

                  return GestureDetector(
                    onTap: () {
                      pushToNextScreen(
                        context: context,
                        destination: JobDetailsPage(
                          jobId: job?.id?.toString() ?? '0',
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(16),
                      margin: EdgeInsets.only(bottom: 8, top: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(width: 1, color: Color(0xFFECECEC)),
                        color: Colors.white,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(timeAgoText, style: AppStyles.font500_12().copyWith(color: Color(0xFF2D2B2B))),
                          SizedBox(height: 4),
                          Text(job?.title ?? '', style: AppStyles.font700_14().copyWith(color: AppColors.btncolor)),
                          SizedBox(height: 4),
                          Row(
                            children: [
                              getCurrencyCode(),
                              SizedBox(width: 5),
                              Text(
                                'Budget: ${job?.totalBudgets ?? ''}',
                                style: AppStyles.font500_12().copyWith(color: Color(0xFF2D2B2B)),
                              ),
                            ],
                          ),
                          SizedBox(height: 4),
                          Text(job?.descriptions ?? '', style: AppStyles.font500_12().copyWith(color: Colors.black)),
                          SizedBox(height: 4),
                          Divider(),
                          SizedBox(height: 4),
                          Row(
                            children: [
                              Text('Proposals', style: AppStyles.font500_12().copyWith(color: Colors.black)),
                              Text(': ${job?.totalProposals ?? ''}', style: AppStyles.font700_14().copyWith(color: AppColors.green)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),



          );

        },
      ),
    );
  }

  Widget getCurrencyCode() {
    return CircleAvatar(
      radius: 16,
      backgroundColor: Colors.orange,
      child: Text(
        '₦',
        style: TextStyle(
          fontSize: 17,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
