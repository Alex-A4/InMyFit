import 'package:inmyfit/src/models/tablet_intake.dart';
import 'package:inmyfit/src/models/water_intake.dart';

/// This controller describes user activity per one day.
/// It contains information about today's intake of tablets and water
///
/// This controller needs to move between days and look up 'journal' of previous
/// intakes or to plan future
class DayActivityController {
  /// Info about water intake, if it's not set up then creates with [WaterIntake.init()]
  final WaterIntake waterIntake;

  /// Info about tablets intake, if it's not set up then null
  final List<TabletsIntake> tabletsIntake;

  /// Contains information about today's date. There needs only year, month and day
  /// All actions to save/restore date must be made with these three parameters
  ///
  /// This time must be created with [getPrimitiveDate] to store data into sql
  final DateTime todaysDate;

  ///Default constructor
  DayActivityController(this.todaysDate,
      {WaterIntake water, List<TabletsIntake> tablets})
      : this.waterIntake = water ?? WaterIntake.init(),
        this.tabletsIntake = tablets ?? [];

  /// Convert object to JSON
  Map<String, dynamic> toJSON() => {
        'date': getPrimitiveDate(todaysDate),
        'water': waterIntake.toJSON(),
        'tablets': tabletsIntake.map((tablet) => tablet.toJSON()).toList(),
      };

  ///Create controller based on JSON data which could be get from DB, for example
  factory DayActivityController.fromJSON(Map<String, dynamic> data) {
    return DayActivityController(
      dateFromPrimitive(data['date']),
      tablets: data['tablets']
          .map((tablet) => TabletsIntake.fromJSON(tablet))
          .toList(),
      water: WaterIntake.fromJSON(data['water']),
    );
  }

  /// Get the primitive [date] that consists only of year, month and day
  /// It will be needed to easy compare dates
  static Map<String, dynamic> getPrimitiveDate(DateTime date) => {
        'year': date.year,
        'month': date.month,
        'day': date.day,
      };

  /// Get the DateTime object that consists only of year, month and day
  static DateTime dateFromPrimitive(Map<String, dynamic> date) {
    return DateTime(date['year'], date['month'], date['day']);
  }

  /// Compare [todaysDate] and [other] date
  /// If [todaysDate] is greater than [other] then return 1, if is less then -1 else 0
  int compareDate(DateTime other) {
    if (todaysDate.year.compareTo(other.year) != 0)
      return todaysDate.year.compareTo(other.year);

    if (todaysDate.month.compareTo(other.month) != 0)
      return todaysDate.month.compareTo(other.month);

    return (todaysDate.day.compareTo(other.day));
  }
}
