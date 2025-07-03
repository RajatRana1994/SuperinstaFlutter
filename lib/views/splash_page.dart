import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instajobs/controllers/check_login_status/check_login_status_controller.dart';
import 'package:instajobs/utils/app_images.dart';
import 'package:instajobs/utils/baseClass.dart';
import 'package:instajobs/views/welcome_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with BaseClass {
  CheckLoginStatusController checkLoginStatusController = Get.put(
    CheckLoginStatusController(),
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Image(
        image: AssetImage(AppImages.splash),
        width: Get.width,
        height: Get.height,
        fit: BoxFit.cover,
      ),
    );
  }
}
