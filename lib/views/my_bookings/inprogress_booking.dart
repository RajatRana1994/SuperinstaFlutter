import 'package:flutter/material.dart';
import 'package:instajobs/utils/baseClass.dart';

import '../../controllers/profile_controller.dart';
import '../../utils/app_colors.dart';
import 'my_bookings_widget/my_booking_widget.dart';
import 'package:get/get.dart';
import 'package:instajobs/storage_services/local_stoage_service.dart';
import 'package:instajobs/views/my_bookings/my_bookings_page.dart';
import 'package:instajobs/views/my_bookings/mybooking_detail.dart';
import 'package:instajobs/views/my_bookings/addBookingadon.dart';
import 'package:instajobs/views/my_wallet/pay_coins_page.dart';
import 'package:instajobs/views/message/chat_vc.dart';

class InprogressBooking extends StatefulWidget {
  const InprogressBooking({super.key});

  @override
  State<InprogressBooking> createState() => _InprogressBookingState();
}

class _InprogressBookingState extends State<InprogressBooking> with BaseClass {
  ProfileController controller = Get.put(ProfileController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    controller.getMyBookings(status: 1);
    print('object');
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
              final userId = item?.userId.toString();
              final currentLoginUserId = StorageService().getUserData().userId.toString();

              return BookingCard(
                status: item?.status??1,
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
                paymentStatus: item?.paymentStatus ?? 0,
                location: item?.address ?? '',
                dateLabel: item?.date.toString() ?? '',
                frequencyLabel: 'Daily - ${item?.freelancer?.dailyPrice ?? ''}',
                serviceCategory: item?.freelancer?.categoryName ?? '',
                typeUser: (userId == currentLoginUserId) ? '1' : '0',
                services:
                item?.subCategories?.map((e) => e?.name ?? '').toList() ??
                    [],
                note: item?.notes ?? '',
                statusLabel: (item?.status == 1 && item?.paymentStatus == 0) ? 'Accepted / Non Paid' : 'Accepted / Paid',
                onViewDetail: () {
                  final bookingId = item?.id.toString() ?? '';
                  pushToNextScreen(
                    context: context,
                    destination: MybookingDetail(bookingId: bookingId),
                  );
                },
                onPay: () {
                  final bookId = item?.id.toString() ?? '';
                  final amoubt = item?.price.toString() ?? '';
                  pushToNextScreen(
                    context: context,
                    destination: PayCoinsPage(
                      coins: amoubt,
                      walletId: '',
                      bookId: bookId,
                    ),
                  );
                },
                onSendQuote: () {
                  final bookingId = item?.id.toString() ?? '';
                  Get.bottomSheet(
                    Addbookingadon(bookingId: bookingId, onClose: () {

                    },),
                    isScrollControlled: true, // optional, useful for keyboard/form inputs
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
                onComplete: () async {
                  final bookingId = item?.id.toString() ?? '';
                  final result = await controller.completeBooking(bookingId: bookingId);
                  if (result) {
                    controller.inProgressBookingsList?.removeAt(index);// ✅ Return true to calling screen
                  }
                },
                onCancel: () {
                  if (userId == currentLoginUserId) {
                    final bookingId = item?.id.toString() ?? '';
                    controller.bookingCancels(bookingId, index, 1);
                  } else {

                  }
                },
              );
            },
          );
        }
      },
    );
  }
}
