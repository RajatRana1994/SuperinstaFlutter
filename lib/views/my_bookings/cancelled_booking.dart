import 'package:flutter/material.dart';

import '../../controllers/profile_controller.dart';
import '../../utils/app_colors.dart';
import 'my_bookings_widget/my_booking_widget.dart';
import 'package:get/get.dart';
class CancelledBooking extends StatefulWidget {
  const CancelledBooking({super.key});

  @override
  State<CancelledBooking> createState() => _CancelledBookingState();
}

class _CancelledBookingState extends State<CancelledBooking> {
  ProfileController controller = Get.put(ProfileController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    controller.getMyBookings(status: 2);

  }



  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      init: controller,
      builder: (snapshot) {
        if (controller.cancelledBookingsList == null) {
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
        } else if (controller.cancelledBookingsList?.isEmpty ?? false) {

          return Center(
            child: Container(
              padding: const EdgeInsets.all(10),
              child: const Text('No Canceled bookings found'),
            ),
          );
        } else {

          return ListView.builder(
            itemCount: controller.cancelledBookingsList?.length ?? 0,
            itemBuilder: (context, index) {
              final item = controller.cancelledBookingsList?.elementAt(index);
              return BookingCard(
                status: item?.status??2,
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
