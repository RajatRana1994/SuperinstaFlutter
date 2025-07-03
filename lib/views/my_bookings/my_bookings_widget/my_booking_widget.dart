import 'package:flutter/material.dart';
import 'package:instajobs/widgets/currency_widget.dart';
import 'package:instajobs/widgets/rounded_edged_button.dart';

class BookingCard extends StatelessWidget {
  const BookingCard({
    super.key,
    required this.avatar, // square image (NetworkImage / AssetImage)
    required this.name,
    required this.addressLabel, // "Booking Address" etc.
    required this.location,
    required this.dateLabel, // "22 Feb, 2025"
    required this.frequencyLabel, // "Daily - 0"
    required this.services, // ["Tiler","Plumber","Painter"]
    required this.note,
    required this.statusLabel, // "Open" / "Closed" ...
    required this.status, // "Open" / "Closed" ...
    this.onViewDetail,
    this.onChat,
    this.onCancel,
  });

  final ImageProvider avatar;
  final String name;
  final String addressLabel;
  final String location;
  final String dateLabel;
  final String frequencyLabel;
  final List<String> services;
  final String note;
  final String statusLabel;
  final int status;

  final VoidCallback? onViewDetail;
  final VoidCallback? onChat;
  final VoidCallback? onCancel;

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
                              color: status==4?Colors.green: Colors.amber, // tweak per status
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Text(
                              statusLabel,
                              maxLines: 1, // ‼️ keep to 1 line
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.labelLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),

                      // address label
                      Text(
                        addressLabel,
                        maxLines: 1, // ‼️ keep to 1 line
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.grey.shade700,
                        ),
                      ),

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
                            dateLabel,
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
                          color: Colors.grey.shade800,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text('View Detail / Add Ons'),
                    ),
                  ],
                ),

                // services list
                Text(
                  ' - ${services.join(', ')}',
                  maxLines: 1, // ‼️ keep to 1 line
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.teal,
                    height: 1.2,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
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

                        style: TextStyle(fontWeight: FontWeight.w600),
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
                  icon: const Icon(Icons.chat_bubble_outline),
                  color: Colors.grey.shade700,
                  iconSize: 32,
                ),
                Spacer(),
                (status!=4 && status !=2 && status!=1)?  Container(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Cancel',

                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ):SizedBox(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
