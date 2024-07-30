import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tzl;

class NotificationService {
  late final FlutterLocalNotificationsPlugin _localNotification;

  NotificationService() {
    _localNotification = FlutterLocalNotificationsPlugin();
    tzl.initializeTimeZones();
    _initializeNotifications();
  }

  void init() {
    _initializeNotifications();
  }

  void _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _localNotification.initialize(initializationSettings);
  }

  Future<void> scheduleNotification(tz.TZDateTime scheduledDate) async {
    const androidDetails = AndroidNotificationDetails(
      'reminder_channel',
      'Reminders',
      importance: Importance.max,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails();

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotification.zonedSchedule(
      0,
      'Reminder',
      'You have a new message',
      scheduledDate,
      notificationDetails,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
    );
  }

  void schedulePushNotification(DateTime scheduledDate, String message) {
    FirebaseMessaging.instance.sendMessage(
      to: 'Chat',
      data: {
        'message': message,
        'scheduledDate': scheduledDate.toIso8601String()
      },
    );
  }
}
