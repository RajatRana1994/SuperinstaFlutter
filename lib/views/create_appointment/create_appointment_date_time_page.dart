import 'package:flutter/material.dart';

class CreateAppointmentDateTimePage extends StatefulWidget {
  const CreateAppointmentDateTimePage({super.key});

  @override
  State<CreateAppointmentDateTimePage> createState() =>
      _CreateAppointmentDateTimePageState();
}

class _CreateAppointmentDateTimePageState
    extends State<CreateAppointmentDateTimePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Column(
      children: [
        Column(
          children: [
            const Placeholder(),
          ],
        ),
      ],
    ));
  }
}
