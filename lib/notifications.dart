import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'festival_config.dart';
import 'i18n.dart';
import 'model.dart';

final AndroidNotificationDetails _androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
  'event_notification',
  'Gig Reminder',
  'Notification to remind of scheduled gigs',
  importance: Importance.Max,
  priority: Priority.High,
  color: Color(0xFF000000),
);
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
int _nextNotificationId = 0;

void initializeNotifications() {
  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  flutterLocalNotificationsPlugin
      .getNotificationAppLaunchDetails()
      .then((details) {
    if (details != null && details.didNotificationLaunchApp) {
      debugPrint('was launched with notification');
    }
  });

  final initializationSettingsAndroid =
      AndroidInitializationSettings('notification_icon');
  final initializationSettings = InitializationSettings(
    initializationSettingsAndroid,
    IOSInitializationSettings(),
  );
  flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onSelectNotification: onSelectNotification,
  );
}

Future onSelectNotification(String payload) async {
  if (payload != null) {
    debugPrint('notification payload: $payload');
  }
}

Future<int> scheduleNotificationForEvent(
  AppLocalizations i18n,
  Event event, [
  int notificationId,
]) async {
  final platformChannelSpecifics = NotificationDetails(
    _androidPlatformChannelSpecifics,
    IOSNotificationDetails(),
  );
  final id = notificationId ?? _nextNotificationId++;
  await flutterLocalNotificationsPlugin.schedule(
    id,
    festivalName,
    i18n.eventNotification(event.bandName, event.start.toLocal(), event.stage),
    event.start.subtract(Duration(minutes: 10)),
    platformChannelSpecifics,
  );
  return id;
}

Future<void> cancelNotification(int notificationId) =>
    flutterLocalNotificationsPlugin.cancel(notificationId);

Future<void> verifyScheduledEventNotifications(
  AppLocalizations i18n,
  Map<int, Event> requiredNotifications,
) async {
  final pendingNotifications =
      await flutterLocalNotificationsPlugin.pendingNotificationRequests();
  final scheduledNotifications = {};
  for (final notification in pendingNotifications) {
    _nextNotificationId = max(_nextNotificationId, notification.id + 1);
    if (requiredNotifications[notification.id] == null) {
      cancelNotification(notification.id);
    } else {
      scheduledNotifications[notification.id] = true;
    }
  }
  requiredNotifications.forEach((notificationId, event) {
    if (scheduledNotifications[notificationId] == null) {
      scheduleNotificationForEvent(i18n, event, notificationId);
    }
  });
}
