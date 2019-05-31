import 'dart:async';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:inmyfit/src/activity/models/date_interval.dart';
import 'package:inmyfit/src/activity/models/tablet_intake.dart';
import 'package:inmyfit/src/activity/models/water_intake.dart';

final FlutterLocalNotificationsPlugin notifications =
    FlutterLocalNotificationsPlugin();

/// Singleton class that needs to control for notification push
class NotificationController {
  /// Singleton instance of controller
  static NotificationController _instance;

  // Private constructor
  NotificationController._();

  /// Getter of instance
  static Future<NotificationController> getInstance() async {
    if (_instance == null) {
      _instance = NotificationController._();

      // Initialize notifications
      var androidSettings = AndroidInitializationSettings('app_icon');
      var iosSettings = IOSInitializationSettings();

      await notifications.initialize(
        InitializationSettings(androidSettings, iosSettings),
        onSelectNotification: (_) {},
      );
    }

    return _instance;
  }

  /// Check is there some bounded notifications
  ///
  /// Notifications can be cancelled by phone restart, so this method must
  /// be called when app is launching
  Future<bool> isNotificationsBounded() async {
    var response = await notifications.pendingNotificationRequests();
    print('COUNT OF NOTIFICATIONS:  ${response.length}');
    response.forEach(
        (notif) => print('Notification id: ${notif.id}, ${notif.title}'));
    return response.length != 0;
  }

  /// Verify notifications of tablet and cancel it if needs
  Future<void> verifyTablet(TabletsIntake tablet, DateInterval interval) async {
    var today = DateTime.now();
    if (today.isBefore(interval.startDate) || today.isAfter(interval.endDate)) {
      var id = (interval.hashCode + tablet.hashCode) % 2147483643;
      var response = await notifications.pendingNotificationRequests();
      for (var notification in response) {
        if (notification.id == id + 1 ||
            notification.id == id + 2 ||
            notification.id == id + 3) {
          await notifications.cancel(notification.id);
        }
      }
    }
  }

  /// Cancel all notifications, uses for debugging
  Future<void> cancelAll() async {
    await notifications.cancelAll();
  }

  /// Schedule water notifications in separate isolate
  ///
  /// This function must be call instead of [scheduleWater]
  Future<void> scheduleWaterNotification(WaterIntake water) async {
    await _scheduleWater(water);
  }

  /// Schedule tablets notification in separate isolate
  ///
  /// This function must be call instead of [scheduleTablets]
  Future<void> scheduleTabletsNotification(
      DateInterval interval, TabletsIntake tablets) async {
    await _scheduleTablets(interval, tablets);
  }

  /// Cancel notifications in a separate isolate
  ///
  /// Do not call [cancelTablet], because of slow handling
  Future<void> cancelTabletNotification(
      DateInterval interval, TabletsIntake tablet) async {
    await _cancelTablet(interval, tablet);
  }
}

///
/// TOP LEVEL
/// FUNCTIONS
/// TO USE THEM
/// IN [IsolateRunner.spawn]
/// FUNCTION
///

/// Schedule water notifications
///
/// Do not call that, because of slow handling
///
/// The id of water must be from 0 to 10 (inclusive)
/// [water] instance must provide count of intakes. This count will be
/// split on equals intervals since 9 AM to 7PM (11 hours)
///
/// Notifications will be shown every day
Future<void> _scheduleWater(WaterIntake water) async {
  /// The time between each notification
  /// Split 11 hours (in minutes) on goal
  int timeSpace = 660 ~/ water.goalToIntake;

  /// Start date for notifications is the 9AM this needs only for spacing
  var startDate = DateTime(2019, 1, 1, 9, 0);

  var android = AndroidNotificationDetails(
    'Water notification ID',
    'Water intake',
    'Water intake',
    icon: 'app_icon',
  );
  var ios = IOSNotificationDetails();

  /// Cycle for maximum available count of intakes
  /// If current index is less then water.goal then schedule notification
  /// else delete by index
  for (int i = 0; i < 11; i++) {
    if (i < water.goalToIntake) {
      Time time = Time(startDate.hour, startDate.minute);
      await notifications.showDailyAtTime(
          i,
          'Приём воды',
          'Пожалуйста, выпейте воды и отметьте это в приложении',
          time,
          NotificationDetails(android, ios));

      // Set up next time
      startDate = startDate.add(Duration(minutes: timeSpace));
    } else {
      await notifications.cancel(i);
    }
  }
}

/// Schedule tablets notification
///
/// Do not call that, because of slow handling
///
/// The id of tablets must be 1
/// [tablets] instance must provide the full information about tablet
/// Morning intake time: 9AM
/// Afternoon time: 2PM
/// Evening time: 7PM
///
/// Notification will be planned since [interval.startDate] to [interval.endDate]
/// [today] variable needs to check is this 'update' action and no need
/// to schedule all interval
Future<void> _scheduleTablets(
    DateInterval interval, TabletsIntake tablets) async {
  var today = DateTime.now();

  var android = AndroidNotificationDetails(
    'Tablets notification ID',
    'Tablets intake',
    'Tablets intake',
    icon: 'app_icon',
  );
  var ios = IOSNotificationDetails();

  /// Add notification schedule for each day in interval
  if (today.isBefore(interval.endDate) && today.isAfter(interval.startDate)) {
    var id = (interval.hashCode + tablets.hashCode) % 2147483643;
    // Morning
    if (tablets.countOfIntakes >= 1) {
      await notifications.showDailyAtTime(
          id + 1,
          'Приём таблеток',
          'Пожалуйста, примите ${tablets.name} и отметьте это в приложении',
          Time(9),
          NotificationDetails(android, ios));
    }

    // Evening
    if (tablets.countOfIntakes >= 2) {
      await notifications.showDailyAtTime(
          id + 2,
          'Приём таблеток',
          'Пожалуйста, примите ${tablets.name} и отметьте это в приложении',
          Time(19),
          NotificationDetails(android, ios));
    }

    // Afternoon
    if (tablets.countOfIntakes >= 3) {
      await notifications.showDailyAtTime(
          id + 3,
          'Приём таблеток',
          'Пожалуйста, примите ${tablets.name} и отметьте это в приложении',
          Time(14),
          NotificationDetails(android, ios));
    }
  }
}

/// Cancel all scheduled notification with [tablet] on [interval] since today
///
/// Use [cancelTabletNotification] instead of that
Future<void> _cancelTablet(DateInterval interval, TabletsIntake tablet) async {
  var id = (interval.hashCode + tablet.hashCode) % 2147483643;

  await Future.wait([
    notifications.cancel(id + 1),
    notifications.cancel(id + 2),
    notifications.cancel(id + 3)
  ]);
}
