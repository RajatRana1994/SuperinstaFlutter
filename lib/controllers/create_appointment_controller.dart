import 'dart:convert';

import 'package:get/get.dart';
import 'package:instajobs/repositories/appointment_repository.dart';

class CreateAppointmentController extends GetxController {
  final AppointmentRepository _appointmentRepository = AppointmentRepository();

  Future<void> createAppointment({required Map<String,dynamic> params}) async {
    print(jsonEncode(params));
    final response = await _appointmentRepository.createAppointment(params);
    if (response.isSuccess) {

    } else {

    }
    update();
  }

}