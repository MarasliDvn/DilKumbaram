import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotifyApi {
  static final _notify = FlutterLocalNotificationsPlugin();
  static Future _notificationDetails() async {
    return const NotificationDetails(
        android: AndroidNotificationDetails('channel id', 'channel name',
            importance: Importance.max),
        iOS: IOSNotificationDetails());
  }

  static Future init({bool initScheduled = false}) async {
    final android = AndroidInitializationSettings('@mipmap/ic_launcher');
    final ios = IOSInitializationSettings();
    final initializationSettings =
        InitializationSettings(android: android, iOS: ios);
    final details =await _notify.getNotificationAppLaunchDetails();
    if(details != null && details.didNotificationLaunchApp){
      debugPrint('d');
    }
    await _notify.initialize(initializationSettings);
    if (initScheduled) {
      tz.initializeTimeZones();
      final locationName= await FlutterNativeTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(locationName));
      
    }
  }

  static Future showNotify({
    int id = 0,
    String? title,
    String? body,
  }) async {
    _notify.show(
      id,
      title,
      body,
      await _notificationDetails(),
    );
  }

  static Future showTimeNotify({
    int id = 0,
    String? title,
    String? body,
    required DateTime time,
  }) async {
    tz.initializeTimeZones();
    _notify.zonedSchedule(id, title, body, tz.TZDateTime.from(time, tz.local),
        await _notificationDetails(),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }
}
