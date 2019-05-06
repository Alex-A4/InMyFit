import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:inmyfit/src/models/date_interval.dart';
import 'package:inmyfit/src/models/tablet_intake.dart';
import 'package:inmyfit/src/models/water_intake.dart';

/// Singleton class that needs to control for notification push
class NotificationController {
  /// Singleton instance of controller
  static NotificationController _instance;

  /// Instance of notification plugin
  FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  // Private constructor
  NotificationController._();

  /// Getter of instance
  static NotificationController getInstance() {
    if (_instance == null) {
      _instance = NotificationController._();
      _instance._initializeNotification();
    }

    return _instance;
  }

  /// Method to initialize notifications for both platforms
  void _initializeNotification() {
    var androidSettings = AndroidInitializationSettings('app_icon');
    var iosSettings = IOSInitializationSettings();

    _notifications.initialize(
      InitializationSettings(androidSettings, iosSettings),
      onSelectNotification: (payload) {},
    );
  }

  /// Schedule water notifications
  ///
  /// The id of water must be from 0 to 10 (inclusive)
  /// [water] instance must provide count of intakes. This count will be
  /// split on equals intervals since 9 AM to 7PM (11 hours)
  ///
  /// Notifications will be shown every day
  Future<void> scheduleWaterNotification(WaterIntake water) async {
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
        await _notifications.showDailyAtTime(
            i,
            'Приём воды',
            'Пожалуйста, выпейте воды и отметьте это в приложении',
            time,
            NotificationDetails(android, ios));

        // Set up next time
        startDate = startDate.add(Duration(minutes: timeSpace));
      } else {
        await _notifications.cancel(i);
      }
    }
  }

  /// Schedule tablets notification
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
  Future<void> scheduleTabletsNotification(
      DateInterval interval, TabletsIntake tablets) async {
    var startDate = interval.startDate;
    var today = DateTime.now();

    // If today is inside interval
    if (startDate.isBefore(today))
      startDate = DateTime(today.year, today.month, today.day);

    var android = AndroidNotificationDetails(
      'Water notification ID',
      'Water intake',
      'Water intake',
      icon: 'app_icon',
    );
    var ios = IOSNotificationDetails();

    /// Add notification schedule for each day in interval
    while (startDate.isBefore(interval.endDate) ||
        startDate.compareTo(interval.endDate) == 0) {
      var id = (startDate.hashCode + tablets.hashCode) % 2147483643;

      // Morning
      if (tablets.countOfIntakes >= 1)
        await _notifications.schedule(
            id + 1,
            'Приём таблеток',
            'Пожалуйста, примите ${tablets.name} и отметьте это в приложении',
            _getMorningIntakeTime(startDate),
            NotificationDetails(android, ios));

      // Evening
      if (tablets.countOfIntakes >= 2)
        await _notifications.schedule(
            id + 2,
            'Приём таблеток',
            'Пожалуйста, примите ${tablets.name} и отметьте это в приложении',
            _getEveningIntakeTime(startDate),
            NotificationDetails(android, ios));

      // Afternoon
      if (tablets.countOfIntakes == 3)
        await _notifications.schedule(
            id + 3,
            'Приём таблеток',
            'Пожалуйста, примите ${tablets.name} и отметьте это в приложении',
            _getNoonIntakeTime(startDate),
            NotificationDetails(android, ios));

      startDate = startDate.add(Duration(days: 1));
    }
  }

  /// Get the time of morning intake (9AM) with specified [date]
  DateTime _getMorningIntakeTime(DateTime date) =>
      DateTime(date.year, date.month, date.day, 9, 0);

  /// Get the time of afternoon intake (14PM) with specified [date]
  DateTime _getNoonIntakeTime(DateTime date) =>
      DateTime(date.year, date.month, date.day, 14, 0);

  /// Get the time of evening intake (19PM) with specified [date]
  DateTime _getEveningIntakeTime(DateTime date) =>
      DateTime(date.year, date.month, date.day, 19, 0);

  Future<void> _checkPending() async {
    var requests = await _notifications.pendingNotificationRequests();
    for (var request in requests) {
      print('pending notification: [id: ${request.id},'
          ' title: ${request.title}, body: ${request.body}, '
          'payload: ${request.payload}]');
    }
  }

  /// Cancel all scheduled notification with [tablet] on [interval] since today
  Future<void> cancelTabletNotification(
      DateInterval interval, TabletsIntake tablet) async {
    var startDate = DateTime.now();
    startDate = DateTime(startDate.year, startDate.month, startDate.day);

    while (startDate.isBefore(interval.endDate) ||
        startDate.compareTo(interval.endDate) == 0) {
      var id = (startDate.hashCode + tablet.hashCode) % 2147483643;
      await Future.wait([
        _notifications.cancel(id + 1),
        _notifications.cancel(id + 2),
        _notifications.cancel(id + 3)
      ]);

      startDate = startDate.add(Duration(days: 1));
    }
  }

  Future<void> cancelAll() async {
    await _notifications.cancelAll();
  }
}
