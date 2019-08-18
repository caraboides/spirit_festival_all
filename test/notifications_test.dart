import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:spirit/festival_config.dart';
import 'package:spirit/i18n.dart';
import 'package:spirit/model.dart';
import 'package:spirit/notifications.dart';

void main() {
  final i18n = en;
  final notificationLog = <MethodCall>[];
  List<Map<dynamic, dynamic>> pendingNotifications;

  setUpAll(() {
    initializeDateFormatting('en_US');
    MethodChannel('dexterous.com/flutter/local_notifications')
        .setMockMethodCallHandler((MethodCall methodCall) async {
      notificationLog.add(methodCall);
      switch (methodCall.method) {
        case 'getNotificationAppLaunchDetails':
          return {'notificationLaunchedApp': false};
        case 'initialize':
          return true;
        case 'pendingNotificationRequests':
          return pendingNotifications;
        default:
          return null;
      }
    });
    initializeNotifications();
    notificationLog.clear();
  });

  tearDown(() async {
    notificationLog.clear();
  });

  test('it should verify scheduled event notifications', () async {
    final now = DateTime.now();
    final start0 = now.add(Duration(hours: 1));
    final start1 = now.add(Duration(hours: 2));
    final start2 = now.add(Duration(hours: 3));
    final requiredNotifications = {
      0: Event(bandName: 'Band 0', start: start0, stage: 'Stage 0'),
      1: Event(bandName: 'Band 1', start: start1, stage: 'Stage 1'),
      2: Event(bandName: 'Band 2', start: start2, stage: 'Stage 2'),
    };
    final minutes10 = Duration(minutes: 10);
    pendingNotifications = [
      {'id': 0},
      {'id': 3},
      {'id': 4},
    ];
    await verifyScheduledEventNotifications(i18n, requiredNotifications);
    expect(notificationLog, <Matcher>[
      isMethodCall('pendingNotificationRequests', arguments: null),
      isMethodCall('cancel', arguments: 3),
      isMethodCall('cancel', arguments: 4),
      isMethodCall('schedule', arguments: {
        'id': 1,
        'title': festivalName,
        'body': i18n.eventNotification('Band 1', start1, 'Stage 1'),
        'millisecondsSinceEpoch':
            start1.subtract(minutes10).millisecondsSinceEpoch,
        'platformSpecifics': null,
        'payload': '',
      }),
      isMethodCall('schedule', arguments: {
        'id': 2,
        'title': festivalName,
        'body': i18n.eventNotification('Band 2', start2, 'Stage 2'),
        'millisecondsSinceEpoch':
            start2.subtract(minutes10).millisecondsSinceEpoch,
        'platformSpecifics': null,
        'payload': '',
      }),
    ]);
  });
}
