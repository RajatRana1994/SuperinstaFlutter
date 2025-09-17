import 'package:flutter/material.dart';
import 'package:instajobs/models/job_details_model.dart';

import 'package:instajobs/widgets/currency_widget.dart';
import 'package:instajobs/widgets/rounded_edged_button.dart';
import '../../controllers/job_controller/job_tab_controller.dart';
import 'package:get/get.dart';
import 'package:instajobs/storage_services/local_stoage_service.dart';
import '../../utils/app_colors.dart';
import 'package:instajobs/widgets/currency_widget.dart';
import 'package:instajobs/widgets/form_input_with_hint_on_top.dart';
import '../../utils/app_styles.dart';

class JobViewProposal extends StatefulWidget {
  final JobDetailsModelDataJobProposals proposal;
  const JobViewProposal({Key? key, required this.proposal}) : super(key: key);
  // const JobViewProposal({super.key});


  @override
  State<JobViewProposal> createState() => _JobViewProposalState();
}

class _JobViewProposalState extends State<JobViewProposal> {
  @override

  String calculateServiceFee(dynamic amount, dynamic percent) {
    if (amount == null) return '0';
    final numValue = num.tryParse(amount.toString()) ?? 0;
    final serviceFee = numValue * percent;
    return serviceFee.toStringAsFixed(2);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.greyBackground,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: Text(
          'View Proposal',
          style: TextStyle(
            color: AppColors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Terms',
              style: AppStyles.font700_16().copyWith(
                color: AppColors.labelColor,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Freelancer will be paid ${widget.proposal.requestBudget ?? '0'}',
              style: AppStyles.font500_16().copyWith(
                color: AppColors.labelColor,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'By ${(widget.proposal.type == 2) ? 'Project' : 'Milestone'}',
              style: AppStyles.font700_16().copyWith(
                color: AppColors.green,
              ),
            ),
            SizedBox(height: 4),

            if (widget.proposal.type == 1) ... [
              Text(
                'Included Milestone',
                style: AppStyles.font700_16().copyWith(
                  color: AppColors.labelColor,
                ),
              ),
              SizedBox(height: 4),
            ],
            SizedBox(height: 20),

            FormInputWithHint(
              label: '10% SuperInstajobs Service Fee',
              hintText: '${calculateServiceFee(widget.proposal.requestBudget, 0.10)}',
              borderColor: AppColors.borderColor,
              isDigitsOnly: true,
              isEnabled: false,
              keyboardType: TextInputType.number,

              prefixIcon: GetCurrencyWidget(fontSize: 20),
            ),

            SizedBox(height: 20),

            FormInputWithHint(
              label: 'Customer will Receive\nThe estimated amount freelance will receive after service fees',
              hintText: '${calculateServiceFee(widget.proposal.requestBudget, 0.90)}',
              borderColor: AppColors.borderColor,
              isDigitsOnly: true,
              isEnabled: false,
              keyboardType: TextInputType.number,

              prefixIcon: GetCurrencyWidget(fontSize: 20),
            ),

            SizedBox(height: 20),
            Text(
              'Attachments',
              style: AppStyles.font700_16().copyWith(
                color: AppColors.labelColor,
              ),
            ),
            SizedBox(height: 8),

            if (widget.proposal.attachments != null && widget.proposal.attachments!.isNotEmpty)
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: widget.proposal.attachments!.map((attachment) {
                  // Only show image attachments (mediaType == 1)
                  if (attachment.mediaType == 1 && attachment.name != null) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        attachment.name!,
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Container(height: 100, width: 100, color: Colors.grey[300]),
                      ),
                    );
                  } else {
                    return SizedBox(); // skip non-image attachments
                  }
                }).toList(),
              )
            else
              Text(
                'No attachments found.',
                style: AppStyles.font500_14().copyWith(color: Colors.grey),
              ),

          ],
        ),
      ),
    );
  }
}
