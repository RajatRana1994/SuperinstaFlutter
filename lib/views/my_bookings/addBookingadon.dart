// custom_bottom_sheet.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instajobs/widgets/form_input_with_hint_on_top.dart';
import '../../controllers/profile_controller.dart';

class Addbookingadon extends StatefulWidget {
  final String bookingId;
  final VoidCallback? onClose;

  const Addbookingadon({Key? key, required this.bookingId, this.onClose})
    : super(key: key);

  @override
  State<Addbookingadon> createState() => _AddbookingadonState();
}

class _AddbookingadonState extends State<Addbookingadon> {
  final ProfileController controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: double.infinity, // 👈 Make it full width
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start, // Optional: aligns title to left
            children: [
              Text(
                'Addons request for further work progress',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              FormInputWithHint(
                label: 'Add information about the work',
                hintText: 'Text here..',
                maxLine: 5,
                controller: controller.adOnInformation,
              ),

              const SizedBox(height: 10),
              FormInputWithHint(
                label: 'Budget required',
                hintText: 'Enter budget required for completion',
                maxLine: 1,
                controller: controller.adOnBudget,
                keyboardType: TextInputType.number,
              ),

              const SizedBox(height: 10),
              FormInputWithHint(
                label: 'Time required to coplete',
                hintText: 'Time Required in hours or days',
                maxLine: 1,
                controller: controller.adOnTime,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
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
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Cancel',
                          style: theme.textTheme.bodyMedium?.copyWith(
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
                      onTap: () async {
                        final result = await controller.bookingSendQuote(bookId: widget.bookingId ?? '');
                        if (result) {
                          widget.onClose?.call();
                          Navigator.of(context).pop(true); // ✅ Return true to calling screen
                        }
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
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Submit',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}
