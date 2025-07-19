import 'package:flutter/material.dart';
import 'package:instajobs/models/job_details_model.dart';
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

class JobDetailsPage extends StatefulWidget {
  final String jobId;

  const JobDetailsPage({super.key, required this.jobId});

  @override
  State<JobDetailsPage> createState() => _JobDetailsPageState();
}

class _JobDetailsPageState extends State<JobDetailsPage> with BaseClass {
  JobTabController jobTabController = Get.put(JobTabController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    jobTabController.getJobDetailsApi(widget.jobId);
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
                      style: AppStyles.font700_16().copyWith(
                        color: AppColors.labelColor,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      getTimeAgoText(
                        snapshot.jobDetailsModelData?.created ?? 0,
                      ),
                      style: AppStyles.font500_14().copyWith(
                        color: AppColors.labelLightColor.withOpacity(0.6),
                      ),
                    ),
                    SizedBox(height: 9),
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
                                  .where(
                                    (e) => e != null && e.trim().isNotEmpty,
                                  )
                                  .join(', '),
                          style: AppStyles.font500_14().copyWith(
                            color: AppColors.labelLightColor,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
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
                        Icon(Icons.location_history, color: AppColors.orange),
                        SizedBox(width: 11),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              snapshot.jobDetailsModelData?.experience ?? '',
                              style: AppStyles.font500_14().copyWith(
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 0),
                            Text(
                              'Experience Level',
                              style: AppStyles.font500_12().copyWith(
                                color: Colors.black.withOpacity(0.6),
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
                        SizedBox(width: 11),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              snapshot.jobDetailsModelData?.totalBudgets
                                      .toString() ??
                                  '',
                              style: AppStyles.font500_14().copyWith(
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 0),
                            Text(
                              'Budget',
                              style: AppStyles.font500_12().copyWith(
                                color: Colors.black.withOpacity(0.6),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 24),
                    Divider(
                      color: Color(
                        0xFFECECEC,
                      ), // Space above and below the divider
                      thickness: 4, // Actual thickness of the line
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Skills & Expertise',
                      style: AppStyles.font700_16().copyWith(
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 14),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children:
                          snapshot.skillsList.map((skill) {
                            return Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(24),
                                color: Color(0xFFEAEAEA),
                              ),
                              child: Text(
                                skill,
                                style: AppStyles.font600_12().copyWith(
                                  color: Color(0xFF717171),
                                ),
                              ),
                            );
                          }).toList(),
                    ),

                    SizedBox(height: 24),
                    Divider(
                      color: Color(
                        0xFFECECEC,
                      ), // Space above and below the divider
                      thickness: 4, // Actual thickness of the line
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Text(
                          (StorageService().getUserData().userId ==
                                  snapshot.jobDetailsModelData?.userId
                                      .toString())
                              ? 'Proposals'
                              : 'About Client',
                          style: AppStyles.font700_16().copyWith(
                            color: Colors.black,
                          ),
                        ),
                        if (StorageService().getUserData().userId !=
                            snapshot.jobDetailsModelData?.userId
                                .toString()) ...[
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
                      ],
                    ),
                    SizedBox(height: 10),

                    (StorageService().getUserData().userId !=
                            snapshot.jobDetailsModelData?.userId.toString())
                        ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                (snapshot.jobDetailsModelData?.users?.profile ==
                                            null ||
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
                                      snapshot
                                              .jobDetailsModelData
                                              ?.users
                                              ?.name ??
                                          '',
                                      style: AppStyles.font600_14().copyWith(
                                        color: Color(0xFF2D2B2B),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                            Text(
                              snapshot.jobDetailsModelData?.users?.country ??
                                  '',
                              style: AppStyles.font500_14().copyWith(
                                color: AppColors.black,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              '${snapshot.jobDetailsModelData?.users?.totalJobPosted.toString() ?? ''} Jobs Posted',
                              style: AppStyles.font500_14().copyWith(
                                color: AppColors.black,
                              ),
                            ),
                            SizedBox(height: 8),
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
                            SizedBox(height: 8),
                            Text(
                              snapshot.jobDetailsModelData?.categories?.name
                                      ?.toString() ??
                                  '',
                              style: AppStyles.font500_14().copyWith(
                                color: AppColors.black,
                              ),
                            ),
                            (snapshot.jobDetailsModelData?.isSendProposals == 0)
                                ? Column(
                                  children: [
                                    SizedBox(height: 24),
                                    RoundedEdgedButton(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15,
                                      buttonText: 'Send Proposal',
                                      onButtonClick: () async {
                                        pushToNextScreen(
                                          context: context,
                                          destination: SendProposal(proposal: snapshot.jobDetailsModelData!),
                                        );
                                      },
                                    ),
                                  ],
                                )
                                : SizedBox(height: 24),
                          ],
                        )
                        : Padding(
                          padding: const EdgeInsets.symmetric(vertical: 0),
                          child: buildJobProposalList(
                            snapshot.jobDetailsModelData?.jobProposals ?? [],
                          ),
                        ),
                  ],
                ),
              );
        },
      ),
    );
  }

  Widget buildJobProposalList(
    List<JobDetailsModelDataJobProposals?> proposals,
  ) {
    if (proposals.isEmpty) {
      return const Text('No proposals found.');
    }

    return ListView.builder(
      itemCount: proposals.length,
      padding: EdgeInsets.symmetric(horizontal: 0),
      shrinkWrap: true, // Makes ListView size itself to children
      physics: const NeverScrollableScrollPhysics(), // Prevent inner scroll
      itemBuilder: (context, index) {
        final proposal = proposals[index];
        final name = proposal?.users?.name ?? '';
        final userId = proposal?.users?.id.toString() ?? '';
        final description = proposal?.description ?? '';
        final images = proposal?.users?.profile ?? '';
        final idProposal = proposal?.id?.toString() ?? '';
        final status = proposal?.isAccept.toString() ?? '';

        final proposalAmount = proposal?.requestBudget.toString();

        return Container(
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ((images.isEmpty ?? true))
                      ? SizedBox()
                      : ClipRRect(
                        borderRadius: BorderRadius.circular(40),
                        child: Image(
                          image: NetworkImage(images),
                          fit: BoxFit.cover,
                          height: 48,
                          width: 48,
                        ),
                      ),
                  SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: AppStyles.font600_14().copyWith(
                          color: Color(0xFF2D2B2B),
                        ),
                      ),
                    ],
                  ),
                  Spacer(),

                  GetCurrencyWidget(radius: 12, fontSize: 14),
                  SizedBox(width: 11),
                  Text(
                    proposalAmount!,
                    style: AppStyles.font500_14().copyWith(color: Colors.black),
                  ),
                ],
              ),

              SizedBox(height: 4),
              Text(
                description,
                style: AppStyles.font500_14().copyWith(
                  color: AppColors.labelLightColor.withOpacity(0.6),
                ),
              ),
              SizedBox(height: 4),
              if (status == "0") ...[
                Row(
                  children: [
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
                          showDialog(
                            context: context,
                            builder:
                                (context) => buildJobProposalDialog(
                                  context,
                                  'Accept',
                                  userId,
                                  proposalAmount,
                                  idProposal,
                                ),
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
                          showDialog(
                            context: context,
                            builder:
                                (context) => buildJobProposalDialog(
                                  context,
                                  'Reject',
                                  userId,
                                  proposalAmount,
                                  idProposal,
                                ),
                          );
                          // Handle button click
                        },
                      ),
                    ),
                    Expanded(
                      child: RoundedEdgedButton(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        height: 49,
                        buttonText: 'View Proposal',
                        onButtonClick: () async {
                          pushToNextScreen(
                            context: context,
                            destination: JobViewProposal(proposal: proposal!),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget buildJobProposalDialog(
    BuildContext context,
    String type,
    String assignUserid,
    String amount,
    String proposalId,
  ) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Confirmation',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),
            Text(
              type == 'Accept'
                  ? 'Are you sure to Accept this Proposal? Please make sure that Applied proposal Freelancer have required experience and skills'
                  : 'Review the Proposal Again: Double-check whether the freelancer has the right skills and experience for the job. Sometimes, a quick second review might reveal things you missed. Consider the Potential Impact: if you reject this proposal, are there other proposals on the table? Would rejecting it mean losing a potentially good candidate for your project?',

              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: RoundedEdgedButton(
                    height: 40,
                    backgroundColor: Colors.green,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    borderColor: Colors.white,
                    buttonText: 'Yes',
                    onButtonClick: () {
                      if (type == 'Accept') {
                        jobTabController.acceptJobApi(
                          widget.jobId,
                          assignUserid,
                          amount,
                          proposalId,
                          () {
                            jobTabController.getJobDetailsApi(widget.jobId);
                            Navigator.of(context).pop();
                          },
                        );
                      } else {
                        jobTabController.rejectJobApi(proposalId, () {
                          jobTabController.getJobDetailsApi(widget.jobId);
                          Navigator.of(context).pop();
                        });
                      }

                      // You can add an else if you want to handle other types
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: RoundedEdgedButton(
                    height: 40,
                    backgroundColor: Colors.red,
                    fontSize: 14,
                    borderColor: Colors.white,
                    fontWeight: FontWeight.w600,
                    buttonText: 'No',
                    onButtonClick: () {
                      Navigator.of(context).pop();
                      // Handle reject logic
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
