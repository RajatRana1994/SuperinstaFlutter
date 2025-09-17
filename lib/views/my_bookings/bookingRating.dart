import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_styles.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:instajobs/widgets/form_input_with_hint_on_top.dart';
import '../../controllers/profile_controller.dart';

class Bookingrating extends StatefulWidget {
  final String bookingId;
  final String userId;
  final String? jobId;
  const Bookingrating({super.key, required this.bookingId, required this.userId, this.jobId});

  @override
  State<Bookingrating> createState() => _BookingratingState();
}

class _BookingratingState extends State<Bookingrating> {
  final ProfileController controller = Get.put(ProfileController());
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
          'Add Rating & Review',
          style: AppStyles.fontInkika().copyWith(fontSize: 24),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Center(
                child: RatingBar.builder(
                  initialRating: 3,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder:
                      (context, _) => Icon(Icons.star, color: Colors.amber),
                  onRatingUpdate: (rating) {
                    controller.communicationRating = rating;
                    print(rating);
                  },
                ),
              ),
              const SizedBox(height: 5),
              FormInputWithHint(
                label: 'Communication',
                hintText: 'Enter Text here...',
                maxLine: 4,
                controller: controller.communicationTextField,
              ),
              const SizedBox(height: 16),

              Center(
                child: RatingBar.builder(
                  initialRating: 3,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder:
                      (context, _) => Icon(Icons.star, color: Colors.amber),
                  onRatingUpdate: (rating) {
                    controller.attitudeRating = rating;
                    print(rating);
                  },
                ),
              ),
              const SizedBox(height: 5),
              FormInputWithHint(
                label: 'Attitude',
                hintText: 'Enter Text here...',
                maxLine: 4,
                controller: controller.attitudeTextField,
              ),

              const SizedBox(height: 16),
              Center(
                child: RatingBar.builder(
                  initialRating: 3,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder:
                      (context, _) => Icon(Icons.star, color: Colors.amber),
                  onRatingUpdate: (rating) {
                    print(rating);
                    controller.deliveryRating = rating;
                  },
                ),
              ),
              const SizedBox(height: 5),
              FormInputWithHint(
                label: 'Delivery',
                hintText: 'Enter Text here...',
                maxLine: 4,
                controller: controller.deliveryTextField,
              ),

              const SizedBox(height: 16),
              GestureDetector(
                onTap: () async {

                  final result = await controller.addBookingRating(bookingId: widget.bookingId, userId: widget.userId, jobId: widget.jobId ?? '');
                  if (result) {
                    Navigator.of(context).pop(); // Pop current screen
                    Navigator.of(context).pop(true);// ✅ Return true to calling screen
                  }
                },
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(
                    //  horizontal: 50,
                    vertical: 13,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.btncolor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Submit',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
