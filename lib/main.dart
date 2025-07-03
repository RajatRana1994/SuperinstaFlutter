import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instajobs/storage_services/local_stoage_service.dart';
import 'package:instajobs/views/splash_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter bindings are initialized

  await StorageService().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Insta Jobs',
      theme: ThemeData(),
      home: SplashPage(),
    );
  }
}
