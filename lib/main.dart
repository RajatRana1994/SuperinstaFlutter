import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instajobs/storage_services/local_stoage_service.dart';
import 'package:instajobs/views/splash_page.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:instajobs/views/message/chat_vc.dart';

import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling background message: ${message.messageId}");
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter bindings are initialized

  await Firebase.initializeApp();
  await StorageService().init();

  // Register background handler (works for both Android + iOS)
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // iOS foreground presentation options
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  _requestNotificationPermission();

  // Initialize local notifications
  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: DarwinInitializationSettings(),
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  runApp(const MyApp());

  // Fetch FCM token safely AFTER app starts
  _initFCMToken();
  // Setup foreground notifications
  _setupForegroundNotificationListener();
}

Future<void> _initFCMToken() async {
  try {
    String? fcmToken = await FirebaseMessaging.instance.getToken();
    print("🔥 FCM Token: $fcmToken");

    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      print("🔄 Refreshed FCM Token: $newToken");
    });
  } catch (e) {
    print("⚠️ Could not fetch FCM token yet: $e");
  }
}

void _setupForegroundNotificationListener() {
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print("📩 Foreground message: ${message.notification?.title}");

    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (notification != null && android != null) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'high_importance_channel', // id
            'High Importance Notifications', // name
            importance: Importance.max,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
          ),
        ),
      );
    }
  });
}

void _requestNotificationPermission() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('✅ User granted permission');
  } else {
    print('❌ User declined permission');
  }
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Insta Jobs',
      theme: ThemeData(),
      debugShowCheckedModeBanner: false,
      home: SplashPage(),
    );
  }
}
