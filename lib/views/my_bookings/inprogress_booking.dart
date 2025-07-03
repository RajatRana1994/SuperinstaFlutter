import 'package:flutter/material.dart';

import '../../controllers/profile_controller.dart';
import '../../utils/app_colors.dart';
import 'my_bookings_widget/my_booking_widget.dart';
import 'package:get/get.dart';

class InprogressBooking extends StatefulWidget {
  const InprogressBooking({super.key});

  @override
  State<InprogressBooking> createState() => _InprogressBookingState();
}

class _InprogressBookingState extends State<InprogressBooking> {
  ProfileController controller = Get.put(ProfileController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    controller.getMyBookings(status: 1);

  }



  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      init: controller,
      builder: (snapshot) {
        if (controller.inProgressBookingsList == null) {
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
        } else if (controller.inProgressBookingsList?.isEmpty ?? false) {

          return Center(
            child: Container(
              padding: const EdgeInsets.all(10),
              child: const Text('No In Progress bookings found'),
            ),
          );
        } else {

          return ListView.builder(
            itemCount: controller.inProgressBookingsList?.length ?? 0,
            itemBuilder: (context, index) {
              final item = controller.inProgressBookingsList?.elementAt(index);
              return BookingCard(
                status: item?.status??1,
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
                statusLabel: item?.status == 0 ? 'Open' : 'Closed',
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
