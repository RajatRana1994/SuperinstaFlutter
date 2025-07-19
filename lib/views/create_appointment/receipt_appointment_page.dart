import 'package:flutter/material.dart';
import 'package:instajobs/models/vendor_details_model.dart';
import 'package:instajobs/storage_services/local_stoage_service.dart';
import 'package:instajobs/utils/baseClass.dart';
import 'package:instajobs/widgets/form_input_with_hint_on_top.dart';
import 'package:instajobs/widgets/rounded_edged_button.dart';

import 'appointment_custom_app_bar.dart';
import 'create_appointment_final_step_page.dart';

class ReceiptAppointmentPage extends StatefulWidget {
  final VendorDetailsModelData? vendorDetailsModel;
  final List<int> selectedIndices;
  final String userSelectedDate;
  final String userSelectedSlot;

  const ReceiptAppointmentPage({
    super.key,
    required this.vendorDetailsModel,
    required this.selectedIndices,
    required this.userSelectedDate,
    required this.userSelectedSlot,
  });

  @override
  State<ReceiptAppointmentPage> createState() => _ReceiptAppointmentPageState();
}

class _ReceiptAppointmentPageState extends State<ReceiptAppointmentPage>
    with BaseClass {
  TextEditingController nameController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController zipController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController notesController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameController.text = StorageService().getUserData().fullName ?? '';
    phoneController.text = StorageService().getUserData().phoneNumber ?? '';
  }

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
          AppointmentCustomAppBar(showStepOne: true, showStepTwo: false),
          SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                children: [
                  FormInputWithHint(
                    label: 'Recipient Name',
                    hintText: 'Enter recipient name',
                    controller: nameController,
                  ),
                  SizedBox(height: 16),
                  FormInputWithHint(
                    label: 'Address',
                    hintText: 'Enter recipient address',
                    controller: locationController,
                  ),
                  SizedBox(height: 16),
                  FormInputWithHint(
                    label: 'Postal Zone',
                    hintText: 'XXXXX',
                    controller: zipController,
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 16),
                  FormInputWithHint(
                    label: 'Phone number',
                    controller: phoneController,
                    hintText: 'Enter phone number',
                  ),
                  SizedBox(height: 16),
                  FormInputWithHint(
                    label: 'Notes',
                    controller: notesController,
                    keyboardAction: TextInputAction.done,
                    hintText: 'Text here',
                    maxLength: 1000,
                    maxLine: 5,
                  ),
                ],
              ),
            ),
          ),
          RoundedEdgedButton(
            buttonText: 'Next',
            onButtonClick: () {
              String name = nameController.text.trim();
              String address = locationController.text.trim();
              String phone = phoneController.text.trim();
              String zip = zipController.text.trim();
              String notes = notesController.text.trim();
              if (name.isEmpty) {
                showError(
                  title: 'Recipient',
                  message: 'Please enter recipient name',
                );
              } else if (address.isEmpty) {
                showError(
                  title: 'Recipient',
                  message: 'Please enter recipient address',
                );
              } else if (zip.isEmpty) {
                showError(
                  title: 'Recipient',
                  message: 'Please enter postal code',
                );
              } else if (phone.isEmpty) {
                showError(
                  title: 'Recipient',
                  message: 'Please enter phone number',
                );
              } else if (notes.isEmpty) {
                showError(title: 'Recipient', message: 'Please enter notes');
              } else {
                pushToNextScreen(
                  context: context,
                  destination: CreateAppointmentFinalStepPage(
                    vendorDetails: widget.vendorDetailsModel,
                    selectedIndices: widget.selectedIndices,
                    userSelectedDate: widget.userSelectedDate,
                    userSelectedSlot: widget.userSelectedSlot,
                    recipientName: name,
                    recipientAddress: address,
                    recipientPhone: phone,
                    postalCode: zip,
                    notes: notes,
                  ),
                );
              }
            },
            leftMargin: 16,
            rightMargin: 16,
            bottomMargin: 16,
          ),
        ],
      ),
    );
  }
}
