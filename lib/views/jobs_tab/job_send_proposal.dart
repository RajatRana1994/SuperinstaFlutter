import 'package:flutter/material.dart';
import 'package:instajobs/models/job_details_model.dart';
import 'package:instajobs/utils/baseClass.dart';

import 'package:instajobs/widgets/currency_widget.dart';
import 'package:instajobs/widgets/rounded_edged_button.dart';
import '../../controllers/job_controller/job_tab_controller.dart';
import 'package:get/get.dart';
import 'package:instajobs/storage_services/local_stoage_service.dart';
import '../../utils/app_colors.dart';
import 'package:instajobs/widgets/currency_widget.dart';
import 'package:instajobs/widgets/form_input_with_hint_on_top.dart';
import '../../utils/app_styles.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instajobs/bottom_sheets/choose_image_bottom_sheet.dart';

class SendProposal extends StatefulWidget {
  final JobDetailsModelData proposal;
  const SendProposal({Key? key, required this.proposal}) : super(key: key);

  @override
  State<SendProposal> createState() => _SendProposalState();
}

enum PaymentType { milestone, project }

class _SendProposalState extends State<SendProposal> with BaseClass {
  JobTabController jobTabController = Get.put(JobTabController());
  List<MilestoneModel> milestones = [MilestoneModel()];
  PaymentType? _selectedType = PaymentType.milestone;
  //TextEditingController _totalAmountController = TextEditingController();
  double _serviceFee = 0;
  double _freelancerReceives = 0;

  @override
  void initState() {
    super.initState();
    jobTabController.totalAmountController.text = '';
    jobTabController.proposalDescription.text = '';
    jobTabController.pickedImages = [];
    jobTabController.totalAmountController.addListener(() {
      if (_selectedType == PaymentType.project) {
        calculatePaymentValues();
      }
    });
  }

