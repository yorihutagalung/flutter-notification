import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_notification/local_notification_service.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title, required this.localNotifcationService});

  final String title;
  final LocalNotifcationService localNotifcationService;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  StreamSubscription<RemoteMessage>? _onMessageSubscription;

  @override
  void initState() {
    super.initState();
    _onMessageSubscription = FirebaseMessaging.onMessage.listen(_handleMessage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _onCopyFCMTokenPressed,
              child: Text('Copy FCM token'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onCopyFCMTokenPressed() async {
    try {
      final fcmToken = await FirebaseMessaging.instance.getToken();
      if (fcmToken != null) {
        Clipboard.setData(ClipboardData(text: fcmToken));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('FCM token is null')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  _handleMessage(RemoteMessage message) {
    final String title;
    final String body;

    if (message.notification != null) {
      title = message.notification?.title ?? 'No Title';
      body = message.notification?.body ?? 'No Body';
    } else {
      title = message.data['title'] ?? 'No Title';
      body = message.data['body'] ?? 'No Body';
    }

    widget.localNotifcationService.show(title, body);
  }

  @override
  void dispose() {
    _onMessageSubscription?.cancel();
    _onMessageSubscription = null;
    super.dispose();
  }
}
