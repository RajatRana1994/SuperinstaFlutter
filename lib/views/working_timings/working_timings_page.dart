import 'package:flutter/material.dart';
import 'package:instajobs/controllers/profile_controller.dart';
import 'package:instajobs/views/working_timings/working_time_bottom_sheet.dart';
import 'package:instajobs/widgets/rounded_edged_button.dart';
import 'package:get/get.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_styles.dart';

class WorkingTimingsPage extends StatefulWidget {
  const WorkingTimingsPage({super.key});

  @override
  State<WorkingTimingsPage> createState() => _WorkingTimingsPageState();
}

class _WorkingTimingsPageState extends State<WorkingTimingsPage> {
  ProfileController profileController = Get.put(ProfileController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    profileController.getProfileDetails();
  }

  Map<String, String> getStartEnd(String timeRange) {
    if (timeRange.isEmpty) {
      return {"start": "00:00", "end": "00:00"};
    }
    // Normalize: handle both "10:00 - 18:00" and "10:00-18:00"
    final normalized = timeRange.replaceAll(" ", ""); // remove spaces
    final parts = normalized.split('-');

    if (parts.length < 2) {
      return {"start": "00:00", "end": "00:00"};
    }

    return {
      "start": parts[0].trim(),
      "end": parts[1].trim(),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: AppColors.bgColor,
        centerTitle: false,
        title: Text(
          'Working Days and Time',
          style: AppStyles.fontInkika().copyWith(fontSize: 24),
        ),
      ),
      body: GetBuilder<ProfileController>(
        init: profileController,
        builder: (snapshot) {
          if (snapshot.profileDetailsModel == null) {
            return Center(child: CircularProgressIndicator());
          }
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              children: [
                _getWorkingDays(
                  startTime:
                  getStartEnd(
                    profileController
                        .profileDetailsModel
                        ?.userInfo
                        ?.workingHours
                        ?.monday ??
                        '00:00 - 00:00',
                  )['start'] ??
                      '00:00',
                  lastTime:
                  getStartEnd(
                    profileController
                        .profileDetailsModel
                        ?.userInfo
                        ?.workingHours
                        ?.monday ??
                        '00:00 - 00:00',
                  )['end'] ??
                      '00:00',
                  onTap: () async {
                    final result = await showStartEndTimePickerSheet(
                      context: context,
                      rawStart:
                      getStartEnd(
                        profileController
                            .profileDetailsModel
                            ?.userInfo
                            ?.workingHours
                            ?.monday ??
                            '00:00 - 00:00',
                      )['start'] ??
                          '00:00',
                      dayName: 'Monday',
                      rawEnd:
                      getStartEnd(
                        profileController
                            .profileDetailsModel
                            ?.userInfo
                            ?.workingHours
                            ?.monday ??
                            '00:00 - 00:00',
                      )['end'] ??
                          '00:00',
                    );

                    if (result != null) {
                      final newStart = result['start']!; // e.g. "09:30"
                      final newEnd = result['end']!; // e.g. "17:45"

                      // Do something with the chosen times, e.g. setState or pass to your controller:
                      print('User chose start = $newStart and end = $newEnd');
                      profileController
                          .profileDetailsModel
                          ?.userInfo
                          ?.workingHours
                          ?.monday = '$newStart - $newEnd';
                      profileController.update();
                    } else {
                      // The user dismissed the sheet without tapping “Done.”
                      print('User cancelled.');
                    }
                  },
                  title: 'Monday',
                ),
                SizedBox(height: 16),
                _getWorkingDays(
                  startTime:
                  getStartEnd(
                    profileController
                        .profileDetailsModel
                        ?.userInfo
                        ?.workingHours
                        ?.tuesday ??
                        '00:00 - 00:00',
                  )['start'] ??
                      '00:00',
                  lastTime:
                  getStartEnd(
                    profileController
                        .profileDetailsModel
                        ?.userInfo
                        ?.workingHours
                        ?.tuesday ??
                        '00:00 - 00:00',
                  )['end'] ??
                      '00:00',
                  onTap: () async {
                    final result = await showStartEndTimePickerSheet(
                      context: context,
                      rawStart:
                      getStartEnd(
                        profileController
                            .profileDetailsModel
                            ?.userInfo
                            ?.workingHours
                            ?.tuesday ??
                            '00:00 - 00:00',
                      )['start'] ??
                          '00:00',
                      dayName: 'Tuesday',
                      rawEnd:
                      getStartEnd(
                        profileController
                            .profileDetailsModel
                            ?.userInfo
                            ?.workingHours
                            ?.tuesday ??
                            '00:00 - 00:00',
                      )['end'] ??
                          '00:00',
                    );

                    if (result != null) {
                      final newStart = result['start']!; // e.g. "09:30"
                      final newEnd = result['end']!; // e.g. "17:45"

                      // Do something with the chosen times, e.g. setState or pass to your controller:
                      print('User chose start = $newStart and end = $newEnd');
                      profileController
                          .profileDetailsModel
                          ?.userInfo
                          ?.workingHours
                          ?.tuesday = '$newStart - $newEnd';
                      profileController.update();
                    } else {
                      // The user dismissed the sheet without tapping “Done.”
                      print('User cancelled.');
                    }
                  },
                  title: 'Tuesday',
                ),
                SizedBox(height: 16),
                _getWorkingDays(
                  startTime:
                  getStartEnd(
                    profileController
                        .profileDetailsModel
                        ?.userInfo
                        ?.workingHours
                        ?.wednesday ??
                        '00:00 - 00:00',
                  )['start'] ??
                      '00:00',
                  lastTime:
                  getStartEnd(
                    profileController
                        .profileDetailsModel
                        ?.userInfo
                        ?.workingHours
                        ?.wednesday ??
                        '00:00 - 00:00',
                  )['end'] ??
                      '00:00',
                  onTap: () async {
                    final result = await showStartEndTimePickerSheet(
                      context: context,
                      rawStart:
                      getStartEnd(
                        profileController
                            .profileDetailsModel
                            ?.userInfo
                            ?.workingHours
                            ?.wednesday ??
                            '00:00 - 00:00',
                      )['start'] ??
                          '00:00',
                      dayName: 'Wednesday',
                      rawEnd:
                      getStartEnd(
                        profileController
                            .profileDetailsModel
                            ?.userInfo
                            ?.workingHours
                            ?.wednesday ??
                            '00:00 - 00:00',
                      )['end'] ??
                          '00:00',
                    );

                    if (result != null) {
                      final newStart = result['start']!; // e.g. "09:30"
                      final newEnd = result['end']!; // e.g. "17:45"

                      // Do something with the chosen times, e.g. setState or pass to your controller:
                      print('User chose start = $newStart and end = $newEnd');
                      profileController
                          .profileDetailsModel
                          ?.userInfo
                          ?.workingHours
                          ?.wednesday = '$newStart - $newEnd';
                      profileController.update();
                    } else {
                      // The user dismissed the sheet without tapping “Done.”
                      print('User cancelled.');
                    }
                  },
                  title: 'Wednesday',
                ),
                SizedBox(height: 16),
                _getWorkingDays(
                  startTime:
                  getStartEnd(
                    profileController
                        .profileDetailsModel
                        ?.userInfo
                        ?.workingHours
                        ?.thursday ??
                        '00:00 - 00:00',
                  )['start'] ??
                      '00:00',
                  lastTime:
                  getStartEnd(
                    profileController
                        .profileDetailsModel
                        ?.userInfo
                        ?.workingHours
                        ?.thursday ??
                        '00:00 - 00:00',
                  )['end'] ??
                      '00:00',
                  onTap: () async {
                    final result = await showStartEndTimePickerSheet(
                      context: context,
                      rawStart:
                      getStartEnd(
                        profileController
                            .profileDetailsModel
                            ?.userInfo
                            ?.workingHours
                            ?.thursday ??
                            '00:00 - 00:00',
                      )['start'] ??
                          '00:00',
                      dayName: 'Thursday',
                      rawEnd:
                      getStartEnd(
                        profileController
                            .profileDetailsModel
                            ?.userInfo
                            ?.workingHours
                            ?.thursday ??
                            '00:00 - 00:00',
                      )['end'] ??
                          '00:00',
                    );

                    if (result != null) {
                      final newStart = result['start']!; // e.g. "09:30"
                      final newEnd = result['end']!; // e.g. "17:45"

                      // Do something with the chosen times, e.g. setState or pass to your controller:
                      print('User chose start = $newStart and end = $newEnd');
                      profileController
                          .profileDetailsModel
                          ?.userInfo
                          ?.workingHours
                          ?.thursday = '$newStart - $newEnd';
                      profileController.update();
                    } else {
                      // The user dismissed the sheet without tapping “Done.”
                      print('User cancelled.');
                    }
                  },
                  title: 'Thursday',
                ),
                SizedBox(height: 16),
                _getWorkingDays(
                  startTime:
                  getStartEnd(
                    profileController
                        .profileDetailsModel
                        ?.userInfo
                        ?.workingHours
                        ?.friday ??
                        '00:00 - 00:00',
                  )['start'] ??
                      '00:00',
                  lastTime:
                  getStartEnd(
                    profileController
                        .profileDetailsModel
                        ?.userInfo
                        ?.workingHours
                        ?.friday ??
                        '00:00 - 00:00',
                  )['end'] ??
                      '00:00',
                  onTap: () async {
                    final result = await showStartEndTimePickerSheet(
                      context: context,
                      rawStart:
                      getStartEnd(
                        profileController
                            .profileDetailsModel
                            ?.userInfo
                            ?.workingHours
                            ?.friday ??
                            '00:00 - 00:00',
                      )['start'] ??
                          '00:00',
                      dayName: 'Friday',
                      rawEnd:
                      getStartEnd(
                        profileController
                            .profileDetailsModel
                            ?.userInfo
                            ?.workingHours
                            ?.friday ??
                            '00:00 - 00:00',
                      )['end'] ??
                          '00:00',
                    );

                    if (result != null) {
                      final newStart = result['start']!; // e.g. "09:30"
                      final newEnd = result['end']!; // e.g. "17:45"

                      // Do something with the chosen times, e.g. setState or pass to your controller:
                      print('User chose start = $newStart and end = $newEnd');
                      profileController
                          .profileDetailsModel
                          ?.userInfo
                          ?.workingHours
                          ?.friday = '$newStart - $newEnd';
                      profileController.update();
                    } else {
                      // The user dismissed the sheet without tapping “Done.”
                      print('User cancelled.');
                    }
                  },
                  title: 'Friday',
                ),
                SizedBox(height: 16),
                _getWorkingDays(
                  startTime:
                  getStartEnd(
                    profileController
                        .profileDetailsModel
                        ?.userInfo
                        ?.workingHours
                        ?.saturday ??
                        '00:00 - 00:00',
                  )['start'] ??
                      '00:00',
                  lastTime:
                  getStartEnd(
                    profileController
                        .profileDetailsModel
                        ?.userInfo
                        ?.workingHours
                        ?.saturday ??
                        '00:00 - 00:00',
                  )['end'] ??
                      '00:00',
                  onTap: () async {
                    final result = await showStartEndTimePickerSheet(
                      context: context,
                      rawStart:
                      getStartEnd(
                        profileController
                            .profileDetailsModel
                            ?.userInfo
                            ?.workingHours
                            ?.saturday ??
                            '00:00 - 00:00',
                      )['start'] ??
                          '00:00',
                      dayName: 'Saturday',
                      rawEnd:
                      getStartEnd(
                        profileController
                            .profileDetailsModel
                            ?.userInfo
                            ?.workingHours
                            ?.saturday ??
                            '00:00 - 00:00',
                      )['end'] ??
                          '00:00',
                    );

                    if (result != null) {
                      final newStart = result['start']!; // e.g. "09:30"
                      final newEnd = result['end']!; // e.g. "17:45"

                      // Do something with the chosen times, e.g. setState or pass to your controller:
                      print('User chose start = $newStart and end = $newEnd');
                      profileController
                          .profileDetailsModel
                          ?.userInfo
                          ?.workingHours
                          ?.saturday = '$newStart - $newEnd';
                      profileController.update();
                    } else {
                      // The user dismissed the sheet without tapping “Done.”
                      print('User cancelled.');
                    }
                  },
                  title: 'Saturday',
                ),
                SizedBox(height: 16),
                _getWorkingDays(
                  startTime:
                  getStartEnd(
                    profileController
                        .profileDetailsModel
                        ?.userInfo
                        ?.workingHours
                        ?.sunday ??
                        '00:00 - 00:00',
                  )['start'] ??
                      '00:00',
                  lastTime:
                  getStartEnd(
                    profileController
                        .profileDetailsModel
                        ?.userInfo
                        ?.workingHours
                        ?.sunday ??
                        '00:00 - 00:00',
                  )['end'] ??
                      '00:00',
                  onTap: () async {
                    final result = await showStartEndTimePickerSheet(
                      context: context,
                      rawStart:
                      getStartEnd(
                        profileController
                            .profileDetailsModel
                            ?.userInfo
                            ?.workingHours
                            ?.sunday ??
                            '00:00 - 00:00',
                      )['start'] ??
                          '00:00',
                      dayName: 'Sunday',
                      rawEnd:
                      getStartEnd(
                        profileController
                            .profileDetailsModel
                            ?.userInfo
                            ?.workingHours
                            ?.sunday ??
                            '00:00 - 00:00',
                      )['end'] ??
                          '00:00',
                    );

                    if (result != null) {
                      final newStart = result['start']!; // e.g. "09:30"
                      final newEnd = result['end']!; // e.g. "17:45"

                      // Do something with the chosen times, e.g. setState or pass to your controller:
                      print('User chose start = $newStart and end = $newEnd');
                      profileController
                          .profileDetailsModel
                          ?.userInfo
                          ?.workingHours
                          ?.sunday = '$newStart - $newEnd';
                      profileController.update();
                    } else {
                      // The user dismissed the sheet without tapping “Done.”
                      print('User cancelled.');
                    }
                  },
                  title: 'Sunday',
                ),

                SizedBox(height: 16),
                RoundedEdgedButton(buttonText: 'Save',
                    onButtonClick: () {
                      profileController.updateDayAndTime(profileController
                          .profileDetailsModel
                          ?.userInfo
                          ?.workingHours
                          ?.monday ?? '', profileController
                          .profileDetailsModel
                          ?.userInfo
                          ?.workingHours
                          ?.tuesday ?? '', profileController
                          .profileDetailsModel
                          ?.userInfo
                          ?.workingHours
                          ?.wednesday ?? '', profileController
                          .profileDetailsModel
                          ?.userInfo
                          ?.workingHours
                          ?.thursday ?? '', profileController
                          .profileDetailsModel
                          ?.userInfo
                          ?.workingHours
                          ?.friday ?? '', profileController
                          .profileDetailsModel
                          ?.userInfo
                          ?.workingHours
                          ?.saturday ?? '', profileController
                          .profileDetailsModel
                          ?.userInfo
                          ?.workingHours
                          ?.sunday ?? '');
                    }),
              ],
            ),
          );
        },
      ),
    );
  }

  _getWorkingDays({
    required String startTime,
    required String lastTime,
    required String title,
    required Function onTap,
  }) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppStyles.font700_16().copyWith(color: Colors.black),
          ),
          SizedBox(height: 4),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade500),
            ),
            child: Text(
              ('$startTime - $lastTime' == '00:00 - 00:00')
                  ? 'Closed'
                  : '$startTime - $lastTime',
              style: AppStyles.font500_14().copyWith(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
