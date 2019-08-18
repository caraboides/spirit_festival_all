import 'package:flutter/material.dart';

import 'i18n.dart';
import 'model.dart';
import 'my_schedule.dart';
import 'notifications.dart';
import 'schedule.dart';

class InitializationWidget extends StatefulWidget {
  const InitializationWidget({Key key, this.child}) : super(key: key);

  final Widget child;

  @override
  State<StatefulWidget> createState() => _InitalizationWidgetState();
}

class _InitalizationWidgetState extends State<InitializationWidget> {
  bool initalized = false;

  void _handleEventNotificationIfExists(MySchedule mySchedule, Event event,
          void Function(int notificationId) callback) =>
      mySchedule.getEventNotificationId(event.id).ifPresent(callback);

  void _checkScheduledEventNotifications(BuildContext context) {
    final i18n = AppLocalizations.of(context);
    final mySchedule = MyScheduleController.of(context).mySchedule;
    final now = DateTime.now();
    final scheduledEvents = <int, Event>{};
    final schedule = Schedule.of(context);
    if (schedule.events.isEmpty || mySchedule.isEmpty) {
      return;
    }
    schedule.events.forEach((event) {
      _handleEventNotificationIfExists(mySchedule, event, (notificationId) {
        if (event.start.isAfter(now)) {
          scheduledEvents[notificationId] = event;
        }
      });
    });
    schedule.updatedEvents.forEach((event) {
      _handleEventNotificationIfExists(mySchedule, event, (notificationId) {
        cancelNotification(notificationId);
        if (event.start.isAfter(now)) {
          scheduledEvents[notificationId] = event;
        }
      });
    });
    verifyScheduledEventNotifications(i18n, scheduledEvents);
    initalized = true;
  }

  @override
  Widget build(BuildContext context) {
    if (!initalized) {
      _checkScheduledEventNotifications(context);
    }
    return widget.child;
  }
}
