import 'package:flutter/material.dart';
import 'package:instajobs/utils/baseClass.dart';

import '../../controllers/profile_controller.dart';
import '../../utils/app_colors.dart';
import 'my_bookings_widget/my_booking_widget.dart';
import 'package:get/get.dart';
import 'package:instajobs/storage_services/local_stoage_service.dart';
import 'package:instajobs/views/my_bookings/my_bookings_page.dart';
import 'package:instajobs/views/my_bookings/mybooking_detail.dart';
import 'package:instajobs/views/message/chat_vc.dart';

class CancelledBooking extends StatefulWidget {
  const CancelledBooking({super.key});

  @override
  State<CancelledBooking> createState() => _CancelledBookingState();
}

class _CancelledBookingState extends State<CancelledBooking>  with BaseClass{
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
              final userId = item?.userId.toString();
              final currentLoginUserId = StorageService().getUserData().userId.toString();
              return BookingCard(
                status: item?.status??2,
                avatar:
                (userId == currentLoginUserId)
                    ? (item?.freelancer?.profile != null &&
                    (item?.freelancer?.profile?.isNotEmpty ??
                        false))
                    ? NetworkImage(item?.freelancer?.profile ?? '')
                    : AssetImage('assets/imagesicon.png')
                    : (item?.users?.profile != null &&
                    (item?.users?.profile?.isNotEmpty ?? false))
                    ? NetworkImage(item?.users?.profile ?? '')
                    : AssetImage('assets/imagesicon.png'),
                name:
                (userId == currentLoginUserId)
                    ? (item?.freelancer?.name ?? '')
                    : (item?.users?.name ?? ''),
                addressLabel: 'Booking Address',
                location: item?.address ?? '',
                dateLabel: item?.date.toString() ?? '',
                typeUser: (userId == currentLoginUserId) ? '1' : '0',
                frequencyLabel: 'Daily - ${item?.freelancer?.dailyPrice ?? ''}',
                serviceCategory: item?.freelancer?.categoryName ?? '',
                services:
                item?.subCategories?.map((e) => e?.name ?? '').toList() ??
                    [],
                note: item?.notes ?? '',
                statusLabel: item?.status == 0 ? 'Open' : 'Closed',
                onViewDetail: () {
                  final bookingId = item?.id.toString() ?? '';
                  pushToNextScreen(
                    context: context,
                    destination: MybookingDetail(bookingId: bookingId),
                  );
                },
                onChat: () {
                  final bookingId = item?.id.toString() ?? '';
                  final currentLoginUserId =
                  StorageService().getUserData().userId.toString();
                  final assignId = item?.assignUserId.toString() ?? '';
                  final userId = item?.userId.toString() ?? '';
                  String friendId = item?.assignUserId.toString() ?? '';
                  if (currentLoginUserId == assignId) {
                    friendId = userId;

                  }
                  pushToNextScreen(context: context, destination: ChatVc(chatId: '', bookingId: bookingId, type: 'booking', friendId: friendId,));
                },
                onCancel: () => debugPrint('cancel $index'),
              );
            },
          );
        }
      },
    );
  }
}
