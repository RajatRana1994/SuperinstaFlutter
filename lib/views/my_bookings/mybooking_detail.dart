import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/profile_controller.dart';
import 'my_bookings_widget/my_booking_widget.dart';
import 'package:instajobs/views/my_bookings/bookingRating.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_styles.dart';
import 'inprogress_booking.dart';
import 'package:instajobs/storage_services/local_stoage_service.dart';
import 'package:flutter/material.dart';
import 'package:instajobs/utils/baseClass.dart';
import 'package:instajobs/views/my_bookings/mybooking_detail.dart';
import 'package:instajobs/views/my_bookings/addBookingadon.dart';
import '../../controllers/profile_controller.dart';
import '../../utils/app_colors.dart';
import 'my_bookings_widget/my_booking_widget.dart';
import 'package:get/get.dart';
import 'package:instajobs/storage_services/local_stoage_service.dart';
import 'package:instajobs/views/my_bookings/my_bookings_page.dart';

class MybookingDetail extends StatefulWidget {
  final String bookingId;

  const MybookingDetail({super.key, required this.bookingId});

  @override
  State<MybookingDetail> createState() => _MybookingDetailState();
}

class _MybookingDetailState extends State<MybookingDetail> with BaseClass {
  final ProfileController controller = Get.put(ProfileController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getBookingDetail(widget.bookingId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        backgroundColor: AppColors.bgColor,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        title: Text(
          'Booking Detail',
          style: AppStyles.fontInkika().copyWith(fontSize: 24),
        ),
      ),
      body: GetBuilder<ProfileController>(
        builder: (controller) {
          final item = controller.bookingDetail;

          if (item == null) {
            return const SizedBox();
          }

          final userId = item.userId.toString();
          final currentLoginUserId =
              StorageService().getUserData().userId.toString();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BookingCard(
                  avatar:
                      (userId == currentLoginUserId)
                          ? (item.freelancer?.profile?.isNotEmpty ?? false)
                              ? NetworkImage(item.freelancer!.profile!)
                              : const AssetImage('assets/imagesicon.png')
                          : (item.users?.profile?.isNotEmpty ?? false)
                          ? NetworkImage(item.users!.profile!)
                          : const AssetImage('assets/imagesicon.png'),
                  name:
                      (userId == currentLoginUserId)
                          ? (item.freelancer?.name ?? '')
                          : (item.users?.name ?? ''),
                  addressLabel: 'Booking Address',
                  paymentStatus: item.paymentStatus ?? 0,
                  location: item.address ?? '',
                  dateLabel: item.date.toString(),
                  frequencyLabel:
                      (item.bookingType == 0)
                          ? 'Hourly - ${item.freelancer?.hourlyPrice ?? ''}'
                          : 'Daily - ${item.freelancer?.dailyPrice ?? ''}',
                  serviceCategory: item.freelancer?.categoryName ?? '',
                  typeUser: (userId == currentLoginUserId) ? '1' : '0',
                  services:
                      item.subCategories?.map((e) => e?.name ?? '').toList() ??
                      [],
                  note: item.notes ?? '',
                  isRated: item.isRated ?? 0,
                  statusLabel:
                      item.status == 0
                          ? 'Open'
                          : (item.status == 1 && item.paymentStatus == 0)
                          ? 'Non-Paid'
                          : (item.status == 2)
                          ? 'Cancelled'
                          : (item.status == 4)
                          ? 'Completed'
                          : 'Paid',
                  onViewDetail: () {},
                  onChat: () => debugPrint('chat tapped'),
                  onAccept: () {
                    controller.bookingAcceptReject('1', item.id.toString(), 0);
                  },
                  onCancel: () {
                    final bookingId = item.id.toString();
                    if (userId == currentLoginUserId) {
                      controller.bookingCancels(bookingId, 0, 9999);
                    } else {
                      controller.bookingAcceptReject('2', bookingId, 9999);
                    }
                  },
                  onSendQuote: () {
                    Get.bottomSheet(
                      Addbookingadon(
                        bookingId: widget.bookingId,
                        onClose: () {
                          controller.getBookingDetail(widget.bookingId);
                        },
                      ),
                      isScrollControlled:
                          true, // optional, useful for keyboard/form inputs
                    );
                  },
                  onRating: () {
                    final bookingId = widget.bookingId;
                    final userId = item.freelancer?.id ?? 0;
                    pushToNextScreen(
                      context: context,
                      destination: Bookingrating(bookingId: widget.bookingId, userId: userId.toString(),),
                    );
                  },
                  onComplete: () async {
                    final result = await controller.completeBooking(
                      bookingId: widget.bookingId,
                    );
                    if (result) {
                      controller.getBookingDetail(
                        widget.bookingId,
                      ); // ✅ Return true to calling screen
                    }
                  },
                  status: item.status ?? 0,
                ),

                const SizedBox(height: 16),

                Text(
                  'Add Ons on Appointments',
                  style: Theme.of(context).textTheme.titleMedium,
                ),

                const SizedBox(height: 8),

                // 🔽 This is the ListView.builder inside a fixed height box
                ListView.builder(
                  itemCount: item.addOns?.length ?? 0,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final notess = item.addOns?[index];
                    final userId = notess?.userId.toString();
                    final currentLoginUserId =
                        StorageService().getUserData().userId.toString();

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Estimate Time to Complete:- ',
                                    style: theme.textTheme.titleMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                        ),
                                  ),
                                  Text(
                                    (notess?.timeToComplete ?? 0).toString(),
                                    style: theme.textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Add on Cost:- ',
                                    style: theme.textTheme.titleMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                        ),
                                  ),
                                  Text(
                                    (notess?.price ?? 0).toString(),
                                    style: theme.textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Add Ons Description:- ',
                                    style: theme.textTheme.titleMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                        ),
                                  ),
                                  Spacer(),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color:
                                          (notess?.status == 0)
                                              ? Colors.amber
                                              : (notess?.status == 2)
                                              ? Colors.red
                                              : Colors
                                                  .green, // tweak per status
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: Text(
                                      (notess?.status == 0)
                                          ? 'Open'
                                          : (notess?.status == 2)
                                          ? 'Rejected'
                                          : 'Accepted',
                                      maxLines: 1, // ‼️ keep to 1 line
                                      overflow: TextOverflow.ellipsis,
                                      style: theme.textTheme.labelLarge
                                          ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                    ),
                                  ),
                                ],
                              ),

                              Text(
                                notess?.description ?? '',
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                              ),
                              if (userId != currentLoginUserId) ...[
                                Row(
                                  children: [
                                    if (notess?.status == 0) ...[
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            controller.bookingAdonAcceptReject(
                                              notess!.id.toString(),
                                              "1",
                                              index,
                                            );
                                            // Your click logic here
                                          },
                                          child: Container(
                                            alignment: Alignment.center,
                                            padding: EdgeInsets.symmetric(
                                              //  horizontal: 50,
                                              vertical: 8,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.green,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              'Accept',
                                              style: theme.textTheme.bodyMedium
                                                  ?.copyWith(
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
                                          onTap: () {
                                            controller.bookingAdonAcceptReject(
                                              notess!.id.toString(),
                                              "2",
                                              index,
                                            );
                                            // Your click logic here
                                          },
                                          child: Container(
                                            alignment: Alignment.center,
                                            padding: EdgeInsets.symmetric(
                                              //    horizontal: 50,
                                              vertical: 8,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.redAccent,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              'Reject',
                                              style: theme.textTheme.bodyMedium
                                                  ?.copyWith(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
