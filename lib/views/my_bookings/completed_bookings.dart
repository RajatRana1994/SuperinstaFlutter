import 'package:flutter/material.dart';

import '../../controllers/profile_controller.dart';
import '../../utils/app_colors.dart';
import 'my_bookings_widget/my_booking_widget.dart';
import 'package:get/get.dart';

class CompletedBookings extends StatefulWidget {
  const CompletedBookings({super.key});

  @override
  State<CompletedBookings> createState() => _CompletedBookingsState();
}

class _CompletedBookingsState extends State<CompletedBookings> {
  ProfileController controller = Get.put(ProfileController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    controller.getMyBookings(status: 4);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      init: controller,
      builder: (snapshot) {
        if (controller.completedBookingsList == null) {
          return Center(
            child: Container(
              padding: const EdgeInsets.all(10),
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppColors.primaryColor,
                ),
              ),
            ),
          );
        } else if (controller.completedBookingsList?.isEmpty ?? false) {
          return Center(
            child: Container(
              padding: const EdgeInsets.all(10),
              child: const Text('No Completed bookings found'),
            ),
          );
        } else {
          return ListView.builder(
            itemCount: controller.completedBookingsList?.length ?? 0,
            itemBuilder: (context, index) {
              final item = controller.completedBookingsList?.elementAt(index);
              return BookingCard(
                avatar:
                    (item?.users?.profile != null &&
                            (item?.users?.profile?.isNotEmpty ?? false))
                        ? NetworkImage(item?.users?.profile ?? '')
                        : AssetImage('assets/imagesicon.png'),
                name: item?.users?.name ?? '',
                addressLabel: 'Booking Address',
                location: item?.address ?? '',
                dateLabel: item?.date.toString() ?? '',
                frequencyLabel: 'Daily - ${item?.freelancer?.dailyPrice ?? ''}',
                services:
                    item?.subCategories?.map((e) => e?.name ?? '').toList() ??
                    [],
                note: item?.notes ?? '',
                statusLabel: 'Completed',
                status: item?.status??4,
                onViewDetail: () => debugPrint('view $index'),
                onChat: () => debugPrint('chat $index'),
                onCancel: () => debugPrint('cancel $index'),
              );
            },
          );
        }
      },
    );
  }
}
