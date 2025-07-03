import 'package:flutter/material.dart';

import '../../controllers/profile_controller.dart';
import '../../utils/app_colors.dart';
import 'my_bookings_widget/my_booking_widget.dart';
import 'package:get/get.dart';

class PendingBookings extends StatefulWidget {


  const PendingBookings({super.key, });

  @override
  State<PendingBookings> createState() => _PendingBookingsState();
}

class _PendingBookingsState extends State<PendingBookings> {
  ProfileController controller = Get.put(ProfileController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    controller.getMyBookings(status: 0);

  }



  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      init: controller,
      builder: (snapshot) {
        if (controller.pendingBookingsList == null) {
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
        } else if (controller.pendingBookingsList?.isEmpty ?? false) {

          return Center(
            child: Container(
              padding: const EdgeInsets.all(10),
              child: const Text('No pending bookings found'),
            ),
          );
        } else {

          return ListView.builder(
            itemCount: controller.pendingBookingsList?.length ?? 0,
            itemBuilder: (context, index) {
              final item = controller.pendingBookingsList?.elementAt(index);
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
                statusLabel: item?.status == 0 ? 'Open' : 'Closed',
                onViewDetail: () => debugPrint('view $index'),
                onChat: () => debugPrint('chat $index'),
                onCancel: () => debugPrint('cancel $index'),  status: item?.status??0,
              );
            },
          );
        }
      },
    );
  }
}
