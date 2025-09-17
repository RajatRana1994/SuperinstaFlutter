import 'package:flutter/material.dart';
import 'package:instajobs/models/vendor_details_model.dart';
import 'package:instajobs/storage_services/local_stoage_service.dart';
import 'package:instajobs/utils/baseClass.dart';
import 'package:instajobs/views/my_bookings/my_bookings_page.dart';
import 'package:instajobs/widgets/rounded_edged_button.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import '../../controllers/create_appointment_controller.dart';
import '../../utils/app_styles.dart';
import 'appointment_custom_app_bar.dart';

class CreateAppointmentFinalStepPage extends StatefulWidget {
  final VendorDetailsModelData? vendorDetails;
  final String userSelectedDate;
  final List<int> selectedIndices;
  final String userSelectedSlot;
  final String recipientName;
  final String recipientAddress;
  final String recipientPhone;
  final String postalCode;
  final String notes;

  const CreateAppointmentFinalStepPage({
    super.key,
    required this.vendorDetails,
    required this.userSelectedDate,
    required this.selectedIndices,
    required this.userSelectedSlot,
    required this.recipientName,
    required this.recipientAddress,
    required this.recipientPhone,
    required this.postalCode,
    required this.notes,
  });

  @override
  State<CreateAppointmentFinalStepPage> createState() =>
      _CreateAppointmentFinalStepPageState();
}

class _CreateAppointmentFinalStepPageState
    extends State<CreateAppointmentFinalStepPage> with BaseClass{
  CreateAppointmentController createAppointmentController = Get.put(
    CreateAppointmentController(),
  );
  String selectedOption = 'option1';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Create Appointment'),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          AppointmentCustomAppBar(showStepOne: true, showStepTwo: true),
          SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Recipient',
                    style: AppStyles.font700_16().copyWith(color: Colors.black),
                  ),
                  SizedBox(height: 8),
                  Container(
                    margin: EdgeInsets.only(left: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.person, color: Colors.orange),
                            SizedBox(width: 8),
                            Text(
                              widget.recipientName,
                              style: AppStyles.font500_14().copyWith(
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.phone, color: Colors.orange),
                            SizedBox(width: 8),
                            Text(
                              widget.recipientPhone,
                              style: AppStyles.font500_14().copyWith(
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.home, color: Colors.orange),
                            SizedBox(width: 8),
                            Text(
                              widget.recipientAddress,
                              style: AppStyles.font500_14().copyWith(
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Time Information',
                    style: AppStyles.font700_16().copyWith(color: Colors.black),
                  ),
                  SizedBox(height: 12),
                  Text(
                    DateFormat(
                      "EEE, dd MMM, yyyy",
                    ).format(DateTime.parse(widget.userSelectedDate)),
                    style: AppStyles.font500_14().copyWith(color: Colors.black),
                  ),
                  Text(
                    widget.userSelectedSlot,
                    style: AppStyles.font500_14().copyWith(color: Colors.grey),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Working price of freelancer',
                    style: AppStyles.font700_16().copyWith(color: Colors.black),
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Radio<String>(
                        value: 'option1',
                        groupValue: selectedOption,
                        activeColor: Colors.orange,
                        onChanged: (value) {
                          setState(() {
                            selectedOption = value!;
                          });
                        },
                      ),
                      Text(
                        'Hourly ${widget.vendorDetails?.userInfo?.hourlyPrice ?? 0}',
                      ),
                      SizedBox(width: 20),
                      Radio<String>(
                        value: 'option2',
                        groupValue: selectedOption,
                        activeColor: Colors.orange,
                        onChanged: (value) {
                          setState(() {
                            selectedOption = value!;
                          });
                        },
                      ),
                      Text(
                        'Daily ${widget.vendorDetails?.userInfo?.dailyPrice ?? 0}',
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  RoundedEdgedButton(
                    buttonText: 'Create Booking',
                    onButtonClick: () async {
                      try {
                        List<int> subCategoryIds = [];

                        for (
                        int i = 0;
                        i <
                            (widget.vendorDetails?.userInfo?.category
                                ?.elementAt(0)
                                ?.subCategory
                                ?.length ??
                                0);
                        i++
                        ) {
                          if (widget.selectedIndices.contains(i)) {
                            final id =
                                widget.vendorDetails?.userInfo?.category
                                    ?.elementAt(0)
                                    ?.subCategory
                                    ?.elementAt(i)
                                    ?.subCategoryId;

                            if (id != null) {
                              subCategoryIds.add(id);
                            }
                          }
                        }
                        showCircularDialog(context);

                        await createAppointmentController.createAppointment(
                          params: {
                            "bookingType": selectedOption=='option1'?'0': "1",
                            "endTime": "12:30",
                            "endDate": DateTime.parse(widget.userSelectedDate).millisecondsSinceEpoch ~/ 1000,
                            "assignUserId": widget.vendorDetails?.userInfo?.id,
                            "date": DateTime.parse(widget.userSelectedDate).millisecondsSinceEpoch ~/ 1000,
                            "time": widget.userSelectedSlot,
                            "recipientName": widget.recipientName,
                            "address": widget.recipientAddress,
                            "phone": widget.recipientPhone,
                            'latitude': '30.7269755',
                            'longitude': '76.8441849',
                            "postalCode": widget.postalCode,
                            "price": selectedOption=='option1'?
                            widget.vendorDetails?.userInfo?.hourlyPrice :
                            widget.vendorDetails?.userInfo?.dailyPrice,
                            "notes": widget.notes,
                            "subCategoryIds": subCategoryIds.join(','),
                          },
                        );
                        popToPreviousScreen(context: context);
                        showSuccess(title: 'Booking created', message: 'Booking created successfully' );
                        popToPreviousScreen(context: context);
                        popToPreviousScreen(context: context);
                        popToPreviousScreen(context: context);
                        pushToNextScreen(context: context, destination: MyBookingsPage());
                      } catch (e) {
                        popToPreviousScreen(context: context);
                        showError(title: 'Create Booking', message: e.toString());
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
