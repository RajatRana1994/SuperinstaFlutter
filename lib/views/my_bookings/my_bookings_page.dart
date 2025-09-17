import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instajobs/views/my_bookings/cancelled_booking.dart';
import 'package:instajobs/views/my_bookings/completed_bookings.dart';
import 'package:instajobs/views/my_bookings/pending_bookings.dart';
import 'package:instajobs/storage_services/local_stoage_service.dart';
import '../../controllers/profile_controller.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_styles.dart';
import 'inprogress_booking.dart';

class MyBookingsPage extends StatefulWidget {
  const MyBookingsPage({super.key});

  @override
  State<MyBookingsPage> createState() => _MyBookingsPageState();
}

class _MyBookingsPageState extends State<MyBookingsPage> {
  int selectedIndex = 0 ;

  ProfileController controller = Get.put(ProfileController());
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    controller.completedTotal = -1;
    controller.inProgressTotal = -1;
    controller.pendingTotal = -1;
    controller.cancelledTotal = -1;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        backgroundColor: AppColors.bgColor,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        title: Text(
          'My Bookings',
          style: AppStyles.fontInkika().copyWith(fontSize: 24),
        ),
      ),
      body: GetBuilder<ProfileController>(
        init: controller,
        builder: (snapshot) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          selectedIndex = 0;
                          setState(() {});
                        },
                        child: Container(
                          height: 52,
                          decoration: BoxDecoration(
                            color:
                            selectedIndex == 0
                                ? Colors.orange
                                : Colors.orange.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Pending',
                                  style: AppStyles.font400_12().copyWith(
                                    color:
                                    selectedIndex == 0
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  controller.pendingTotal == -1
                                      ? ''
                                      : controller.pendingTotal.toString(),
                                  style: AppStyles.font400_12().copyWith(
                                    color:
                                    selectedIndex == 0
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          selectedIndex = 1;
                          setState(() {});
                        },
                        child: Container(
                          height: 52,
                          decoration: BoxDecoration(
                            color:
                            selectedIndex == 1
                                ? Colors.orange
                                : Colors.orange.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'In Progress',
                                  style: AppStyles.font400_12().copyWith(
                                    color:
                                    selectedIndex == 1
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  controller.inProgressTotal == -1
                                      ? ''
                                      : controller.inProgressTotal.toString(),
                                  style: AppStyles.font400_12().copyWith(
                                    color:
                                    selectedIndex == 1
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          selectedIndex = 2;
                          setState(() {});
                        },
                        child: Container(
                          height: 52,
                          decoration: BoxDecoration(
                            color:
                            selectedIndex == 2
                                ? Colors.orange
                                : Colors.orange.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Cancelled',
                                  style: AppStyles.font400_12().copyWith(
                                    color:
                                    selectedIndex == 2
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  controller.cancelledTotal == -1
                                      ? ''
                                      : controller.cancelledTotal.toString(),
                                  style: AppStyles.font400_12().copyWith(
                                    color:
                                    selectedIndex == 2
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          selectedIndex = 3;
                          setState(() {});
                        },
                        child: Container(
                          height: 52,
                          decoration: BoxDecoration(
                            color:
                            selectedIndex == 3
                                ? Colors.orange
                                : Colors.orange.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Completed',
                                  style: AppStyles.font400_12().copyWith(
                                    color:
                                    selectedIndex == 3
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  controller.completedTotal == -1
                                      ? ''
                                      : controller.completedTotal.toString(),
                                  style: AppStyles.font400_12().copyWith(
                                    color:
                                    selectedIndex == 3
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                selectedIndex == 0
                    ? Expanded(
                  child: PendingBookings(

                  ),
                )
                    : selectedIndex == 1
                    ? Expanded(
                  child: InprogressBooking(

                  ),
                )
                    : selectedIndex == 2
                    ? Expanded(
                  child: CancelledBooking(

                  ),
                )
                    : Expanded(
                  child: CompletedBookings(

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
