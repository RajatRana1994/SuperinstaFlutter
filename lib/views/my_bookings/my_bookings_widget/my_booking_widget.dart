import 'package:flutter/material.dart';
import 'package:instajobs/utils/app_colors.dart';
import 'package:instajobs/widgets/currency_widget.dart';
import 'package:instajobs/widgets/rounded_edged_button.dart';
import 'package:intl/intl.dart';
import 'package:instajobs/utils/app_images.dart';

class BookingCard extends StatelessWidget {
  const BookingCard({
    super.key,
    required this.avatar, // square image (NetworkImage / AssetImage)
    required this.name,
    required this.addressLabel, // "Booking Address" etc.
    required this.location,
    required this.dateLabel, // "22 Feb, 2025"
    required this.serviceCategory,
    required this.typeUser,
    required this.frequencyLabel, // "Daily - 0"
    required this.services, // ["Tiler","Plumber","Painter"]
    required this.note,
    required this.statusLabel, // "Open" / "Closed" ...
    required this.status, // "Open" / "Closed" ...
    this.onViewDetail,
    this.onChat,
    this.onCancel,
    this.onAccept,
    this.onSendQuote,
    this.onPay,
    this.onComplete,
    this.onRating,
    this.paymentStatus = 0,
    this.isRated = 0,
  });

  final VoidCallback? onAccept;
  final ImageProvider avatar;
  final String name;
  final String addressLabel;
  final String location;
  final String dateLabel;
  final String serviceCategory;
  final String frequencyLabel;
  final List<String> services;
  final String note;
  final String statusLabel;
  final int status;
  final int paymentStatus;
  final int isRated;
  final String typeUser;

  final VoidCallback? onViewDetail;
  final VoidCallback? onChat;
  final VoidCallback? onCancel;
  final VoidCallback? onSendQuote;
  final VoidCallback? onComplete;
  final VoidCallback? onRating;
  final VoidCallback? onPay;

  String formatDateFromTimestampString(String timestampStr) {
    int timestamp = int.tryParse(timestampStr) ?? 0;
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return DateFormat('dd MMM, yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // avatar / preview image
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image(
                    image: avatar,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
                // textual content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              name,
                              maxLines: 1, // ‼️ keep to 1 line
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),

                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color:
                              status == 4
                                  ? Color(0xFF1FAC81)
                                  : Color(0xFFFBBF00), // tweak per status
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Text(
                              statusLabel,
                              maxLines: 1, // ‼️ keep to 1 line
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.labelLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),

                      // address label
                      // Text(
                      //   addressLabel,
                      //   maxLines: 1, // ‼️ keep to 1 line
                      //   overflow: TextOverflow.ellipsis,
                      //   style: theme.textTheme.bodySmall?.copyWith(
                      //     color: Colors.grey.shade700,
                      //   ),
                      // ),

                      const SizedBox(height: 4),

                      // location row
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            size: 16,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            (location.length <= 30)
                                ? location
                                : '${location.substring(0, 30)}…',
                            maxLines: 1, // ‼️ keep to 1 line
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 4),

                      // date & frequency row
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_month,
                            size: 16,
                            color: Colors.deepOrange,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            formatDateFromTimestampString(dateLabel),
                            maxLines: 1, // ‼️ keep to 1 line
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Text(' · '),
                          GetCurrencyWidget(),

                          const SizedBox(width: 2),
                          Text(
                            frequencyLabel,
                            maxLines: 1, // ‼️ keep to 1 line
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      // view-detail pill button
                    ],
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // services header
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Appointment for services',
                        maxLines: 1, // ‼️ keep to 1 line
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Color(0xFF2D2B2B),
                          fontSize: 12,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        onViewDetail?.call();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text('View Detail / Add Ons', style: TextStyle(color: Color(0xFFEA8803), fontSize: 12, fontWeight: FontWeight.w700),),
                      ),
                    ),
                  ],
                ),

                // services list
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '$serviceCategory', // service category
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: const Color(0xFF828282), // gray color
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          height: 1.2,
                        ),
                      ),
                      TextSpan(
                        text: ' - ${services.join(', ')}', // services list
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.black, // black color
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),


                const SizedBox(height: 4),
                // note
                RichText(
                  maxLines: 1, // ‼️ keep to 1 line
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.black,
                    ),
                    children: [
                      const TextSpan(
                        text: 'Note - ',

                        style: TextStyle(fontWeight: FontWeight.w500, color: Color(0xFF828282)),
                      ),
                      TextSpan(text: note),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              children: [
                IconButton(
                  onPressed: onChat,
                  icon: Image.asset(
                    AppImages.icChat,
                    width: 32,
                    height: 32,
                  ),
                ),
                Spacer(),

                if (status == 0) ...[
                  if (typeUser == "0") ...[
                    GestureDetector(
                      onTap: () {
                        // Your click logic here
                        onAccept?.call();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 50,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Accept',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                  ],

                  GestureDetector(
                    onTap: () {
                      // Your click logic here
                      onCancel?.call();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 50,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        (typeUser == "1") ? 'Cancel' : 'Reject',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],

                if (status == 1) ...[
                  if (typeUser == '1') ...[
                    GestureDetector(
                      onTap: () {
                        if (paymentStatus == 0) {
                          print('object');
                          onPay?.call();
                        } else {
                          onComplete?.call();
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 50,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          paymentStatus == 0 ? 'Pay' : 'Complete',

                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                  ],

                  if (paymentStatus == 0) ...[
                    GestureDetector(
                      onTap: () {
                        if (typeUser == '1') {
                          onCancel?.call();
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 50,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          (typeUser == '1') ? 'Cancel' : 'Waiting For Payment',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],

                  if (paymentStatus == 1 && typeUser == '0') ...[
                    GestureDetector(
                      onTap: () {
                        print('object');
                        onSendQuote?.call();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 50,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Send Quote',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],

                if (status == 2) ...[
                  if (typeUser == '0') ...[
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 50,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Rejected',

                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ],


                if (status == 4) ...[
                  if (typeUser == '1' && isRated == 0) ...[
                    GestureDetector(
                      onTap: () {
                        onRating?.call();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 50,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xFFEA8803),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Give Rating',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    )
                  ],
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
