import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import 'package:instajobs/controllers/feed_tab_controller.dart';
import 'package:get/get.dart';

class ReportVc extends StatefulWidget {
  final String feedId;
  const ReportVc({super.key, required this.feedId});

  @override
  State<ReportVc> createState() => _ReportVcState();
}

class _ReportVcState extends State<ReportVc> {
  FeedTabController feedTabController = Get.put(FeedTabController());
  int _selectedIndex = 0; // keep track of selected option

  final List<String> _reportReasons = [
    "I just do not like it",
    "Bullying or unwanted contact",
    "Violence, hate or exploitation",
    "Scam, fraud or spam",
    "False information",
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
            CrossAxisAlignment.center, // Optional: aligns title to left
            children: [
              Text(
                'Report',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              Text(
                'Why are you reporting this post?',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              Text(
                'Your report is annonyous. If someone is in immediate danger, call the local emergency services- don not wait.',
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 30),
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
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
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
                              border: Border.all(color: AppColors.btncolor, width: 1),
                              borderRadius: BorderRadius.circular(4), // square shape
                              color: _selectedIndex == index
                                  ? AppColors.btncolor
                                  : Colors.transparent,
                            ),
                            child: _selectedIndex == index
                                ? const Icon(Icons.check,
                                size: 16, color: Colors.white)
                                : null,
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),

              SizedBox(height: 40,),
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
                        feedTabController.reportFeed(widget.feedId, _reportReasons[_selectedIndex], context);

                        // Your click logic here
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

