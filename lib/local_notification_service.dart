import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotifcationService {
  LocalNotifcationService(this._plugin);

  final FlutterLocalNotificationsPlugin _plugin;

  static Future<LocalNotifcationService> initialize() async {
    FlutterLocalNotificationsPlugin plugin = FlutterLocalNotificationsPlugin();
    final initializationSettings = InitializationSettings(android: const AndroidInitializationSettings('ic_notification'));
    await plugin.initialize(initializationSettings);
    return LocalNotifcationService(plugin);
  }

  Future<void> show(String title, String body) {
    final id = DateTime.now().millisecondsSinceEpoch % 86400000;
    const notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails('local_notification', 'local_notification', channelDescription: 'local_notification'),
    );
    return _plugin.show(id, title, body, notificationDetails);
  }
}
