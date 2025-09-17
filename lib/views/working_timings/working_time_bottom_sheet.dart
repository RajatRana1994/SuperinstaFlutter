import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instajobs/widgets/rounded_edged_button.dart';

/// Shows a bottom sheet containing two Cupertino time pickers:
///  - One for “Start Time” (pre-populated with [rawStart], which must be in `"HH:mm"` format)
///  - One for “End Time”   (pre-populated with [rawEnd],   which must be in `"HH:mm"` format)
///
/// Returns a Future that resolves to a Map<String, String> with keys:
///   - `"start"`: the user-selected start time as `"HH:mm"`
///   - `"end"`:   the user-selected end time   as `"HH:mm"`
///
/// If the user dismisses the sheet without tapping “Done,” this Future returns `null`.
Future<Map<String, String>?> showStartEndTimePickerSheet({
  required BuildContext context,
  required String rawStart,
  required String rawEnd,
  required String dayName,
}) {
  // Helper to parse "HH:mm" into a DateTime (today’s date + that time).
  DateTime _parseToDateTime(String hhmm) {
    final parts = hhmm.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    final now = DateTime.now();
    // Use today’s date (year, month, day), but replace hour/minute.
    return DateTime(now.year, now.month, now.day, hour, minute);
  }

  // Initial DateTimes for both pickers:
  final initialStart = _parseToDateTime(rawStart);
  final initialEnd   = _parseToDateTime(rawEnd);

  // showModalBottomSheet returns a Future that resolves when Navigator.pop is called.
  return showModalBottomSheet<Map<String, String>>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext bc) {
      // We’ll need to keep mutable state for the two picked times inside the sheet.
      DateTime selectedStart = initialStart;
      DateTime selectedEnd   = initialEnd;
      bool isEnabled = !(rawStart == "00:00" && rawEnd == "00:00");
      return DraggableScrollableSheet(
        initialChildSize: 0.72,
        minChildSize: 0.65,
        maxChildSize: 0.74,
        builder: (context, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          dayName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        // Switch on the right
                        StatefulBuilder(
                          builder: (context, setState) {


                            return Switch(
                              value: isEnabled,
                              onChanged: (val) {
                                setState(() {
                                  isEnabled = val;
                                });
                              },
                            );
                          },
                        ),
                      ],
                    ),

                    // A “grabber” to indicate draggable sheet
                    Center(
                      child: Container(
                        margin: const EdgeInsets.only(top: 4, bottom: 8),
                        height: 4,
                        width: 48,
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          borderRadius: BorderRadius.circular(2),
                        ),
                        alignment: Alignment.center,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // “Start Time” label
                    const Text(
                      'Select Start Time',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(
                      height: 150,
                      child: CupertinoDatePicker(
                        mode: CupertinoDatePickerMode.time,
                        use24hFormat: true,
                        initialDateTime: selectedStart,
                        onDateTimeChanged: (DateTime newDt) {
                          setState(() {
                            selectedStart = newDt;
                          });
                        },
                      ),
                    ),

                    const SizedBox(height: 16),

                    // “End Time” label
                    const Text(
                      'Select End Time',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(
                      height: 150,
                      child: CupertinoDatePicker(
                        mode: CupertinoDatePickerMode.time,
                        use24hFormat: true,
                        initialDateTime: selectedEnd,
                        onDateTimeChanged: (DateTime newDt) {
                          setState(() {
                            selectedEnd = newDt;
                          });
                        },
                      ),
                    ),

                    const SizedBox(height: 16),
                    RoundedEdgedButton(buttonText: 'Save', onButtonClick: (){
                      // Format each DateTime back to "HH:mm"
                      if (isEnabled == false) {

                        Navigator.of(context).pop({
                          'start': '00:00',
                          'end': '00:00',
                        });
                      } else {
                        if (selectedStart.isBefore(selectedEnd)) {
                          // Format each DateTime back to "HH:mm"
                          String formattedStart =
                              '${selectedStart.hour.toString().padLeft(2, '0')}:${selectedStart.minute.toString().padLeft(2, '0')}';
                          String formattedEnd =
                              '${selectedEnd.hour.toString().padLeft(2, '0')}:${selectedEnd.minute.toString().padLeft(2, '0')}';

                          Navigator.of(context).pop({
                            'start': formattedStart,
                            'end': formattedEnd,
                          });
                        } else {
                          // Show alert: start must be earlier than end
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text('Invalid Time Range'),
                              content: const Text(
                                'Start time must be earlier than End time.',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(ctx).pop(),
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          );
                        }
                      }
                    }),

                    // “Done” button
                    /*SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // Format each DateTime back to "HH:mm"
                          String formattedStart =
                              '${selectedStart.hour.toString().padLeft(2, '0')}:${selectedStart.minute.toString().padLeft(2, '0')}';
                          String formattedEnd   =
                              '${selectedEnd.hour.toString().padLeft(2, '0')}:${selectedEnd.minute.toString().padLeft(2, '0')}';

                          Navigator.of(context).pop({
                            'start': formattedStart,
                            'end': formattedEnd,
                          });
                        },
                        child: const Text('Done'),
                      ),
                    ),*/

                    const SizedBox(height: 16),
                  ],
                );
              },
            ),
          );
        },
      );
    },
  );
}
