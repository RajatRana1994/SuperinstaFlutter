import 'package:flutter/material.dart';
import 'package:instajobs/models/job_details_model.dart';
import 'package:instajobs/views/jobs_tab/jobFlag_page.dart';
import 'package:instajobs/views/jobs_tab/job_view_proposal.dart';
import 'package:instajobs/views/jobs_tab/job_send_proposal.dart';
import 'package:instajobs/utils/baseClass.dart';
import 'package:instajobs/widgets/currency_widget.dart';
import 'package:instajobs/widgets/rounded_edged_button.dart';
import '../../controllers/job_controller/job_tab_controller.dart';
import 'package:get/get.dart';
import 'package:instajobs/storage_services/local_stoage_service.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_styles.dart';
import 'package:instajobs/views/my_bookings/bookingRating.dart';

class JobDetailsPageNew extends StatefulWidget {
  final String jobId;
  const JobDetailsPageNew({super.key, required this.jobId});

  @override
  State<JobDetailsPageNew> createState() => _JobDetailsPageNewState();
}

class _JobDetailsPageNewState extends State<JobDetailsPageNew> with BaseClass {
  JobTabController jobTabController = Get.put(JobTabController());
  int selectedIndexs = 0;
  bool userType = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    jobTabController.getAppSetting();
    jobTabController.getJobDetailsApi(widget.jobId).then((_) {
      userType =
          (StorageService().getUserData().userId ==
              jobTabController.jobDetailsModelData?.userId.toString());
      final totalMilestones =
          jobTabController.jobDetailsModelData?.totalJobMileStones ?? 0;
      if (totalMilestones == 0) {
        setState(() {
          selectedIndexs = 1; // Default to Details
        });
      } else {
        setState(() {
          selectedIndexs = 0; // Default to Milestones
        });
      }
    });
  }

  String getTimeAgoText(int? timestamp) {
    if (timestamp == null) return 'Posted recently';

    final createdDate = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    final diff = DateTime.now().difference(createdDate);

    if (diff.inDays >= 30) {
      final months = (diff.inDays / 30).floor();
      return 'Posted $months month${months > 1 ? 's' : ''} ago';
    } else if (diff.inDays >= 1) {
      return 'Posted ${diff.inDays} day${diff.inDays > 1 ? 's' : ''} ago';
    } else if (diff.inHours >= 1) {
      return 'Posted ${diff.inHours} hour${diff.inHours > 1 ? 's' : ''} ago';
    } else if (diff.inMinutes >= 1) {
      return 'Posted ${diff.inMinutes} minute${diff.inMinutes > 1 ? 's' : ''} ago';
    } else if (diff.inSeconds >= 1) {
      return 'Posted ${diff.inSeconds} second${diff.inSeconds > 1 ? 's' : ''} ago';
    } else {
      return 'Posted just now';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.greyBackground,
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
          final acceptedProposals =
              snapshot.jobDetailsModelData?.jobProposals
                  ?.where((p) => (p?.isAccept == 1))
                  .toList() ??
              [];

          final milestones = snapshot.jobDetailsModelData?.jobMileStones ?? [];
          final completed =
              milestones
                  .where((m) => m?.status == 3 && m?.isPaid == 1)
                  .toList();
          final pending =
              milestones
                  .where((m) => !(m?.status == 3 && m?.isPaid == 1))
                  .toList()
                  .reversed
                  .toList();

          if (snapshot.jobDetailsModelData == null) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppColors.primaryColor,
                ),
              ),
            );
          } else {
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    snapshot.jobDetailsModelData?.title ?? '',
                    style: AppStyles.font700_16().copyWith(
                      color: AppColors.labelColor,
                    ),
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.location_pin,
                        color: AppColors.labelLightColor.withOpacity(0.6),
                      ),
                      SizedBox(width: 6),
                      Text(
                        (snapshot.jobDetailsModelData?.isAnyWhere == 1)
                            ? 'Anywhere'
                            : [
                                  snapshot.jobDetailsModelData?.state,
                                  snapshot.jobDetailsModelData?.country,
                                ]
                                .where((e) => e != null && e.trim().isNotEmpty)
                                .join(', '),
                        style: AppStyles.font500_14().copyWith(
                          color: AppColors.labelLightColor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),

                  if (selectedIndexs != 2) ...[
                    Text(
                      snapshot.jobDetailsModelData?.descriptions ?? '',
                      style: AppStyles.font500_14().copyWith(
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                                height: 48,
                                width: 48,
                              ),
                            ),
                        SizedBox(width: 14),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              snapshot.jobDetailsModelData?.users?.name ?? '',
                              style: AppStyles.font600_14().copyWith(
                                color: Color(0xFF2D2B2B),
                              ),
                            ),
                            Text(
                              "${snapshot.jobDetailsModelData?.users?.state ?? ''}, ${snapshot.jobDetailsModelData?.users?.country ?? ''}",
                              style: AppStyles.font500_14().copyWith(
                                color: AppColors.black,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                  ],

                  Row(
                    children: [
                      if (snapshot.jobDetailsModelData?.totalJobMileStones !=
                          0) ...[
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              selectedIndexs = 0;
                              setState(() {});
                            },
                            child: Container(
                              height: 42,
                              decoration: BoxDecoration(
                                color:
                                    selectedIndexs == 0
                                        ? Colors.orange
                                        : Colors.orange.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(
                                  'Milestones',
                                  style: AppStyles.font500_14().copyWith(
                                    color:
                                        selectedIndexs == 0
                                            ? Colors.white
                                            : Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                      ],

                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            selectedIndexs = 1;
                            setState(() {});
                          },
                          child: Container(
                            height: 42,
                            decoration: BoxDecoration(
                              color:
                                  selectedIndexs == 1
                                      ? Colors.orange
                                      : Colors.orange.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                'Details',
                                style: AppStyles.font500_14().copyWith(
                                  color:
                                      selectedIndexs == 1
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
                            selectedIndexs = 2;
                            setState(() {});
                          },
                          child: Container(
                            height: 42,
                            decoration: BoxDecoration(
                              color:
                                  selectedIndexs == 2
                                      ? Colors.orange
                                      : Colors.orange.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                'Chat Box',
                                style: AppStyles.font500_14().copyWith(
                                  color:
                                      selectedIndexs == 2
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

                  if (selectedIndexs == 0) ...[
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                (snapshot
                                            .jobDetailsModelData
                                            ?.jobMileStonesPaid ??
                                        9)
                                    .toString(),
                                style: AppStyles.font500_14().copyWith(
                                  color: AppColors.labelColor,
                                ),
                              ),
                              Text(
                                'Milestone Paid',
                                style: AppStyles.font700_14().copyWith(
                                  color: AppColors.labelColor,
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                ((snapshot
                                                .jobDetailsModelData
                                                ?.jobMileStonesBudget ??
                                            0) -
                                        (snapshot
                                                .jobDetailsModelData
                                                ?.jobMileStonesPaid ??
                                            0))
                                    .toString(),
                                style: AppStyles.font500_14().copyWith(
                                  color: AppColors.labelColor,
                                ),
                              ),
                              Text(
                                'Remaining',
                                style: AppStyles.font700_14().copyWith(
                                  color: AppColors.labelColor,
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                (snapshot
                                            .jobDetailsModelData
                                            ?.jobMileStonesBudget ??
                                        0)
                                    .toString(),
                                style: AppStyles.font500_14().copyWith(
                                  color: AppColors.labelColor,
                                ),
                              ),
                              Text(
                                'Total Budget',
                                style: AppStyles.font700_14().copyWith(
                                  color: AppColors.labelColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    _buildSection("Pending Milestones", pending),
                    _buildSection("Completed Milestones", completed),
                  ],

                  if (selectedIndexs == 1) ...[
                    SizedBox(height: 16),
                    Text(
                      'Description',
                      style: AppStyles.font700_16().copyWith(
                        color: AppColors.labelColor,
                      ),
                    ),
                    Text(
                      acceptedProposals.first?.description ?? '',
                      style: AppStyles.font500_14().copyWith(
                        color: AppColors.labelColor,
                      ),
                    ),
                    SizedBox(height: 5),
                    Divider(
                      color: Color(
                        0xFFECECEC,
                      ), // Space above and below the divider
                      thickness: 6, // Actual thickness of the line
                    ),

                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                (snapshot.jobDetailsModelData?.acceptedBudget ??
                                        9)
                                    .toString(),
                                style: AppStyles.font500_14().copyWith(
                                  color: AppColors.labelColor,
                                ),
                              ),
                              Text(
                                'Total Budget',
                                style: AppStyles.font700_14().copyWith(
                                  color: AppColors.labelColor,
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                (snapshot.jobDetailsModelData?.devilryTime ?? 9)
                                    .toString(),
                                style: AppStyles.font500_14().copyWith(
                                  color: AppColors.labelColor,
                                ),
                              ),
                              Text(
                                'Delivery time',
                                style: AppStyles.font700_14().copyWith(
                                  color: AppColors.labelColor,
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                (snapshot
                                            .jobDetailsModelData
                                            ?.totalJobMileStones ??
                                        9)
                                    .toString(),
                                style: AppStyles.font500_14().copyWith(
                                  color: AppColors.labelColor,
                                ),
                              ),
                              Text(
                                'Milestones',
                                style: AppStyles.font700_14().copyWith(
                                  color: AppColors.labelColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Divider(
                      color: Color(
                        0xFFECECEC,
                      ), // Space above and below the divider
                      thickness: 6, // Actual thickness of the line
                    ),

                    Text(
                      'Attachments',
                      style: AppStyles.font700_16().copyWith(
                        color: AppColors.labelColor,
                      ),
                    ),

                    if (acceptedProposals.first?.attachments?.isEmpty ??
                        true ||
                            (acceptedProposals.first?.attachments?.isEmpty ??
                                true)) ...[
                      Text(
                        'No Attachments',
                        style: AppStyles.font500_14().copyWith(
                          color: AppColors.labelColor,
                        ),
                      ),
                    ] else ...[
                      SizedBox(
                        height: 120, // enough space for 100x100 + padding
                        child: GridView.builder(
                          scrollDirection: Axis.horizontal,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 1, // one row
                                mainAxisSpacing: 8,
                                childAspectRatio: 1, // 100x100 square
                              ),
                          itemCount:
                              acceptedProposals.first?.attachments!.length,
                          itemBuilder: (context, index) {
                            final attachment =
                                acceptedProposals.first?.attachments?[index];

                            return Container(
                              width: 100,
                              height: 100,
                              margin: const EdgeInsets.only(right: 8),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child:
                                    attachment?.name != null
                                        ? Image.network(
                                          attachment!.name!,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  const Icon(
                                                    Icons.broken_image,
                                                  ),
                                        )
                                        : const Icon(
                                          Icons.insert_drive_file,
                                        ), // fallback for non-image files
                              ),
                            );
                          },
                        ),
                      ),
                    ],


                    if (snapshot.jobDetailsModelData?.isSubmit == 1 && snapshot.jobDetailsModelData?.isJobEnd == 0) ... [
                      SizedBox(height: 10),
                      Text(
                        'Work is submitted to review. If you are satisfied with work please update on it.',
                        style: AppStyles.font500_16().copyWith(
                          color: AppColors.labelColor,
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Spacer(),
                          Expanded(
                            child: RoundedEdgedButton(
                              height: 49,
                              rightMargin: 10,
                              leftMargin: 10,
                              backgroundColor: Colors.green,
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                              borderColor: Colors.white,
                              buttonText: 'Accept',
                              onButtonClick: () async {
                                jobTabController.acceptJob(widget.jobId,
                                );
                                // Handle button click
                              },
                            ),
                          ),
                          Expanded(
                            child: RoundedEdgedButton(
                              rightMargin: 10,
                              height: 49,
                              fontWeight: FontWeight.w700,
                              backgroundColor: Colors.red,
                              fontSize: 15,
                              buttonText: 'Reject',
                              onButtonClick: () async {
                                jobTabController.rejectJob(widget.jobId,
                                );
                                // Handle button click
                              },
                            ),
                          ),

                        ],
                      ),
                    ],

                  ],
                ],
              ),
            );
          }
        },
      ),

      bottomNavigationBar: GetBuilder<JobTabController> (
        builder:(controller) {
          final job = controller.jobDetailsModelData;
          if (job?.isRated == 1) return SizedBox.shrink();

          return Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 40),
            child: RoundedEdgedButton(
              fontWeight: FontWeight.w700,
              fontSize: 15,
              buttonText:
              jobTabController.jobDetailsModelData?.isJobEnd == 1 ? "Give Rate & Review" : (userType == false &&
                  jobTabController
                      .jobDetailsModelData
                      ?.jobMileStones
                      ?.length ==
                      0 && jobTabController.jobDetailsModelData?.isSubmit == 0)
                  ? 'Submit Work' : (userType == false &&
                  jobTabController
                      .jobDetailsModelData
                      ?.jobMileStones
                      ?.length ==
                      0 && jobTabController.jobDetailsModelData?.isSubmit == 2) ? 'Re-Submit Work' :
              (userType == false && jobTabController.jobDetailsModelData?.jobMileStones?.length == 0 &&
                  jobTabController.jobDetailsModelData?.isSubmit == 1) ? 'Job work is submitted and in review' : 'End This Contract',
              onButtonClick: () async {
                if (jobTabController.jobDetailsModelData?.isJobEnd == 1) {
                  final bookingId = widget.jobId;
                  String userId = '';
                  if (userType == false) {
                    userId =
                        (jobTabController.jobDetailsModelData?.userId ?? 0)
                            .toString();
                  } else {
                    userId =
                        (jobTabController
                            .jobDetailsModelData
                            ?.assignUserId ??
                            0)
                            .toString();
                  }
                  print(bookingId);
                  print(StorageService().getUserData().userId);
                  pushToNextScreen(
                    context: context,
                    destination: Bookingrating(
                      bookingId: '',
                      userId: userId.toString(),
                      jobId: bookingId,
                    ),
                  );
                } else if (userType == false && jobTabController.jobDetailsModelData?.jobMileStones?.length == 0 && jobTabController.jobDetailsModelData?.isSubmit == 0) {
                  print('submit work');
                  jobTabController.submitJob(widget.jobId,
                  );
                } else if (userType == false && jobTabController.jobDetailsModelData?.jobMileStones?.length == 0 && jobTabController.jobDetailsModelData?.isSubmit == 2) {
                  print('submit work');
                  jobTabController.submitJob(widget.jobId,
                  );
                } else {
                  print('submit work end');
                }

                // Your submission logic here
              },
            ),
          );
        }
      ),
          
    );
  }

  Widget _buildSection(String title, List<Milestone?> items) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section title
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          const Divider(height: 1),
          // List of milestones
          ...items.asMap().entries.map((entry) {
            final index = entry.key + 1;
            final milestone = entry.value;
            final status = milestone?.status ?? 0;
            var statustext = (status == 3) ? '' : '(Pending)';

            String getButtonText(int status, bool userType) {
              if (status == 1 && userType == true) {
                return "Submit";
              } else if (status == 2 && userType == true) {
                return "In-Review";
              } else if (status == 2 && userType == false) {
                return "Accept";
              } else if (status == 4 && userType == true) {
                return "Re-Submit";
              } else {
                return "Complete";
              }
            }

            var userType =
                (StorageService().getUserData().userId ==
                    milestone?.userId.toString());
            final buttonText = getButtonText(status, userType);
            if (milestone == null) return const SizedBox.shrink();
            return Container(
              color: index.isEven ? Colors.grey.shade50 : Colors.white,
              child: ListTile(
                title: Text("$index. ${milestone.description}"),
                subtitle: Text("${milestone.price} ${statustext}"),
                trailing:
                    (status != 3 && status != 0)
                        ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                if (buttonText == "Submit" ||
                                    buttonText == "Re-Submit") {
                                  jobTabController.submitJobMilestone(
                                    milestone.id.toString(),
                                    widget.jobId,
                                  );
                                }
                                print("Button pressed: $buttonText");
                                // handle accept
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                minimumSize: const Size(70, 36),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                              ),
                              child: Text(
                                (status == 1 && userType == true)
                                    ? "Submit"
                                    : (status == 2 && userType == true)
                                    ? 'In-Review'
                                    : (status == 2 && userType == false)
                                    ? 'Accept'
                                    : (status == 4 && userType == true)
                                    ? 'Re-Submit'
                                    : 'Complete',
                                style: TextStyle(fontSize: 12),
                              ),
                            ),

                            if (status == 2 && userType == false) ...[
                              const SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: () {
                                  jobTabController.rejectJobMilestone(
                                    milestone.id.toString(),
                                    widget.jobId,
                                  );
                                  // handle reject
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  minimumSize: const Size(70, 36),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                ),
                                child: const Text(
                                  "Reject",
                                  style: TextStyle(fontSize: 12),
                                ),
                              ),
                            ],
                          ],
                        )
                        : (status == 0 && index == 1 && userType == false)
                        ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                jobTabController.startJobMileStone(
                                  milestone.id.toString(),
                                  widget.jobId,
                                );
                                // handle reject
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                minimumSize: const Size(70, 36),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                              ),
                              child: const Text(
                                "Start",
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                          ],
                        )
                        : null,
              ),
            );
          }),
        ],
      ),
    );
  }
}
