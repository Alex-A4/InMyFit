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
  Map<String, String> toJSON() => {
        'start': startDate.toUtc().toString(),
        'end': endDate.toUtc().toString(),
      };

  /// Restore [DateInterval] from JSON object
  factory DateInterval.fromJSON(Map<String, String> date) => DateInterval(
        startDate: DateTime.parse(date['start']),
        endDate: DateTime.parse(date['end']),
      );
}
