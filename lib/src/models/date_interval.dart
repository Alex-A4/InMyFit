import 'package:meta/meta.dart';

/// The PODO class that describes interval between two dates
/// Both dates consists only of year, month and day
class DateInterval {
  final DateTime startDate;
  final DateTime endDate;

  /// Initialize dates by primitive representation
  DateInterval({@required DateTime startDate, @required DateTime endDate})
      : this.startDate = getPrimitiveDate(startDate),
        this.endDate = getPrimitiveDate(endDate);

  /// Get date that consists only of year, month and day
  static DateTime getPrimitiveDate(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  ///Convert [DateInterval] to JSON object
  String toJSON() =>
      '${startDate.toUtc().toString()}|${endDate.toUtc().toString()}';

  /// Restore [DateInterval] from JSON object
  factory DateInterval.fromJSON(String datePair) {
    List<String> dates = datePair.split('|');
    return DateInterval(
      startDate: DateTime.parse(dates[0]),
      endDate: DateTime.parse(dates[1]),
    );
  }

  /// Check is 'this' [DateInterval] contains [other] date
  bool isContainsDate(DateTime other) {
    if (startDate.isBefore(other) && endDate.isAfter(other) ||
        startDate == other ||
        endDate == other)
      return true;
    else
      return false;
  }
}
