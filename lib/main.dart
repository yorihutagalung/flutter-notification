import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_notification/home_page.dart';
import 'package:flutter_notification/local_notification_service.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseMessaging.instance.requestPermission(provisional: true);

  // Handle background messages
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  final localNotifcationService = await LocalNotifcationService.initialize();
  runApp(MyApp(localNotifcationService: localNotifcationService));
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If the message is a notification, let FCM service handle it
  if (message.notification != null) return;

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final localNotifcationService = await LocalNotifcationService.initialize();

  // If the message is a data message, show a local notification
  final title = message.data['title'];
  final body = message.data['body'];
  if (title != null) {
    localNotifcationService.show(title, body);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.localNotifcationService});

  final LocalNotifcationService localNotifcationService;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: MyHomePage(title: 'Test Notification App', localNotifcationService: localNotifcationService),
    );
  }
}
