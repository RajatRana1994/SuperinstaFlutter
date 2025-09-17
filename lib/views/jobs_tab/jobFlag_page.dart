import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instajobs/models/job_details_model.dart';
import 'package:instajobs/controllers/feed_tab_controller.dart';
import 'package:instajobs/utils/baseClass.dart';
import '../../utils/app_colors.dart';
import 'package:instajobs/widgets/form_input_with_hint_on_top.dart';

class JobflagPage extends StatefulWidget {
  final JobDetailsModelData proposal;
  const JobflagPage({Key? key, required this.proposal}) : super(key: key);

  @override
  State<JobflagPage> createState() => _JobflagPageState();
}

class _JobflagPageState extends State<JobflagPage> with BaseClass{
  FeedTabController feedTabController = Get.put(FeedTabController());
  int _selectedIndex = 0; // keep track of selected option
  TextEditingController proposalDescription = TextEditingController();
  final List<String> _reportReasons = [
    "Client is asking to work outside SuperInstaJobs.",
    "Client is attempting to get contact information.",
    "Client is misrepresenting their identity.",
    "Client is posting fake Jobs.",
    "It's something else.",
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: double.infinity, // 👈 Make it full width
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start, // Optional: aligns title to left
            children: [
              // ✅ Options List
              Column(
                children: List.generate(_reportReasons.length, (index) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        _selectedIndex = index;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 8,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              _reportReasons[index],
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          Container(
                            width: 22,
                            height: 22,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: AppColors.btncolor,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(
                                4,
                              ), // square shape
                              color:
                              _selectedIndex == index
                                  ? AppColors.btncolor
                                  : Colors.transparent,
                            ),
                            child:
                            _selectedIndex == index
                                ? const Icon(
                              Icons.check,
                              size: 16,
                              color: Colors.white,
                            )
                                : null,
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),

              Text(
                'Please tell us more',
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: AppColors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              FormInputWithHint(
                label: '',
                hintText: 'Enter text here',
                maxLine: 3,
                borderColor: AppColors.borderColor,
                keyboardAction: TextInputAction.done,
                controller: proposalDescription,
              ),

              SizedBox(height: 40),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                        // Your click logic here
                      },
                      child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(
                          //    horizontal: 50,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Cancel',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width: 10),
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        if (proposalDescription.text.isEmpty) {
                          showError(title: 'Price', message: 'Please add description');
                        } else {
                          feedTabController.reportUser((widget.proposal.userId ?? 0).toString(), _reportReasons[_selectedIndex], proposalDescription.text, context);

                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(
                          //  horizontal: 50,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.btncolor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Submit',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