  void calculatePaymentValues() {
    double total = 0;

    if (_selectedType == PaymentType.project) {
      total = double.tryParse(jobTabController.totalAmountController.text) ?? 0;
    } else if (_selectedType == PaymentType.milestone) {
      for (var milestone in milestones) {
        total += double.tryParse(milestone.amountController.text) ?? 0;
      }
    }

    setState(() {
      _serviceFee = total * 0.10;
      _freelancerReceives = total * 0.90;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.greyBackground,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: Text(
          'Send Proposal',
          style: TextStyle(
            color: AppColors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      body: GetBuilder<JobTabController>(
        builder: (controller) {
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Terms',
                  style: AppStyles.font700_18().copyWith(
                    color: AppColors.labelColor,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'How do you want to be paid?',
                  style: AppStyles.font600_14().copyWith(
                    color: AppColors.labelColor,
                  ),
                ),
                RadioListTile<PaymentType>(
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                  visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                  title: Text(
                    'By Milestone',
                    style: AppStyles.font600_14().copyWith(
                      color: AppColors.labelColor,
                    ),
                  ),
                  value: PaymentType.milestone,
                  groupValue: _selectedType,
                  onChanged: (PaymentType? value) {
                    setState(() {
                      _selectedType = value;
                    });
                  },
                  activeColor: AppColors.primaryColor,
                ),
                Text(
                  'Divide the project into smaller segments, called milestone. You will be paid as they are completed and approved.',
                  style: AppStyles.font400_14().copyWith(
                    color: AppColors.labelColor,
                  ),
                ),
                SizedBox(height: 10),
                RadioListTile<PaymentType>(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    'By Project',
                    style: AppStyles.font600_14().copyWith(
                      color: AppColors.labelColor,
                    ),
                  ),
                  value: PaymentType.project,
                  visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                  groupValue: _selectedType,
                  onChanged: (PaymentType? value) {
                    setState(() {
                      _selectedType = value;
                    });
                  },
                  activeColor: AppColors.primaryColor,
                ),
                Text(
                  'Get your entire payment at the end, when all work has been delivered',
                  style: AppStyles.font400_14().copyWith(
                    color: AppColors.labelColor,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  (_selectedType == PaymentType.milestone)
                      ? 'How many milestone do you want to include'
                      : 'What is the full amount you like to bid for this job?\nBid',
                  style: AppStyles.font700_14().copyWith(
                    color: AppColors.labelColor,
                  ),
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _selectedType == PaymentType.project
                      ? [
                    // Your existing 'project' layout
                    SizedBox(height: 5),
                    Text(
                      'Total amount the client will see on your proposal',
                      style: AppStyles.font500_14().copyWith(
                        color: AppColors.labelColor,
                      ),
                    ),
                    SizedBox(height: 5),
                    FormInputWithHint(
                      label: 'Total amount the client will see on your proposal',
                      showLabel: false,
                      hintText: '0',
                      borderColor: AppColors.borderColor,
                      isDigitsOnly: true,
                      isEnabled: true,
                      keyboardType: TextInputType.number,
                      controller: jobTabController.totalAmountController,
                      prefixIcon: GetCurrencyWidget(fontSize: 20),
                    ),
                    SizedBox(height: 15),

                  ]
                      : [
                    ...milestones.asMap().entries.map((entry) {
                      int index = entry.key;
                      MilestoneModel milestone = entry.value;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 15),
                          Row(
                            children: [
                              Expanded(
                                child: FormInputWithHint(
                                  label: '${index + 1}. Description',
                                  showLabel: true,
                                  hintText: 'Enter description',
                                  borderColor: AppColors.borderColor,
                                  isDigitsOnly: false,
                                  isEnabled: true,
                                  controller: milestone.descriptionController,
                                ),
                              ),
                              if (milestones.length > 1)
                                IconButton(
                                  icon: Icon(Icons.close, color: Colors.red),
                                  onPressed: () {
                                    setState(() {
                                      milestones.removeAt(index);
                                      calculatePaymentValues(); // Recalculate amounts
                                    });
                                  },
                                ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () async {
                                    DateTime? pickedDate = await showDatePicker(
                                      context: context,
                                      initialDate: milestone.selectedDate ?? DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime(2100),
                                    );

                                    if (pickedDate != null) {
                                      setState(() {
                                        milestone.selectedDate = pickedDate;
                                        milestone.dueDateController.text =
                                        "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                                      });
                                    }
                                  },
                                  child: AbsorbPointer(
                                    child: FormInputWithHint(
                                      label: 'Due Date',
                                      showLabel: true,
                                      hintText: 'Select date',
                                      borderColor: AppColors.borderColor,
                                      isDigitsOnly: false,
                                      isEnabled: true,
                                      controller: milestone.dueDateController,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: FormInputWithHint(
                                  label: 'Amount',
                                  showLabel: true,
                                  hintText: '0',
                                  borderColor: AppColors.borderColor,
                                  isDigitsOnly: true,
                                  isEnabled: true,
                                  controller: milestone.amountController,
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    }).toList(),

                    SizedBox(height: 20),
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          bool isValid = true;

                          for (var milestone in milestones) {
                            if (milestone.descriptionController.text.trim().isEmpty ||
                                milestone.dueDateController.text.trim().isEmpty ||
                                milestone.amountController.text.trim().isEmpty) {
                              isValid = false;
                              break;
                            }
                          }

                          if (isValid) {
                            setState(() {
                              calculatePaymentValues();
                              milestones.add(MilestoneModel());
                            });
                          } else {
                            // You can show a Snackbar, Dialog, or Toast
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Please fill all fields in existing milestones before adding a new one.'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },

                        icon: Icon(Icons.add),
                        label: Text('Add More Milestone'),
                      ),
                    ),
                  ],
                ),

                Text(
                  '10% Freelancer Service Fee',
                  style: AppStyles.font500_14().copyWith(
                    color: AppColors.labelColor,
                  ),
                ),
                SizedBox(height: 5),
                FormInputWithHint(
                  label: 'Amount',
                  showLabel: false,
                  hintText: _serviceFee.toStringAsFixed(2),
                  borderColor: AppColors.borderColor,
                  isDigitsOnly: true,
                  isEnabled: false,
                  keyboardType: TextInputType.number,
                  prefixIcon: GetCurrencyWidget(fontSize: 20),
                ),
                SizedBox(height: 15),
                Text(
                  'The estimated amount you will receive after service fees',
                  style: AppStyles.font500_14().copyWith(
                    color: AppColors.labelColor,
                  ),
                ),
                SizedBox(height: 5),
                FormInputWithHint(
                  label: 'Amount',
                  showLabel: false,
                  hintText: _freelancerReceives.toStringAsFixed(2),
                  borderColor: AppColors.borderColor,
                  isDigitsOnly: true,
                  isEnabled: false,
                  keyboardType: TextInputType.number,
                  prefixIcon: GetCurrencyWidget(fontSize: 20),
                ),
                SizedBox(height: 16),
                FormInputWithHint(
                  label: 'Your Proposal',
                  hintText: 'Enter text here',
                  maxLine: 3,
                  borderColor: AppColors.borderColor,
                  keyboardAction: TextInputAction.done,
                  controller: jobTabController.proposalDescription,
                ),
                SizedBox(height: 16),
                GestureDetector(
                  onTap: () {
                    ChooseImageBottomSheet.show(
                      context: context,
                      onCancel: () {
                        popToPreviousScreen(context: context);
                      },
                      onCamera: () {
                        popToPreviousScreen(context: context);
                        controller.pickOne(ImageSource.camera);
                      },
                      onGallery: () {
                        popToPreviousScreen(context: context);
                        controller.pickOne(ImageSource.gallery);
                      },
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 7),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.btncolor),
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: Text(
                      '+ Upload files',
                      style: AppStyles.font700_12().copyWith(
                        color: AppColors.btncolor,
                      ),
                    ),
                  ),
                ),
                GridView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: controller.pickedImages.length,
                  itemBuilder: (context, idx) {
                    return Stack(
                      children: [
                        Positioned.fill(
                          child: Image.file(
                            controller.pickedImages[idx],
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 4,
                          right: 4,
                          child: InkWell(
                            onTap: () => controller.removeImage(idx),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                shape: BoxShape.circle,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                SizedBox(height: 24),
                RoundedEdgedButton(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  buttonText: 'Submit',
                  onButtonClick: () async {
                    jobTabController.uploadImages(
                        widget.proposal.id.toString(), (_selectedType == PaymentType.project) ? '2' : '1', milestones
                    );
                    // Add your submission logic here
                  },
                ),
                SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }
}

class MilestoneModel {
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController dueDateController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  DateTime? selectedDate;
}